# Workshop de Contenedores y Kubernetes - Link Shortener App

## 🎯 Objetivo del Workshop

Aprender a containerizar, orquestar y gestionar aplicaciones en producción usando Docker y Kubernetes, aplicando prácticas SRE reales de confiabilidad, escalabilidad y observabilidad.

## 📋 Prerrequisitos

### Software Requerido
- **WSL2** (Windows) o terminal Linux/Mac
- **Docker Desktop** o Docker Engine (20.10+)
- **Docker Compose** (2.0+)
- **Minikube** (v1.30+)
- **kubectl** (cliente de Kubernetes)
- **Git**

### Conocimientos Previos
- Comandos básicos de Linux (cd, ls, cat, grep)
- Conceptos básicos de redes (IP, puertos, HTTP)
- Conocimiento básico de Git

### Verificación del Entorno

```bash
# Verificar Docker
docker --version
docker compose version

# Verificar Minikube
minikube version

# Verificar kubectl
kubectl version --client

# Verificar WSL2 (Windows)
wsl --status
```

## 🗂️ Estructura de los Laboratorios

| Lab | Tema | Duración | Dificultad |
|-----|------|----------|------------|
| **Lab 1** | Docker Fundamentals | 60 min | ⭐ Básico |
| **Lab 2** | Docker Compose | 60 min | ⭐⭐ Intermedio |
| **Lab 3** | Kubernetes Essentials | 90 min | ⭐⭐⭐ Avanzado |
| **Lab 4** | SRE Troubleshooting | 75 min | ⭐⭐⭐ Avanzado |

## 🚀 Progresión de Aprendizaje

```
Lab 1: Docker Fundamentals
├─ Construir imágenes optimizadas
├─ Multi-stage builds
├─ Seguridad básica
└─ Escaneo de vulnerabilidades
         │
         ▼
Lab 2: Docker Compose
├─ Orquestar múltiples servicios
├─ Redes y volúmenes
├─ Health checks
└─ Gestión de dependencias
         │
         ▼
Lab 3: Kubernetes Essentials
├─ Deployments y Pods
├─ Services y balanceo
├─ ConfigMaps y Secrets
└─ Auto-healing y escalado
         │
         ▼
Lab 4: SRE Troubleshooting
├─ Debugging de contenedores
├─ Análisis de logs
├─ Probes (liveness/readiness)
└─ Resolución de incidentes reales
```

## 📚 Contenido de Cada Lab

### [Lab 1: Docker Fundamentals](lab-01-docker-fundamentals/README.md)
Aprende a construir imágenes Docker optimizadas para producción usando multi-stage builds y mejores prácticas de seguridad.

**Aprenderás:**
- Dockerfiles multi-stage
- Optimización de capas y cache
- Usuarios no-root
- Escaneo de vulnerabilidades con Trivy

### [Lab 2: Docker Compose](lab-02-docker-compose/README.md)
Orquesta la aplicación completa (Frontend + Backend + Redis) con Docker Compose, implementando redes aisladas, volúmenes persistentes y health checks.

**Aprenderás:**
- Definición de servicios multi-contenedor
- Redes personalizadas
- Volúmenes para persistencia
- Health checks y depends_on

### [Lab 3: Kubernetes Essentials](lab-03-kubernetes-essentials/README.md)
Migra la aplicación de Docker Compose a Kubernetes, implementando alta disponibilidad, auto-healing y gestión de configuración.

**Aprenderás:**
- Deployments con réplicas
- Services (ClusterIP, NodePort)
- ConfigMaps y Secrets
- Rolling updates y rollbacks

### [Lab 4: SRE Troubleshooting](lab-04-sre-troubleshooting/README.md)
Resuelve incidentes reales simulados: crashloops, fallos de conexión, OOM kills y problemas de readiness probes.

**Aprenderás:**
- Debugging con kubectl logs/exec
- Análisis de eventos del cluster
- Liveness y Readiness Probes
- Resource limits y requests

## 🔧 Configuración Inicial

### 1. Clonar el Repositorio

```bash
cd ~/Desktop
git clone <URL_DEL_REPO>
cd link-shortener-app
```

### 2. Verificar Estructura

```bash
ls -la
# Deberías ver: apps/ practice/ README.md
```

### 3. Configurar Minikube (Para Labs 3 y 4)

```bash
# Iniciar Minikube con recursos limitados (8GB RAM laptop)
minikube start --cpus=2 --memory=4096 --driver=docker

# Verificar estado
minikube status

# Habilitar métricas (opcional)
minikube addons enable metrics-server
```

## 📝 Metodología de Trabajo

Cada laboratorio sigue esta estructura:

1. **Introducción Teórica** (5 min): Conceptos clave explicados de forma simple
2. **Setup Inicial** (5 min): Preparar archivos y verificar herramientas
3. **Ejercicios Guiados** (40-60 min): Comandos paso a paso con explicaciones
4. **Verificación** (5 min): Tests para confirmar que funciona correctamente
5. **Desafíos Opcionales** (10-15 min): Ejercicios extra para profundizar

## 🆘 Solución de Problemas Comunes

### Docker no arranca en WSL2

```bash
# Verificar que Docker Desktop está corriendo
# Reiniciar servicio Docker en WSL2
sudo service docker start
```

### Minikube falla por falta de recursos

```bash
# Detener Minikube
minikube stop

# Eliminar el cluster actual
minikube delete

# Crear con menos recursos
minikube start --cpus=2 --memory=3072 --driver=docker
```

### Puertos ya en uso

```bash
# Ver qué proceso usa el puerto 5000
sudo lsof -i :5000

# Matar el proceso (reemplaza PID)
kill -9 <PID>
```

## 🎓 Recursos Adicionales

- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Kubernetes Patterns](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)

## 📞 Soporte

Si encuentras problemas durante los labs:
1. Revisa la sección "Troubleshooting" de cada README
2. Consulta con el instructor
3. Revisa los logs: `docker logs <container>` o `kubectl logs <pod>`

## ✅ Checklist de Completitud

Marca cada lab conforme lo completes:

- [ ] Lab 1: Docker Fundamentals completado
- [ ] Lab 2: Docker Compose completado
- [ ] Lab 3: Kubernetes Essentials completado
- [ ] Lab 4: SRE Troubleshooting completado

---

**¡Comienza con el [Lab 1: Docker Fundamentals](lab-01-docker-fundamentals/README.md)!**
