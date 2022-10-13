function ArmTemplateFunction{
    param(
   [parameter(mandatory =$true)]
    [string]$adminusername,
    [parameter(mandatory =$true)]
    [string]$adminpassword,
    [parameter(mandatory =$true)]
   [string]$resourcegroup,
    [parameter(mandatory =$true)]
    [string]$location,
    [parameter(mandatory =$true)]
    [string[]]$vmNames,
    [parameter(mandatory =$false)]
    [string]$targetsubscription,
    [parameter(mandatory =$false)]
    [bool]$whatif = $false
    ) 

    $Logfile = "D:\Upwork\Azure-VM\manage-vm-api\manage-vm-api\provision-azure-resources\lohfile.log"

    $context = Get-AzSubscription -SubscriptionName $targetsubscription
    Set-AzContext $context

    Write-Host($adminUserName)
    Write-Host($adminPassword)
    Write-Host($resourceGroup)
    Write-Host($location)
    Write-Host($vmNames)


    $creationDate = Get-Date -Format "dd/MM/yyyy"

    # check if the resource group exists if it doesn't create it
    if(!(Get-AzResourceGroup $resourceGroup -ErrorAction SilentlyContinue)){
        Write-Host "Create resource group: $resourceGroup" -ForegroundColor Yellow
        $provision = New-AzResourceGroup -Name $resourceGroup -Location $location -Tag @{$creationDate = $creationDate}
    }
    else{
        Write-Host "$resourceGroup exists." -ForegroundColor Yellow
        Add-content $Logfile -value "$resourceGroup exists."
    }
    if($WhatIf){
        Write-Host "Running WhatIf" -ForegroundColor Green

        $provisionVNET = New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile 'D:\Upwork\Azure-VM\manage-vm-api\manage-vm-api\provision-azure-resources\VNET-Deployment.bicep' -VNetName 'cyberlabVNet' -SubNetName  'cyberlabVMSubnet' -WhatIf
        $VNetID = Get-AzResource -name 'cyberlabVNet' -ResourceGroupName $resourceGroup

        foreach ($VM in $vmNames)
        {
            Write-Host "Running resource provision" -ForegroundColor Green
            $provision = New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile 'D:\Upwork\Azure-VM\manage-vm-api\manage-vm-api\provision-azure-resources\Provision.bicep' -vmName $VM -adminUsername $adminUsername -adminPassword $adminPassword -VNetId $VNetID -SubNetName 'cyberlabVMSubnet' -WhatIf
        }
    }
    else{

        try {
            $provisionVNET = New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile 'D:\Upwork\Azure-VM\manage-vm-api\manage-vm-api\provision-azure-resources\VNET-Deployment.bicep' -VNetName 'cyberlabVNet' -SubNetName  'cyberlabVMSubnet'

            
            Add-content $Logfile -value $provisionVNET.Outputs

            $VNetID = Get-AzResource -name 'cyberlabVNet' -ResourceGroupName $resourceGroup
    
            foreach ($VM in $vmNames)
            {
                Add-content $Logfile -value "Creating ${VM}"
                Write-Host "Running resource provision" -ForegroundColor Green
                $provision = New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile 'D:\Upwork\Azure-VM\manage-vm-api\manage-vm-api\provision-azure-resources\Provision.bicep' -vmName $VM  -adminUsername $adminUsername -adminPassword $adminPassword -VNetId $VNetID.ResourceId -SubNetName 'cyberlabVMSubnet'
            }
        }
        catch {
            Add-content $Logfile -value $_.Exception.Message
            return $_.Exception.Message

        }
    }
    
   }