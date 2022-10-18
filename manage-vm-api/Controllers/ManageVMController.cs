using manage_vm_api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System;
using System.Threading.Tasks;
using Azure.Core;
using Azure.Identity;
using Azure.ResourceManager;
using Azure.ResourceManager.Compute;
using Azure.ResourceManager.Resources;
using Azure;
using System.Xml.Linq;

namespace manage_vm_api.Controllers
{
    [ApiController]
    [Route("api/")]
    public class ManageVMController : ControllerBase
    {
        ArmClient client = new ArmClient(new DefaultAzureCredential());

        [HttpPost("CreateVM")]
        public PSObject CreateVM(VirtualMachine virtualMachine)
        {
            try
            {
                //Execute PS1(PowerShell script) file
                using (PowerShell PowerShellInst = PowerShell.Create())
                {
                    string path = System.IO.Path.GetDirectoryName(@"D:\Upwork\Azure-VM\manage-vm-api\manage-vm-api\provision-azure-resources\") + "\\ArmTemplateFunction.ps1";
                    if (!string.IsNullOrEmpty(path))
                        PowerShellInst.AddScript(System.IO.File.ReadAllText(path));

                    var outPut = PowerShellInst.Invoke();
                    PowerShellInst.AddCommand("ArmTemplateFunction");
                    PowerShellInst.AddParameters(new Dictionary<string, string>
                                                                {
                                                                    {"adminUserName" ,virtualMachine.adminUserName},
                                                                    {"adminPassword",virtualMachine.adminPassword},
                                                                    {"resourceGroup",virtualMachine.resourceGroup},
                                                                    {"location",virtualMachine.location}

                                                                        });

                    PowerShellInst.AddParameter("vmNames", virtualMachine.vmNames);
                    foreach (PSObject result in PowerShellInst.Invoke())
                    {
                        return result;
                    }
                    Console.WriteLine("Done");
                    Console.Read();
                }
            } 
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            return null;
        }

        [HttpGet("ListVM")]
        public async Task<VirtualMachineCollection> ListVM()
        {
            ArmClient client = new ArmClient(new DefaultAzureCredential());
            string resourceGroupName = "cyberlab003";
            SubscriptionResource subscription = await client.GetDefaultSubscriptionAsync();
            ResourceGroupCollection resourceGroups = subscription.GetResourceGroups();
            ResourceGroupResource resourceGroup = await resourceGroups.GetAsync(resourceGroupName);

            var vmList = resourceGroup.GetVirtualMachines();

            return vmList;
        }

        [HttpGet("StartVM")]
        public async Task<ArmOperation> StartVM(string vmName)
        {
            ArmClient client = new ArmClient(new DefaultAzureCredential());
            string resourceGroupName = "cyberlab003";
            SubscriptionResource subscription = await client.GetDefaultSubscriptionAsync();
            ResourceGroupCollection resourceGroups = subscription.GetResourceGroups();
            ResourceGroupResource resourceGroup = await resourceGroups.GetAsync(resourceGroupName);

            var vm = resourceGroup.GetVirtualMachine(vmName);

            var result = await vm.Value.PowerOnAsync(WaitUntil.Started);

            return result;
        }

        [HttpPost("StopVM")]
        public async Task<ArmOperation> StopVM(string vmName)
        {
            ArmClient client = new ArmClient(new DefaultAzureCredential());
            string resourceGroupName = "cyberlab003";
            SubscriptionResource subscription = await client.GetDefaultSubscriptionAsync();
            ResourceGroupCollection resourceGroups = subscription.GetResourceGroups();
            ResourceGroupResource resourceGroup = await resourceGroups.GetAsync(resourceGroupName);

            var vm = resourceGroup.GetVirtualMachine(vmName);

            var result = await vm.Value.PowerOffAsync(WaitUntil.Completed);

            return result;
        }

        [HttpGet("DeleteVM")]
        public async Task<ArmOperation> DeleteVM(string vmName)
        {
            ArmClient client = new ArmClient(new DefaultAzureCredential());
            string resourceGroupName = "cyberlab003";
            SubscriptionResource subscription = await client.GetDefaultSubscriptionAsync();
            ResourceGroupCollection resourceGroups = subscription.GetResourceGroups();
            ResourceGroupResource resourceGroup = await resourceGroups.GetAsync(resourceGroupName);

            var vm = resourceGroup.GetVirtualMachine(vmName);

            var result = await vm.Value.DeleteAsync(WaitUntil.Completed);

            return result;
        }
    }
}
