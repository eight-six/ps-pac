[string]$Script:Group = 'org'

$Script:Commands = @{
    Fetch            = 'fetch' 
    List             = 'list'  
    'ListSettings'   = 'list-settings'
    Select           = 'select' 
    'UpdateSettings' = 'update-settings'
    Who              = 'who'
}


<#
    .SYNOPSIS Work with your Dataverse organization.
#>
function Get-PacOrg {
    param(
        [Parameter(Mandatory = $false, HelpMessage = 'Specifies the target Dataverse. The value may be a Guid or absolute https URL. When not specified, the active organization selected for the current auth profile will be used. (alias: -env)')]
        [alias('env')]
        [string]$Environment,
        [Parameter(Mandatory = $false, HelpMessage = 'Show only settings containing filter criteria (alias: -f)')]
        [alias('f')]
        [string]$Filter,
        [switch]$ShowCommand
    )

    Get-PacCommand -Group $Script:Group -Command $Script:Commands.List -Params $PSBoundParameters | 
    DoIt -ShowCommand:$ShowCommand

}

<#
    .SYNOPSIS List environment settings
#>
function Get-PacOrgSettings {
    param(        
        [Parameter(Mandatory = $false, HelpMessage = 'Specifies the target Dataverse. The value may be a Guid or absolute https URL. When not specified, the active organization selected for the current auth profile will be used. (alias: -env)')]
        [alias('env')]
        [string]$Environment,
        [Parameter(Mandatory = $false, HelpMessage = 'Show only settings containing filter criteria (alias: -f)')]
        [alias('f')]
        [string]$Filter,
        [switch]$ShowCommand
    )

    Get-PacCommand -Group $Script:Group -Command $Script:Commands.ListSettings -Params $PSBoundParameters | 
    DoIt -ShowCommand:$ShowCommand

}

function Get-PacOrgWhoAmI {
    param(
        [Parameter(Mandatory = $false, HelpMessage = 'Specifies the target Dataverse. The value may be a Guid or absolute https URL. When not specified, the active organization selected for the current auth profile will be used. (alias: -env)')]
        [alias('env')]
        [string]$Environment,
        [Alias('AsJson')]
        [switch]$Json,
        [switch]$ShowCommand
    )

    Get-PacCommand -Group $Script:Group -Command $Script:Commands.Who -Params $PSBoundParameters | 
    DoIt -ShowCommand:$ShowCommand

}

function Select-PacOrg {
    param(
        [Parameter(Mandatory = $true, HelpMessage = 'Default environment (ID, url, unique name, or partial name). (alias: -env)')]
        [alias('env')]
        [string]$Environment,
        [switch]$ShowCommand
    )

    Get-PacCommand -Group $Script:Group -Command $Script:Commands.Select -Params $PSBoundParameters | 
    DoIt -ShowCommand:$ShowCommand
}
