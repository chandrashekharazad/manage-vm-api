$scriptInvocationInfo = $MyInvocation

function Get-ScriptName(){
    $scriptFileItem = Get-Item ($scriptInvocationInfo.PSCommandPath)
    return $scriptFileItem.BaseName
}

$outputLogFile = $PSScriptRoot + "\" + (Get-ScriptName) + ".log.txt"

function Write-LogMessage(){
    param(
        $messageType,
        $message,
        $color
    )
    $prefix = $(Get-Date -Format "yyyy-MM-dd HH:mm:ss") + " - "
    Write-Host -ForegroundColor Gray $prefix -NoNewline
    Write-Host -ForegroundColor $color $messageType -NoNewline
    Write-Host -ForegroundColor Gray (" - " + $message)
    $formattedMessage = $prefix + $messageType + " - " + $message
    return $formattedMessage
}

function Add-Log{
    param (
        [string] $message
    )
    $logMessage = Write-LogMessage "INFO" $message "Grey"
    if ($outputLogFile){
        Add-Content -Value $logMessage -Path $outputLogFile
    }
}

function Add-Error {
    param (
        [string] $message
    )
    $logMessage = Write-LogMessage "ERR" $message "Red"
    if ($outputLogFile){
        Add-Content -Value $logMessage -Path $outputLogFile
    } 
    
}

function Add-Warning {
    param (
        [string] $message
    )
    $logMessage = Write-LogMessage "WARN" $message "Yellow"
    if ($outputLogFile){
        Add-Content -Value $logMessage -Path $outputLogFile
    } 
    
}