[string]$Script:Group = 'auth'

function Clear-PacAuth {
    param (
        [switch]$ShowCommand
    )

    if ($ShowCommand) {
        Write-Host "pac auth clear"
    } else {
        #& pac auth clear
        Write-Warning "not implemented yet"
    }

    
}

function Get-PacAuth {
    param (
        [switch]$ShowCommand
    )

    $CommandName = 'list'
    $Command = Get-PacCommand -Group $Script:Group -Command $CommandName -Params $PSBoundParameters

    if ($ShowCommand) {
       $Command
    } else {
        & pac $Script:Group list
    }    
}

function New-PacAuth {
    param (
    # --name                      The name you want to give to this authentication profile (maximum 30 characters). (alias: -n)
    # --username                  Optional: The username to authenticate with; shows Microsoft Entra ID dialog if not specified. (alias: -un)
    # --password                  Optional: The password to authenticate with (alias: -p)
    # --applicationId             Optional: The application ID to authenticate with. (alias: -id)
    # --clientSecret              Optional: The client secret to authenticate with (alias: -cs)
    # --certificateDiskPath       Optional: The certificate disk path to authenticate with (alias: -cdp)
    # --certificatePassword       Optional: The certificate password to authenticate with (alias: -cp)
    # --tenant                    Tenant ID if using application ID/client secret or application ID/client certificate. (alias: -t)
    # --cloud                     Optional: The cloud instance to authenticate with (alias: -ci)
    #                             Values: Public, UsGov, UsGovHigh, UsGovDod, China
    # --deviceCode                Use the Microsoft Entra ID Device Code flow for interactive sign-in. (alias: -dc)
    # --managedIdentity           Use Azure Managed Identity. (alias: -mi)
    # --environment               Default environment (ID, url, unique name, or partial name). (alias: -env)
    # --kind                      (deprecated) The kind of authentication profile you're creating. (alias: -k)
    # --url                       (deprecated) The resource URL to connect to (alias: -u)

        [Parameter(Mandatory = $true)]
        [alias("n")]
        [string]$Name,

        [Parameter(Mandatory = $false, ParameterSetName = "WithUsernamePassword")]
        [alias("un")]
        [string]$Username,

        [Parameter(Mandatory = $false, ParameterSetName = "WithUsernamePassword")]
        [alias("p")]
        [securestring]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = "WithServicePrincipalAndClientSecret")]
        [Parameter(Mandatory = $true, ParameterSetName = "WithServicePrincipalAndCertificate")]
        [alias("ClientId")]
        [alias("Id")]
        [string]$ApplicationId ,
        
        [Parameter(Mandatory = $true, ParameterSetName = "WithServicePrincipalAndClientSecret")]
        [alias("cs")]
        [securestring]$ClientSecret,

        [Parameter(Mandatory = $true, ParameterSetName = "WithServicePrincipalAndCertificate")]
        [alias("cdp")]
        [string]$CertificateDiskPath ,
        
        [Parameter(Mandatory = $true, ParameterSetName = "WithServicePrincipalAndCertificate")]
        [alias("cp")]
        [securestring]$CertificatePassword,

        [Parameter(Mandatory = $true, HelpMessage = "Tenant ID if using application ID/client secret or application ID/client certificate.")]
        [alias("t")]
        [string]$Tenant ,

        [switch]$ShowCommand
    )

    $CommandName = 'create'
    $Command = Get-PacCommand -Group $Script:Group -Command $CommandName -Params $PSBoundParameters

    if ($ShowCommand) {
        $Command 
    } else {
        # & $Command
        Write-Warning "not implemented yet"
    }

    
}

function Remove-PacAuth {
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
        [alias("n")]
        [string]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = "ByIndex")]
        [alias("i")]
        [string]$Index,

        [switch]$ShowCommand
    )
    $CommandName = 'delete'
    $Command = Get-PacCommand -Group $Script:Group -Command $CommandName -Params $PSBoundParameters

    if ($ShowCommand) {
        $Command 
    } else {
        # & $Command
        Write-Warning "not implemented yet"
    }

}