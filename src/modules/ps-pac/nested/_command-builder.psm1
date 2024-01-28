
$Script:PacExe = 'pac'

$Script:IgnoreParams = , 'ShowCommand'
$Script:Switches = , 'Json'

function Get-PacCommand {
    param(
        [string]$Group,
        [string]$Command,
        [object]$Params
    )

    $Ret = [pscustomobject]@{
        Exe    = $Script:PacExe
        Tokens = $null
    }

    $Ret | Add-Member -MemberType 'ScriptMethod' -Name 'GetDisplayText' -Value {
        $this.Exe, ($this.Tokens -join ' ') -join ' '
    }

    $Ret.Tokens = @($Group, $Command)

    $Params.Keys | Where-Object { $_ -notin $Script:IgnoreParams }  | ForEach-Object {
        $Key = $_.ToLower()
        $Value = $Params[$key]
        Write-Verbose "Key: $Key, Value: $Value" -Verbose

        if ($Key -in $Script:Switches) {
            if ($Value ) {
                $Ret.Tokens += "--$Key"
            }
        }
        elseif ($value) {
            #TODO - think about this - should we allow empty strings/null values?
            Write-Verbose "Adding Key: $Key"
            $Ret.Tokens += "--$Key"
            $Ret.Tokens += $Value
        }   
    }

    $Ret
}