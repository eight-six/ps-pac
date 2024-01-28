$ModuleTemplate = @'
[string]$Script:Group = '{{Group}}'

$Script:Commands = @{
    {{CommandDictionaryEntries}}
}
'@

$CommandDictionaryEntryTemplate = @'
{{CommandName:pascal}} = '{{CommandName}}'
'@

$FunctionTemplate = @'

<#
 .SYNOPSIS
    {{CommandHelp}}
 #>
function {{Verb}}-Pac{{Group:pascal}}{{Noun}} {
    param(
        {{params}} 
    )

    Get-PacCommand -Group $Script:Group -Command $Script:Commands.{{CommandName:pascal}} -Params $PSBoundParameters | 
    DoIt -ShowCommand:$ShowCommand
}
'@

$ParameterTemplate = @'
[Parameter(Mandatory = $false, HelpMessage = '{{Arg:help}}')]
{{alias}}
[string]${{Arg:pascal}}
'@

$FilePath = './pac-1.30.3+g0f0e0b9.yaml'
$BuildPath = './build/nested'
$Definitions = Get-Content -Path $FilePath -Raw | ConvertFrom-Yaml

# $Definitions | Where-Object Name -EQ 'org' | ForEach-Object {
$Definitions | ForEach-Object {
    $Group = $_
    $ModuleFilePath = "$BuildPath/$($Group.Name).psm1"
    $GroupPascalCase = $Group.Name | ConvertTo-PascalCase

    $ModuleHeader = $ModuleTemplate -replace '{{Group}}', $Group.Name
    
    $CommandDictionaryEntries = $Group.Commands | Sort-Object -Property 'Name' | ForEach-Object {
        $Command = $_
        
        $Entry = $CommandDictionaryEntryTemplate -replace '{{CommandName:pascal}}', ($Command.Name | ConvertTo-PascalCase)
        $Entry = $Entry -replace '{{CommandName}}', $Command.Name.ToLower()
        $Entry
    }
    
    $ModuleHeader = $ModuleHeader -replace '{{CommandDictionaryEntries}}', ($CommandDictionaryEntries -join "`n    ")
    $ModuleHeader | Set-Content -Path $ModuleFilePath

    $Functions = @()

    $Group.Commands | Sort-Object -Property 'Name' | ForEach-Object {
        $Command = $_ 
        $CommandPascalCase = $Command.Name | ConvertTo-PascalCase

        switch ($true) {

            { $Command.Name -eq 'clear' } {
                $Verb = 'Clear'
                $Noun = ''
            }
            { $Command.Name -eq 'create' } {
                $Verb = 'New'
                $Noun = ''
            }
            { $Command.Name -eq 'delete' } {
                $Verb = 'Remove'
                $Noun = ''
            }
            { $Command.Name -eq 'install' } {
                $Verb = 'Install'
                $Noun = ''
            }
            { $Command.Name -eq 'list' } {
                $Verb = 'Get'
                $Noun = ''
            }
            { $Command.Name -eq 'list-settings' } {
                $Verb = 'Get'
                $Noun = 'Settings'
            }
            { $Command.Name -eq 'name' } {
                $Verb = 'Rename'
                $Noun = ''
            }
            { $Command.Name -eq 'select' } {
                $Verb = 'Select'
                $Noun = ''
            }
            { $Command.Name -eq 'update' } {
                $Verb = 'Update'
                $Noun = ''
            } 
            { $Command.Name -eq 'update-settings' } {
                $Verb = 'Set'
                $Noun = 'Settings'
            }

            Default {
                $Verb = 'Get'
                $Noun = $Command.Name | ConvertTo-PascalCase
            }
        }
        $Function = $FunctionTemplate -replace '{{Verb}}', $Verb
        $Function = $Function -replace '{{Noun}}', $Noun
        $Function = $Function -replace '{{Group:pascal}}', $GroupPascalCase
        $Function = $Function -replace '{{CommandName:pascal}}', $CommandPascalCase
        $Function = $Function -replace '{{CommandHelp}}', $Command.Description
        
        $Params = @()

        $Command.Arguments | ForEach-Object {
            $Parameter = $_
            $ParameterPascalCase = $Parameter.Name | ConvertTo-PascalCase
            $ParameterDeclaration = $ParameterTemplate -replace '{{Arg:help}}', $Parameter.Description.Replace("'", "''")
            $ParameterDeclaration = $ParameterDeclaration -replace '{{Arg:pascal}}', $ParameterPascalCase

            if ($Parameter.Description -match 'alias: (.*)') {
                $Alias = $Matches[1]
                $ParameterDeclaration = $ParameterDeclaration -replace '{{alias}}', "[alias('$Alias')]"
            }
            else {
                $ParameterDeclaration = $ParameterDeclaration -replace '{{alias}}', ''
            }
                        
            $Params += $ParameterDeclaration
        }

        $Params += '[switch]$ShowCommand'
        $Function = $Function -replace '{{params}}', ($Params -join ",`n`n   ")
        $Functions += $Function
    }

    $Functions | Sort-Object | Add-Content -Path $ModuleFilePath
}

# $Params = $Command.Arguments | ForEach-Object {
#     $Parameter = $_

#     $ParameterTemplate -replace '{{arg:help}}', $Parameter.Description -replace '{{arg:alias}}', $Parameter.Name -replace '{{arg:name}}', $Parameter.Name
# }

# $Method = $MethodTemplate -replace '{{params}}', $Params -replace '{{command:lower}}', $Command.Name.ToLower()

# $Method | Add-Content -Path "./src/modules/ps-pac/nested/$($Group.Name).psm1"