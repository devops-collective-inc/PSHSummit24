break # Dont run this as a script!
cd .\Demos\

$UID = "a$((New-Guid).guid.Replace('-','').Substring(0,8))a"
$ResourceGroupName = "PSDO2024$($UID)"
$Location = 'West US'

New-AzResourceGroup -Name $ResourceGroupName -Location $Location

New-AzResourceGroupDeployment   -Name 'RGDeploy' `
                                -ResourceGroupName $ResourceGroupName `
                                -TemplateFile .\2.CreateFunctionBicep.bicep `
                                -Verbose
