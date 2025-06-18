# Dockerfile para Suyay Events Frontend - Optimizado para Render
# Construcción multi-stage para aplicación Angular

# ======================================
# Stage 1: Build Stage
# ======================================
FROM node:22-alpine AS build

# Información del mantenedor
LABEL maintainer="Suyay Events Team"
LABEL description="Dockerfile para frontend Angular de Suyay Events"

# Instalar dependencias del sistema necesarias para Angular
RUN apk add --no-cache python3 make g++ git

# Establecer directorio de trabajo
WORKDIR /app

# Copiar todos los archivos necesarios
COPY . .

# Instalar dependencias con caché optimizado
RUN npm ci --silent

# Limpiar cache de npm para reducir tamaño
RUN npm cache clean --force

# Variables de entorno para el build
ENV NODE_ENV=production
ENV NG_CLI_ANALYTICS=false

# Construir la aplicación para producción
RUN npm run build --prod || npm run build

# ======================================
# Stage 2: Production Stage con Nginx
# ======================================
FROM nginx:1.25-alpine AS production

# Instalar curl para health checks
RUN apk add --no-cache curl

# Remover configuración por defecto de nginx
RUN rm -rf /usr/share/nginx/html/*

# Copiar archivos construidos desde el stage anterior
# Ajustar el path según la estructura del proyecto
COPY --from=build /app/dist/* /usr/share/nginx/html/

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Crear usuario no-root para seguridad
RUN addgroup -g 1001 -S nginx && \
    adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G nginx nginx

# Configurar permisos
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Cambiar a usuario no-root
USER nginx

# Exponer puerto (Render asigna automáticamente el puerto)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Comando para iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
