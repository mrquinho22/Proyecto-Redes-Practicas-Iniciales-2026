# Solo lectura. Ejecutar en SRV-PRINCIPAL, Windows PowerShell como administrador.
Write-Output 'Identidad del equipo'
hostname
whoami
Get-NetIPAddress -AddressFamily IPv4 | Format-Table InterfaceAlias,IPAddress,PrefixLength
Write-Output 'Roles pertinentes'
Get-WindowsFeature Telnet-Server,RDS-Web-Access,ADFS-Federation,Web-Application-Proxy | Format-Table Name,InstallState
Write-Output 'Servicios'
Get-Service TlntSvr,TermService,adfssrv,Spooler,VBoxService -ErrorAction SilentlyContinue | Format-Table Name,Status,StartType
Write-Output 'Puertos en escucha'
Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object LocalPort -in 23,443,3389,8080 | Format-Table LocalAddress,LocalPort,OwningProcess
Write-Output 'Reglas de laboratorio'
Get-NetFirewallRule -ErrorAction SilentlyContinue | Where-Object Name -like 'Practicas-*' | Format-Table Name,Enabled,Direction,Action
Write-Output 'DNS de federacion'
Resolve-DnsName fs.servidor1.com -Type A -ErrorAction Continue
if (Get-Module -ListAvailable ADFS) {
    Import-Module ADFS
    Get-AdfsProperties -ErrorAction Continue | Format-List HostName,Identifier,HttpsPort
}
Write-Output 'Certificados publicos: sin exportar claves'
Get-ChildItem Cert:\LocalMachine\My | Format-Table Subject,Thumbprint,HasPrivateKey,NotAfter
if (Get-Module -ListAvailable WebAdministration) {
    Import-Module WebAdministration
    Get-WebBinding | Select-Object protocol,bindingInformation,ItemXPath | Format-List
}
Write-Output 'Sesiones'
query session
Write-Output 'Impresoras y driver Epson'
Get-Printer | Format-Table Name,DriverName,PortName,PrinterStatus
Get-PrinterDriver | Where-Object Name -like '*L3150*' | Format-List Name,Manufacturer,InfPath
Test-NetConnection 192.168.0.200 -Port 445
$vboxControl = Join-Path $env:windir 'System32\VBoxControl.exe'
if (Test-Path $vboxControl) { & $vboxControl sharedfolder list }
