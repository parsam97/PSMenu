function Write-MenuItem(
    [Parameter(Mandatory)][String] $MenuItem,
    [Switch]$IsFocused,
    [ConsoleColor]$FocusColor) {
    if ($IsFocused) {
        Write-Host $MenuItem -ForegroundColor $FocusColor
    }
    else {
        Write-Host $MenuItem
    }
}

function Write-Menu {
    param (
        [Parameter(Mandatory)][Array] $MenuItems, 
        [Parameter(Mandatory)][Int] $MenuPosition,
        [Parameter()][Array] $CurrentSelection, 
        [Parameter(Mandatory)][ConsoleColor] $ItemFocusColor,
        [Parameter(Mandatory)][ScriptBlock] $MenuItemFormatter,
        [Switch] $MultiSelect
    )
    
    $CurrentIndex = Get-CalculatedPageIndexNumber -MenuItems $MenuItems -MenuPosition $MenuPosition -TopIndex
    $MenuItemCount = Get-CalculatedPageIndexNumber -MenuItems $MenuItems -MenuPosition $MenuPosition -ItemCount

    for ($i = 0; $i -le $MenuItemCount; $i++) {
        if ($null -eq $MenuItems[$CurrentIndex]) {
            Continue
        }

        $MenuItemStr = & $MenuItemFormatter $($MenuItems[$CurrentIndex])
        if (!$MenuItemStr) {
            Throw "'MenuItemFormatter' returned an empty string for item #$CurrentIndex"
        }

        $IsItemSelected = $CurrentSelection -contains $CurrentIndex
        $IsItemFocused = $CurrentIndex -eq $MenuPosition

        $DisplayText = Format-MenuItem -MenuItem $MenuItemStr -MultiSelect:$MultiSelect -IsItemSelected:$IsItemSelected -IsItemFocused:$IsItemFocused
        Write-MenuItem -MenuItem $DisplayText -IsFocused:$IsItemFocused -FocusColor $ItemFocusColor

        $CurrentIndex++;
    }
}