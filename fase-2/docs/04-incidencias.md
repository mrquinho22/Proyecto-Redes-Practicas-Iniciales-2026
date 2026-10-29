# Incidencias y soluciones aplicadas

[Índice](../README.md) · [Galería completa](../evidencias/README.md)

## Telnet

**TCP 23 fallido.** Antes de completar el servicio y la regla de firewall, el cliente no conectaba. Se comprobó TlntSvr, la escucha y el perfil de red; se permitió TCP 23 desde 192.168.0.0/24. La prueba pasó a True y luego se validó una sesión real.

**Comando telnet no encontrado.** El cliente Windows no tenía el componente. Se habilitó TelnetClient con elevación y se volvió a probar. Tener el rol en el servidor no instala el cliente en la otra VM.

## RDP y RD Web

**RDP inicialmente cerrado.** fDenyTSConnections era 1 y TermService estaba detenido. Se habilitó RDP, se inició el servicio y se creó la regla de laboratorio.

**CredSSP: no se permite la función solicitada.** La conexión llegaba al servidor pero fallaba la autenticación por incompatibilidad de actualizaciones. Se instaló KB4103725 x64 para Server 2012 R2 y se reinició; RDP funcionó después. No se presentó como una contraseña equivocada ni se deshabilitó permanentemente la protección para resolverlo.

**Portal RD Web vacío.** No había aplicaciones ni colecciones publicadas. El portal sí autenticaba. La pestaña clásica para conectar a otro equipo necesitó compatibilidad Internet Explorer, por ActiveX. Se utilizó ese flujo para acceder al principal.

**SESSIONNAME devolvía Console.** Una consola abierta previamente puede conservar el entorno anterior. La salida de query session confirmó rdp-tcp#2 y después rdp-tcp#3 activos. La evidencia usa esa consulta y la identidad del equipo.

## Impresora

| Síntoma | Diagnóstico / acción aplicada | Resultado |
|---|---|---|
| Error de sistema 5 al crear cuenta | Abrir terminal del HOST con privilegios de administrador | Se pudo preparar ImpresionLab |
| PIN como credencial | Se usó una cuenta local específica con contraseña | Autenticación SMB satisfactoria |
| 0x80070035 y TCP 445 False desde CLI | Revisar retorno HOST-only; añadir ruta /32 al cliente observado .26 en el HOST | TCP 445 True |
| Error 1219 | net use mostraba conexión al mismo HOST con otra identidad; eliminar solo las conexiones afectadas y autenticar de nuevo | IPC$ correcto |
| Acceso denegado al buscar controlador | Paquete completo copiado y driver preinstalado en el cliente | Impresión desde CLI confirmada |
| 0x80070040 en principal | No bastaba con registrar el controlador; autenticar SMB explícitamente | IPC$ correcto; apareció el siguiente error |
| 0x8007011b después de autenticar | Crear cola local Epson-Red con puerto UNC y driver local | Estado Normal y página física confirmada |
| Impresora ya existe | Se repitió Add-Printer una segunda vez | Consultar la cola existente; no era un fallo de la primera creación |

Las cadenas 0x0000011b, 0x80070040 y 0x8007011b se conservan según las capturas de los distintos intentos; no se reemplazan por un único código. No se desactivó RPC authentication en el HOST como parte de la solución documentada.

## AD FS y respaldo

**Rol instalado pero servicio detenido.** Antes de crear la granja adfssrv estaba Stopped. Se configuraron DNS, certificado, cuenta y granja; quedó Running.

**Parámetros modernos no disponibles para certificados.** Se consultó la sintaxis local de New-SelfSignedCertificate de Server 2012 R2 y se optó por certreq con INF explícito. Se verificó la clave privada y el nombre DNS del certificado.

**Exportación PFX: -Cert no reconocido.** Se había pegado el parámetro sin la línea Export-PfxCertificate. Repetir el comando completo en una sola línea produjo el archivo. No fue necesario crear otra vez el certificado.

## Carpeta de VirtualBox

**Medio protegido contra escritura.** La carpeta TransferenciaPracticas se había compartido como solo lectura. Por eso no podía recibir el respaldo desde la VM. Se copió el respaldo leyendo C$ desde la Intel, alternativa que Mark confirmó.

**0x80070043 y carpeta inaccesible después de editarla.** VBoxService estaba Running y VBoxSF cargado. Reiniciar servicio y VM no recuperó el acceso. VBoxControl no estaba en Program Files; se encontró en C:\Windows\System32. El diagnóstico `sharedfolder list` devolvió cero mappings, pese a que se había visto una entrada en la configuración. Se eliminó y volvió a agregar la carpeta de esa VM; Mark confirmó que abrió nuevamente. No se reinstaló Guest Additions.

![Cero carpetas publicadas](../evidencias/incidencias/20261028-031556.png)

**PowerShell queda en >>.** Algunas instrucciones pegadas quedaron incompletas. Ctrl+C vuelve al prompt antes de ejecutar instrucciones de una línea. No pegar los símbolos `PS ...>` o `>>` de las capturas.

## Consulta de actualizaciones

**Sort-Object InstalledOn lanza DateTime Parse.** La propiedad InstalledOn de Get-HotFix generaba un error de conversión. Se consultaron los datos sin ordenar esa propiedad:

```powershell
Get-CimInstance Win32_QuickFixEngineering | Select-Object HotFixID,InstalledOn | Format-Table -AutoSize
```

## Capacidad y traslado

La Intel tiene 8 GB y una captura mostró muy poca memoria disponible. Se priorizó no añadir servidores; el enunciado también limita a dos. No se debe instalar Exchange en otra VM de la Intel para suplir la falta de avances del secundario. Su ubicación y recursos deben verificarse en el equipo de Luis.

La red de laboratorio es host-only y no depende directamente del nombre del Wi-Fi, pero la integración remota depende de Internet, Tailscale, rutas aprobadas y ausencia de bloqueos. Al trasladar el equipo no se garantiza conectividad con Luis sin probarla. La impresora requiere ir conectada por USB a la Intel y encendida.
