# Integración pendiente con Luis

[Índice de fase 2](../README.md) · [Matriz de requisitos](../docs/03-pruebas.md)

Al corte documental del 28/10/2026 no se recibió una actualización verificable del servidor secundario. Esto registra ausencia de confirmación, no una afirmación de lo que Luis haya hecho fuera de esta conversación.

## Datos necesarios antes de cambiar la red

- RAM y disco libres del HOST y de la VM.
- Adaptadores de VirtualBox y dirección definitiva del secundario.
- Salida de hostname, ipconfig /all, Get-WindowsFeature y bindings IIS.
- Existencia del bosque servidor2.com y estado de Exchange.
- Rutas de ida y vuelta entre las VM y los dos HOST mediante Tailscale.

El dato previo de NAT 10.0.2.15 no acredita acceso desde la otra computadora. La ruta anunciada a SRV-PRINCIPAL 192.168.0.20/32 no publica automáticamente la impresora 192.168.0.200 ni el servidor secundario. No abrir puertos a Internet para suplir esta integración.

## Secuencia de trabajo

1. **Fijar conectividad y recursos.** Confirmar IP antes de promover el dominio e instalar Exchange. Mantener solamente los dos servidores permitidos.
2. **Dominio aislado.** Preparar AD DS/DNS con servidor2.com. No unir el secundario a servidor1.com ni fusionar usuarios de ambos dominios.
3. **Exchange 2013.** Revisar requisitos del CU y del sistema. Exchange se prepararía después de promover el servidor si debe compartir la única VM del segundo HOST; esa coexistencia no es la arquitectura recomendada por Microsoft y requiere validar los requisitos reales. No promover ni despromover un equipo después de instalar Exchange.
4. **Correo y OWA.** Dominio SMTP correo2.com, buzones correo1ex y correo2ex, acceso web y pruebas en ambos sentidos. El texto literal para credenciales inválidas debe verificarse sobre OWA real: DATOS INCORRECTOS DE AUTENTICACIÓN. No sustituir autenticación por una página simulada.
5. **RDP a Exchange.** Administrador del dominio servidor2.com; comprobar hostname, whoami y query session desde el cliente. Repetir desde RD Web del principal indicando el nombre del secundario.
6. **Impresión desde Exchange.** Primero comprobar TCP 445 al HOST que comparte la Epson. Registrar el driver compatible localmente y probar la conexión. El método Epson-Red del principal está documentado como referencia; no afirmar que ya funciona desde el secundario.
7. **WAP.** El enunciado lo permite como alternativa a ISA/TMG. AD FS ya está en el principal. Antes de instalar WAP en el secundario, revisar la coexistencia con Exchange/IIS, nombres, certificados, bindings HTTPS y alcance de publicación. No se validó esa coexistencia completa. WAP y AD FS no deben instalarse en el mismo equipo.
8. **Validar autenticación y requisitos del proxy.** Acceso anónimo rechazado, acceso autorizado permitido, credenciales inválidas con texto exacto y puerto 8080 según el enunciado. WAP es un proxy inverso de aplicaciones, no equivale por sí mismo a un proxy de navegación ISA/TMG; documentar el funcionamiento real y el alcance de la alternativa.
9. **Pruebas integradas y Linux.** Verificar fase 1, cliente Linux unido al dominio, dos funcionalidades y el cliente virtual por HOST.

## Guía previa

La [Guía de trabajo paralelo para Luis en PDF](Guia_Luis_Trabajo_Paralelo_Fase2.pdf) se preparó durante el montaje como orientación. Las instrucciones son un plan, no evidencia de ejecución. El estado actualizado es el de esta carpeta: AD FS ahora sí está configurado y autenticando; WAP/Exchange siguen sin evidencia final recibida. La propuesta de compartir WAP y Exchange en el secundario aún necesita revisión de capacidad y HTTPS.

No hay PFX ni contraseñas adjuntos a la guía. El certificado privado está respaldado en la Intel; su transferencia deberá hacerse por un canal autorizado cuando se defina el destino.

## Evidencias de cierre a solicitar

- Dominio y DNS de servidor2.com; nombres, direcciones y roles definitivos.
- Exchange y OWA operativos, ambos buzones y envío/recepción.
- Mensaje literal de error OWA con credenciales inválidas.
- RDP como administrador al secundario, directo y lanzado desde web.
- Hoja física impresa desde Exchange y cola de origen.
- Instalación WAP, aplicación publicada y autenticación de extremo a extremo.
- Puerto 8080 y prueba negativa/positiva con texto requerido.
- Linux unido a AD con dos funcionalidades e integración completa de fase 1.
