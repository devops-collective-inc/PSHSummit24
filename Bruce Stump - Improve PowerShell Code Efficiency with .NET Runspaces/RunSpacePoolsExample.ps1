# Runspace Pool 

$rsp = [RunspaceFactory]::CreateRunspacePool(1,4)

$rsp.open()

$jb1 = 1..20 | Foreach-Object {
  $inst = [PowerShell]::Create().AddScript('Start-Sleep -s 10')
  # Assign RunspacePool to each Runspace.
  $inst.RunspacePool = $rsp
  [PSCustomObject] @{
   Id = $inst.InstanceID
   Instance = $inst
   AsyncResult = $inst.BeginInvoke()
    # The InvocationStateInfo Property is used to show if object is running.
  } | Add-Member State -MemberType ScriptProperty -PassThru -Value {$this.Instance.InvocationStateInfo.State}
}

