# Lab 4: SRE Troubleshooting - Debugging Production Issues

## 🎯 Objetivos

- Diagnosticar y resolver crashloop backoffs
- Debugging de conectividad entre servicios
- Identificar y remediar vulnerabilidades
- Implementar probes correctamente
- Analizar logs y eventos del cluster

## ⏱️ Duración: 75 minutos

## 🚨 Parte 1: Incident 01 - CrashLoopBackOff

### Contexto del Incidente
Backend está en crash loop. No arranca correctamente.

### Paso 1.1: Desplegar Escenario Roto

Crea `incidents/incident-01/broken-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-broken
  namespace: linkshortener
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend-broken
  template:
    metadata:
      labels:
        app: backend-broken
    spec:
      containers:
      - name: backend
        image: link-backend:v1
        env:
        - name: REDIS_HOST
          value: "redis-wrong-name"  # ❌ Error intencional
        - name: REDIS_PORT
          value: "6379"
```

Aplicar:
```bash
kubectl apply -f incidents/incident-01/broken-deployment.yaml
```

### Paso 1.2: Investigar el Problema

```bash
# Ver estado
kubectl get pods -n linkshortener -l app=backend-broken

# Salida esperada:
# NAME                              READY   STATUS             RESTARTS
# backend-broken-xxx                0/1     CrashLoopBackOff   5

# Ver eventos
kubectl describe pod <POD_NAME> -n linkshortener

# Ver logs
kubectl logs <POD_NAME> -n linkshortener
```

**Análisis:**
- El pod intenta conectarse a `redis-wrong-name`
- DNS no resuelve el nombre
- App crashea y K8s reintenta (backoff exponencial)

### Paso 1.3: Resolver

Editar el deployment:
```bash
kubectl edit deployment backend-broken -n linkshortener

# Cambiar:
# value: "redis-wrong-name"
# Por:
# value: "redis"
```

Verificar:
```bash
kubectl get pods -n linkshortener -l app=backend-broken -w
```

### Limpieza
```bash
kubectl delete deployment backend-broken -n linkshortener
```

## 🔌 Parte 2: Incident 02 - Conectividad Fallida

### Contexto
Frontend no puede conectarse al backend (502 Bad Gateway).

### Paso 2.1: Desplegar Escenario

Crea `incidents/incident-02/broken-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-broken-svc
  namespace: linkshortener
spec:
  selector:
    app: backend-wrong-label  # ❌ Label selector incorrecto
  ports:
  - port: 5000
    targetPort: 5000
```

```bash
kubectl apply -f incidents/incident-02/broken-service.yaml
```

### Paso 2.2: Debugging

```bash
# Ver endpoints del service
kubectl get endpoints backend-broken-svc -n linkshortener

# Salida: <none> (sin pods asociados)

# Comparar con service correcto
kubectl get endpoints backend -n linkshortener

# Verificar labels de pods
kubectl get pods -n linkshortener --show-labels
```

### Paso 2.3: Resolver

```bash
kubectl edit service backend-broken-svc -n linkshortener

# Cambiar selector a:
# app: backend
```

### Paso 2.4: Test de Conectividad

```bash
# Desde otro pod
kubectl run test-pod --image=busybox:1.28 -n linkshortener -- sleep 3600

kubectl exec -it test-pod -n linkshortener -- sh

# Dentro del pod:
wget -qO- http://backend-broken-svc:5000/health
```

Limpieza:
```bash
kubectl delete service backend-broken-svc -n linkshortener
kubectl delete pod test-pod -n linkshortener
```

## 💾 Parte 3: Incident 03 - OOMKilled

### Contexto
Backend muere por falta de memoria.

### Paso 3.1: Deployment Sin Limits

Crea `incidents/incident-03/no-limits.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-oom
  namespace: linkshortener
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend-oom
  template:
    metadata:
      labels:
        app: backend-oom
    spec:
      containers:
      - name: backend
        image: link-backend:v1
        env:
        - name: REDIS_HOST
          value: "redis"
        resources:
          limits:
            memory: "50Mi"  # ❌ Muy poco
```

### Paso 3.2: Detectar OOM

```bash
kubectl apply -f incidents/incident-03/no-limits.yaml

# Monitorear
kubectl get pods -n linkshortener -w

# Ver razón de terminación
kubectl describe pod <POD_NAME> -n linkshortener | grep -A 5 "Last State"

# Buscar: Reason: OOMKilled
```

### Paso 3.3: Resolver

```bash
kubectl edit deployment backend-oom -n linkshortener

# Ajustar:
resources:
  requests:
    memory: "128Mi"
  limits:
    memory: "512Mi"
```

