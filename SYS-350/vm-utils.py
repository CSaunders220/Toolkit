import vconnect

import json
with open('vcenter-conf.json', 'r') as f:
    vcenter_conf = json.load(f)

# SnapVM function loosely based on the snapshot VM pyvmomi community sample. 

def snapVM():
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

    vmchoice = str(input("Enter the name of the desired VM to snapshot: "))
    target_vm = None
    print()
    
    for vm in vms:
        if vm.name == vmchoice:
            target_vm = vm
            break

    if target_vm:
        desc = str(input("Enter a short description for the snapshot: "))
        snapName = str(input("Enter a name for the snapshot: "))
        target_vm.CreateSnapshot_Task(name=snapName, description=desc, memory=False, quiesce=False)
        print(f"Taking a snapshot of {vmchoice}")
        print(f"{vmchoice} snapshotted successfully!")
    else:
        print(f"{vmchoice} was not found")

# Power VM function inspired by the pyvmomi community sample provided and in 
# part from the instructor's demo by Ryan Gillen

def powerVM():
    import ssl
    from pyVmomi import vim
    content = vconnect.si.RetrieveContent()
    container_view = content.viewManager.CreateContainerView(content.rootFolder, [vim.VirtualMachine], True)
    vms = container_view.view

    print()
    print("[1] Power On VMs")
    print("[2] Power Off VMs")

    powerChoice = int(input("Enter your option: "))

    if powerChoice == 1:
        print()
        print("List of the VMs on " + (vcenter_conf['vcenter'][0]['vcenterhost']))
        for vm in vms:
            print(vm.name)
        print()

        vmchoice = str(input("Enter the name of the desired VM or leave blank to power on all VMs: "))
        target_vm = None
        print()
        
        if vmchoice != "":
            for vm in vms:
                if vm.name == vmchoice:
                    target_vm = vm
                    break
            if target_vm:
                if target_vm.runtime.powerState == vim.VirtualMachine.PowerState.poweredOff:
                    print(f"Powering on {vmchoice}")
                    target_vm.PowerOn()
                    print(f"{vmchoice} powered on successfully!")
                else:
                    print(f"{vmchoice} is already on or in a different state currently...")
            else:
                print(f"{vmchoice} was not found...")
        elif vmchoice == "":
            for vm in vms:
                if vm.runtime.powerState == vim.VirtualMachine.PowerState.poweredOff:
                    print(f"Powering on {vm.name}")
                    vm.PowerOn()
                    print(f"{vm.name} powered on successfully!")
                else:
                    print(f"{vm.name} is already on or in a different state currently...")
    elif powerChoice == 2:
        print()
        print("List of the VMs on " + (vcenter_conf['vcenter'][0]['vcenterhost']))
        for vm in vms:
            print(vm.name)
        print()

        vmchoice = str(input("Enter the name of the desired VM to power off: "))
        target_vm = None
        print()
        
        if vmchoice != "":
            for vm in vms:
                if vm.name == vmchoice:
                    target_vm = vm
                    break
            if target_vm:
                if target_vm.runtime.powerState == vim.VirtualMachine.PowerState.poweredOn:
                    print(f"Powering off {vmchoice}")
                    target_vm.PowerOff()
                    print(f"{vmchoice} powered off successfully!")
                else:
                    print(f"{vmchoice} is already off or in a different state currently...")
            else:
                print(f"{vmchoice} was not found...")
        else:
            print("Invalid selection, no input detected and no bulk power off allowed...")

# Full clone function inspired by and modeled from the clone vm pyvmomi community sample.

def fClone():
    import ssl
    from pyVmomi import vim
    content = vconnect.si.RetrieveContent()
    container_view = content.viewManager.CreateContainerView(content.rootFolder, [vim.VirtualMachine], True)
    host_view = content.viewManager.CreateContainerView(content.rootFolder, [vim.HostSystem], True)
    vms = container_view.view

    templates = []

    for vm in vms:
        if vm.config and vm.config.template:
            templates.append(vm)
    
    print("List of available templates on host:")
    for template in templates:
        print(template.name)
    print()

    templateSelection = str(input("Enter the name of the desired template to full clone: "))
    print()

    targetTemplate = None
    for template in templates:
        if template.name == templateSelection:
            targetTemplate = template
            break

    if targetTemplate:
        newName = str(input("Enter the new name for the cloned VM: "))

        datacenter = content.rootFolder.childEntity[0]
        resource_pool = datacenter.hostFolder.childEntity[0].resourcePool
        datastore = None
        for ds in content.rootFolder.childEntity[0].datastore:
            if ds.name == 'datastore2-super11':
                datastore = ds
                break

        relospec = vim.vm.RelocateSpec()
        relospec.pool = datacenter.hostFolder.childEntity[0].resourcePool
        relospec.datastore = datastore

        hostName = None
        for host in host_view.view:
            if host.name == 'super11':
                hostName = host.name

        clonespec = vim.vm.CloneSpec()
        clonespec.location = relospec
        clonespec.location.host = host
        clonespec.powerOn = False
        clonespec.template = False

        print(datastore.name)
        print(datacenter.name)

        print(f"Cloning {templateSelection}")
        task = targetTemplate.CloneVM_Task(folder=datacenter.vmFolder, name=newName, spec=clonespec)

        while task.info.state in [vim.TaskInfo.State.running, vim.TaskInfo.State.queued]:
            pass

        print()
        if task.info.state == vim.TaskInfo.State.success:
            print("Cloned successfully!")
        else:
            print(f"Error cloning template...")
    else:
        print("Target VM not found...")

