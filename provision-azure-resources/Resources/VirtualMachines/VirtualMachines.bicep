@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
param adminPassword string

param location string = resourceGroup().location

param vmName string

param VNetId string
param SubNetName string

resource VM_PublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' ={
  name: '${vmName}-PublicIP'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource NIC_VM 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: '${vmName}-NIC'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddress: {
            id: VM_PublicIP.id
          }
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${VNetId}/subnets/${SubNetName}'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource VirtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties:{
    hardwareProfile: {
      vmSize:'Standard_D2s_v3'
      }
      storageProfile: {
        osDisk: {
          name: '${vmName}-osDisk'
          createOption: 'FromImage'
          osType: 'Windows'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }
        imageReference: {
          publisher: 'MicrosoftWindowsDesktop'
          offer: 'Windows-10'
          sku: '19H1-ent'
          version: '18362.1198.2011031735'
        }
      }
      osProfile: {
        computerName: vmName
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: NIC_VM.id
          }
        ]
      }
  }
}
