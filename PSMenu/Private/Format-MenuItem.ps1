function Format-MenuItem(
    [Parameter(Mandatory)] $MenuItem, 
    [Switch] $MultiSelect,
    [String] $SeparatorValue,
    [Parameter(Mandatory)][bool] $IsItemSelected, 
    [Parameter(Mandatory)][bool] $IsItemFocused) {

    $SelectionPrefix = '    '
    $FocusPrefix = '  '
    $ItemText = $SeparatorValue ? $SeparatorValue : ' -------------------------- '

    if ($(Test-MenuSeparator $MenuItem) -ne $true) {
        if ($MultiSelect) {
            $SelectionPrefix = if ($IsItemSelected) { '[x] ' } else { '[ ] ' }
        }

        $FocusPrefix = if ($IsItemFocused) { '> ' } else { '  ' }
        $ItemText = $MenuItem.ToString()
    }

    $WindowWidth = (Get-Host).UI.RawUI.WindowSize.Width

    $Text = "{0}{1}{2}" -f $FocusPrefix, $SelectionPrefix, $ItemText
    if ($WindowWidth - ($Text.Length + 2) -gt 0) {
        $Text = $Text.PadRight($WindowWidth - ($Text.Length + 2), ' ')
    }
    
    Return $Text
}

function Format-MenuItemDefault($MenuItem) {
    Return $MenuItem.ToString()
}
