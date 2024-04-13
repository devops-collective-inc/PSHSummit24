<#
    Task: 
    Create a function, which checks if the input is a ServiceController object or a string representing a service,
    converting it if necessary, and performing related actions, displaying appropriate messages based on the input provided.
#>


function Get-ServiceInsights {
    param (
        $Service
    )
    switch($Service){
        {$Service -is [System.ServiceProcess.ServiceController]}{
            Write-host 'its a service yay! - Get ready for some magic..'
        }
        {$Service -is [string]}{
            Write-host 'its a string, noooo!' -ForegroundColor Yellow

            # make it a ServiceController object
            try {
                $Service = Get-Service -Name $Service -ErrorAction Stop
                Write-host 'its a service yay! - Get ready for some magic..'

            }
            catch {
                Write-Host 'All we had to do was follow the dang train, CJ!' -ForegroundColor Red
                return
            }
        }
        Default {
            Write-Host 'Provide better next time, punk...' -ForegroundColor Red
            return
        }

    }

    Write-Host 'Do some magic...'
}

# Test cases
Get-ServiceInsights -Service 'Wuauserv'
Get-ServiceInsights -Service 'WuauservX'
Get-ServiceInsights -Service (Get-Service -Name 'Wuauserv')
Get-ServiceInsights -Service $bool

class ServiceTransform : System.Management.Automation.ArgumentTransformationAttribute{
    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics,[object]$Service){
        switch($Service){
            {$Service -is [System.ServiceProcess.ServiceController]}{
                Write-host 'its a service yay! - Get ready for some magic..'
            }
            {$Service -is [string]}{
                Write-host 'its a string, noooo!' -ForegroundColor Yellow
    
                # make it a ServiceController object
                try {
                    $Service = Get-Service -Name $Service -ErrorAction Stop
                    Write-host 'its a service yay! - Get ready for some magic..'
    
                }
                catch {
                    Write-Host  -ForegroundColor Red
                    throw 'All we had to do was follow the dang train, CJ!'
                }
            }
            Default {
                throw 'Provide better next time, punk...'
            }
        }
        return $Service
    }
}

function Get-ServiceInsights {
    param (
        [ServiceTransform()]
        $Service
    )
    Write-Host 'Do some magic...'
}