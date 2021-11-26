function Invoke-Banner {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True, HelpMessage="Заголовок для баннера")]
        [string]$Title,
        
        [Parameter(Mandatory=$True, HelpMessage="Текст для баннера")]
        [string]$Text,
        
        [Parameter(HelpMessage="Уровень сообщения")]
        [ValidateSet('Info', 'Warning', 'Error')]
        [string]$Type="Info",
        
        [Parameter(HelpMessage="Продолжительность показа баннера в мс.")]
        [int]$Duration=400,
        
        [Parameter(HelpMessage="Иконка")]
        [string]$Icon
    )

    Add-Type -AssemblyName System.Windows.Forms

    if (-NOT $global:banner) {
        $global:banner = New-Object System.Windows.Forms.NotifyIcon

        [void](Register-ObjectEvent -InputObject $banner -EventName MouseDoubleClick -SourceIdentifier BannerClick -Action {
            $global:banner.dispose()
            Unregister-Event -SourceIdentifier BannerClick
            Remove-Job -Name BannerClick
            Remove-Variable -Name banner -Scope Global
        })
    }
    
    Add-Type -AssemblyName System.Drawing
    
    if ($Icon){
        $banner.Icon = New-Object System.Drawing.Icon($Icon)
    }
    else {
        $path = (Get-Command powershell).Path
        $banner.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    }
    $banner.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]$Type
    $banner.BalloonTipTitle = $Title    
    $banner.BalloonTipText  = $Text
    $banner.Visible = $true
    $banner.ShowBalloonTip($Duration)
}