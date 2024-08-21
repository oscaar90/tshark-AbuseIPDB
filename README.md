# Análisis de IPs sospechosas en red con Bash y AbuseIPDB

Este script en Bash permite analizar capturas de tráfico de red (archivos .pcapng) para identificar direcciones IP sospechosas y verificar su reputación en la base de datos de AbuseIPDB. Es una herramienta útil para analistas de seguridad que desean automatizar el proceso de revisión de IPs potencialmente maliciosas.

## Requisitos

- `tshark`: Herramienta de línea de comandos para capturar y analizar tráfico de red. Se incluye con Wireshark.
- `curl`: Herramienta para realizar solicitudes HTTP.
- `jq`: Herramienta para procesar JSON.
- Una clave API de [AbuseIPDB](https://www.abuseipdb.com/).

## Instalación

1. **Instalar `tshark`, `curl` y `jq`**:
   En sistemas basados en Debian/Ubuntu, puedes instalar estos paquetes con:

   ```bash
   sudo apt-get install tshark curl jq
   ```

   En sistemas basados en Red Hat/CentOS, usa:

   ```bash
   sudo yum install tshark curl jq
   ```

2. **Obtener una clave API de AbuseIPDB**:
   Regístrate en [AbuseIPDB](https://www.abuseipdb.com/) y obtén tu clave API.

## Configuración

1. **Clona el repositorio**:

   ```bash
   git clone https://github.com/oscaar90/tshark-AbuseIPDB.git
   cd tu_repositorio
   ```

2. **Configura el script**:

   Abre el archivo `analizar_ips.sh` en un editor de texto y reemplaza `YOUR_ABUSEIPDB_API_KEY` con tu clave API de AbuseIPDB.

   ```bash
   API_KEY="YOUR_ABUSEIPDB_API_KEY"
   ```

## Uso

1. **Captura el tráfico de red**:

   Usa `tshark` para capturar tráfico y guardarlo en un archivo `.pcapng`. Asegúrate de reemplazar `ens33` con el nombre de tu interfaz de red:

   ```bash
   tshark -i ens33 -w captura.pcapng
   ```

2. **Ejecuta el script**:

   Una vez que tengas el archivo `captura.pcapng`, ejecuta el script:

   ```bash
   bash analizar_ips.sh
   ```

   El script generará un archivo `verificadas_ips.csv` con las IPs verificadas y sus detalles.

## Explicación del Script

1. **Extracción de IPs sospechosas**:
   Extrae las IPs sospechosas del archivo de captura de red utilizando filtros TCP.

2. **Filtrado de IPs locales**:
   Elimina IPs locales para centrarse en IPs externas.

3. **Verificación contra AbuseIPDB**:
   Envía solicitudes a la API de AbuseIPDB para obtener el puntaje de confianza de abuso para cada IP.

4. **Generación de resultados**:
   Guarda los resultados en un archivo CSV, indicando si la IP ha sido reportada por actividades maliciosas.

## Contribuciones

Las contribuciones son bienvenidas. Si deseas contribuir a este proyecto, por favor, abre un issue o realiza un pull request.

## Licencia

Este proyecto está bajo la licencia [MIT](LICENSE).

## Contacto

Para preguntas o comentarios, por favor contacta a [tu_email@dominio.com](mailto:tu_email@dominio.com).

