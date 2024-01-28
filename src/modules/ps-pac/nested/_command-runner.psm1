
function DoIt {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [pscustomobject]$PacCommand,
        [switch]$ShowCommand
    )

    if($ShowCommand) {
        $PacCommand.GetDisplayText()
    } else {
        Write-Verbose -Message "Executing ``$($PacCommand.GetDisplayText())``"
        &  $PacCommand.Exe $PacCommand.Tokens
    }
}