function ArmTemplateFunction{
    param(
    # #    [parameter(mandatory =$false)]
    # #    [string]$adminusername,
    # #    [parameter(mandatory =$false)]
    # #    [string]$adminpassword,
    # #    [parameter(mandatory =$false)]
    # #    [string]$resourcegroup,
    # [parameter(mandatory =$true)]
    # [string]$location,
    # #    [parameter(mandatory =$false)]
    # #    [string[]]$vmnames,
    # #    [parameter(mandatory =$false)]
    # #    [string]$targetsubscription,
    # #    [parameter(mandatory =$false)]
    # #    [bool]$whatif = $true
    ) 

    $context = Get-AzSubscription -SubscriptionName $targetsubscription
    Set-AzContext $context

    Write-Host($adminUserName)
    Write-Host($adminPassword)
    Write-Host($resourceGroup)
    Write-Host($location)
    Write-Host($vmName)


    $creationDate = Get-Date -Format "dd/MM/yyyy"

    # check if the resource group exists if it doesn't create it
    if(!(Get-AzResourceGroup $resourceGroup -ErrorAction SilentlyContinue)){
        Write-Host "Create resource group: $resourceGroup" -ForegroundColor Yellow
        New-AzResourceGroup -Name $resourceGroup -Location $location -Tag @{$creationDate = $creationDate}
    }
    # else{
    #     Write-Host "$resourceGroup exists." -ForegroundColor Yellow
    # }
    # if($WhatIf){
    #     Write-Host "Running WhatIf" -ForegroundColor Green
    #     $provision = New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile 'Provision.bicep' -vmName $VM -adminUsername $adminUsername -adminPassword $adminPassword
    # }
    # else{
    #     $provisionVNET = New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile 'VNET-Deployment' -VNetName 'cyberlabVNet' -SubNetName  'cyberlabVMSubnet'
    #     $VNetID = Get-AzResource -name 'cyberlabVNet' -ResourceGroupName $resourceGroup

    #     foreach ($VM in $vmNames)
    #     {
    #         Write-Host "Running resource provision" -ForegroundColor Green
    #         $provision = New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile 'Provision.bicep' -vmName $VM -adminUsername $adminUsername -adminPassword $adminPassword -VNetId $VNetID -SubNetName 'cyberlabVMSubnet'
    #     }

    #     return  $provision
    # }
   }