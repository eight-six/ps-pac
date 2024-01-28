$ErrorActionPreference = 'Stop'

<#
.SYNOPSIS
    Convert a string to camelCase.
#>
function ConvertTo-CamelCase {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$InputString
    )
    
    $Output = ConvertTo-PascalCase -InputString $InputString
    $Output = $Output.Substring(0, 1).ToLower() + $Output.Substring(1)
    $Output
}

function ConvertTo-KebabCase {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$InputString,
        [switch]$UpperCase
    )
    
    $Output = $InputString -creplace '([A-Z]+)', { ' ' + $_.Value.ToLower() }
    $Output = $Output.Trim()
    $Output = $Output -replace '[ _]', '-'
    $Output = $Output -replace '-+', '-'

    if ($UpperCase.IsPresent) {
        $Output = $Output.ToUpper()
    }

    $Output 
}

function ConvertTo-PascalCase {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$InputString
    )
    
    $Output = $InputString -creplace '([A-Z]+)', { ' ' + $_.Value.ToLower() }
    $Output = $Output.Trim()
    $Output = $Output -replace '[\-_]', ' '
    $Output = $Output -replace '\s+', ' '
    $Output = $Output -replace '(\w\w*)', { $_.Value.Substring(0, 1).ToUpper() + $_.Value.Substring(1) }
    $Output = $Output -replace '\s+', ''
    $Output
}

function ConvertTo-PascalCase2 {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [ValidatePattern('^[a-zA-z][a-zA-Z0-9- ]*$')]
        [string]$InputString
    )
    
    $Chars = $InputString.ToCharArray()
    $Buffer = [char[]]::new($Chars.Length * 2)
    $BufferIndex = 0
    $Offset = 32

    for ($i = 0; $i -lt $InputString.Length; $i++) {
        $Char = $Chars[$i]

        switch ($Char) {
            # space, dash
            { $Char -in 32, 45 } {
                $Offset = 32
            }
            # A-Z
            { $Char -ge 65 -and $Char -le 90 } {
                $Buffer[$BufferIndex] = $Char 
                $BufferIndex += 1
                $Offset = 0
            }
            # a-z
            { $Char -ge 97 -and $Char -le 122 } {
                $Buffer[$BufferIndex] = $Char - $Offset
                $BufferIndex += 1
                $Offset = 0
            }

            Default {
                # char is excluded. Treat as a space?
            }
        }
    }

    $Ret = [string]::new($Buffer, 0, $BufferIndex)
    $Ret
}

function ConvertTo-SnakeCase {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$InputString,
        [switch]$UpperCase
    )
    
    $Output = $InputString -creplace '([A-Z]+)', { ' ' + $_.Value.ToLower() }
    $Output = $Output.Trim()
    $Output = $Output -replace '[ \-]', '_'
    $Output = $Output -replace '_+', '_'

    if ($UpperCase.IsPresent) {
        $Output = $Output.ToUpper()
    }
    
    $Output
}