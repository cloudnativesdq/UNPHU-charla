# Lab 3: Kubernetes Essentials - From Docker Compose to K8s

## 🎯 Objetivos

- Migrar aplicación de Docker Compose a Kubernetes
- Crear Deployments con réplicas y auto-healing
- Configurar Services para networking interno
- Gestionar configuración con ConfigMaps y Secrets
- Implementar rolling updates

## ⏱️ Duración: 90 minutos

## 🚀 Parte 1: Setup de Minikube

### Paso 1.1: Iniciar Minikube

```bash
# Iniciar con recursos limitados (8GB RAM laptop)
minikube start --cpus=2 --memory=4096 --driver=docker

# Verificar
minikube status
kubectl cluster-info
kubectl get nodes
```

### Paso 1.2: Habilitar Addons

```bash
minikube addons enable metrics-server
minikube addons enable dashboard

# Ver dashboard (opcional)
minikube dashboard
```

### Paso 1.3: Configurar Docker para Minikube

```bash
# Usar Docker daemon de Minikube
eval $(minikube docker-env)

# Construir imágenes dentro de Minikube
cd ./apps/backend
docker build -t link-backend:v1 .

cd ./apps/frontend
docker build -t link-frontend:v1 .

# Verificar
docker images | grep link-
```

## 📦 Parte 2: Namespace y Redis

### Paso 2.1: Crear Namespace

```bash
cd ./practice/lab-03-kubernetes-essentials
mkdir -p manifests
```

Crea `manifests/01-namespace.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: linkshortener
  labels:
    app: linkshortener
    env: dev
```

Aplicar:
```bash
kubectl apply -f manifests/01-namespace.yaml
kubectl get namespaces
```

### Paso 2.2: Redis PersistentVolumeClaim

Crea `manifests/02-redis-pvc.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-pvc
  namespace: linkshortener
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard
```

### Paso 2.3: Redis Deployment

Crea `manifests/03-redis-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: linkshortener
  labels:
    app: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:7-alpine
        ports:
        - containerPort: 6379
          name: redis
        volumeMounts:
        - name: redis-storage
          mountPath: /data
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "250m"
        livenessProbe:
          exec:
            command:
            - redis-cli
            - ping
          initialDelaySeconds: 5
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - redis-cli
            - ping
          initialDelaySeconds: 5
          periodSeconds: 5
      volumes:
      - name: redis-storage
        persistentVolumeClaim:
          claimName: redis-pvc
```

### Paso 2.4: Redis Service

Crea `manifests/04-redis-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
  namespace: linkshortener
spec:
  type: ClusterIP
  selector:
    app: redis
  ports:
  - port: 6379
    targetPort: 6379
    protocol: TCP
```

### Paso 2.5: Aplicar Redis

```bash
kubectl apply -f manifests/02-redis-pvc.yaml
kubectl apply -f manifests/03-redis-deployment.yaml
kubectl apply -f manifests/04-redis-service.yaml

# Verificar
kubectl get pods -n linkshortener
kubectl get svc -n linkshortener
kubectl logs -n linkshortener -l app=redis
```

## 🔧 Parte 3: Backend con ConfigMap

### Paso 3.1: ConfigMap

Crea `manifests/05-backend-configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backend-config
  namespace: linkshortener
data:
  REDIS_HOST: "redis"
  REDIS_PORT: "6379"
  FLASK_ENV: "production"
  LOG_LEVEL: "info"
```

### Paso 3.2: Secret (opcional)

Crea `manifests/06-backend-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: backend-secret
  namespace: linkshortener
type: Opaque
data:
  # base64 encoded values
  # echo -n "supersecretkey" | base64
  SECRET_KEY: c3VwZXJzZWNyZXRrZXk=
```

### Paso 3.3: Backend Deployment

Crea `manifests/07-backend-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: linkshortener
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: link-backend:v1
        imagePullPolicy: Never
        ports:
        - containerPort: 5000
          name: http
        envFrom:
        - configMapRef:
            name: backend-config
        env:
        - name: SECRET_KEY
          valueFrom:
            secretKeyRef:
              name: backend-secret
              key: SECRET_KEY
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 5000
          initialDelaySeconds: 10
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /health
            port: 5000
          initialDelaySeconds: 5
          periodSeconds: 10
```

### Paso 3.4: Backend Service

Crea `manifests/08-backend-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: linkshortener
spec:
  type: NodePort
  selector:
    app: backend
  ports:
  - port: 5000
    targetPort: 5000
    nodePort: 30500
    protocol: TCP
```

### Paso 3.5: Aplicar Backend

```bash
kubectl apply -f manifests/05-backend-configmap.yaml
kubectl apply -f manifests/06-backend-secret.yaml
kubectl apply -f manifests/07-backend-deployment.yaml
kubectl apply -f manifests/08-backend-service.yaml

# Verificar 3 réplicas
kubectl get pods -n linkshortener -l app=backend

# Ver logs
kubectl logs -n linkshortener -l app=backend --tail=20
```

