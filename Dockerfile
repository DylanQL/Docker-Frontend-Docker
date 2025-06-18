# Dockerfile para Suyay Events Frontend - Versión Simplificada para Render

# ======================================
# Stage 1: Build Stage
# ======================================
FROM node:22-alpine AS build

# Instalar dependencias básicas
RUN apk add --no-cache python3 make g++

# Establecer directorio de trabajo
WORKDIR /app

# Copiar package files primero para mejor caching
COPY package*.json ./

# Verificar que npm está funcionando
RUN npm --version

# Instalar dependencias (usar npm install en lugar de ci para mayor compatibilidad)
RUN npm install --production --silent || npm install --silent

# Copiar el resto de archivos
COPY . .

# Limpiar cache de npm para reducir tamaño
RUN npm cache clean --force

# Variables de entorno para el build
ENV NODE_ENV=production
ENV NG_CLI_ANALYTICS=false

# Instalar Angular CLI globalmente si no está disponible
RUN npm install -g @angular/cli@16 || echo "Angular CLI ya disponible"

# Construir la aplicación para producción
RUN ng build --configuration=production || ng build || npm run build

# ======================================
# Stage 2: Production Stage con Nginx
# ======================================
FROM nginx:1.25-alpine AS production

# Instalar curl para health checks
RUN apk add --no-cache curl

# Remover configuración por defecto de nginx
RUN rm -rf /usr/share/nginx/html/*

# Copiar archivos construidos desde el stage anterior
# Intentar diferentes ubicaciones posibles del build
COPY --from=build /app/dist/ /usr/share/nginx/html/

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exponer puerto
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Comando para iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
