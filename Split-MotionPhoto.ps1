function Split-MotionPhoto
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Split-MotionPhoto
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Split-MotionPhoto
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position=0)]
        [System.String]
        $FilePath
    )
    
    $PatternString = 'MotionPhoto_Data'

    $Raw = Get-Content -Path $FilePath -Raw
    $RawSplit = $Raw -split $PatternString
    if ($RawSplit.Length -ne 2)
    {
        throw "Split failed $PatternString not found."
    }

    $Encoding = [system.Text.Encoding]::Default
    [System.IO.File]::WriteAllBytes(($FilePath -replace '.jpg','_New.jpg'),$Encoding.GetBytes($RawSplit[0]))
    [System.IO.File]::WriteAllBytes(($FilePath -replace '.jpg','_New.mp4'),$Encoding.GetBytes($RawSplit[1]))
}

Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = [System.Windows.Forms.OpenFileDialog]::new()
#$OpenFileDialog.InitialDirectory = [System.IO.Directory]::GetCurrentDirectory()
$OpenFileDialog.Title = 'Select files to split'
$OpenFileDialog.Filter = 'Samsung Motion Photo Files (*.JPG)|*.JPG|All Files (*.*)|*.*'
$OpenFileDialog.Multiselect = $true

$Result = $OpenFileDialog.ShowDialog()
if ($Result -eq 'OK')
{
    foreach ($File in $OpenFileDialog.FileNames)
    {
        "Splitting $File" 
        try
        {
            Split-MotionPhoto -FilePath $File -ErrorAction Stop
        
        }
        catch
        {
            Write-Error -Message "Split failed for file: $File. Error: $_"
        }
    }
}
else
{
    'Import Settings File Cancelled!'
}