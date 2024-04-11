@{
    Server = @{
        FileMonitor = @{
            Enable  = $false
            Include = @("*.psd1", "*.ps1")
        }
    }
    Web    = @{
        Static = @{
            Cache = @{
                Enable  = $true
                Include = @("*.txt", "*.ps1", "*.psd1")
            }
        }
    }
}
