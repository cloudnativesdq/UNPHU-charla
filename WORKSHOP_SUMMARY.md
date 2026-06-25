# Workshop de Contenedores y Kubernetes - Resumen Ejecutivo

## 📋 Información General

**Aplicación:** Link Shortener (Acortador de URLs)  
**Stack:** React + Flask + Redis  
**Duración Total:** 4-5 horas  
**Nivel:** Básico a Avanzado

## 🎯 Objetivos Cumplidos

### Para Estudiantes
✅ Containerizar aplicaciones multi-tier con Docker  
✅ Orquestar servicios con Docker Compose  
✅ Desplegar en Kubernetes (Minikube)  
✅ Aplicar prácticas SRE de troubleshooting  

### Para Instructores
✅ Material step-by-step probado  
✅ Escenarios de fallo realistas  
✅ Optimizado para hardware limitado (8GB RAM)  
✅ Compatible con WSL2/Linux/Mac  

## 📚 Estructura de los Labs

```
practice/
├── README.md                          # Índice general
├── lab-01-docker-fundamentals/        # 60 min ⭐
│   ├── README.md
│   └── scripts/
├── lab-02-docker-compose/             # 60 min ⭐⭐
│   ├── README.md
│   ├── configs/
│   └── scripts/
├── lab-03-kubernetes-essentials/      # 90 min ⭐⭐⭐
│   ├── README.md
│   ├── manifests/
│   └── scripts/
└── lab-04-sre-troubleshooting/        # 75 min ⭐⭐⭐
    ├── README.md
    ├── incidents/
    └── scripts/
```

## 🔑 Conceptos Cubiertos

### Lab 1: Docker Fundamentals
- Multi-stage builds
- Optimización de imágenes (82-96% reducción)
- Usuarios no-root
- Escaneo de vulnerabilidades con Trivy
- .dockerignore y cache optimization

### Lab 2: Docker Compose
- Orquestación multi-contenedor
- Redes personalizadas (seguridad por capas)
- Volúmenes persistentes
- Health checks y depends_on
- Simulación de fallos

### Lab 3: Kubernetes Essentials
- Deployments con réplicas
- Services (ClusterIP, NodePort)
- ConfigMaps y Secrets
- PersistentVolumeClaims
- Rolling updates y rollbacks
- Auto-healing y auto-scaling (HPA)

### Lab 4: SRE Troubleshooting
- CrashLoopBackOff (misconfigured env vars)
- Conectividad fallida (wrong selectors)
- OOMKilled (resource limits)
- Readiness probe failures
- Log aggregation y análisis
- Vulnerability scanning

## 💡 Decisiones de Diseño

### ¿Por qué esta app?
- **Simplicidad:** 3 servicios, fácil de entender
- **Realismo:** Arquitectura típica (frontend + API + DB)
- **Stateful:** Redis con persistencia (más desafiante)
- **Observable:** Health checks, logs, métricas

### ¿Por qué Minikube?
- Corre en laptops de 8GB RAM
- Funciona en WSL2 sin problemas
- Incluye dashboard y métricas
- Fácil de resetear (minikube delete)

