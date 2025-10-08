import vconnect

import json
with open('vcenter-conf.json', 'r') as f:
    vcenter_conf = json.load(f)

def vcenter_info():
    vcenterinfo = vconnect.si.content.about
    print()
    print(vcenterinfo)

def session_info():
    current_user = vconnect.si.content.sessionManager.currentSession.userName
    current_host = vcenter_conf['vcenter'][0]['vcenterhost']
    current_IP = vconnect.si.content.sessionManager.currentSession.ipAddress

    print()
    print("Connected User: " + current_user)
    print("Current vCenter: " + current_host)
    print("Connection Source IP: " + current_IP)

# VmInfo function was adapted and inspired by the pyvmomi community samples page (getallvms.py, get_vm_names.py)
# Code was refined and reorganized for effecienty through the use of AI tools (Gemini)
def vmInfo():
    import ssl
    from pyVmomi import vim
    content = vconnect.si.RetrieveContent()
    container_view = content.viewManager.CreateContainerView(content.rootFolder, [vim.VirtualMachine], True)
    vms = container_view.view

    print()
    print("List of the VMs on " + (vcenter_conf['vcenter'][0]['vcenterhost']))
    for vm in vms:
        print(vm.name)
    print()

    vmchoice = str(input("Enter the name of the desided VM or leave blank to see all VM's imfo: "))
    target_vm = None
    print()
    
    if vmchoice != "":
        for vm in vms:
            if vm.name == vmchoice:
                target_vm = vm
                break
        
        if target_vm:
            print(f"Vm Name: {target_vm.name}")
            print(f"Power State: {target_vm.runtime.powerState}")
            if target_vm.guest and target_vm.guest.ipAddress:
                print(f"IP Address: {target_vm.guest.ipAddress}")
            print(f"Number of CPUs: {target_vm.summary.config.numCpu}")
            print(f"Memory Total: {round((target_vm.summary.config.memorySizeMB) / 1000)}" + " GB")
        else:
            print(f"\nVM '{vmchoice}' not found.")
            print()
    elif vmchoice == "":
        for vm in vms:
            print(f"Vm Name: {vm.name}")
            print(f"Power State: {vm.runtime.powerState}")
            if vm.guest and vm.guest.ipAddress:
                print(f"IP Address: {vm.guest.ipAddress}")
            print(f"Number of CPUs: {vm.summary.config.numCpu}")
            print(f"Memory Total: {round((vm.summary.config.memorySizeMB) / 1000)}" + " GB")
            print()

# Menu created by referencing Andy Delinski menu tutorial on youtube:
# www.youtube.com/watch?v=63nw00JqHo0
def menu():
    print("[1] vCenter Info")
    print("[2] Session Info")
    print("[3] VM info")
    print("[0] Exit the program")

menu()
option = int(input("Enter your option: "))

while option != 0:
    if option == 1:
        vcenter_info()
    elif option == 2:
        session_info()
    elif option == 3:
        vmInfo()
    else:
        print("Invalid option.")
        
    print()
    menu()
    option = int(input("Enter your option: "))
