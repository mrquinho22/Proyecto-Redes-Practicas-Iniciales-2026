# Manual técnico — Fase 2

[Índice](../README.md) · [Informe](01-informe.md) · [Incidencias](04-incidencias.md)

Este manual describe el montaje realizado. Los comandos de instalación sirven para reconstrucción; no deben repetirse sobre una granja AD FS ya configurada ni sobre una impresora existente. Para revisar el estado actual, utilizar los [diagnósticos de consulta](../scripts/README.md). Ejecutar cada instrucción en el equipo indicado. Si PowerShell muestra `>>` por una instrucción incompleta, cancelar con Ctrl+C antes de pegar el siguiente comando.

## 1. Preparación y conectividad

**Intel física:** encender VirtualBox, iniciar primero SRV-PRINCIPAL y después CLI-WINDOWS01. El adaptador de ambas VM es host-only. La dirección del HOST en esa red es 192.168.0.200/32; el principal conserva 192.168.0.20/24. No sustituir estos adaptadores por puente o NAT durante una demostración.

**En cada VM:** comprobar su identidad antes de aplicar cambios.

```powershell
hostname
whoami
Get-NetIPAddress -AddressFamily IPv4 | Format-Table InterfaceAlias,IPAddress,PrefixLength
```

**En el cliente:** comprobar el acceso a principal y HOST según el servicio.

```powershell
Test-NetConnection 192.168.0.20 -Port 23
Test-NetConnection 192.168.0.20 -Port 3389
Test-NetConnection 192.168.0.20 -Port 443
Test-NetConnection 192.168.0.200 -Port 445
```

Las pruebas TCP sirven para aislar conectividad; no demuestran autenticación ni impresión. Si el cliente recibe otra IP por DHCP, revisar las rutas /32 del HOST. No añadir rutas hasta confirmar el índice de la interfaz host-only en la Intel. Para consultar esa información en el HOST:

```powershell
Get-NetIPAddress -AddressFamily IPv4
Get-NetRoute -AddressFamily IPv4 | Where-Object DestinationPrefix -in '192.168.0.20/32','192.168.0.26/32'
```

## 2. Telnet nativo — SRV-PRINCIPAL

Abrir PowerShell como administrador en el servidor. En una reconstrucción, instalar los componentes:

```powershell
Install-WindowsFeature Telnet-Server,Telnet-Client -IncludeManagementTools
Set-Service TlntSvr -StartupType Automatic
Start-Service TlntSvr
Import-Module ActiveDirectory
Add-ADGroupMember -Identity 'TelnetClients' -Members usuario1,usuario2
tlntadmn config dom=SERVIDOR1
tlntadmn config maxconn=2
```

El grupo TelnetClients ya existía en el dominio. Confirmar sus miembros y los parámetros efectivos:

```powershell
Get-ADGroupMember TelnetClients | Select-Object Name,SamAccountName
tlntadmn
Get-Service TlntSvr
Get-NetTCPConnection -LocalPort 23 -State Listen
```

La configuración observada admitía NTLM y Password. Se creó una regla específica para laboratorio:

```powershell
if (-not (Get-NetFirewallRule -Name 'Practicas-Telnet-LAN' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name 'Practicas-Telnet-LAN' -DisplayName 'Practicas - Telnet LAN' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 23 -LocalAddress 192.168.0.20 -RemoteAddress 192.168.0.0/24 -InterfaceAlias Ethernet -Profile Any
}
```

