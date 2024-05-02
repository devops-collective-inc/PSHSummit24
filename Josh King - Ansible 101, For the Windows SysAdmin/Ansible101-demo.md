# Ansible 101 - For the Windows Sysadmin

_Unless otherwise stated, these instuctions should be followed from a Linux host._

## Prerequisites

Need a minimum of Python 3.10 (with support up to 3.12).

```bash
python --version
```

We only have 3.9 installed so need to install newer version.

```bash
sudo dnf install python3.11
```

Check version again, still 3.9, so will use `python3.11` explicitly.

```bash
python --version
python3 --version
python3.11 --version
```

Installing Ansible via pip requires pip...

```bash
sudo dnf install python3.11-pip
pip3.11 --version
```

## Install Ansible

Use pip to install the latest version of Ansible to the user scope.

```bash
python3.11 -m pip install ansible --user
```

Once installed we can see all of the Ansible collections that are installed by default.

```bash
ansible-galaxy collection list
```

## Run an Ad-Hoc command

Now that Ansible is installed we can execute ad-hoc commands (or modules).

```bash
ansible -m ping localhost
```

Note that without a defined inventory we can only target the localhost.
This `ping` command is not the same as a network "ping" or echo request,
this is actually connecting to the target validating that the connection and credentials
are valid.

## Setup Windows Host

_This section should be run from your Windows host._

Ansible needs a user account to connect to our Windows host,
this example names the account "Ansible" but you can use any name.

```powershell
New-LocalUser -Name Ansible -Password (Read-Host -AsSecureString) -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword
```

This account will need whatever permissions are required to carrying out the tasks
that you want to execute via Ansible.
For this demonstration we're adding it to the local Administrators group,
but you may wish to create a group with a limited scope for this account.

```powershell
Add-LocalGroupMember -Group Administrators -Member Ansible
```

