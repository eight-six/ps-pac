
function DoIt {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [pscustomobject]$PacCommand,
        [switch]$ShowCommand
    )

    if($ShowCommand) {
        $PacCommand.GetDisplayText()
    } else {
        &  $PacCommand.Exe $PacCommand.Tokens
    }
}