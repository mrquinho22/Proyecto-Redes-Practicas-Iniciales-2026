# Diagnóstico de fase 2

[Índice](../README.md)

Scripts de **solo consulta**. No instalan roles, no crean usuarios, no cambian el firewall, no solicitan contraseñas y no envían trabajos a la impresora. Ejecutar en PowerShell del equipo indicado; la lectura de ciertos datos requiere abrir como administrador.

```powershell
# En SRV-PRINCIPAL, desde el directorio donde se descargó el script:
.\Diagnostico-Principal.ps1
```

```powershell
# En CLI-WINDOWS01:
.\Diagnostico-Cliente.ps1
```

Revisar los resultados sin confundir un servicio activo con una prueba funcional. Estos scripts se prepararon para documentación y se revisaron estáticamente; **no se ejecutaron en las VM del usuario durante la organización del repositorio**. No relajar la política de ejecución global para usarlos: se pueden leer y ejecutar las consultas individualmente.
