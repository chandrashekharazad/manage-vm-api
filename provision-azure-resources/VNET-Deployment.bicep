param VNetName string
param location string = resourceGroup().location
param SubNetName string

module VNet 'Resources/VirtualMachines/VNet.bicep' = {
  name: 'appService'
  params: {
    Location: location
    VNetName: VNetName
    SubNetName: SubNetName
  }
}
