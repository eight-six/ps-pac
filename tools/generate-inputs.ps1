

$ErrorActionPreference = 'Stop' 

$Output = & pac help
$Version = $Output[1].Split(':')[1].Trim()

$Groups = @()

$Output[7..$($Output.Length - 7)] | ForEach-Object {
    $GroupName = $_.substring(0, 30).Trim()
    $GroupDescription = $_.Substring(30).Trim()
    $Group = [pscustomobject]@{
        Name        = $GroupName
        Description = $GroupDescription
        Commands    = @()
    }
    $Groups += $Group
    
}

$ProcessedGroups = 0

$Groups | Where-Object { $_.Name -notin 'admin', 'help' } | ForEach-Object {
    $Group = $_
    Write-Progress -Activity 'Processing groups' -Status "Group: $($Group.name)" -PercentComplete ($ProcessedGroups / $Groups.Count * 100)
    Write-Verbose "Processing group: $($Group.Name)" -Verbose
    $GroupHelpText = & pac $Group.Name help

    $GroupHelpText[11..$($GroupHelpText.Length - 3)] | ForEach-Object {
        $CommandName = $_.Substring(0, 30).Trim()
        $CommandDescription = $_.Substring(30).Trim()
        Write-Verbose "Processing command: $($CommandName)" -Verbose

        $Command = [pscustomobject]@{
            Name        = $CommandName
            Description = $CommandDescription
            Arguments   = @()
        }

        $CommandHelpText = & pac $Group.Name $CommandName help

        if ($CommandHelpText[11].trim() -ne "This command doesn't take any arguments.") {
            $i = 11
            while ($i -lt $CommandHelpText.Length -and $CommandHelpText[$i].Trim().Length -gt 0) {
                $Line = $CommandHelpText[$i]
                
                $ArgName = $Line.Substring(0, 30).Trim()
                $ArgDescription = $Line.Substring(30).Trim()
                Write-Verbose "Processing arg: $($ArgName)" -Verbose
                $Arg = [pscustomobject]@{
                    Name        = $ArgName
                    Description = $ArgDescription
                }

                # peek ahead for allowed set. When present, should look something like:
                # Values: Public, Preview, UsGov, UsGovHigh, UsGovDoD, Mooncake
                $Next = $i + 1
                $NextLine = $CommandHelpText[$Next].trim()
                if ($NextLine.StartsWith('Values:')) {
                    Write-Verbose "Allowed values for param: $($NextLine)" -Verbose
                    $Arg | Add-Member -MemberType 'NoteProperty' -Name 'AllowedValues' -Value $NextLine.Substring(8).Trim().Split(',').Trim()
                    $i++
                }
                
                $Command.Arguments += $Arg
                $i++
            }
        }

        $Group.Commands += $Command
    }

    $ProcessedGroups += 1
}

$Groups | ConvertTo-Yaml | Out-File -FilePath "./pac-$Version.yaml"
