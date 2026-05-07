param(
    [Parameter(Mandatory)][string]$User,
    [Parameter(Mandatory)][string]$Pass,
    [Parameter(Mandatory)][string]$Command
)

do { Start-Sleep -Seconds 1 } until (Test-NetConnection -ComputerName localhost -Port 7094 -InformationLevel Quiet)

$client = New-Object System.Net.Sockets.TcpClient('127.0.0.1', 7094)
$stream = $client.GetStream()
$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true

$reader.ReadLine() | Out-Null
$writer.WriteLine("login $User")
$reader.ReadLine() | Out-Null
$writer.WriteLine($Pass)
$reader.ReadLine() | Out-Null
$writer.WriteLine($Command)
while ($true) { $line = $reader.ReadLine(); if ($line -match '^R') { break } }
$writer.WriteLine("logout")
$reader.ReadLine() | Out-Null

$client.Close()