### ¿Por qué estos incidentes?
Basados en problemas reales de SRE:
1. **CrashLoop:** Error de configuración (#1 causa en producción)
2. **502 Bad Gateway:** Selector incorrecto (muy común)
3. **OOMKilled:** Falta de resource limits
4. **Pod Not Ready:** Probes mal configuradas

## 📊 Métricas de Éxito

### Para Estudiantes
Al completar el workshop, podrán:
- [ ] Construir imágenes Docker optimizadas (<200MB)
- [ ] Escribir docker-compose.yml completos
- [ ] Crear manifests de Kubernetes (Deployments, Services)
- [ ] Diagnosticar y resolver 4+ tipos de incidentes
- [ ] Usar kubectl para debugging

### Para Instructores
Indicadores de que el workshop funciona:
- Estudiantes completan Lab 1 en <70 min
- <10% de estudiantes atascados en Lab 2
- Lab 3 corre en Minikube sin issues de RAM
- Estudiantes resuelven 3/4 incidentes sin ayuda

## 🛠️ Requisitos de Infraestructura

### Por Estudiante
- Laptop 8GB RAM / 256GB SSD mínimo
- WSL2 (Windows) o Linux/Mac nativo
- Docker Desktop o Docker Engine
- Minikube + kubectl
- 20GB espacio libre en disco

### Red/Internet
- Descarga de imágenes: ~2GB total
- No requiere cluster externo
- Puede correrse 100% offline después del setup

## 🚀 Guía de Ejecución para Instructores

### Pre-Workshop (1 día antes)
```bash
# 1. Clonar repo en todas las laptops
git clone <REPO_URL>

# 2. Pre-descargar imágenes
docker pull redis:7-alpine
docker pull python:3.11-slim
docker pull node:20-alpine
docker pull nginx:alpine

# 3. Verificar Minikube
minikube start --cpus=2 --memory=4096
minikube status
```

### Durante el Workshop

**Agenda Oficial:**
- 10:00 AM &ndash; 12:00 PM: Conceptos fundamentales de Contenedores (con Lester Diaz)
- 12:00 PM &ndash; 1:00 PM: Receso para almuerzo
- 1:00 PM &ndash; 3:00 PM: Sesión práctica y ejercicios técnicos (labs con [KillerCoda](https://killercoda.com/))

## 📚 Recursos Adicionales

### Documentación Oficial
- [Docker Docs](https://docs.docker.com/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Minikube Docs](https://minikube.sigs.k8s.io/docs/)

### Herramientas Complementarias
- [Lens](https://k8slens.dev/) - GUI para Kubernetes
- [k9s](https://k9scli.io/) - Terminal UI para K8s
- [Dive](https://github.com/wagoodman/dive) - Analizar capas de imágenes

### Para Profundizar
- [Kubernetes Patterns Book](https://www.oreilly.com/library/view/kubernetes-patterns/9781492050278/)
- [The Site Reliability Workbook](https://sre.google/workbook/table-of-contents/)
- [12 Factor App](https://12factor.net/)

## 🐛 Troubleshooting Común

### "Docker no arranca en WSL2"
```bash
sudo service docker start
# O reiniciar Docker Desktop
```

### "Minikube out of memory"
```bash
minikube delete
minikube start --cpus=2 --memory=3072  # Reducir a 3GB
```

### "Imágenes no se encuentran en Minikube"
```bash
eval $(minikube docker-env)  # IMPORTANTE: olvidado frecuentemente
docker build -t link-backend:v1 .
```

### "Puerto ya en uso"
```bash
# Ver qué proceso usa el puerto
sudo lsof -i :5000
# Matar proceso
kill -9 <PID>
```

## ✅ Checklist de Entrega

Antes de entregar el workshop, verificar:
- [ ] Todos los README.md tienen comandos copy-paste-able
- [ ] Scripts tienen permisos de ejecución
- [ ] Manifests de K8s están validados (kubectl apply --dry-run)
- [ ] Incidentes se pueden reproducir
- [ ] Soluciones están documentadas
- [ ] Repository tiene .gitignore para archivos generados
- [ ] LICENSE incluido (si aplica)

## 📞 Soporte Post-Workshop

### Para Estudiantes
- Issues en GitHub: `<REPO_URL>/issues`
- Slack/Discord: `#docker-k8s-workshop`
- Office hours: Viernes 3-5pm

### Para Instructores
- Material actualizable vía PRs
- Feedback bienvenido en Discussions
- Contacto: `<EMAIL_INSTRUCTOR>`

---

**Versión:** 1.0  
**Última actualización:** 2026-05-31  
**Mantenedor:** SRE Team
