# Operación y guion de demostración

[Índice](../README.md) · [Manual](02-manual.md) · [Pendientes](../pendientes/README.md)

## Arranque

1. Encender la Intel, conectar la Epson por USB y poner papel si se demostrará impresión.
2. Abrir VirtualBox e iniciar SRV-PRINCIPAL. Esperar al inicio de sesión y a los servicios del dominio.
3. Iniciar CLI-WINDOWS01 y comprobar su dirección DHCP, DNS y dominio.
4. Si se utilizará acceso remoto entre HOST, verificar Internet y Tailscale. Las VM host-only siguen necesitando las rutas del HOST.
5. Ejecutar los diagnósticos de consulta y probar los servicios antes de la presentación.

No restaurar snapshots antiguos del controlador de dominio para “acelerar” el inicio. No cambiar direcciones, adaptadores ni contraseñas durante una demostración sin revisar su impacto.

## Demostración de lo probado

| Paso | Equipo / acción | Qué explicar y mostrar |
|---|---|---|
| 1 | Cliente: hostname, whoami, ipconfig | Identidad del cliente, DHCP y servidor DNS |
| 2 | Cliente: telnet 192.168.0.20 | Inicio con cuenta autorizada; hostname y whoami dentro de la sesión; salir con exit |
| 3 | Cliente: mstsc al principal | RDP como administrador; identidad del destino y query session |
| 4 | Cliente: https://srv-principal.servidor1.com/RDWeb/ | Portal autenticado; compatibilidad IE para conectar al equipo remoto |
| 5 | Dentro de RDP lanzado desde portal | SRV-PRINCIPAL, servidor1\administrador y sesión rdp-tcp activa |
| 6 | Cliente: https://fs.servidor1.com/adfs/ls/IdpInitiatedSignOn.aspx | Autenticación de usuario de dominio en AD FS; cerrar sesión al terminar |
| 7 | Principal: Get-Printer -Name Epson-Red | Driver local y puerto UNC al HOST |
| 8 | Principal: página de prueba | Mostrar hoja física; comprobar que el trabajo sale de la cola |

La prueba AD FS no debe presentarse como WAP. La conexión al principal no debe presentarse como RDP hacia Exchange. Consultar la matriz antes de afirmar cumplimiento de un inciso.

## Preguntas de preparación

- **¿Qué cambia entre HOST y VM?** El HOST tiene la impresora USB y la interfaz host-only; las VM consumen servicios y recursos por esa red.
- **¿Qué prueba un puerto TCP abierto?** Conectividad al servicio, no credenciales correctas ni funcionalidad completa.
- **¿Qué hace TelnetClients?** Autoriza a los miembros para entrar al servicio Telnet configurado.
- **¿Por qué usuario1 no sustituye al administrador para instalar controladores?** Las operaciones de administración requieren elevación y credenciales con permisos.
- **¿Qué aporta RD Web?** El portal desde el que se inicia el acceso remoto; el flujo usado termina en una sesión RDP clásica.
- **¿Qué hace AD FS?** Autentica usuarios y emite información de confianza para aplicaciones; WAP es otro componente que publica acceso a aplicaciones.
- **¿Qué contiene el PFX?** Certificado y clave privada, protegidos con contraseña. No se incluye en el repositorio.
- **¿Por qué hubo error 1219?** Existían sesiones al mismo servidor con identidades distintas.
- **¿Qué diferencia hay entre cola Normal e impresión comprobada?** Normal es estado de software; la salida de papel requiere prueba física.
- **¿Qué falta del proxy?** WAP real, publicación, autenticación/denegación, puerto 8080 y mensaje exacto de error.

## Traslado a otro lugar

Conservar la configuración host-only, las rutas locales y los certificados. Al cambiar de Wi-Fi revisar solapamientos y disponibilidad de Tailscale. La IP de Wi-Fi no sustituye a 192.168.0.200 del adaptador host-only. No prometer acceso al secundario hasta probarlo desde las VM. Llevar la Epson si se necesita impresión física y mantenerla en el HOST que virtualiza el servidor web.

## Apagado seguro

1. Guardar archivos y comprobar que no queden trabajos de impresión pendientes.
2. Cerrar sesiones RDP desde el menú de usuario del escritorio remoto.
3. Apagar CLI-WINDOWS01 desde Inicio → Encendido → Apagar.
4. En la consola de SRV-PRINCIPAL ejecutar `Stop-Computer` como administrador o usar el apagado de Windows. Si aparece un motivo, seleccionar uno planeado.
5. Esperar que ambas VM indiquen Apagada en VirtualBox. Después cerrar VirtualBox y apagar la Intel.

No usar el botón de VirtualBox “Apagar la máquina” como procedimiento normal: es un corte de alimentación virtual. “Cerrar sesión” y cerrar la ventana RDP no apagan el servidor. Al volver, iniciar primero el principal y después el cliente.

## Cierre conjunto pendiente

Cuando se confirme el avance de Luis, probar Exchange/OWA, impresión desde Exchange, RDP al secundario y WAP. Repetir además web, correo, FTP y SMB de fase 1 y comprobar el cliente Linux unido al dominio con dos funcionalidades. Registrar cada resultado en la matriz con nuevas capturas.
