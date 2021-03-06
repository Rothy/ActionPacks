#Requires -Version 4.0
# Requires -Modules VMware.PowerCLI

<#
.SYNOPSIS
    Retrieves the virtual SCSI controller assigned to the specified HardDisk, VirtualMachine, Template, or Snapshot object

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
    © AppSphere AG

.COMPONENT
    Requires Module VMware.PowerCLI

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/VMware/Disks

.Parameter VIServer
    Specifies the IP address or the DNS name of the vSphere server to which you want to connect

.Parameter VICredential
    Specifies a PSCredential object that contains credentials for authenticating with the server

.Parameter VMName
    Specifies the virtual machine from which you want to retrieve the SCSI controllers 

.Parameter TemplateName
    Specifies the virtual machine template from which you want to retrieve the SCSI controllers 

.Parameter SnapshotName
    Specifies the snapshot from which you want to retrieve the SCSI controllers 

.Parameter DiskName
    Specifies the name of the SCSI hard disk you want to retrieve the SCSI controllers 

.Parameter ControllerName
    Specifies the names of the SCSI controllers you want to retrieve, is the parameter empty all SCSI controllers retrieved
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true,ParameterSetName = "VM")]
    [Parameter(Mandatory = $true,ParameterSetName = "Template")]
    [Parameter(Mandatory = $true,ParameterSetName = "Snapshot")]
    [string]$VIServer,
    [Parameter(Mandatory = $true,ParameterSetName = "VM")]
    [Parameter(Mandatory = $true,ParameterSetName = "Template")]
    [Parameter(Mandatory = $true,ParameterSetName = "Snapshot")]
    [pscredential]$VICredential,
    [Parameter(Mandatory = $true,ParameterSetName = "VM")]
    [Parameter(Mandatory = $true,ParameterSetName = "Snapshot")]
    [string]$VMName,
    [Parameter(Mandatory = $true,ParameterSetName = "Template")]    
    [string]$TemplateName,
    [Parameter(Mandatory = $true,ParameterSetName = "Snapshot")]
    [string]$SnapshotName,
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [string]$DiskName,
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [string]$ControllerName
)

Import-Module VMware.PowerCLI

try{
    if([System.String]::IsNullOrWhiteSpace($DiskName) -eq $true){
        $DiskName = "*"
    }
    if([System.String]::IsNullOrWhiteSpace($ControllerName) -eq $true){
        $ControllerName = "*"
    }
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop
    
    if($PSCmdlet.ParameterSetName  -eq "Snapshot"){
        $vm = Get-VM -Server $Script:vmServer -Name $VMName -ErrorAction Stop
        $snap = Get-Snapshot -Server $Script:vmServer -Name $SnapshotName -VM $vm -ErrorAction Stop
        $Script:harddisks = Get-HardDisk -Server $Script:vmServer -Snapshot $snap -Name $DiskName -ErrorAction Stop        
    }
    elseif($PSCmdlet.ParameterSetName  -eq "Template"){
        $temp = Get-Template -Server $Script:vmServer -Name $TemplateName -ErrorAction Stop
        $Script:harddisks = Get-HardDisk -Server $Script:vmServer -Template $temp -Name $DiskName -ErrorAction Stop
    }
    else {
        $vm = Get-VM -Server $Script:vmServer -Name $VMName -ErrorAction Stop        
        $Script:harddisks = Get-HardDisk -Server $Script:vmServer -VM $vm -Name $DiskName -ErrorAction Stop
    }
    $script:output = Get-ScsiController -Server $Script:vmServer -HardDisk $Script:harddisks -Name $ControllerName -ErrorAction Stop | Select-Object *

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $script:output
    }
    else{
        Write-Output $script:output
    }
}
catch{
    throw
}
finally{    
    if($null -ne $Script:vmServer){
        Disconnect-VIServer -Server $Script:vmServer -Force -Confirm:$false
    }
}