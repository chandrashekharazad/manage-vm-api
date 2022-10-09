namespace manage_vm_api.Models
{
    public class VirtualMachine
    {
        public string adminUserName { get; set; }
        public string adminPassword { get; set; }
        public string resourceGroup { get; set; }
        public string location { get; set; }
        public List<string> vmNames { get; set; }
    }
}
