# Solo lectura. Ejecutar en CLI-WINDOWS01, Windows PowerShell.
hostname
whoami
Get-NetIPAddress -AddressFamily IPv4 | Format-Table InterfaceAlias,IPAddress,PrefixLength
Get-DnsClientServerAddress -AddressFamily IPv4 | Format-Table InterfaceAlias,ServerAddresses
Resolve-DnsName srv-principal.servidor1.com -Type A -ErrorAction Continue
Resolve-DnsName fs.servidor1.com -Type A -ErrorAction Continue
foreach ($port in 23,443,3389) {
    Test-NetConnection 192.168.0.20 -Port $port
}
Test-NetConnection 192.168.0.200 -Port 445
Get-Printer | Format-Table Name,DriverName,PortName,PrinterStatus
Get-PrinterDriver | Where-Object Name -like '*L3150*' | Format-Table Name,Manufacturer
# Mostrar conexiones existentes, sin crearlas ni eliminarlas.
net use
