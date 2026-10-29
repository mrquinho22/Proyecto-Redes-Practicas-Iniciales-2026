# Referencias

[Índice](../README.md)

Fuente de los requisitos: documento entregado por el curso, **Proyecto Final Prácticas Iniciales**, sección F, adjuntado por Mark y releído completo. Define fase 2 para 29/10/2026, impresión desde Exchange, dos servidores, cliente Linux unido al dominio con dos funcionalidades y al menos 80 % de incisos por fase. La nota del punto 10 permite Web Application Proxy como alternativa. El documento no cambia por lo que se haya conseguido configurar.

Fuentes técnicas oficiales utilizadas para contrastar los procedimientos. Algunas páginas se actualizan para versiones posteriores: los comandos de este manual corresponden a la sintaxis consultada o ejecutada en el laboratorio Server 2012 R2 / Windows 10, no a copiar sin revisión parámetros de Server 2025.

| Tema | Fuente |
|---|---|
| RDP y comprobaciones del servidor | [Microsoft: diagnóstico general de RDP](https://learn.microsoft.com/en-us/troubleshoot/windows-server/remote/rdp-error-general-troubleshooting) |
| CredSSP | [Microsoft: Encryption Oracle Remediation](https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/windows/credssp-encryption-oracle-remediation) |
| Paquete instalado para compatibilidad RDP | [Microsoft Update Catalog: KB4103725](https://www.catalog.update.microsoft.com/Search.aspx?q=KB4103725) |
| RD Web y ActiveX | [Microsoft: pestaña Remote Desktop ausente en Edge](https://learn.microsoft.com/en-us/troubleshoot/windows-server/remote/edge-not-work-run-rdweb-require-activex-controls) |
| Configuración AD FS | [Microsoft: configurar servidor de federación](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/deployment/configure-a-federation-server) |
| Test de granja | [Microsoft: Test-AdfsFarmInstallation](https://learn.microsoft.com/en-us/powershell/module/adfs/test-adfsfarminstallation) |
| Generación de certificado | [Microsoft: certreq](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/certreq_1) |
| Tipo de clave y certificado | [Microsoft: AD FS y KeySpec](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/ad-fs-and-keyspec-property) |
| WAP en 2012 R2, nombres y coexistencia | [Microsoft: planificación de Web Application Proxy](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/dn383650(v=ws.11)) |
| WAP y AD FS en equipos distintos | [Microsoft: despliegue con AD FS y WAP](https://techcommunity.microsoft.com/blog/filecab/deploying-work-folders-with-ad-fs-and-web-application-proxy-wap/425318/) |
| Requisitos Exchange 2013 | [Microsoft: requisitos del sistema](https://learn.microsoft.com/en-us/exchange/exchange-2013-system-requirements-exchange-2013-help) |
| Preparación Exchange 2013 | [Microsoft: prerrequisitos](https://learn.microsoft.com/en-us/exchange/exchange-2013-prerequisites-exchange-2013-help) |
| Instalar controlador de impresión | [Microsoft: Add-PrinterDriver](https://learn.microsoft.com/en-us/powershell/module/printmanagement/add-printerdriver) |
| Crear puerto de impresora | [Microsoft: Add-PrinterPort](https://learn.microsoft.com/en-us/powershell/module/printmanagement/add-printerport) |
| Crear cola con driver y puerto local | [Microsoft: Add-Printer](https://learn.microsoft.com/en-us/powershell/module/printmanagement/add-printer) |
| Paquetes INF y sintaxis por sistema | [Microsoft: ejemplos PnPUtil](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/pnputil-examples) |
| Epson L3150 | [Epson: soporte del modelo](https://epson.co.cr/Soporte/Impresoras/Impresoras-multifuncionales/Epson-L/Epson-L3150/s/SPT_C11CG86301) |
| Carpetas compartidas y Guest Additions | [Oracle: manual Guest Additions](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/guestadditions.html) |

Las fuentes describen capacidades y requisitos; las capturas y confirmaciones de la matriz describen lo efectivamente probado. No se infiere ejecución en el servidor secundario a partir de documentación oficial o de una guía preparada.
