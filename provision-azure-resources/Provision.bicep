param vmName string
param region string = resourceGroup().location
// param creationDate string

// param resourceTags object ={
//   CreationDate: creationDate
// }

param adminUsername string
param adminPassword string

param VNetId string
param SubNetName string


module virtualMachine 'Resources/VirtualMachines/VirtualMachines.bicep' = {
  name: 'vmDeploy'
  params:{
    vmName: vmName
    location: region
    adminUsername: adminUsername
    adminPassword: adminPassword
    VNetId: VNetId
    SubNetName: SubNetName
  }
}