Next run the [ConfigureRemotingForAnsible.ps1](https://raw.githubusercontent.com/ansible/ansible-documentation/ae8772176a5c645655c91328e93196bcf741732d/examples/scripts/ConfigureRemotingForAnsible.ps1)
script to configure your Windows host to accept Ansible's WinRM connections.

_Swap back to your Linux host to finish this demo._

## Create an Ansible Inventory

Create a directory which will contain your inventory,
then create a new file named `hosts` (without a file extension) in this directory.

_The examples here use `vi`, substitute your editor of choice,
or consider using the [VS Code Remote Development using SSH](https://code.visualstudio.com/docs/remote/ssh)._

```bash
mkdir inventory
vi inventory/hosts
```

In this file create two groups, `linux_servers` and `windows_server`.
Add your Ansible server and your Windows box to this inventory file as shown here:

```yaml
---
linux_servers:
  hosts:
    ansible:
windows_servers:
  hosts:
    windows:
...
```

You can now attempt to ping your `linux_servers` group:

```bash
ansible -m ping linux_servers -i inventory/hosts
```

But this may not work as it's no loner making use of the "local" connection to
the server. Instead it's trying to establish as SSH connection.

We can solve this by telling Ansible to connect via the local connection again.
Create a file under `host_vars` that matches the name of your Ansible host,
`ansible` in this case, with a `.yml` file extension.

```bash
vi inventory/host_vars/ansible.yml
```

Add the following content:

```yaml
---
ansible_connection: local
...
```

This tells Ansible that it should not use the default connection method of SSH,
and should instead use the internal/local connection.
Rerun the previous command and it should now succeed.

```bash
ansible -m ping linux_servers -i inventory/hosts
```

Try now pinging the `windows_servers` group.

```bash
ansible -m setup windows_servers -i inventory/hosts
```

Once again, this is defaulting to SSH for connectivity,
but we need to use WinRM to connect to our Windows host.
We can tell Ansible to override the default behaviour like we did for the Ansible host,
except that a little more information is needed and we will also apply this to the
entire `windows_servers` group by creating a matching file under `group_vars`.

```bash
vi inventory/group_vars/windows_servers.yml
```

```yaml
---
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
ansible_winrm_transport: ntlm
ansible_winrm_scheme: 'http'
ansible_port: 5985
...
```

When you attempt to re-run the ping command now you will get a message the effectivly
means that Python does not know how to manage WinRM connections.
We will need to install a Python module called `pywinrm` to enable this.

```bash
python3.11 -m pip install --upgrade pywinrm --user
```

Attempt to ping again... and Ansible will complain that a username is required.
Provide this via `host_vars` specific to the Windows host.

```bash
vi inventory/host_vars/windows.yml
```

```yaml
---
ansible_user: Ansible
...
```

Alongside the username a password is also required.
Rather than setting that in the host variables,
we can tell Ansible to ask for it by providing the `--ask-pass` argument.

```bash
ansible -m ping windows_servers -i inventory/hosts --ask-pass
```

And finally... we run into one final error.
The `ping` command only works against Linux based systems,
we need to swap to the `win_ping` command for Windows systems.

```bash
ansible -m win_ping windows_servers -i inventory/hosts --ask-pass
```

## An Introduction to Playbooks

_Extract the `ansible-demo-01-start.zip` archive into your working directory.
You should have both `inventory` and `playbooks` at the same level.
Inside the `playbooks` directory should be a `files` directory and two `yml` files._

Take a moment to explore the first demo playbook.

```bash
vi playbooks/demo1.yml
```

It starts with specifying which hosts the playbook targets and then lists tasks.
These tasks are a list of commands like we were running from the command line earlier.
By listing them in a playbook you can chain a number of different commands together
and repeat them as needed.

The intention of the `demo1.yml` playbook is to create a directory on the Windows host,
`C:\Tools` and copy a file `example.txt` into it.

Open this file to inspect it's contents.

```bash
vi playbooks/files/example.txt
```

Note the `{{ company_name }}` and `{{ machine_type }}` in this file.
We want these are placeholders that we want to replace with the string content of
matching variables.

Create these variables now.

```bash
vi inventory/group_vars/all.yml
```

```yaml
---
company_name: 'Example Inc'
machine_type: 'Virtual Machine'
...
```

You can override these variables by defining them in either a more specific group
or a host's `host_vars`.

Run this playbook using `ansible-playbook`.

```bash
ansible-playbook playbooks/demo1.yml -i inventory/hosts --ask-pass
```

Once it completes you should see the Ansible reported changes from two tasks,
this indicates that both the directory and file were created.

Repeating the playbook run will show no changes because the directory already exists,
and there were no changes needed in the file.

If you check the file, however, you'll note that it still contains `{{ company_name }}`
and `{{ machine_type }}` rather than the value of our variables.
This is because the `win_copy` command copies the specified file as is without interpreting
the contents.

Edit this playbook and change `win_copy` to `win_template`.
This command evaluates any [Jinja2](https://palletsprojects.com/p/jinja/) template
syntax in the file (such as our variable substitutions) before copying the file to disk.

Repeat the previous command and you will see Ansible report one change,
indicating that the contents of the file has changed.
Also check the file on disk and you will see that the placeholders have been replaced
with the contents of our variables.

## PowerShell and Ansible

Take a moment to explore the second demo playbook.

```bash
vi playbooks/demo2.yml
```

This playbook uses the `win_powershell` command to execute a PowerShell script on
the target host.

It gives you an automatic variable, `$Ansible`, through which you're able to communicate
with Ansible whether or not your script has made a change to system state,
if the command has failed, or provide data that subsequent tasks can make use of.

This specific example checks to see if the NuGet package provider is installed on
the target host.
If it isn't then the provider will be installed and it will report back to Ansible
that the system state has changed.
If it is already installed then nothing will happen and the script reports back that
no change was made.

If you do not tell Ansible whether or not the script made a change,
then it will default to reporting that there was a change regardless of if that is
what actually happened.

Go ahead and run this playbook.

```bash
ansible-playbook playbooks/demo2.yml -i inventory/hosts --ask-pass
```

On the first run you should see one change because this provider isn't installed
by default and so the playbook will have done so.
If you run the playbook a second time there should be no changes reported.
