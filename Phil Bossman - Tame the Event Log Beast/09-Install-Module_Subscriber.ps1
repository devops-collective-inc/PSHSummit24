Install-Module -Name Subscriber

Install-EventSubscription -SubscriptionName 'Account Lockout'
-ScriptPath '.\lockout.ps1'
-LogName 'Security'
-Source 'Microsoft-Windows-Security-Auditing'
-EventID 4740



