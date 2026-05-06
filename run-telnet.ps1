param(
    [string]$User,
    [string]$Password,
    [string]$Command
)

$session = New-Object System.Net.Sockets.TcpClient
$session.Connect("127.0.0.1", 7094)
$stream  = $session.GetStream()
$reader  = New-Object System.IO.StreamReader($stream)
$writer  = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true

# Read initial banner
$reader.ReadLine() | Out-Null

# Login
$writer.WriteLine("login $User")
$reader.ReadLine() | Out-Null
$writer.WriteLine($Password)
$reader.ReadLine() | Out-Null

# Run the command
$writer.WriteLine($Command)
# Wait for command to finish – CTSS prints a line starting with 'R'
while ($true) {
    $line = $reader.ReadLine()
    if ($line -match "^R") { break }
}

# Logout
$writer.WriteLine("logout")
$reader.ReadLine() | Out-Null

$session.Close()
