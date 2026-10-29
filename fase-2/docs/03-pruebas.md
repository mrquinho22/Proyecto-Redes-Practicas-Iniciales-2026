# Matriz de requisitos y pruebas

[Índice](../README.md) · [Evidencias completas](../evidencias/README.md)

Se distingue una captura de configuración, una prueba funcional y la confirmación verbal de salida física. “Pendiente” significa que no se recibió evidencia suficiente; no afirma que Luis haya o no ejecutado la tarea por su cuenta.

## Requisitos de la fase 2 y dependencias

| Inciso | Prueba registrada | Estado y límite |
|---|---|---|
| 5.1–5.2 AD independiente servidor2.com | No se recibió salida final del secundario | Pendiente de acreditar |
| 5.3 Dominio SMTP correo2.com | Sin prueba | Pendiente |
| 5.4 correo1ex y correo2ex | Sin prueba de buzones ni intercambio | Pendiente |
| 5. OWA funcional | Sin prueba | Pendiente; es obligatorio en el enunciado |
| 5. OWA: DATOS INCORRECTOS DE AUTENTICACIÓN | Sin prueba negativa ni personalización | Pendiente |
| 7. Telnet nativo en servidor web | [Identidad por Telnet](../evidencias/07-telnet/20261027-050210.png) | Funcional con usuario1 |
| 7. Autorización usuario2 | [Miembros TelnetClients](../evidencias/07-telnet/20261027-025655.png) | Autorizado; sesión propia no probada |
| 9.1 RDP a Exchange como administrador | RDP probado solo en SRV-PRINCIPAL | Requisito de Exchange pendiente |
| 9.2 RDP vía web | Portal, conexión por nombre y [sesión activa](../evidencias/09-rdp-rdweb/20261028-022332.png) en principal | Flujo clásico probado; destino Exchange pendiente |
| 10. ISA/TMG o WAP permitido por nota | AD FS instalado, granja y login correctos | WAP no acreditado; AD FS es preparación |
| 10.2 Puerto 8080 | Sin escucha ni publicación probada | Pendiente; HTTPS 443 de AD FS no acredita 8080 |
| 10.3 Integración de autenticación AD | [Login AD FS](../evidencias/10-adfs/20261028-015301.png) | Correcto en AD FS; falta extremo a extremo de WAP |
| 10.4 Solo usuarios autenticados | Sin intento anónimo contra aplicación publicada | Pendiente |
| 10.5 Mensaje literal de autenticación | Sin prueba negativa sobre WAP/proxy | Pendiente |
| 3.3 Impresora en HOST y nombre impresora | [Compartida en Intel](../evidencias/03-impresora/20261027-055654.png) | Configuración confirmada |
| 3.3 Impresión desde Exchange | Imprimieron cliente y principal, confirmado por Mark | Exchange pendiente |
| Restricción: cliente Linux unido al dominio y 2 funcionalidades | Intentos de fase 1 sin cierre de unión acreditado | Pendiente de acreditar; ver documentación de fase 1 |
| Restricción: dos servidores | Principal y secundario previstos | Mantener el límite; no añadir VM de servidor para separar servicios |
| Restricción: servidor y cliente por HOST | Cliente virtual del HOST de Luis no acreditado aquí | Pendiente de comprobar |
| Integración con fase 1 | RDP/RD Web se repitió tras AD FS | Falta regresión completa de web, correo, FTP, SMB y Linux |

## Evidencias de las pruebas satisfactorias

| ID | Acción | Resultado visible | Evidencia |
|---|---|---|---|
| T01 | TCP 23 desde cliente | TcpTestSucceeded True | [Captura](../evidencias/07-telnet/20261027-025457.png) |
| T02 | hostname y whoami dentro de Telnet | Principal / usuario1 | [Captura](../evidencias/07-telnet/20261027-050210.png) |
| R01 | RDP directo | RDP-Tcp#1 y administrador | [Captura](../evidencias/09-rdp-rdweb/20261027-233143.png) |
| R02 | Portal RD Web | Formulario por FQDN | [Captura](../evidencias/09-rdp-rdweb/20261028-000652.png) |
| R03 | query session tras acceso desde portal | rdp-tcp#2 activo | [Captura](../evidencias/09-rdp-rdweb/20261028-002606.png) |
| A01 | DNS del servicio de federación | fs.servidor1.com → 192.168.0.20 | [Captura](../evidencias/10-adfs/20261028-012523.png) |
| A02 | Certificado | HasPrivateKey True | [Captura](../evidencias/10-adfs/20261028-012741.png) |
| A03 | Granja AD FS y servicio | DeploymentSucceeded; Running; 443 | [Captura](../evidencias/10-adfs/20261028-014817.png) |
| A04 | Autenticar en AD FS desde cliente | Ha iniciado sesión | [Captura](../evidencias/10-adfs/20261028-015301.png) |
| A05 | Exportación del certificado | Archivo PFX de 2923 bytes | [Listado, no clave privada](../evidencias/10-adfs/20261028-021736.png) |
| R04 | RD Web después de AD FS | Portal autenticado | [Captura](../evidencias/09-rdp-rdweb/20261028-021952.png) |
| R05 | RDP después de AD FS | Principal, administrador, rdp-tcp#3 activo | [Captura](../evidencias/09-rdp-rdweb/20261028-022332.png) |
| P01 | SMB desde cliente | TCP 445 True | [Captura](../evidencias/03-impresora/20261027-062004.png) |
| P02 | Driver cliente | oem2.inf / Epson registrado | [Captura](../evidencias/03-impresora/20261027-065259.png) |
| P03 | Página de prueba desde CLI | Captura muestra cola; Mark confirmó papel | [Captura de cola](../evidencias/03-impresora/20261027-065458.png) |
| P04 | SMB desde principal | TCP 445 True | [Captura](../evidencias/03-impresora/20261028-032236.png) |
| P05 | Paquete Epson principal | Importación correcta, oem4.inf | [Captura](../evidencias/03-impresora/20261028-042356.png) |
| P06 | Autenticar al HOST | IPC$ completado correctamente | [Captura](../evidencias/03-impresora/20261028-043018.png) |
| P07 | Cola local con puerto UNC | Epson-Red, driver y estado Normal | [Captura](../evidencias/03-impresora/20261028-044029.png) |
| P08 | Página física desde principal | Mark respondió que imprimió | Confirmación en conversación; no foto adicional |
| V01 | Carpeta VBoxSvr recuperada | Mark confirmó que volvió a abrir | Tras recrear entrada; no captura final adicional |
| B01 | Copia PFX y CER al HOST | Mark confirmó copia por C$ | Confirmación en conversación; no captura final adicional |

## Cierre pendiente

Antes de cambiar cualquier pendiente a “funcional”, registrar origen y destino, nombre del usuario, fecha, resultado y captura. Para las pruebas físicas agregar confirmación de la hoja. No concluir que un puerto abierto valida OWA, WAP o impresión. No calcular el 80 % contando preparación AD FS como proxy terminado.
