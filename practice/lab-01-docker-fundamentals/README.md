# Lab 1: Docker Fundamentals - Building Production-Ready Containers

## 🎯 Objetivos de Aprendizaje

Al finalizar este laboratorio, serás capaz de:
- Construir imágenes Docker optimizadas con multi-stage builds
- Implementar mejores prácticas de seguridad (usuarios no-root)
- Optimizar el tamaño de imágenes y el cache de Docker
- Escanear vulnerabilidades con Trivy
- Comparar diferentes estrategias de construcción

## 📚 Conceptos Clave

### ¿Qué es un Dockerfile?
Un archivo de texto con instrucciones para construir una imagen Docker. Cada instrucción crea una **capa** (layer) que se cachea para acelerar futuras construcciones.

### ¿Qué es Multi-Stage Build?
Una técnica que usa múltiples `FROM` en un Dockerfile:
- **Stage 1 (Builder):** Compila el código, instala dependencias de desarrollo
- **Stage 2 (Runtime):** Copia solo los artefactos necesarios, sin herramientas de build

**Beneficio:** Imágenes finales 5-10x más pequeñas y seguras.

### Mejores Prácticas de Seguridad
1. **Usuarios no-root:** Evitar ejecutar procesos como root dentro del contenedor
2. **Imágenes base mínimas:** Usar variantes Alpine o Slim
3. **Escaneo de vulnerabilidades:** Detectar CVEs conocidos
4. **Secrets nunca en imágenes:** Usar Docker secrets o variables de entorno

## ⏱️ Duración Estimada
60 minutos

## 📋 Prerrequisitos

```bash
# Verificar Docker
docker --version  # Debe ser 20.10+

# Verificar acceso
docker ps

# Instalar Trivy (escáner de vulnerabilidades)
# docs: https://github.com/aquasecurity/trivy
# WSL2/Linux:
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

# Windows
choco install trivy

# MacOs
brew install trivy

# Alternativa con Docker:
alias trivy='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy'
```

## 🚀 Parte 1: Construir Backend (Flask) - Enfoque Básico

### Paso 1.1: Examinar el Código del Backend

```bash
cd ./apps/backend
ls -la
# Verás: app/ requirements.txt Dockerfile
```

### Paso 1.2: Crear Dockerfile Básico (Sin Optimizar)

Crea `Dockerfile.basic`:

```dockerfile
FROM python:3.11

# Copiar todo el código
COPY . /app
WORKDIR /app

# Instalar dependencias
RUN pip install -r requirements.txt

# Exponer puerto
EXPOSE 5000

# Comando de inicio
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:create_app()"]
```

### Paso 1.3: Construir y Verificar Tamaño

```bash
# Construir imagen
docker build -f Dockerfile.basic -t link-backend:basic .

# Verificar tamaño
docker images | grep link-backend

# Debería mostrar ~1 GB (muy pesado)
```

**❌ Problemas de este enfoque:**
- Imagen de ~1 GB
- Incluye herramientas de build innecesarias
- Cache no optimizado
- Se ejecuta como root (inseguro)

## 🔧 Parte 2: Optimizar con Multi-Stage Build

### Paso 2.1: Crear Dockerfile Optimizado

Crea `Dockerfile.optimized`:

```dockerfile
# ============================================
# Stage 1: Builder (Instalar dependencias)
# ============================================
FROM python:3.11-slim AS builder

# Instalar dependencias de compilación
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Crear virtualenv
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copiar solo requirements primero (optimización de cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ============================================
# Stage 2: Runtime (Imagen final mínima)
# ============================================
FROM python:3.11-slim

# Crear usuario no-root
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copiar virtualenv desde el builder
COPY --from=builder /opt/venv /opt/venv

# Copiar código de la aplicación
WORKDIR /app
COPY app/ ./app/

# Configurar variables de entorno
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

# Cambiar a usuario no-root
USER appuser

# Exponer puerto
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:5000/health')"

# Comando de inicio
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:create_app()"]
```

### Paso 2.2: Crear .dockerignore

Crea `.dockerignore` para excluir archivos innecesarios:

```
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
*.so
*.egg
*.egg-info/
.pytest_cache/
.coverage
htmlcov/
.venv/
venv/
ENV/
.git/
.gitignore
README.md
*.md
.DS_Store
```

### Paso 2.3: Construir y Comparar

```bash
# Construir imagen optimizada
docker build -f Dockerfile.optimized -t link-backend:optimized .

# Comparar tamaños
docker images | grep link-backend

# Resultado esperado:
# link-backend:basic      ~1000 MB
# link-backend:optimized  ~180 MB
```

**✅ Mejoras logradas:**
- Reducción de tamaño: ~82%
- Usuario no-root (más seguro)
- Cache optimizado (rebuilds más rápidos)
- Health check incluido

## 🖼️ Parte 3: Optimizar Frontend (React/Nginx)

### Paso 3.1: Ir al Directorio Frontend

```bash
cd ./apps/frontend
```

### Paso 3.2: Crear Dockerfile Multi-Stage

Crea `Dockerfile.optimized`:

```dockerfile
# ============================================
# Stage 1: Builder (Build de React)
# ============================================
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar package files primero (cache optimization)
COPY package.json package-lock.json ./
RUN npm ci --silent

# Copiar código fuente
COPY . .

# Build de producción
RUN npm run build

# ============================================
# Stage 2: Runtime (Nginx)
# ============================================
FROM nginx:alpine

# Copiar configuración custom de Nginx
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
    location /health { \
        access_log off; \
        return 200 "healthy\n"; \
        add_header Content-Type text/plain; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Copiar assets buildeados desde el stage anterior
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer puerto
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

# Nginx se ejecuta en foreground por defecto
CMD ["nginx", "-g", "daemon off;"]
```

