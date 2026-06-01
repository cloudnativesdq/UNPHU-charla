# Lab 2: Docker Compose - Orchestrating Multi-Container Applications

## 🎯 Objetivos

- Orquestar 3 servicios (Frontend + Backend + Redis) con Docker Compose
- Configurar redes personalizadas y volúmenes persistentes
- Implementar health checks y dependencias entre servicios
- Simular escenarios de fallo y recuperación

## 📚 Conceptos Clave

**Docker Compose:** Herramienta para definir y ejecutar aplicaciones multi-contenedor usando un archivo YAML.

**Beneficios:**
- Un solo comando para levantar toda la stack
- Networking automático entre servicios
- Gestión de volúmenes y variables de entorno
- Reproducible en cualquier máquina

## ⏱️ Duración: 60 minutos

## 🚀 Parte 1: Compose Básico

### Paso 1.1: Crear Estructura

```bash
cd ./practice/lab-02-docker-compose
mkdir -p configs
```

### Paso 1.2: Docker Compose Starter

Crea `docker-compose.starter.yml`:

```yaml
services:
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build:
      context: ../../apps/backend
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - FLASK_ENV=production

  frontend:
    build:
      context: ../../apps/frontend
      dockerfile: Dockerfile
    ports:
      - "5173:80"
    environment:
      - VITE_BACKEND_URL=http://localhost:5000
```

### Paso 1.3: Levantar Stack

```bash
# Construir y levantar
docker-compose -f docker-compose.starter.yml up --build

# Verificar servicios
docker-compose -f docker-compose.starter.yml ps

# Probar en navegador: http://localhost:5173
```

**❌ Problemas:**
- Sin redes aisladas
- Sin persistencia de datos
- Sin health checks
- Sin control de orden de inicio

## 🔧 Parte 2: Redes Personalizadas

### Paso 2.1: Agregar Redes

Crea `docker-compose.networks.yml`:

```yaml
services:
  redis:
    image: redis:7-alpine
    networks:
      - backend-network
    ports:
      - "6379:6379"

  backend:
    build:
      context: ../../apps/backend
      dockerfile: Dockerfile
    networks:
      - backend-network
      - frontend-network
    ports:
      - "5000:5000"
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379

  frontend:
    build:
      context: ../../apps/frontend
      dockerfile: Dockerfile
    networks:
      - frontend-network
    ports:
      - "5173:80"
    environment:
      - VITE_BACKEND_URL=http://localhost:5000

networks:
  backend-network:
    driver: bridge
  frontend-network:
    driver: bridge
```

**✅ Ventaja:** Frontend no puede acceder directamente a Redis (seguridad por capas).

### Paso 2.2: Probar Aislamiento

```bash
docker-compose -f docker-compose.networks.yml up -d

# Verificar redes
docker network ls | grep lab-02

# Intentar ping desde frontend a redis (debe fallar)
docker-compose -f docker-compose.networks.yml exec frontend ping redis
# Debe devolver: ping: bad address 'redis'
```

## 💾 Parte 3: Volúmenes Persistentes

### Paso 3.1: Agregar Volúmenes

Crea `docker-compose.volumes.yml`:

```yaml
services:
  redis:
    image: redis:7-alpine
    networks:
      - backend-network
    volumes:
      - redis-data:/data
      - ./configs/redis.conf:/usr/local/etc/redis/redis.conf:ro
    command: redis-server /usr/local/etc/redis/redis.conf
    ports:
      - "6379:6379"

  backend:
    build:
      context: ../../apps/backend
      dockerfile: Dockerfile
    networks:
      - backend-network
      - frontend-network
    ports:
      - "5000:5000"
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    depends_on:
      - redis

  frontend:
    build:
      context: ../../apps/frontend
      dockerfile: Dockerfile
    networks:
      - frontend-network
    ports:
      - "5173:80"
    depends_on:
      - backend

networks:
  backend-network:
  frontend-network:

volumes:
  redis-data:
    driver: local
```

### Paso 3.2: Probar Persistencia

```bash
docker-compose -f docker-compose.volumes.yml up -d

# Crear una URL corta
curl -X POST http://localhost:5000/shorten \
  -H "Content-Type: application/json" \
  -d '{"url": "https://github.com"}'

# Resultado: {"short_url": "http://localhost:5000/abc123"}

# Detener servicios
docker-compose -f docker-compose.volumes.yml down

# Levantar de nuevo (sin -v para preservar volumen)
docker-compose -f docker-compose.volumes.yml up -d

# Verificar que el dato persiste
curl http://localhost:5000/stats/`hash_codigo`
# Debe devolver los stats guardados
```

## 🏥 Parte 4: Health Checks

### Paso 4.1: Compose Production-Ready

Crea `docker-compose.complete.yml`:

```yaml
services:
  redis:
    image: redis:7-alpine
    container_name: link-redis
    networks:
      - backend-network
    volumes:
      - redis-data:/data
      - ./configs/redis.conf:/usr/local/etc/redis/redis.conf:ro
    command: redis-server /usr/local/etc/redis/redis.conf
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3
      start_period: 5s
    restart: unless-stopped

  backend:
    build:
      context: ../../apps/backend
      dockerfile: Dockerfile
    container_name: link-backend
    networks:
      - backend-network
      - frontend-network
    ports:
      - "5000:5000"
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - FLASK_ENV=production
    depends_on:
      redis:
        condition: service_healthy
    healthcheck:
      test: [
        "CMD", 
        "python", 
        "-c", 
        "\"import requests; requests.get('http://localhost:5000/health')\""
      ]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M

  frontend:
    build:
      context: ../../apps/frontend
      dockerfile: Dockerfile
    container_name: link-frontend
    networks:
      - frontend-network
    ports:
      - "5173:80"
    environment:
      - VITE_BACKEND_URL=http://localhost:5000
    depends_on:
      backend:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 5s
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.25'
          memory: 128M

networks:
  backend-network:
    driver: bridge
  frontend-network:
    driver: bridge

volumes:
  redis-data:
    driver: local
```