**En CLI-WINDOWS01, como administrador:** habilitar el cliente si falta.

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName TelnetClient -All
```

**En la sesión de usuario del cliente:** ejecutar `telnet 192.168.0.20`, autenticar con la cuenta de laboratorio autorizada y comprobar:

```text
hostname
whoami
```

Resultado registrado: SRV-PRINCIPAL y servidor1\usuario1. Para salir, escribir `exit`. Telnet se conserva únicamente dentro del entorno de práctica.

![Sesión Telnet comprobada](../evidencias/07-telnet/20261027-050210.png)

## 3. RDP — configuración probada en el principal

**SRV-PRINCIPAL, PowerShell administrador:**

```powershell
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -Value 1
Start-Service TermService
if (-not (Get-NetFirewallRule -Name 'Practicas-RDP-LAN' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name 'Practicas-RDP-LAN' -DisplayName 'Practicas - RDP LAN' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3389 -LocalAddress 192.168.0.20 -RemoteAddress 192.168.0.0/24 -Profile Any
}
```

Se mantuvo NLA. El cliente mostró un error CredSSP sobre la corrección de oráculo de cifrado. Se descargó KB4103725 para Windows Server 2012 R2 x64 desde Microsoft Update Catalog en el HOST, se transfirió a la VM y se instaló con reinicio. No se utilizó como solución desactivar permanentemente la protección CredSSP. En una reconstrucción revisar primero las actualizaciones aplicables o ya instaladas.

**CLI-WINDOWS01:**

```powershell
Test-NetConnection 192.168.0.20 -Port 3389
mstsc /v:192.168.0.20
```

Entrar como `SERVIDOR1\Administrador` usando su contraseña privada. En el escritorio remoto ejecutar `hostname`, `whoami` y `query session`. Una sesión activa `rdp-tcp#...` confirma el transporte remoto. La variable `$env:SESSIONNAME` de una consola ya abierta mostró Console en una prueba; se utilizó `query session` para comprobar el estado real.

**Límite:** el punto 9.1 exige RDP en Exchange. Esta prueba del principal es útil, pero no lo reemplaza.

## 4. RD Web sobre IIS

**SRV-PRINCIPAL, administrador:** antes de instalar se realizó un respaldo de IIS con appcmd. Para una reconstrucción, crear uno nuevo con nombre propio:

```powershell
& "$env:windir\System32\inetsrv\appcmd.exe" add backup ("Antes-RDWeb-" + (Get-Date -Format yyyyMMddHHmmss))
Install-WindowsFeature RDS-Web-Access -IncludeManagementTools
```

El comando terminó Success sin reinicio. Inspeccionar los bindings y certificados, sin borrar enlaces de los sitios existentes:

```powershell
Import-Module WebAdministration
Get-WebBinding | Select-Object protocol,bindingInformation,ItemXPath | Format-List
Get-ChildItem Cert:\LocalMachine\My | Format-List Subject,Thumbprint,NotAfter
```

Estado observado: Default Web Site con HTTP `*:80:` y HTTPS `*:443:`; WebPrivada en `192.168.0.20:1080:`; FTP-Publico en `192.168.0.20:21:`. Para HTTPS se permitió TCP 443 desde la red de laboratorio:

```powershell
if (-not (Get-NetFirewallRule -Name 'Practicas-RDWeb-HTTPS' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name 'Practicas-RDWeb-HTTPS' -DisplayName 'Practicas - RDWeb HTTPS' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 443 -LocalAddress 192.168.0.20 -RemoteAddress 192.168.0.0/24 -Profile Any
}
```

**Cliente Windows:** abrir `https://srv-principal.servidor1.com/RDWeb/`. El certificado autofirmado provoca advertencia si el cliente no lo tiene como confiable. Verificar el nombre y el certificado del laboratorio antes de continuar; no convertir la omisión de advertencias en una regla general.

Autenticar con SERVIDOR1\Administrador. El portal “Recursos de trabajo” puede quedar vacío porque no se publicaron RemoteApps ni colecciones. Para acceder mediante la opción clásica:

1. En Edge, abrir `edge://settings/defaultBrowser` y permitir recarga en modo Internet Explorer.
2. Reiniciar Edge si lo pide y recargar RD Web en ese modo.
3. Seleccionar **Conectarse a un equipo remoto**.
4. Indicar `srv-principal.servidor1.com` y conectar con la cuenta de administrador del destino.
5. Verificar identidad y sesión dentro del escritorio.

No se desplegaron RD Connection Broker, RD Session Host ni RD Gateway. El flujo utilizado lanza RDP desde el portal clásico; no se implementó cliente web HTML5. Después de instalar AD FS se repitió el acceso y `query session` mostró rdp-tcp#3 activo como Administrador.

![Sesión después de AD FS](../evidencias/09-rdp-rdweb/20261028-022332.png)

## 5. AD FS — preparación de la alternativa WAP

### 5.1 Instalar el rol y preparar DNS

**Solo en SRV-PRINCIPAL, como administrador:**

```powershell
Install-WindowsFeature ADFS-Federation -IncludeManagementTools
Import-Module DnsServer
if (-not (Get-DnsServerResourceRecord -ZoneName 'servidor1.com' -Name 'fs' -ErrorAction SilentlyContinue)) {
    Add-DnsServerResourceRecordA -ZoneName 'servidor1.com' -Name 'fs' -IPv4Address '192.168.0.20'
}
Resolve-DnsName fs.servidor1.com -Type A
```

El servicio adfssrv estaba detenido tras instalar el rol y antes de crear la granja. No se eliminó el enlace TLS existente de RD Web. Se eligió `fs.servidor1.com` para diferenciar el servicio de federación del FQDN del equipo.

### 5.2 Crear el certificado de laboratorio

La versión local de New-SelfSignedCertificate tenía pocos parámetros. Se utilizó certreq con proveedor RSA SChannel, KeySpec 1, clave exportable y SAN para el nombre de federación:

```powershell
New-Item 'C:\PracticasADFS' -ItemType Directory -Force | Out-Null
@'
[Version]
Signature="$Windows NT$"

[NewRequest]
Subject = "CN=fs.servidor1.com"
FriendlyName = "ADFS - fs.servidor1.com"
KeyLength = 2048
KeySpec = 1
KeyUsage = 0xa0
MachineKeySet = TRUE
Exportable = TRUE
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ProviderType = 12
RequestType = Cert
HashAlgorithm = sha256
ValidityPeriod = Years
ValidityPeriodUnits = 1

[Extensions]
2.5.29.17 = "{text}"
_continue_ = "dns=fs.servidor1.com"

[EnhancedKeyUsageExtension]
OID = 1.3.6.1.5.5.7.3.1
'@ | Set-Content 'C:\PracticasADFS\adfs.inf' -Encoding ASCII
certreq.exe -new 'C:\PracticasADFS\adfs.inf' 'C:\PracticasADFS\adfs.cer'
```

Consultar el certificado y verificar HasPrivateKey True:

```powershell
$certADFS = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -eq 'CN=fs.servidor1.com' -and $_.HasPrivateKey } | Sort-Object NotAfter -Descending | Select-Object -First 1
$certADFS | Format-List Subject,Thumbprint,HasPrivateKey,NotAfter
Import-Certificate -FilePath 'C:\PracticasADFS\adfs.cer' -CertStoreLocation Cert:\LocalMachine\Root
```

Certificado creado en la sesión: huella `FA6C6BC2123ABC79981936A46377EE1DB5F5C359`; vencimiento mostrado 27/10/2027. En una reconstrucción se obtiene otra huella, por eso los comandos consultan el certificado en vez de fijar ese valor.

### 5.3 Cuenta de servicio y granja

Se creó `svc_adfs` como usuario del dominio, sin agregarlo a grupos de administración. Su contraseña se introdujo en un diálogo privado. La configuración realizada usa contraseña sin vencimiento para esta cuenta de laboratorio; requiere conservarla y administrarla fuera del repositorio.

```powershell
Import-Module ActiveDirectory
Import-Module ADFS
$credADFS = Get-Credential -UserName 'SERVIDOR1\svc_adfs' -Message 'Contraseña de la cuenta de servicio AD FS'
if (-not (Get-ADUser -Filter "SamAccountName -eq 'svc_adfs'")) {
    New-ADUser -Name 'Servicio AD FS' -SamAccountName 'svc_adfs' -UserPrincipalName 'svc_adfs@servidor1.com' -AccountPassword $credADFS.Password -Enabled $true -PasswordNeverExpires $true -CannotChangePassword $true
}
Test-AdfsFarmInstallation -CertificateThumbprint $certADFS.Thumbprint -FederationServiceName 'fs.servidor1.com' -ServiceAccountCredential $credADFS
```

Si ya existía la cuenta, introducir su contraseña actual; este bloque no la restablece. Revisar todos los resultados del test. Solo durante el montaje inicial, después de superar los requisitos:

```powershell
Install-AdfsFarm -CertificateThumbprint $certADFS.Thumbprint -FederationServiceName 'fs.servidor1.com' -FederationServiceDisplayName 'Practicas - Servidor1' -ServiceAccountCredential $credADFS
Get-Service adfssrv
Get-AdfsProperties | Format-List HostName,Identifier,HttpsPort
```

Resultado comprobado: DeploymentSucceeded / Success, servicio Running, HostName fs.servidor1.com, Identifier http://fs.servidor1.com/adfs/services/trust y HttpsPort 443. El Identifier es un identificador de confianza; el acceso probado del navegador fue HTTPS.

### 5.4 Autenticación desde el cliente

Abrir `https://fs.servidor1.com/adfs/ls/IdpInitiatedSignOn.aspx`, seleccionar iniciar sesión y usar SERVIDOR1\usuario1 con la contraseña de laboratorio asignada. La página mostró “Ha iniciado sesión”. Cerrar sesión al finalizar.

![Autenticación AD FS](../evidencias/10-adfs/20261028-015301.png)

Esto comprueba AD FS, no una aplicación publicada mediante WAP. Tampoco prueba todavía la denegación a usuarios no autenticados en el proxy ni el mensaje literal exigido para credenciales incorrectas.

### 5.5 Exportación y respaldo

En el principal, seleccionar de nuevo el certificado si se cerró PowerShell y pedir una contraseña privada para el respaldo:

```powershell
$certADFS = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -eq 'CN=fs.servidor1.com' -and $_.HasPrivateKey } | Sort-Object NotAfter -Descending | Select-Object -First 1
$clavePFX = Read-Host 'Contraseña para proteger el PFX' -AsSecureString
Export-PfxCertificate -Cert $certADFS -FilePath 'C:\PracticasADFS\fs.servidor1.com.pfx' -Password $clavePFX
Get-ChildItem 'C:\PracticasADFS'
```

El listado final mostró adfs.cer, adfs.inf y fs.servidor1.com.pfx (2923 bytes). Para respaldar en la Intel se abrió `\\192.168.0.20\C$\PracticasADFS` desde el HOST con credenciales de administrador del dominio y se copiaron `.cer` y `.pfx` a `C:\TransferenciaPracticas\RespaldoADFS`. La copia fue confirmada por Mark. Mantener la clave del PFX separada y no subir el archivo privado a GitHub.

## 6. Impresora Epson L3150 por USB en el HOST

### 6.1 Compartir y autenticar

**Intel física:** conectar la Epson por USB, instalar su controlador y comprobar impresión local. En propiedades de impresora, compartir con nombre `impresora`. Se creó la cuenta local `ImpresionLab`, se le concedió permiso de imprimir y se utilizó su contraseña privada para SMB; el PIN de inicio de sesión de maria no es esa contraseña.

Consulta del HOST:

```powershell
Get-Printer | Where-Object ShareName -eq 'impresora' | Format-List Name,Shared,ShareName
```

**Desde cada VM:**

```powershell
Test-NetConnection 192.168.0.200 -Port 445
net use \\192.168.0.200\IPC$ /user:LAPTOP-6S06UVNR\ImpresionLab *
```

Introducir la contraseña cuando la pida. Si hay error 1219, consultar primero `net use` y eliminar únicamente las conexiones anteriores a ese HOST que estén usando otra identidad. No borrar indiscriminadamente todas las conexiones de red. En el cliente se retiró la conexión a `\\192.168.0.200\impresora`; un IPC$ inexistente devolvió que no había conexión, lo cual no impedía autenticar de nuevo.

### 6.2 Controlador en CLI-WINDOWS01

El HOST tenía el paquete en DriverStore bajo `e_wf1une.inf_amd64_b51ebee095535cae`. Se copió el directorio completo, no solo el INF, a C:\ControladorEpson y se compartió temporalmente con lectura para ImpresionLab. Desde el cliente se copió a C:\Users\Public\ControladorEpson.

**Cliente, PowerShell elevado:**

```powershell
pnputil.exe /add-driver 'C:\Users\Public\ControladorEpson\e_wf1une.inf'
Add-PrinterDriver -Name 'EPSON L3150 Series'
```

Se publicó oem2.inf. Después, desde la sesión del usuario se agregó `\\192.168.0.200\impresora` y se imprimió una página de prueba. El usuario confirmó la salida de la hoja. La captura conservada muestra propiedades y trabajo en cola.

### 6.3 Controlador en SRV-PRINCIPAL

**Intel:** copiar C:\ControladorEpson dentro de C:\TransferenciaPracticas. **Principal, PowerShell administrador:**

```powershell
Copy-Item '\\VBoxSvr\TransferenciaPracticas\ControladorEpson' 'C:\ControladorEpson' -Recurse -Force
Test-Path 'C:\ControladorEpson\e_wf1une.inf'
pnputil.exe -a 'C:\ControladorEpson\e_wf1une.inf'
Add-PrinterDriver -Name 'EPSON L3150 Series'
Get-PrinterDriver -Name 'EPSON L3150 Series' | Format-List Name,Manufacturer,InfPath
```

Solo continuar si Test-Path devuelve True y la importación es correcta. En Server 2012 R2 se usó `pnputil -a`, mientras que en Windows 10 se había utilizado `/add-driver`. El paquete se publicó como oem4.inf.

El intento `Add-Printer -ConnectionName '\\192.168.0.200\impresora'` falló inicialmente con 0x80070040. Después de autenticar IPC$ correctamente, mostró 0x8007011b. La configuración que funcionó usa el driver instalado localmente:

```powershell
Add-PrinterPort -Name '\\192.168.0.200\impresora'
Add-Printer -Name 'Epson-Red' -DriverName 'EPSON L3150 Series' -PortName '\\192.168.0.200\impresora'
Get-Printer -Name 'Epson-Red' | Format-List Name,DriverName,PortName,PrinterStatus
```

Crear cada objeto una sola vez. Si ya existe, consultarlo antes de repetir. El resultado fue DriverName EPSON L3150 Series, PortName \\192.168.0.200\impresora y PrinterStatus Normal.

### 6.4 Prueba física

Con Epson encendida, papel y USB conectado a la Intel:

```powershell
rundll32.exe printui.dll,PrintUIEntry /k /n 'Epson-Red'
```

Mark confirmó que imprimió. No se cambió la protección RPC del HOST en el registro para aplicar esta solución. Tras un nuevo arranque comprobar autenticación y volver a probar: la persistencia de credenciales después de reiniciar no quedó validada en la sesión documentada. Sigue pendiente imprimir desde Exchange.

![Cola Epson-Red](../evidencias/03-impresora/20261028-044029.png)

## 7. Carpeta de transferencia de VirtualBox

La Intel contiene C:\TransferenciaPracticas. En la configuración de **SRV-PRINCIPAL**, la carpeta compartida debe llamarse TransferenciaPracticas, con ruta al HOST, automontaje y permanencia activados. Se dejó solo lectura para transferir archivos del HOST a la VM.

Dentro del principal la ruta es `\\VBoxSvr\TransferenciaPracticas`. El servicio VBoxService y los controladores pueden estar activos sin que haya ninguna carpeta publicada. El diagnóstico decisivo fue:

```powershell
Get-Service VBoxService
Get-CimInstance Win32_SystemDriver | Where-Object Name -like '*VBox*' | Format-Table Name,State,StartMode
& 'C:\Windows\System32\VBoxControl.exe' sharedfolder list
```

En este equipo VBoxControl estaba en System32 y reportó versión 7.2.20, Shared Folder mappings (0). Eliminar y volver a agregar la entrada en la configuración de la VM recuperó el acceso, confirmado por Mark. Reiniciar solo VBoxService y luego la VM no lo habían resuelto. La copia del respaldo al HOST se realizó por SMB en sentido HOST → lectura del servidor, sin depender de escritura en VBoxSvr.

## 8. Próxima integración

Consultar el [plan pendiente de Luis](../pendientes/README.md). No iniciar WAP en el mismo equipo de AD FS. Antes de definir su ubicación final con Exchange, comprobar roles, capacidad y enlaces HTTPS del secundario. No cambiar el dominio aislado servidor2.com por servidor1.com ni crear una confianza de bosques sin una necesidad técnica validada. Los requisitos de 8080 y del texto exacto deben probarse sobre la implementación real.
