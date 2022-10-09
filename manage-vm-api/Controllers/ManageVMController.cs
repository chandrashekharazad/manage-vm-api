using manage_vm_api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace manage_vm_api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ManageVMController : ControllerBase
    {
        [HttpPost(Name = "CreateVM")]
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
                                                                    {"location",virtualMachine.location},
                                                                    {"vmNames",virtualMachine.vmNames},

                                                                        });

                    //PowerShellInst.AddParameter("vmNames", virtualMachine.vmNames);
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
    }
}
