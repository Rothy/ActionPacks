#Requires -Version 4.0
# Requires -Modules VMware.PowerCLI

<#
.SYNOPSIS
    Creates a new resource pool

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
    https://github.com/scriptrunner/ActionPacks/tree/master/VMware/ResourcePool

.Parameter VIServer
    Specifies the IP address or the DNS name of the vSphere server to which you want to connect

.Parameter VICredential
    Specifies a PSCredential object that contains credentials for authenticating with the server

.Parameter Name
    Specifies a name for the new resource pool

.Parameter VMHost
    Specifies the host on which you want to create the new resource pool

.Parameter CpuExpandableReservation
    Indicates that the CPU reservation can grow beyond the specified value if the parent resource pool has unreserved resources

.Parameter CpuLimitMhz
    Specifies a CPU usage limit in MHz

.Parameter CpuReservationMhz
    Specifies the CPU size in MHz that is guaranteed to be available

.Parameter CpuSharesLevel
    Specifies the CPU allocation level for this pool

.Parameter MemExpandableReservation
    If the value is $true, the memory reservation can grow beyond the specified value if the parent resource pool has unreserved resources

.Parameter MemLimitGB
    Specifies a memory usage limit in gigabytes (GB)

.Parameter MemReservationGB
    Specifies the guaranteed available memory in gigabytes (GB)

.Parameter MemSharesLevel
    Specifies the memory allocation level for this pool

.Parameter NumCpuShares
    Specifies the CPU allocation level for this pool

.Parameter NumMemShares
    Specifies the memory allocation level for this pool
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$VIServer,
    [Parameter(Mandatory = $true)]
    [pscredential]$VICredential,
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$VMHost,
    [bool]$CpuExpandableReservation,
    [int64]$CpuLimitMhz,
    [int64]$CpuReservationMhz,
    [ValidateSet("Custom", "High", "Low","Normal")]
    [string]$CpuSharesLevel,
    [bool]$MemExpandableReservation,
    [decimal]$MemLimitGB,
    [decimal]$MemReservationGB,
    [ValidateSet("Custom", "High", "Low","Normal")]
    [string]$MemSharesLevel,
    [int32]$NumCpuShares,
    [int32]$NumMemShares
)

Import-Module VMware.PowerCLI

try{
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop

    $Script:pool = New-ResourcePool -Server $Script:vmServer -Location $VMHost -Name $Name -Confirm:$false -ErrorAction Stop

    if($PSBoundParameters.ContainsKey('CpuExpandableReservation') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -CpuExpandableReservation $CpuExpandableReservation -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('CpuLimitMhz') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -CpuLimitMhz $CpuLimitMhz -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('CpuReservationMhz') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -CpuReservationMhz $CpuReservationMhz -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('CpuSharesLevel') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -CpuSharesLevel $CpuSharesLevel -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('MemExpandableReservation') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -MemExpandableReservation $MemExpandableReservation -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('MemLimitGB') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -MemLimitGB $MemLimitGB -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('MemReservationGB') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -MemReservationGB $MemReservationGB -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('MemSharesLevel') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -MemSharesLevel $MemSharesLevel -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('NumCpuShares') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -NumCpuShares $NumCpuShares -Confirm:$false -ErrorAction Stop
    }
    if($PSBoundParameters.ContainsKey('NumMemShares') -eq $true){
        $Script:pool = Set-ResourcePool -Server $Script:vmServer -ResourcePool $Script:pool -NumMemShares $NumMemShares -Confirm:$false -ErrorAction Stop
    }
   
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:pool | Select-Object * 
    }
    else{
        Write-Output $Script:pool | Select-Object *
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