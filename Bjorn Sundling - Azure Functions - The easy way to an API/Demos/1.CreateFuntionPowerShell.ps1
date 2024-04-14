break # Dont run this as a script!

$UID = "a$((New-Guid).guid.Replace('-','').Substring(0,8))a"
$ResourceGroupName = "PSDO2024$($UID)"
$Location = 'West US'
$SAName = "funcsa$($UID)"
$FunctionName = "fn$($UID)" # Needs to be globaly unique!

New-AzResourceGroup -Name $ResourceGroupName -Location $Location

New-AzStorageAccount    -ResourceGroupName $ResourceGroupName `
                        -Name $SAName `
                        -Location $Location `
                        -SkuName Standard_LRS

New-AzFunctionApp       -ResourceGroupName $ResourceGroupName `
                        -Location $Location `
                        -StorageAccountName $SAName `
                        -Name $FunctionName `
                        -Runtime 'PowerShell' `
                        -OSType 'Linux' `
                        -RuntimeVersion '7.2' `
                        -FunctionsVersion 4