## 🎨 Parte 4: Frontend

### Paso 4.1: Frontend Deployment

Crea `manifests/09-frontend-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: linkshortener
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: link-frontend:v1
        imagePullPolicy: Never
        ports:
        - containerPort: 80
          name: http
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 3
          periodSeconds: 10
```

### Paso 4.2: Frontend Service

Crea `manifests/10-frontend-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: linkshortener
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
    protocol: TCP
```

### Paso 4.3: Aplicar Frontend

```bash
kubectl apply -f manifests/09-frontend-deployment.yaml
kubectl apply -f manifests/10-frontend-service.yaml

# Verificar
kubectl get all -n linkshortener
```

## 🧪 Parte 5: Probar Aplicación

### Paso 5.1: Acceder a la App

```bash
# Obtener IP de Minikube
minikube ip

# Acceder al frontend
minikube service frontend -n linkshortener --url

# Acceder al backend
minikube service backend -n linkshortener --url

# Abrir en navegador
minikube service frontend -n linkshortener
```

### Paso 5.2: Test de API

```bash
BACKEND_URL=$(minikube service backend -n linkshortener --url)

# Health check
curl $BACKEND_URL/health

# Shorten URL
curl -X POST $BACKEND_URL/shorten \
  -H "Content-Type: application/json" \
  -d '{"url": "https://kubernetes.io"}'
```

## 🔄 Parte 6: Rolling Updates

### Paso 6.1: Actualizar Imagen

```bash
# Simular cambio en código
cd ./apps/backend
docker build -t link-backend:v2 .

# Ver estrategia actual
kubectl describe deployment backend -n linkshortener | grep Strategy
```

### Paso 6.2: Aplicar Update

```bash
# Cambiar imagen en deployment
kubectl set image deployment/backend \
  backend=link-backend:v2 \
  -n linkshortener

# Monitorear rollout
kubectl rollout status deployment/backend -n linkshortener

# Ver historia
kubectl rollout history deployment/backend -n linkshortener
```

### Paso 6.3: Rollback

```bash
# Volver a versión anterior
kubectl rollout undo deployment/backend -n linkshortener

# Rollback a revisión específica
kubectl rollout undo deployment/backend --to-revision=1 -n linkshortener
```

## 🛠️ Parte 7: Auto-Healing

### Paso 7.1: Eliminar Pod

```bash
# Listar pods
kubectl get pods -n linkshortener

# Eliminar un pod del backend
kubectl delete pod <NOMBRE_POD> -n linkshortener

# Observar recreación automática
kubectl get pods -n linkshortener -w
```

### Paso 7.2: Simular Crash

```bash
# Matar proceso dentro del contenedor
kubectl exec -n linkshortener <NOMBRE_POD> -- kill 1

# Ver reinicio automático
kubectl get pods -n linkshortener
kubectl describe pod <NOMBRE_POD> -n linkshortener | grep Restart
```

## 📊 Parte 8: Escalado

### Paso 8.1: Escalar Manualmente

```bash
# Escalar backend a 5 réplicas
kubectl scale deployment backend --replicas=5 -n linkshortener

# Verificar
kubectl get pods -n linkshortener -l app=backend

# Volver a 3
kubectl scale deployment backend --replicas=3 -n linkshortener
```

### Paso 8.2: Autoscaling (HPA)

```bash
# Crear Horizontal Pod Autoscaler
kubectl autoscale deployment backend \
  --cpu-percent=50 \
  --min=2 \
  --max=10 \
  -n linkshortener

# Verificar
kubectl get hpa -n linkshortener

# Ver detalles
kubectl describe hpa backend -n linkshortener
```

## 🔍 Comandos Útiles

```bash
# Ver todos los recursos
kubectl get all -n linkshortener

# Describir pod
kubectl describe pod <POD_NAME> -n linkshortener

# Logs
kubectl logs <POD_NAME> -n linkshortener
kubectl logs -f <POD_NAME> -n linkshortener
kubectl logs -l app=backend -n linkshortener --tail=50

# Ejecutar comando en pod
kubectl exec -it <POD_NAME> -n linkshortener -- sh

# Port-forward (acceso directo)
kubectl port-forward service/backend 5000:5000 -n linkshortener

# Ver eventos
kubectl get events -n linkshortener --sort-by='.lastTimestamp'

# Ver uso de recursos
kubectl top pods -n linkshortener
kubectl top nodes

# Eliminar todo
kubectl delete namespace linkshortener
```

## ✅ Verificación

- [ ] Minikube iniciado y funcionando
- [ ] Redis desplegado con PVC
- [ ] Backend con 3 réplicas
- [ ] Frontend con 2 réplicas
- [ ] ConfigMaps y Secrets aplicados
- [ ] Services accesibles
- [ ] Auto-healing verificado
- [ ] Rolling update ejecutado
- [ ] Escalado manual probado

## 🚀 Siguiente Paso

**Continúa con:** [Lab 4: SRE Troubleshooting](../lab-04-sre-troubleshooting/README.md)