#Linked clone function also based on the same clone vm pyvmomi sample. 

def lClone():
    import ssl
    from pyVmomi import vim
    content = vconnect.si.RetrieveContent()
    container_view = content.viewManager.CreateContainerView(content.rootFolder, [vim.VirtualMachine], True)
    host_view = content.viewManager.CreateContainerView(content.rootFolder, [vim.HostSystem], True)
    vms = container_view.view

    templates = []

    for vm in vms:
        if vm.config and vm.config.template:
            templates.append(vm)
    
    print("List of available templates on host:")
    for template in templates:
        print(template.name)
    print()

    templateSelection = str(input("Enter the name of the desired template to full clone: "))
    print()

    targetTemplate = None
    for template in templates:
        if template.name == templateSelection:
            targetTemplate = template
            break

    if targetTemplate:
        newName = str(input("Enter the new name for the cloned VM: "))

        datacenter = content.rootFolder.childEntity[0]
        resource_pool = datacenter.hostFolder.childEntity[0].resourcePool
        datastore = None
        for ds in content.rootFolder.childEntity[0].datastore:
            if ds.name == 'datastore2-super11':
                datastore = ds
                break

        relospec = vim.vm.RelocateSpec()
        relospec.diskMoveType = 'createNewChildDiskBacking'
        relospec.pool = datacenter.hostFolder.childEntity[0].resourcePool
        relospec.datastore = datastore

        hostName = None
        for host in host_view.view:
            if host.name == 'super11':
                hostName = host.name

        clonespec = vim.vm.CloneSpec()
        clonespec.location = relospec
        clonespec.location.host = host
        clonespec.powerOn = False
        clonespec.template = True

        print(datastore.name)
        print(datacenter.name)

        print(f"Cloning {templateSelection}")
        task = targetTemplate.CloneVM_Task(folder=datacenter.vmFolder, name=newName, spec=clonespec)

        while task.info.state in [vim.TaskInfo.State.running, vim.TaskInfo.State.queued]:
            pass

        print()
        if task.info.state == vim.TaskInfo.State.success:
            print("Cloned successfully!")
        else:
            print(f"Error cloning template...")
    else:
        print("Target VM not found...")

# SnapRevert function based off of the snapshot management pyvmomi community sample. 

def snapRevert():
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

    vmchoice = str(input("Enter the name of the desired VM to snapshot: "))
    target_vm = None
    print()
    
    for vm in vms:
        if vm.name == vmchoice:
            target_vm = vm
            break
    
    if target_vm:
        if target_vm.snapshot is None:
            print(f"{vmchoice} has no snapshots available...")
        else:
            for snapshot in target_vm.snapshot.rootSnapshotList:
                print("==========================")
                print(snapshot.name)
                print(snapshot.description)
                print("==========================")
            print()
            snapChoice = str(input("Enter the name of the desired snapshot: "))
            for snapshot in target_vm.snapshot.rootSnapshotList:
                if snapChoice == snapshot.name:
                    targetsnap = snapshot
            if targetsnap:
                targetsnap.snapshot.RevertToSnapshot_Task()
                print(f"{snapChoice} reverted successfully!")
            else:
                print("Snapshot not found...")
    else:
        print(f"{vmchoice} not found in server...")

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

    vmchoice = str(input("Enter the name of the desired VM or leave blank to see all VM's imfo: "))
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

# Remove vm is loosely based off of the pyvmomi vm management community sample. 

def removeVM():
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

    vmchoice = str(input("Enter the name of the desired VM or leave blank to see all VM's imfo: "))
    target_vm = None
    print()

    for vm in vms:
            if vm.name == vmchoice:
                target_vm = vm
                break
    doubleCheck = str(input(f"Are you sure you wish to delete {vmchoice}? (Y/n)"))

    if target_vm:
        if doubleCheck == 'Y' or 'y':
            print()
            print(f"Attempting to delete {vmchoice}")
            target_vm.Destroy_Task()
        else:
            print()
            print("Double check failed, aborting...")
    else:
        print()
        print("VM not found, aborting...")

def vmFunctions():
    import ssl
    from pyVmomi import vim
    content = vconnect.si.RetrieveContent()
    container_view = content.viewManager.CreateContainerView(content.rootFolder, [vim.VirtualMachine], True)
    vms = container_view.view
    vmUtilMenu()  

    utilChoice = int(input("Enter your option: "))
    
    while utilChoice != 0:
        if utilChoice == 1:
            powerVM()
        elif utilChoice == 2:
            snapVM()
        elif utilChoice == 3:
            fClone()
        elif utilChoice == 4:
            lClone()
        elif utilChoice == 5:
            removeVM()
        elif utilChoice == 6:
            snapRevert()
        else:
            print("Invalid option.")
        
        print()
        vmUtilMenu()
        utilChoice = int(input("Enter your option: "))

def vmUtilMenu():
    print()
    print("[1] Power VMs")
    print("[2] Snapshot VM")
    print("[3] Full Clone VM")
    print("[4] Linked Clone VM")
    print("[5] Delete VM")
    print("[6] Revert VM to Snapshot")
    print("[0] Exit the program")

# Menu created by referencing Andy Delinski menu tutorial on youtube:
# www.youtube.com/watch?v=63nw00JqHo0
def menu():
    print()
    print("[1] vCenter Info")
    print("[2] Session Info")
    print("[3] VM info")
    print("[4] VM Utils")
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
    elif option == 4:
        vmFunctions()
    else:
        print("Invalid option.")
        
    print()
    menu()
    option = int(input("Enter your option: "))