### Paso 3.3: Crear .dockerignore

```
node_modules/
dist/
.vite/
coverage/
.env.local
.env.*.local
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.git/
.gitignore
README.md
*.md
.DS_Store
```

### Paso 3.4: Construir y Verificar

```bash
# Construir
docker build -f Dockerfile.optimized -t link-frontend:optimized .

# Verificar tamaño
docker images | grep link-frontend

# Resultado esperado: ~50 MB (increíblemente pequeño)
```

## 🔒 Parte 4: Escaneo de Vulnerabilidades

### Paso 4.1: Escanear Backend

```bash
# Escanear imagen optimizada
trivy image link-backend:optimized

# Ver solo vulnerabilidades HIGH y CRITICAL
trivy image --severity HIGH,CRITICAL link-backend:optimized
```

**Interpretación:**
- **LOW:** Informativas, baja prioridad
- **MEDIUM:** Revisar en próximas actualizaciones
- **HIGH:** Parchear pronto
- **CRITICAL:** Requiere acción inmediata

### Paso 4.2: Escanear Frontend

```bash
trivy image link-frontend:optimized
```

**Nota:** Alpine suele tener menos vulnerabilidades que imágenes Debian/Ubuntu.

### Paso 4.3: Generar Reporte en JSON

```bash
# Backend
trivy image --format json --output backend-scan.json link-backend:optimized

# Frontend
trivy image --format json --output frontend-scan.json link-frontend:optimized

# Ver resumen
cat backend-scan.json | jq '.Results[].Vulnerabilities | length'
```

## 🧪 Parte 5: Probar las Imágenes

### Paso 5.1: Probar Backend

```bash
# Iniciar Redis (dependencia del backend)
docker run -d --name redis-test -p 6379:6379 redis:7-alpine

# Iniciar backend
docker run -d --name backend-test \
    -p 5000:5000 \
    -e REDIS_HOST=host.docker.internal \
    -e REDIS_PORT=6379 \
    link-backend:optimized

# Verificar logs
docker logs backend-test

# Probar endpoint
curl http://localhost:5000/health

# Debería devolver: {"status": "healthy", "redis": "connected"}
```

### Paso 5.2: Probar Frontend

```bash
# Iniciar frontend
docker run -d --name frontend-test -p 8080:80 link-frontend:optimized

# Verificar logs
docker logs frontend-test

# Abrir en navegador
# http://localhost:8080
```

### Paso 5.3: Limpiar Contenedores

```bash
docker stop backend-test frontend-test redis-test
docker rm backend-test frontend-test redis-test
```

## 📊 Parte 6: Comparación de Estrategias

### Tabla Comparativa

| Métrica | Basic | Optimized | Mejora |
|---------|-------|-----------|--------|
| **Backend Size** | ~1000 MB | ~180 MB | **82% ↓** |
| **Frontend Size** | ~1200 MB | ~50 MB | **96% ↓** |
| **Vulnerabilidades** | 150+ | 20-30 | **80% ↓** |
| **Build Time** | 5 min | 2 min | **60% ↓** |
| **Usuario Root** | ✅ Sí (riesgo) | ❌ No | ✅ Seguro |

## 🎓 Ejercicios Desafío (Opcional)

### Desafío 1: Optimizar Cache de Layers

Modifica el Dockerfile del backend para que cambios en el código **NO** invaliden el cache de dependencias.

**Pista:** El orden de las instrucciones `COPY` importa.

### Desafío 2: Agregar Build Args

Permite configurar la versión de Python en build time:

```dockerfile
ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-slim AS builder
```

Construir con:
```bash
docker build --build-arg PYTHON_VERSION=3.12 -t link-backend:py312 .
```

### Desafío 3: Implementar Distroless

Intenta usar una imagen base [Distroless](https://github.com/GoogleContainerTools/distroless) para el backend (solo runtime, sin shell).

## ✅ Verificación Final

Confirma que completaste todos los pasos:

- [ ] Construiste imagen básica del backend (~1 GB)
- [ ] Creaste Dockerfile multi-stage optimizado
- [ ] Agregaste usuario no-root
- [ ] Implementaste .dockerignore
- [ ] Construiste imagen optimizada (~180 MB)
- [ ] Construiste imagen frontend (~50 MB)
- [ ] Escaneaste vulnerabilidades con Trivy
- [ ] Probaste ambas imágenes en ejecución
- [ ] Comparaste tamaños y vulnerabilidades

## 🔄 Limpieza

```bash
# Eliminar imágenes creadas (opcional)
docker rmi link-backend:basic link-backend:optimized link-frontend:optimized

# Limpiar cache de Docker (libera espacio)
docker system prune -a
```

## 📚 Recursos Adicionales

- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Distroless Images](https://github.com/GoogleContainerTools/distroless)

## 🚀 Siguiente Paso

¡Felicidades! Ahora sabes construir imágenes Docker production-ready.

**Continúa con:** [Lab 2: Docker Compose](../lab-02-docker-compose/README.md)

---

**Tiempo completado:** _____ minutos  
**Dificultad percibida:** ⭐ ⭐ ⭐ ⭐ ⭐
