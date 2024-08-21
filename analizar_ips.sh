#!/bin/bash

tshark -r captura.pcapng -T fields -e ip.src -e ip.dst -e tcp.flags -Y "tcp.flags.syn == 1 and tcp.flags.ack == 0" > ips_sospechosas.txt

# El comando `tshark -r captura.pcapng` lee el archivo de captura de red.
# `-T fields` indica que queremos extraer campos específicos.
# `-e ip.src -e ip.dst -e tcp.flags` especifica los campos a extraer: IP de origen, IP de destino y flags TCP.
# `-Y "tcp.flags.syn == 1 and tcp.flags.ack == 0"` es un filtro que selecciona paquetes TCP con el flag SYN establecido y el flag ACK no establecido (escaneo de puertos).
# La salida se guarda en `ips_sospechosas.txt`.


grep -vE "^192\.168\." ips_sospechosas.txt > ips_sospechosas_filtradas.txt

# `grep -vE "^192\.168\."` filtra las IPs que comienzan con `192.168.` (una red local típica).
# `ips_sospechosas.txt` es el archivo de entrada y `ips_sospechosas_filtradas.txt` es el archivo de salida con las IPs locales eliminadas.


API_KEY="YOUR_ABUSEIPDB_API_KEY"
INPUT_FILE="ips_sospechosas_filtradas.txt"
OUTPUT_VERIFIED_CSV="verificadas_ips.csv"
> $OUTPUT_VERIFIED_CSV

# `API_KEY` debe ser reemplazada con tu clave API de AbuseIPDB para autenticar las solicitudes.
# `INPUT_FILE` es el archivo con IPs filtradas para verificar.
# `OUTPUT_VERIFIED_CSV` es el archivo donde se almacenarán los resultados de la verificación.

while IFS=$'\t' read -r src_ip dst_ip flags; do
    response=$(curl -s "https://api.abuseipdb.com/api/v2/check?ipAddress=$src_ip&maxAgeInDays=90" \
    -H "Key: $API_KEY" \
    -H "Accept: application/json")

    is_abused=$(echo "$response" | jq -r '.data.abuseConfidenceScore')

    if [[ "$is_abused" != "null" && "$is_abused" -ge 50 ]]; then
        echo -e "$src_ip\t$dst_ip\t$flags\tAbused\t$is_abused" >> $OUTPUT_VERIFIED_CSV
    else
        echo -e "$src_ip\t$dst_ip\t$flags\tNot Abused\t$is_abused" >> $OUTPUT_VERIFIED_CSV
    fi

    sleep 1  
done < "$INPUT_FILE"

# El bucle `while` lee el archivo de IPs filtradas línea por línea.
# `curl` envía una solicitud a la API de AbuseIPDB para verificar la IP de origen.
# `jq` extrae el puntaje de confianza de abuso de la respuesta JSON. (NOTA, se requiere de jq, si no lo tenemos, instalar )
# Si el puntaje es mayor o igual a 50, se considera que la IP está reportada por abuso.
# Los resultados se guardan en `verificadas_ips.csv`.
# `sleep 1` se utiliza para evitar exceder el límite de solicitudes de la API.

echo "IPs verificadas han sido registradas en $OUTPUT_VERIFIED_CSV"

# El mensaje de echo informa al usuario que el proceso ha terminado y que el archivo con las IPs verificadas está disponible.

