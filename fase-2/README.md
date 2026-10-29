# Fase 2 — Servicios y evidencias

**Proyecto Final de Prácticas Iniciales · USAC · Sección F**  
**Marco David Mérida Velásquez · 202500065 · Equipo con Luis Saloj**  
Actualización documental: **28/10/2026, Guatemala**. Entrega prevista en el enunciado: 29/10/2026.

Esta carpeta reúne lo realizado en fase 2, su manual, las capturas originales y los pendientes de integración. Se conserva la documentación anterior de fase 1 en sus carpetas originales.

**Resultado registrado:** Telnet, RDP al servidor principal, acceso iniciado desde RD Web, autenticación AD FS e impresión física desde el cliente y desde SRV-PRINCIPAL. **No hay confirmación recibida de la configuración final de Exchange ni de WAP en el servidor de Luis. El proyecto completo no se declara terminado.**

## Lectura de la entrega

| Documento | Contenido |
|---|---|
| [Informe](docs/01-informe.md) | Objetivo, arquitectura, decisiones y resultados |
| [Manual técnico](docs/02-manual.md) | Configuración paso a paso de Telnet, RDP, RD Web, AD FS e impresora |
| [Pruebas y requisitos](docs/03-pruebas.md) | Evidencia disponible, límites y pendientes por inciso |
| [Incidencias](docs/04-incidencias.md) | Errores encontrados y solución aplicada |
| [Demostración y operación](docs/05-demostracion.md) | Guion de defensa, arranque, apagado y traslado |
| [Integración pendiente con Luis](pendientes/README.md) | Exchange, WAP y requisitos por cerrar |
| [Capturas](evidencias/README.md) | 68 imágenes originales con explicación y manifest |
| [Referencias](docs/06-referencias.md) | Enunciado y documentación oficial |
| [Diagnósticos](scripts/README.md) | Consultas de solo lectura para principal y cliente |

## Estado por requisito

| Requisito | Estado al corte |
|---|---|
| 7. Telnet nativo del servidor web | Sesión usuario1 comprobada; usuario2 autorizado en el grupo |
| 9.1 RDP en Exchange para administrador | Pendiente. Lo probado corresponde a SRV-PRINCIPAL |
| 9.2 RDP vía web | Portal y conexión a SRV-PRINCIPAL comprobados; destino Exchange pendiente |
| 10. Proxy / alternativa WAP | AD FS operativo como preparación. WAP no configurado ni acreditado |
| 10. Puerto 8080, autenticación y texto exacto | Sin validación de extremo a extremo |
| 3.3 Impresora para Exchange | HOST comparte impresora; imprimen CLI y principal; Exchange pendiente |
| 5. Exchange, dominio aislado y OWA | Sin evidencia final recibida del secundario |

El aviso de certificado en los navegadores corresponde a certificados autofirmados del laboratorio. AD FS autenticando no equivale a WAP funcionando. El portal clásico RD Web inicia una conexión RDP; no es un escritorio HTML5 dentro de la página.

## Evidencias de cierre destacadas

### Telnet con identidad comprobada
![Telnet usuario1](evidencias/07-telnet/20261027-050210.png)

### AD FS configurado y autenticado
![AD FS operativo](evidencias/10-adfs/20261028-014817.png)
![Inicio de sesión en AD FS](evidencias/10-adfs/20261028-015301.png)

### RDP después de instalar AD FS
![Sesión remota activa](evidencias/09-rdp-rdweb/20261028-022332.png)

### Epson registrada en el servidor
![Epson-Red en estado normal](evidencias/03-impresora/20261028-044029.png)

La impresión de la página de prueba desde esta cola fue confirmada por Mark después de esta captura; no se adjuntó fotografía de la hoja.

## Archivos privados

El respaldo `fs.servidor1.com.pfx` se exportó y se copió al HOST, pero **no se publica**: contiene la clave privada. Tampoco se publican contraseñas de administrador, de `svc_adfs`, de `ImpresionLab` ni la contraseña del PFX. Los nombres de cuentas y las huellas de certificados que aparecen en las capturas no son sus contraseñas.
