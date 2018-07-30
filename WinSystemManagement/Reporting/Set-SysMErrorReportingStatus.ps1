#Requires -Version 4.0

<#
.SYNOPSIS
    Enables or disables Windows Error Reporting

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
    © AppSphere AG

.COMPONENT

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/WinClientManagement/Reporting

.Parameter Status
    Specifies the status to set for Windows Error Reporting
#>

[CmdLetBinding()]
Param(
    [ValidateSet("Enable", "Disable")]
    [string]$Status = "Enable"
)

Import-Module WindowsErrorReporting

try{
    [string]$Script:Msg
    if($Status -eq "Enable"){
        Enable-WindowsErrorReporting -ErrorAction Stop
    }
    else {
        Disable-WindowsErrorReporting -ErrorAction Stop
    }
    $Script:Msg = Get-WindowsErrorReporting | Format-List
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:Msg 
    }
    else{
        Write-Output $Script:Msg
    }
}
catch{
    throw
}
finally{
}