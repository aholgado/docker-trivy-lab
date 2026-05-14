# =============================================
# DOCKERFILE VULNERABLE - LABORATORIO TRIVY
# =============================================
#
# OBJETIVO: Identificar y corregir los problemas de seguridad
# que detecta Trivy para que el escaneo pase sin errores.
#
# LISTADO DE ACCIONES A REALIZAR:
#
# [ ] 1. Cambiar la imagen base debian:10 (EOL) por debian:12-slim
#        → Elimina la mayoría de CVEs HIGH/CRITICAL
#
# [ ] 2. Unificar los RUN de apt-get en un solo comando encadenado
#        → apt-get update && apt-get install -y ... && rm -rf /var/lib/apt/lists/*
#        → Menos capas, sin caché residual, imagen más ligera
#
# [ ] 3. Eliminar el secreto hardcodeado (SECRET_KEY=...)
#        → Los secretos nunca van en la imagen; usar variables de entorno en runtime
#
# [ ] 4. Activar el usuario no-root ya creado (appuser)
#        → Añadir USER appuser antes del CMD
#
# [ ] 5. Reemplazar el CMD con la backdoor de netcat
#        → Sustituir por un servidor legítimo, p.ej. python3 -m http.server
#
# =============================================

# === IMAGEN BASE ===
# TODO: Cambiar esta imagen base (debian:13-slim es más moderna y segura)
FROM debian:13.4-slim

# === INSTALACIÓN DE PAQUETES ===
RUN apt-get update \
    && apk add --no-cache nginx \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1001 appuser

COPY index.html /usr/share/nginx/html/

EXPOSE 80

USER appuser

# === COMANDO DE INICIO ===
# TODO: Reemplazar por un comando seguro
#CMD ["sh", "-c", "while true; do nc -l -p 80 -e /bin/bash; done"]
CMD ["nginx", "-g", "daemon off;"]

# =============================================
# RESUMEN DE CAMBIOS RECOMENDADOS:
# - Imagen base moderna y mínima
# - Usuario no-root
# - Sin secretos en la imagen
# - Menos capas (mejor cache y seguridad)
# - CMD seguro
# =============================================
