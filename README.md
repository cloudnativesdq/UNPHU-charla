# Introducción a Contenedores — De Docker a Kubernetes

Charla y taller para la **Universidad Nacional Pedro Henríquez Ureña (UNPHU)**
en el contexto del evento **Cloud Native Santo Domingo 2026**, dirigida a estudiantes
de ingeniería y profesionales IT que se acercan por primera vez al mundo cloud native.

> **Página Oficial del Evento**: [Registrarse en CNCF Community Groups](https://ocgroups.dev/cncf/group/cqecyjw/event/um956yb)
>
> **Audiencia**: estudiantes y profesionales con conocimientos básicos de Linux,
> sin experiencia previa con contenedores ni orquestadores.
>
> **Agenda del Taller**:
> * **10:00 AM &ndash; 12:00 PM**: Conceptos fundamentales de Contenedores (con Lester Diaz)
> * **12:00 PM &ndash; 1:00 PM**: Receso para almuerzo
> * **1:00 PM &ndash; 3:00 PM**: Sesión práctica y ejercicios técnicos (labs con [KillerCoda](https://killercoda.com/))

---

## Temas cubiertos

La charla sigue una progresión deliberada: de la motivación a la práctica,
de lo local a lo distribuido, de "funciona en mi máquina" a "escala en producción".

### 1. Acto 1 — Hook + Introducción (5 min)

Por qué los contenedores importan ahora, no en 5 años. El problema real de
"funciona en mi máquina" que cada estudiante ha vivido. Qué veremos hoy.

### 2. Bloque 1 — Docker: la unidad mínima (20 min)

| Tema | Pregunta que responde |
|------|----------------------|
| **¿Por qué contenedores?** | Ventajas sobre VMs: tamaño, velocidad, portabilidad |
| **VMs vs Contenedores** | Qué capa se virtualiza en cada caso (hardware vs OS) |
| **Arquitectura del Docker Engine** | dockerd, containerd, runC, shim — cómo encaja el stack |
| **Namespaces y Cgroups** | La magia del kernel Linux que hace posible el aislamiento |
| **Imagen vs Contenedor** | Diferencia entre clase y objeto |
| **Docker Hub y registries** | Dónde viven las imágenes |
| **Dockerfile** | Cómo escribir una receta reproducible |
| **Image layers y build cache** | Por qué el orden de las instrucciones importa |
| **Cache busting y multi-stage** | Optimizar tamaño y velocidad de build |
| **Comandos esenciales** | Los 5 que usarás el 80% del tiempo |
| **Docker Compose** | Multi-container local para desarrollo |
| **Docker en la industria** | Spotify, Netflix, Shopify: casos reales |

### 3. Break interactivo (5 min)

Pregunta abierta para activar a la audiencia: *"¿Cómo escalarías tu app
de 10 a 10.000 usuarios?"*

### 4. Bloque 2 — Kubernetes: orquestación a escala (25 min)

| Tema | Pregunta que responde |
|------|----------------------|
| **¿Por qué Kubernetes?** | Lo que Docker solo no resuelve (auto-healing, scaling, service discovery) |
| **Historia** | De Borg (Google, 2003) a K8s (CNCF, 2015) |
| **Arquitectura del cluster** | Control plane vs worker nodes |
| **Componentes clave** | API Server, etcd, scheduler, controllers, kubelet, kube-proxy |
| **Pods** | La unidad mínima desplegable (analogía: apartamento compartido) |
| **Deployments** | El "gerente" que mantiene N réplicas vivas |
| **Services** | IP estable + DNS para pods efímeros (analogía: recepcionista de hotel) |
| **ConfigMaps y Secrets** | Config fuera del código, datos sensibles fuera del repo |
| **kubectl básico** | Los 5 comandos del día a día |
| **K8s en la industria** | Google (2B containers/semana), Pokemon Go, CERN, 90% de Fortune 100 |
| **HPA (Horizontal Pod Autoscaler)** | Escalar según CPU, memoria o métricas custom |

### 5. Bloque 3 — Acceso externo y el stack completo (10 min)

| Tema | Pregunta que responde |
|------|----------------------|
| **Ingress** | Una sola puerta con routing inteligente (vs un LoadBalancer por servicio) |
| **El stack completo** | De `docker build` a `kubectl scale` — el viaje de punta a punta |

### 6. Acto 3 — Recursos + Carreras + Cierre (10 min)

| Tema | Para qué |
|------|----------|
| **¿Dónde puedes trabajar?** | DevOps, SRE, Platform Engineering — roles reales |
| **Recursos para seguir** | KillerCoda, Play with K8s, KCNA/CKA/CKAD, CNCF Students |
| **Lab práctico** | Invitación a los 30 min hands-on post-charla |
| **Cierre** | Repo público, contacto, Q&A |

---

## Características de la presentación

- **43 slides** en español, optimizadas para proyección en sala (legible a 5-10m)
- **8 "Interview Tips"** distribuidos en slides técnicas: preguntas típicas de
  entrevistas (Docker, K8s, networking, debugging). Las respuestas están en las
  *speaker notes* — el presentador las ve, la audiencia no.
- **Notas del presentador** (`<aside class="notes">`) en cada slide con guion,
  analogías verbales y contexto para el presentador
- **Imágenes oficiales** de arquitectura Docker y Kubernetes (atribución incluida)
- **Ilustraciones SVG propias** para analogías (lunchbox, hotel, apartamento, barco)
- **Diagrama Mermaid** del stack completo de containers
- **Tema visual**: blanco con acentos azul UNPHU, transiciones suaves
- **Atajos de teclado**: `S` (speaker view), `O` (overview), `F` (fullscreen),
  `Ctrl+Shift+F` (buscar)

---

## Estructura del repositorio

```
.
├── README.md                          # Este archivo
├── docker-compose.yml                 # Nginx + Cloudflare Tunnel
├── html/
│   ├── nginx.conf                     # Sirve /presentation/presentation.html
│   └── presentation/
│       ├── presentation.html          # ⭐ Presentación principal (43 slides)
│       ├── styles.css                 # Tema visual custom
│       ├── index.html                 # Redirect compat (legacy)
│       └── assets/                    # SVGs + imágenes oficiales
│           ├── docker-architecture-official.webp
│           ├── kubernetes-cluster-architecture-official.svg
│           ├── lunchbox.svg           # Analogía containers = lunchbox
│           ├── hotel.svg              # Analogía Service = recepcionista
│           ├── vm-vs-container.svg    # Comparación visual
│           ├── container-ship.svg     # Docker en industria
│           ├── pod-building.svg       # K8s pods
│           ├── student-career.svg     # Roles profesionales
│           ├── hands-on-lab.svg       # Lab práctico
│           ├── image-layers.svg       # Capas de imagen Docker
│           ├── teamwork.svg           # Dev + DevOps + cloud
│           ├── captain-kube.svg       # (legacy, ya no se usa)
│           ├── unphu-logo.svg         # Branding UNPHU
│           └── qr-repo.svg            # QR al repo público
```

---

## Inicio rápido

### Requisitos

- [Docker](https://docs.docker.com/get-docker/) (Docker Desktop o Docker Engine)
- Navegador moderno (Chrome, Firefox, Safari)

### Levantar la presentación

```bash
# Clonar
git clone https://github.com/cloudnativesdq/UNPHU-charla.git
cd UNPHU-charla

# Levantar nginx local
docker compose up -d

# Ver localmente
# http://localhost:8000

# (Opcional) Exponer a internet con URL pública temporal
docker compose logs tunnel | grep trycloudflare.com
```

### Atajos de teclado

| Acción | Tecla |
|--------|-------|
| Avanzar / retroceder | `←` / `→` / `Espacio` |
| Vista de presentador | `S` |
| Vista overview (todas las slides) | `O` |
| Pantalla completa | `F` |
| Buscar en slides | `Ctrl+Shift+F` |
| Zoom en elemento | `Alt+Click` (Linux: `Ctrl+Click`) |

---

## Personalizar la presentación

### Editar el contenido

El archivo principal es `html/presentation/presentation.html`. Es HTML directo
con Reveal.js cargado desde CDN. Después de editar:

```bash
# Los assets se sirven directamente desde ./html/presentation/
# Solo refrescar el navegador (Ctrl+R)
docker compose restart revealjs   # Solo si tocás nginx.conf
```

### Cambiar el tema visual

`html/presentation/styles.css` controla colores, tamaños, espaciado.
Las variables CSS principales están al inicio del archivo:

```css
:root {
  --primary-color: #2563eb;    /* Azul UNPHU */
  --accent-orange: #f59e0b;    /* Docker */
  --accent-cyan: #06b6d4;
  --muted-color: #64748b;
}
```

### Atribución de imágenes oficiales

Las dos imágenes de arquitectura tienen atribución explícita en sus slides
correspondientes (Docker engine → docs.docker.com CC BY-SA; Kubernetes cluster
→ kubernetes.io CC BY 4.0).

---

## Despliegue a GitHub Pages

El repo incluye un redirect legacy en `html/presentation/index.html` por
compatibilidad con despliegues anteriores en GitHub Pages. Para activar:

1. Settings → Pages → Branch: `main`, folder: `/html/presentation`
2. La presentación queda disponible en
   `https://cloudnativesdq.github.io/UNPHU-charla/presentation.html`

---

## Recursos mencionados en la charla

- [Play with Kubernetes](https://labs.play-with-k8s.com/) — Cluster gratis por 4h en el navegador
- [KillerCoda](https://killercoda.com/) — Labs interactivos de Kubernetes y Docker
- [Kubernetes Docs](https://kubernetes.io/docs/) — Documentación oficial
- [Docker Docs](https://docs.docker.com/) — Documentación oficial
- [container.training](https://container.training/) — Workshops interactivos
- [CNCF Landscape](https://landscape.cncf.io/) — Ecosistema completo
- [CNCF Students](https://www.cncf.io/) — Becas y comunidad para estudiantes
- Certificaciones Linux Foundation: **KCNA** (entrada), **CKA** (admin), **CKAD** (developer)

---

## Créditos

Charla preparada para **UNPHU 2026** por la comunidad **Cloud Native Santo Domingo**.
Speaker: Lester Diaz Perez, Kubestronaut.

Ilustraciones SVG: originales del proyecto.
Diagramas de arquitectura: Docker Inc. (Apache 2.0) y Kubernetes Project (CC BY 4.0).

## Licencia

MIT