### Paso 4.2: Levantar y Monitorear

```bash
# Levantar
docker-compose -f docker-compose.complete.yml up -d

# Monitorear health checks
watch -n 2 'docker-compose -f docker-compose.complete.yml ps'

# Ver logs en tiempo real
docker-compose -f docker-compose.complete.yml logs -f

# Ver solo backend
docker-compose -f docker-compose.complete.yml logs -f backend
```

## 🔥 Parte 5: Simulación de Fallos

### Escenario 1: Redis Muere

```bash
# Matar Redis
docker-compose -f docker-compose.complete.yml stop redis

# Intentar acortar URL (debe fallar)
curl -X POST http://localhost:5000/shorten \
  -H "Content-Type: application/json" \
  -d '{"url": "https://github.com"}'

# Backend debe mostrar error 500

# Reiniciar Redis (auto-recuperación)
docker-compose -f docker-compose.complete.yml start redis

# Esperar health check (10-15 seg)
# Reintentar request (debe funcionar)
```

### Escenario 2: Backend Crashea

```bash
# Simular crash
docker-compose -f docker-compose.complete.yml exec backend bash -c "kill 1"

# Verificar restart automático
docker-compose -f docker-compose.complete.yml ps

# Backend debe reiniciarse solo (restart: unless-stopped)
```

### Escenario 3: Limitar Memoria

```bash
# Backend intentará usar más de 512M
# Compose lo matará y reiniciará automáticamente

# Ver eventos
docker stats --no-stream
```

## 🧪 Parte 6: Tests de Integración

### Paso 6.1: Script de Validación

Crea `scripts/test-stack.sh`:

```bash
#!/bin/bash

echo "🧪 Testing Link Shortener Stack..."

# Test 1: Health checks
echo "1. Testing health endpoints..."
curl -f http://localhost:5000/health || exit 1
curl -f http://localhost:5173/health || exit 1
echo "✅ Health checks passed"

# Test 2: Shorten URL
echo "2. Testing URL shortening..."
RESPONSE=$(curl -s -X POST http://localhost:5000/shorten \
  -H "Content-Type: application/json" \
  -d '{"url": "https://kubernetes.io"}')
SHORT_CODE=$(echo $RESPONSE | jq -r '.short_code')
echo "Short code: $SHORT_CODE"
echo "✅ URL shortened"

# Test 3: Redirect
echo "3. Testing redirect..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/$SHORT_CODE)
if [ $STATUS -eq 302 ]; then
  echo "✅ Redirect works"
else
  echo "❌ Redirect failed (got $STATUS)"
  exit 1
fi

# Test 4: Stats
echo "4. Testing stats..."
curl -f http://localhost:5000/stats/$SHORT_CODE || exit 1
echo "✅ Stats retrieved"

echo ""
echo "🎉 All tests passed!"
```

### Paso 6.2: Ejecutar Tests

```bash
chmod +x scripts/test-stack.sh
./scripts/test-stack.sh
```

## 📊 Comandos Útiles

```bash
# Ver logs de todos los servicios
docker-compose logs

# Ver logs de un servicio específico
docker-compose logs backend

# Seguir logs en tiempo real
docker-compose logs -f

# Ver recursos usados
docker stats

# Ejecutar comando en servicio
docker-compose exec backend bash

# Escalar servicio (requiere remover container_name)
docker-compose up -d --scale backend=3

# Ver redes
docker network ls
docker network inspect lab-02_backend-network

# Ver volúmenes
docker volume ls
docker volume inspect lab-02_redis-data

# Restart un servicio
docker-compose restart backend

# Detener sin eliminar
docker-compose stop

# Detener y eliminar contenedores (preserva volúmenes)
docker-compose down

# Eliminar TODO (incluye volúmenes)
docker-compose down -v
```

## ✅ Verificación Final

- [ ] Creaste compose con redes personalizadas
- [ ] Agregaste volúmenes persistentes para Redis
- [ ] Implementaste health checks en todos los servicios
- [ ] Configuraste depends_on con condiciones
- [ ] Agregaste resource limits
- [ ] Probaste escenarios de fallo
- [ ] Verificaste auto-recuperación
- [ ] Ejecutaste tests de integración

## 🎓 Ejercicios Desafío

### Desafío 1: Múltiples Entornos

Crea archivos separados:
- `docker-compose.yml` (base)
- `docker-compose.dev.yml` (overrides para desarrollo)
- `docker-compose.prod.yml` (overrides para producción)

Ejecutar:
```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
```

### Desafío 2: Variables de Entorno

Crea `.env` file:
```env
COMPOSE_PROJECT_NAME=linkshortener
BACKEND_PORT=5000
FRONTEND_PORT=5173
REDIS_PORT=6379
```

Usa en compose: `${BACKEND_PORT}`

### Desafío 3: Profiles

Agrega profiles para servicios opcionales (monitoring, backup):
```yaml
services:
  prometheus:
    image: prom/prometheus
    profiles: ["monitoring"]
```

Activar: `docker-compose --profile monitoring up`

## 🚀 Siguiente Paso

**Continúa con:** [Lab 3: Kubernetes Essentials](../lab-03-kubernetes-essentials/README.md)
