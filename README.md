# Suyay Events Frontend - Docker para Render

Este proyecto contiene el Dockerfile optimizado para deployar la aplicación Angular **Suyay Events Frontend** en la plataforma Render.

## 📋 Contenido

- `Dockerfile` - Configuración multi-stage optimizada para producción
- `nginx.conf` - Configuración de Nginx para SPA Angular
- `docker-compose.yml` - Para testing local
- `.dockerignore` - Optimización del contexto de build

## 🚀 Deploy en Render

### Opción 1: Deploy Directo desde GitHub

1. **Fork o clona el repositorio original:**
   ```bash
   git clone https://github.com/DylanQL/suyay-events-frontend.git
   cd suyay-events-frontend
   ```

2. **Copia los archivos Docker a tu proyecto:**
   ```bash
   # Copia estos archivos a la raíz de tu proyecto Angular
   - Dockerfile
   - nginx.conf
   - .dockerignore
   ```

3. **Configura tu repositorio en Render:**
   - Ve a [Render Dashboard](https://dashboard.render.com)
   - Conecta tu repositorio de GitHub
   - Selecciona "Web Service"
   - Configura los siguientes parámetros:

### Configuración en Render

```yaml
# Configuración del servicio
Name: suyay-events-frontend
Environment: Docker
Region: Selecciona la más cercana a tus usuarios

# Build Settings
Build Command: docker build -t suyay-frontend .
Start Command: docker run -p 8080:8080 suyay-frontend

# Auto-Deploy: Yes (desde main/master branch)
```

### Variables de Entorno (si las necesitas)

```bash
NODE_ENV=production
API_URL=https://tu-backend-api.render.com/api
PORT=8080
```

## 🛠️ Desarrollo Local

### Usando Docker

```bash
# Build y run
docker build -t suyay-frontend .
docker run -p 8080:8080 suyay-frontend

# O usando docker-compose
docker-compose up
```

### Testing Local

```bash
# Verificar que funciona
curl http://localhost:8080/health

# Acceder a la aplicación
open http://localhost:8080
```

## 📁 Estructura del Proyecto

```
suyay-events-frontend/
├── src/                    # Código fuente Angular
├── Dockerfile             # 🐳 Multi-stage build
├── nginx.conf             # ⚙️ Configuración Nginx
├── .dockerignore          # 🚫 Archivos ignorados
├── docker-compose.yml     # 🔧 Para desarrollo local
├── package.json           # 📦 Dependencias
├── angular.json           # ⚡ Configuración Angular
└── README.md             # 📖 Esta documentación
```

## 🔧 Optimizaciones Incluidas

### Dockerfile
- ✅ **Multi-stage build** para reducir tamaño final
- ✅ **Node.js 22.16.0** (versión requerida por el proyecto)
- ✅ **Alpine Linux** para imágenes ligeras
- ✅ **Build de producción** optimizado
- ✅ **Usuario no-root** para seguridad
- ✅ **Health checks** integrados

### Nginx
- ✅ **SPA routing** configurado para Angular
- ✅ **Compresión Gzip** habilitada
- ✅ **Cache de assets estáticos** optimizado
- ✅ **Headers de seguridad** incluidos
- ✅ **Proxy para API** preconfigurado

## 🔐 Configuración de API

Si tu aplicación necesita conectarse a un backend, actualiza la configuración en:

1. **environment.ts** (en tu proyecto Angular):
   ```typescript
   export const environment = {
     production: true,
     apiUrl: 'https://tu-backend.render.com/api'
   };
   ```

2. **nginx.conf** (proxy configuration):
   ```nginx
   location /api/ {
     proxy_pass https://tu-backend.render.com/;
     # ... resto de configuración
   }
   ```

## ⚡ Performance

- **Tamaño de imagen final**: ~15-20MB (Alpine + Nginx)
- **Tiempo de build**: ~3-5 minutos
- **Cold start**: ~10-15 segundos
- **Memoria RAM**: ~50-100MB

## 🔧 Configuración Importante

### Antes de hacer el deploy:

1. **Copia estos archivos a la raíz de tu proyecto Angular:**
   ```
   tu-proyecto-angular/
   ├── src/                    # Tu código Angular existente
   ├── package.json           # Tu package.json existente
   ├── angular.json           # Tu angular.json existente
   ├── Dockerfile             # ⭐ Copia este archivo aquí
   ├── nginx.conf             # ⭐ Copia este archivo aquí
   ├── .dockerignore          # ⭐ Copia este archivo aquí
   ├── render.yaml            # ⭐ Copia este archivo aquí (opcional)
   └── README.md              # Este archivo (opcional)
   ```

2. **Verifica que tu package.json tiene el script de build:**
   ```json
   {
     "scripts": {
       "build": "ng build",
       "build:prod": "ng build --configuration production"
     }
   }
   ```

## 🐛 Troubleshooting

### Error: "failed to calculate checksum" o "not found"
Este error ocurre cuando los archivos no están en el contexto correcto:

**Solución:**
1. Asegúrate de que todos los archivos Docker estén en la raíz de tu proyecto Angular
2. Verifica que tengas estos archivos en tu proyecto:
   - `package.json`
   - `angular.json` 
   - `src/` (directorio)
   - `tsconfig.json`

```bash
# Estructura correcta:
suyay-events-frontend/
├── src/                    # ✅ Debe existir
├── package.json           # ✅ Debe existir  
├── angular.json           # ✅ Debe existir
├── Dockerfile             # ✅ Copiar aquí
├── nginx.conf             # ✅ Copiar aquí
└── .dockerignore          # ✅ Copiar aquí
```

### Error: "Application failed to start"
```bash
# Verifica los logs
docker logs container-name

# Verificaciones comunes:
1. Puerto 8080 expuesto correctamente
2. Archivos de build en /usr/share/nginx/html
3. nginx.conf sintaxis correcta
```

### Error: "Routes not working"
- Verifica que `try_files $uri $uri/ /index.html;` esté en nginx.conf
- Confirma que Angular está built con `--base-href /`

### Error de CORS
- Actualiza los headers CORS en nginx.conf
- Verifica la URL del backend en environment.ts

### Errores Comunes de Build
- Asegúrate de que todas las dependencias están correctamente instaladas.
- Verifica que no hay errores en el código fuente de Angular.
- Confirma que el Dockerfile está en la raíz del proyecto y es accesible.

## 📞 Soporte

Si tienes problemas con el deployment:

1. **Revisa los logs de Render**
2. **Verifica la configuración de nginx**
3. **Confirma las variables de entorno**
4. **Testa localmente con Docker**

## 📝 Notas Adicionales

- Este Dockerfile está optimizado específicamente para **Angular 16**
- Usa **Node.js 22.16.0** como especifica el proyecto original
- El puerto **8080** es ideal para Render (se configura automáticamente)
- Los archivos estáticos se cachean por **1 año**
- Health check en `/health` para monitoreo

---

**Creado para**: Suyay Events Frontend  
**Plataforma**: Render.com  
**Tipo**: Single Page Application (SPA)  
**Framework**: Angular 16 + Nginx