Limpieza:
```bash
kubectl delete deployment backend-oom -n linkshortener
```

## ❤️ Parte 4: Incident 04 - Probes Incorrectas

### Paso 4.1: Readiness Probe Fallida

Crea `incidents/incident-04/bad-probe.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-probe
  namespace: linkshortener
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend-probe
  template:
    metadata:
      labels:
        app: backend-probe
    spec:
      containers:
      - name: backend
        image: link-backend:v1
        env:
        - name: REDIS_HOST
          value: "redis"
        readinessProbe:
          httpGet:
            path: /wrong-endpoint  # ❌ Endpoint inexistente
            port: 5000
          initialDelaySeconds: 2
          periodSeconds: 5
```

### Paso 4.2: Diagnosticar

```bash
kubectl apply -f incidents/incident-04/bad-probe.yaml

kubectl get pods -n linkshortener -l app=backend-probe

# Estado: 0/1 Running (READY = 0)

# Ver eventos
kubectl describe pod <POD_NAME> -n linkshortener | grep Readiness

# Salida: Readiness probe failed: HTTP probe failed with statuscode: 404
```

### Paso 4.3: Corregir

```bash
kubectl edit deployment backend-probe -n linkshortener

# Cambiar:
path: /health
```

Limpieza:
```bash
kubectl delete deployment backend-probe -n linkshortener
```

## 🔍 Parte 5: Escaneo de Vulnerabilidades

### Paso 5.1: Escanear Todas las Imágenes

```bash
# Backend
trivy image link-backend:v1 --severity HIGH,CRITICAL

# Frontend
trivy image link-frontend:v1 --severity HIGH,CRITICAL

# Redis
trivy image redis:7-alpine --severity HIGH,CRITICAL
```

### Paso 5.2: Generar Reporte

```bash
trivy image link-backend:v1 \
  --format json \
  --output backend-vulnerabilities.json

# Ver conteo
cat backend-vulnerabilities.json | jq '[.Results[].Vulnerabilities[]] | length'
```

## 📊 Parte 6: Análisis de Logs

### Paso 6.1: Logs Agregados

```bash
# Todos los logs del backend
kubectl logs -n linkshortener -l app=backend --tail=100

# Con timestamp
kubectl logs -n linkshortener -l app=backend --timestamps=true

# Desde hace 1 hora
kubectl logs -n linkshortener -l app=backend --since=1h
```

### Paso 6.2: Buscar Errores

```bash
# Filtrar solo errores
kubectl logs -n linkshortener -l app=backend | grep -i error

# Contar errores 500
kubectl logs -n linkshortener -l app=backend | grep "500" | wc -l
```

### Paso 6.3: Logs de Contenedor Anterior (después de crash)

```bash
kubectl logs <POD_NAME> -n linkshortener --previous
```

## 🛠️ Comandos de Debugging Avanzado

```bash
# Ejecutar shell en pod corriendo
kubectl exec -it <POD_NAME> -n linkshortener -- /bin/sh

# Copiar archivo desde pod
kubectl cp linkshortener/<POD_NAME>:/app/logs/app.log ./app.log

# Ver uso de recursos en tiempo real
kubectl top pods -n linkshortener

# Eventos recientes ordenados
kubectl get events -n linkshortener \
  --sort-by='.lastTimestamp' \
  | tail -20

# Debug de DNS
kubectl run dnsutils --image=gcr.io/kubernetes-e2e-test-images/dnsutils:1.3 \
  -n linkshortener -- sleep 3600

kubectl exec -it dnsutils -n linkshortener -- nslookup backend
kubectl exec -it dnsutils -n linkshortener -- nslookup redis

# Ver configuración aplicada
kubectl get deployment backend -n linkshortener -o yaml
```

## ✅ Verificación

- [ ] Resuelto incident 01 (CrashLoop)
- [ ] Resuelto incident 02 (Conectividad)
- [ ] Resuelto incident 03 (OOMKill)
- [ ] Resuelto incident 04 (Probes)
- [ ] Escaneado vulnerabilidades
- [ ] Analizado logs del cluster

## 🎓 Resumen de Técnicas SRE

| Síntoma | Comando | Solución |
|---------|---------|----------|
| CrashLoop | `kubectl logs` | Revisar env vars, dependencias |
| 502/503 | `kubectl get endpoints` | Verificar service selectors |
| OOMKilled | `kubectl describe pod` | Aumentar memory limits |
| Pod Not Ready | `kubectl describe pod` | Corregir readiness probe |
| Slow startup | `kubectl get events` | Ajustar initialDelaySeconds |

---

**¡Felicidades! Completaste todos los labs del workshop.**
