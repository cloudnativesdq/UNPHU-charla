# Design Document: Ilustraciones para Presentación Reveal.js "De 0 a Observabilidad"

## Overview

Este feature agrega 5 ilustraciones visuales SVG/HTML inline a la presentación Reveal.js existente (`html/index.html`) sobre contenedores y Kubernetes para la charla UNPHU 2026. Cada ilustración reemplaza o complementa el contenido textual actual con diagramas animados que usan la paleta de colores del proyecto, fragments de Reveal.js para animación progresiva, e íconos SVG de herramientas cargados desde CDN. Todo el código es inline (sin archivos externos adicionales) y compatible con Reveal.js 5.1.0 a resolución 1920×1080.

La estrategia de integración es conservadora: las ilustraciones **reemplazan** las cards de texto donde ya existe una sección visual débil (VM vs Contenedor, Arquitectura K8s, Stack de Observabilidad, Roadmap), y **agregan** un nuevo slide en la sección de la app demo (Flujo del Acortador de URLs). El diseño prioriza legibilidad a distancia, jerarquía visual clara y consistencia con los estilos CSS ya definidos en el `<head>`.

## Paleta de Colores y Estilos CSS Compartidos

```
Colores base (ya definidos en el proyecto):
  --k8s-blue:   #326CE5   → componentes K8s, flechas principales
  --green:      #2ecc71   → estados OK, datos persistentes
  --orange:     #f39c12   → warnings, nodos worker, en curso
  --red:        #e74c3c   → errores, VM overhead, eliminar
  --bg-dark:    #1a1a2e   → fondo global
  --bg-card:    rgba(255,255,255,0.08)  → cards existentes

Colores adicionales para ilustraciones:
  --grafana:    #f46800   → Grafana orange
  --prometheus: #e6522c   → Prometheus red-orange
  --loki:       #f0a500   → Loki yellow
  --tempo:      #3b82f6   → Tempo blue
  --react:      #61dafb   → React cyan
  --flask:      #ffffff   → Flask (blanco sobre fondo)
  --redis:      #dc382c   → Redis red

Gradientes de sección:
  Control Plane bg:  rgba(50,108,229,0.15) border #326CE5
  Worker Node bg:    rgba(243,156,18,0.15) border #f39c12
  Arrow stroke:      #326CE5, width 2px, marker-end arrow
```


## Componentes e Interfaces

### Ilustración 1: Diagrama VM vs Contenedor

**Ubicación**: Slide `¿Por qué contenedores?` (sección `data-auto-animate`, actualmente tiene 2 cards `.grid-2`).

**Integración**: Reemplaza las 2 cards de texto actuales. El slide pasa a tener un `<div class="columns">` con dos columnas SVG: izquierda = stack VM, derecha = stack Contenedor.

**Estructura HTML/SVG**:

```html
<section data-auto-animate data-transition="convex">
  <h3>¿Por qué contenedores?</h3>
  <p class="center small-font" style="opacity:0.7; margin-bottom:12px;">
    Mismo hardware, mucho menos overhead
  </p>
  <div class="columns" style="align-items:center; gap:3rem;">

    <!-- Columna Izquierda: VM Stack -->
    <div class="fragment" style="text-align:center;">
      <p style="color:#e74c3c; font-size:0.65em; margin-bottom:8px;">⚠ Máquina Virtual</p>
      <svg viewBox="0 0 200 340" width="220" height="340"
           xmlns="http://www.w3.org/2000/svg">
        <!-- Hardware -->
        <rect x="10" y="290" width="180" height="40" rx="6"
              fill="#2d3748" stroke="#718096" stroke-width="1.5"/>
        <text x="100" y="315" text-anchor="middle"
              fill="#a0aec0" font-size="12" font-family="monospace">Hardware</text>

        <!-- Hypervisor -->
        <rect x="10" y="240" width="180" height="40" rx="6"
              fill="#553c2e" stroke="#e74c3c" stroke-width="1.5"/>
        <text x="100" y="265" text-anchor="middle"
              fill="#e74c3c" font-size="11" font-family="monospace">Hypervisor</text>

        <!-- OS 1 -->
        <rect x="10" y="175" width="82" height="55" rx="6"
              fill="#3d2a2a" stroke="#e74c3c" stroke-width="1" stroke-dasharray="4"/>
        <text x="51" y="196" text-anchor="middle"
              fill="#fc8181" font-size="9" font-family="monospace">OS Completo</text>
        <text x="51" y="212" text-anchor="middle"
              fill="#fc8181" font-size="8" font-family="monospace">~1 GB</text>
        <rect x="18" y="220" width="66" height="18" rx="3"
              fill="rgba(252,129,129,0.2)" stroke="#fc8181" stroke-width="1"/>
        <text x="51" y="232" text-anchor="middle"
              fill="#fc8181" font-size="8" font-family="monospace">App A</text>

        <!-- OS 2 -->
        <rect x="108" y="175" width="82" height="55" rx="6"
              fill="#3d2a2a" stroke="#e74c3c" stroke-width="1" stroke-dasharray="4"/>
        <text x="149" y="196" text-anchor="middle"
              fill="#fc8181" font-size="9" font-family="monospace">OS Completo</text>
        <text x="149" y="212" text-anchor="middle"
              fill="#fc8181" font-size="8" font-family="monospace">~1 GB</text>
        <rect x="116" y="220" width="66" height="18" rx="3"
              fill="rgba(252,129,129,0.2)" stroke="#fc8181" stroke-width="1"/>
        <text x="149" y="232" text-anchor="middle"
              fill="#fc8181" font-size="8" font-family="monospace">App B</text>

        <!-- Label overhead -->
        <text x="100" y="165" text-anchor="middle"
              fill="#e74c3c" font-size="10" font-family="monospace">2-3 GB overhead</text>
      </svg>
    </div>

    <!-- VS separador -->
    <div style="font-size:1.8em; opacity:0.4; flex:0 0 auto;">VS</div>

    <!-- Columna Derecha: Container Stack -->
    <div class="fragment" style="text-align:center;">
      <p style="color:#2ecc71; font-size:0.65em; margin-bottom:8px;">✓ Contenedores</p>
      <svg viewBox="0 0 200 340" width="220" height="340"
           xmlns="http://www.w3.org/2000/svg">
        <!-- Hardware -->
        <rect x="10" y="290" width="180" height="40" rx="6"
              fill="#2d3748" stroke="#718096" stroke-width="1.5"/>
        <text x="100" y="315" text-anchor="middle"
              fill="#a0aec0" font-size="12" font-family="monospace">Hardware</text>

        <!-- Host OS -->
        <rect x="10" y="240" width="180" height="40" rx="6"
              fill="#1a3a2a" stroke="#2ecc71" stroke-width="1.5"/>
        <text x="100" y="257" text-anchor="middle"
              fill="#2ecc71" font-size="11" font-family="monospace">Host OS (kernel compartido)</text>
        <text x="100" y="272" text-anchor="middle"
              fill="#2ecc71" font-size="9" font-family="monospace">~0 MB extra</text>

        <!-- Container Runtime -->
        <rect x="10" y="195" width="180" height="35" rx="6"
              fill="#1a2a3a" stroke="#326CE5" stroke-width="1.5"/>
        <text x="100" y="217" text-anchor="middle"
              fill="#326CE5" font-size="11" font-family="monospace">containerd / Docker</text>

        <!-- App A container -->
        <rect x="10" y="148" width="82" height="38" rx="6"
              fill="rgba(50,108,229,0.2)" stroke="#326CE5" stroke-width="1"/>
        <text x="51" y="163" text-anchor="middle"
              fill="#93c5fd" font-size="9" font-family="monospace">Namespace</text>
        <text x="51" y="179" text-anchor="middle"
              fill="#93c5fd" font-size="9" font-family="monospace">App A ~30MB</text>

        <!-- App B container -->
        <rect x="108" y="148" width="82" height="38" rx="6"
              fill="rgba(50,108,229,0.2)" stroke="#326CE5" stroke-width="1"/>
        <text x="149" y="163" text-anchor="middle"
              fill="#93c5fd" font-size="9" font-family="monospace">Namespace</text>
        <text x="149" y="179" text-anchor="middle"
              fill="#93c5fd" font-size="9" font-family="monospace">App B ~30MB</text>

        <!-- Label saving -->
        <text x="100" y="138" text-anchor="middle"
              fill="#2ecc71" font-size="10" font-family="monospace">Arranque en milisegundos</text>
      </svg>
    </div>
  </div>
</section>
```

**Comportamiento de animación**:
- Fragment 1 (`.fragment`): aparece columna VM con etiqueta roja
- Fragment 2 (`.fragment`): aparece columna Contenedor con etiqueta verde
- La transición `data-auto-animate` permite morphing si se usa en un slide siguiente


---

### Ilustración 2: Arquitectura Kubernetes

**Ubicación**: Slide `Arquitectura` (actualmente `data-transition="zoom" data-background-color="#1a1a2e"`, tiene `.grid-2` con 7 cards `.fragment`).

**Integración**: Reemplaza el grid de cards. El nuevo slide mantiene el heading `<h3>Arquitectura</h3>` pero debajo coloca un SVG de ancho completo con dos grupos: Control Plane (izquierda, fondo azul suave) y Worker Node (derecha, fondo naranja suave), conectados por flechas bidireccionales centrales.

**Estructura HTML/SVG**:

```html
<section data-transition="zoom" data-background-color="#1a1a2e">
  <h3>Arquitectura</h3>

  <svg viewBox="0 0 900 460" style="width:100%; max-height:520px; margin-top:8px;"
       xmlns="http://www.w3.org/2000/svg" id="k8s-arch-svg">

    <!-- Definición de marcadores de flecha -->
    <defs>
      <marker id="arr-blue" markerWidth="8" markerHeight="6"
              refX="8" refY="3" orient="auto">
        <polygon points="0 0,8 3,0 6" fill="#326CE5"/>
      </marker>
      <marker id="arr-orange" markerWidth="8" markerHeight="6"
              refX="8" refY="3" orient="auto">
        <polygon points="0 0,8 3,0 6" fill="#f39c12"/>
      </marker>
      <marker id="arr-white" markerWidth="8" markerHeight="6"
              refX="8" refY="3" orient="auto">
        <polygon points="0 0,8 3,0 6" fill="rgba(255,255,255,0.4)"/>
      </marker>
    </defs>

    <!-- ======= CONTROL PLANE ======= -->
    <rect x="20" y="30" width="380" height="400" rx="14"
          fill="rgba(50,108,229,0.10)" stroke="#326CE5" stroke-width="2"/>
    <text x="210" y="58" text-anchor="middle"
          fill="#326CE5" font-size="16" font-weight="bold" font-family="sans-serif">
      Control Plane
    </text>

    <!-- API Server - fragment 1 -->
    <g class="fragment" data-fragment-index="1">
      <rect x="60" y="75" width="260" height="52" rx="8"
            fill="rgba(50,108,229,0.25)" stroke="#326CE5" stroke-width="1.5"/>
      <image href="https://cdn.jsdelivr.net/gh/kubernetes/community/icons/svg/control_plane_components/labeled/api.svg"
             x="68" y="83" width="36" height="36"/>
      <text x="175" y="97" text-anchor="middle"
            fill="#93c5fd" font-size="13" font-weight="bold" font-family="sans-serif">API Server</text>
      <text x="175" y="116" text-anchor="middle"
            fill="#93c5fd" font-size="10" font-family="sans-serif">Puerta de entrada · REST</text>
    </g>

    <!-- etcd - fragment 2 -->
    <g class="fragment" data-fragment-index="2">
      <rect x="60" y="140" width="120" height="52" rx="8"
            fill="rgba(50,108,229,0.20)" stroke="#326CE5" stroke-width="1.5"/>
      <text x="120" y="163" text-anchor="middle"
            fill="#93c5fd" font-size="13" font-weight="bold" font-family="sans-serif">etcd</text>
      <text x="120" y="180" text-anchor="middle"
            fill="#93c5fd" font-size="10" font-family="sans-serif">Estado del cluster</text>
    </g>

    <!-- Scheduler - fragment 3 -->
    <g class="fragment" data-fragment-index="3">
      <rect x="200" y="140" width="120" height="52" rx="8"
            fill="rgba(50,108,229,0.20)" stroke="#326CE5" stroke-width="1.5"/>
      <text x="260" y="163" text-anchor="middle"
            fill="#93c5fd" font-size="13" font-weight="bold" font-family="sans-serif">Scheduler</text>
      <text x="260" y="180" text-anchor="middle"
            fill="#93c5fd" font-size="10" font-family="sans-serif">Asigna pods</text>
    </g>

    <!-- Controllers - fragment 4 -->
    <g class="fragment" data-fragment-index="4">
      <rect x="60" y="210" width="260" height="52" rx="8"
            fill="rgba(50,108,229,0.20)" stroke="#326CE5" stroke-width="1.5"/>
      <text x="190" y="233" text-anchor="middle"
            fill="#93c5fd" font-size="13" font-weight="bold" font-family="sans-serif">Controller Manager</text>
      <text x="190" y="250" text-anchor="middle"
            fill="#93c5fd" font-size="10" font-family="sans-serif">Reconciliation loops · estado deseado</text>
    </g>

    <!-- ======= FLECHAS CENTRAL ======= -->
    <g class="fragment" data-fragment-index="5">
      <!-- API → kubelet -->
      <line x1="400" y1="200" x2="500" y2="200"
            stroke="#326CE5" stroke-width="2"
            marker-end="url(#arr-blue)"/>
      <!-- kubelet → API -->
      <line x1="500" y1="215" x2="400" y2="215"
            stroke="#f39c12" stroke-width="2"
            marker-end="url(#arr-orange)"/>
      <text x="450" y="192" text-anchor="middle"
            fill="rgba(255,255,255,0.45)" font-size="9" font-family="sans-serif">kubectl / API</text>
    </g>

    <!-- ======= WORKER NODE ======= -->
    <rect x="500" y="30" width="380" height="400" rx="14"
          fill="rgba(243,156,18,0.10)" stroke="#f39c12" stroke-width="2"/>
    <text x="690" y="58" text-anchor="middle"
          fill="#f39c12" font-size="16" font-weight="bold" font-family="sans-serif">
      Worker Node
    </text>

    <!-- kubelet - fragment 5 -->
    <g class="fragment" data-fragment-index="5">
      <rect x="540" y="75" width="300" height="52" rx="8"
            fill="rgba(243,156,18,0.20)" stroke="#f39c12" stroke-width="1.5"/>
      <text x="690" y="97" text-anchor="middle"
            fill="#fcd34d" font-size="13" font-weight="bold" font-family="sans-serif">kubelet</text>
      <text x="690" y="116" text-anchor="middle"
            fill="#fcd34d" font-size="10" font-family="sans-serif">Agente del nodo · gestiona pods</text>
    </g>

    <!-- kube-proxy - fragment 6 -->
    <g class="fragment" data-fragment-index="6">
      <rect x="540" y="140" width="140" height="52" rx="8"
            fill="rgba(243,156,18,0.15)" stroke="#f39c12" stroke-width="1.5"/>
      <text x="610" y="163" text-anchor="middle"
            fill="#fcd34d" font-size="13" font-weight="bold" font-family="sans-serif">kube-proxy</text>
      <text x="610" y="180" text-anchor="middle"
            fill="#fcd34d" font-size="10" font-family="sans-serif">Reglas iptables</text>
    </g>

    <!-- containerd - fragment 7 -->
    <g class="fragment" data-fragment-index="7">
      <rect x="700" y="140" width="140" height="52" rx="8"
            fill="rgba(243,156,18,0.15)" stroke="#f39c12" stroke-width="1.5"/>
      <text x="770" y="163" text-anchor="middle"
            fill="#fcd34d" font-size="13" font-weight="bold" font-family="sans-serif">containerd</text>
      <text x="770" y="180" text-anchor="middle"
            fill="#fcd34d" font-size="10" font-family="sans-serif">Container runtime</text>
    </g>

    <!-- Pods - fragment 8 -->
    <g class="fragment" data-fragment-index="8">
      <rect x="540" y="210" width="300" height="80" rx="8"
            fill="rgba(50,108,229,0.12)" stroke="#326CE5" stroke-width="1" stroke-dasharray="5"/>
      <text x="690" y="235" text-anchor="middle"
            fill="#93c5fd" font-size="11" font-family="sans-serif">Pods</text>
      <!-- Pod boxes -->
      <rect x="555" y="244" width="60" height="32" rx="4"
            fill="rgba(50,108,229,0.3)" stroke="#326CE5" stroke-width="1"/>
      <text x="585" y="264" text-anchor="middle"
            fill="white" font-size="9" font-family="monospace">Pod A</text>
      <rect x="630" y="244" width="60" height="32" rx="4"
            fill="rgba(50,108,229,0.3)" stroke="#326CE5" stroke-width="1"/>
      <text x="660" y="264" text-anchor="middle"
            fill="white" font-size="9" font-family="monospace">Pod B</text>
      <rect x="705" y="244" width="60" height="32" rx="4"
            fill="rgba(46,204,113,0.3)" stroke="#2ecc71" stroke-width="1"/>
      <text x="735" y="264" text-anchor="middle"
            fill="white" font-size="9" font-family="monospace">Pod C</text>
    </g>

  </svg>
</section>
```

**Comportamiento de animación**:
- Fragment 1-4: componentes del Control Plane aparecen uno a uno
- Fragment 5: flechas bidireccionales + kubelet aparecen simultáneamente
- Fragment 6-7: kube-proxy y containerd
- Fragment 8: pods en el nodo


---

### Ilustración 3: Flujo del Acortador de URLs

**Ubicación**: Nuevo slide insertado **después** de la sección intro de Paso 2 (Docker Compose) y **antes** del slide "Stack local completo". Actúa como puente entre el código de Compose y la arquitectura de la app demo.

**Integración**: `<section>` nuevo dentro del grupo de secciones de Paso 2 (o al inicio de la sección de la app). Usa `data-auto-animate` para animar el flujo de la petición paso a paso.

**Estructura HTML/SVG**:

```html
<section data-transition="slide" data-background-color="#1a1a2e">
  <h3 style="text-align:center;">App Demo: Acortador de URLs</h3>
  <p class="center small-font" style="opacity:0.6; margin-bottom:16px;">
    Flujo de una petición de extremo a extremo
  </p>

  <svg viewBox="0 0 960 300" style="width:100%; max-height:340px;"
       xmlns="http://www.w3.org/2000/svg">

    <defs>
      <marker id="flow-arr" markerWidth="8" markerHeight="6"
              refX="8" refY="3" orient="auto">
        <polygon points="0 0,8 3,0 6" fill="#326CE5"/>
      </marker>
      <marker id="flow-arr-green" markerWidth="8" markerHeight="6"
              refX="8" refY="3" orient="auto">
        <polygon points="0 0,8 3,0 6" fill="#2ecc71"/>
      </marker>
    </defs>

    <!-- ====== BROWSER ====== -->
    <g class="fragment" data-fragment-index="1">
      <rect x="20" y="100" width="130" height="100" rx="10"
            fill="rgba(255,255,255,0.06)" stroke="rgba(255,255,255,0.3)" stroke-width="1.5"/>
      <!-- Browser SVG icon inline -->
      <rect x="40" y="118" width="90" height="64" rx="4"
            fill="none" stroke="rgba(255,255,255,0.5)" stroke-width="1.5"/>
      <rect x="40" y="118" width="90" height="14" rx="4"
            fill="rgba(255,255,255,0.15)"/>
      <circle cx="48" cy="125" r="3" fill="#e74c3c"/>
      <circle cx="58" cy="125" r="3" fill="#f39c12"/>
      <circle cx="68" cy="125" r="3" fill="#2ecc71"/>
      <text x="85" y="163" text-anchor="middle"
            fill="rgba(255,255,255,0.7)" font-size="10" font-family="monospace">Browser</text>
      <text x="85" y="178" text-anchor="middle"
            fill="rgba(255,255,255,0.45)" font-size="8" font-family="monospace">GET /abc123</text>
    </g>

    <!-- Flecha Browser → Frontend -->
    <g class="fragment" data-fragment-index="2">
      <line x1="150" y1="150" x2="220" y2="150"
            stroke="#326CE5" stroke-width="2"
            marker-end="url(#flow-arr)"/>
      <text x="185" y="142" text-anchor="middle"
            fill="#93c5fd" font-size="9" font-family="monospace">HTTP</text>
    </g>

    <!-- ====== FRONTEND (React) ====== -->
    <g class="fragment" data-fragment-index="2">
      <rect x="220" y="90" width="140" height="120" rx="10"
            fill="rgba(97,218,251,0.10)" stroke="#61dafb" stroke-width="1.5"/>
      <!-- React icon: simplified atom -->
      <ellipse cx="290" cy="130" rx="28" ry="11"
               fill="none" stroke="#61dafb" stroke-width="1.5"/>
      <ellipse cx="290" cy="130" rx="28" ry="11"
               fill="none" stroke="#61dafb" stroke-width="1.5"
               transform="rotate(60 290 130)"/>
      <ellipse cx="290" cy="130" rx="28" ry="11"
               fill="none" stroke="#61dafb" stroke-width="1.5"
               transform="rotate(120 290 130)"/>
      <circle cx="290" cy="130" r="5" fill="#61dafb"/>
      <text x="290" y="172" text-anchor="middle"
            fill="#61dafb" font-size="11" font-weight="bold" font-family="sans-serif">Frontend</text>
      <text x="290" y="187" text-anchor="middle"
            fill="#61dafb" font-size="9" font-family="sans-serif">React · Vite · Nginx</text>
    </g>

    <!-- Flecha Frontend → Backend -->
    <g class="fragment" data-fragment-index="3">
      <line x1="360" y1="150" x2="430" y2="150"
            stroke="#326CE5" stroke-width="2"
            marker-end="url(#flow-arr)"/>
      <text x="395" y="142" text-anchor="middle"
            fill="#93c5fd" font-size="9" font-family="monospace">fetch /api</text>
    </g>

    <!-- ====== BACKEND (Flask) ====== -->
    <g class="fragment" data-fragment-index="3">
      <rect x="430" y="90" width="140" height="120" rx="10"
            fill="rgba(255,255,255,0.07)" stroke="rgba(255,255,255,0.4)" stroke-width="1.5"/>
      <!-- Flask icon simplified (flask shape) -->
      <path d="M 490 115 L 490 135 L 470 165 L 530 165 L 510 135 L 510 115 Z"
            fill="none" stroke="white" stroke-width="1.5"/>
      <line x1="484" y1="115" x2="516" y2="115"
            stroke="white" stroke-width="1.5"/>
      <text x="500" y="178" text-anchor="middle"
            fill="rgba(255,255,255,0.9)" font-size="11" font-weight="bold" font-family="sans-serif">Backend</text>
      <text x="500" y="193" text-anchor="middle"
            fill="rgba(255,255,255,0.6)" font-size="9" font-family="sans-serif">Flask · Python</text>
    </g>

    <!-- Flecha Backend → Redis -->
    <g class="fragment" data-fragment-index="4">
      <line x1="570" y1="150" x2="640" y2="150"
            stroke="#dc382c" stroke-width="2"
            marker-end="url(#flow-arr)"/>
      <text x="605" y="142" text-anchor="middle"
            fill="#fc8181" font-size="9" font-family="monospace">GET key</text>
    </g>

    <!-- ====== REDIS ====== -->
    <g class="fragment" data-fragment-index="4">
      <rect x="640" y="90" width="140" height="120" rx="10"
            fill="rgba(220,56,44,0.12)" stroke="#dc382c" stroke-width="1.5"/>
      <!-- Redis simplified logo: diamond -->
      <polygon points="710,115 735,130 710,145 685,130"
               fill="none" stroke="#dc382c" stroke-width="1.5"/>
      <text x="710" y="134" text-anchor="middle"
            fill="#dc382c" font-size="9" font-family="sans-serif">●●●</text>
      <text x="710" y="172" text-anchor="middle"
            fill="#fc8181" font-size="11" font-weight="bold" font-family="sans-serif">Redis</text>
      <text x="710" y="187" text-anchor="middle"
            fill="#fc8181" font-size="9" font-family="sans-serif">url:{code} → URL</text>
    </g>

    <!-- Flecha respuesta Redis → Browser (arco inferior) -->
    <g class="fragment" data-fragment-index="5">
      <path d="M 640 210 Q 420 270 150 210"
            fill="none" stroke="#2ecc71" stroke-width="2" stroke-dasharray="6,3"
            marker-end="url(#flow-arr-green)"/>
      <text x="400" y="268" text-anchor="middle"
            fill="#2ecc71" font-size="9" font-family="monospace">301 Redirect → URL original</text>
    </g>

    <!-- Docker Compose label -->
    <g class="fragment" data-fragment-index="6">
      <rect x="200" y="25" width="600" height="24" rx="5"
            fill="none" stroke="rgba(255,255,255,0.15)" stroke-width="1" stroke-dasharray="4"/>
      <text x="500" y="41" text-anchor="middle"
            fill="rgba(255,255,255,0.35)" font-size="10" font-family="sans-serif">
        Docker network: shortener_default
      </text>
    </g>

  </svg>
</section>
```

**Comportamiento de animación**:
- Fragment 1: aparece el browser
- Fragments 2–4: cada servicio y su flecha de solicitud aparecen secuencialmente
- Fragment 5: arco de retorno verde (respuesta) conecta Redis de vuelta al browser
- Fragment 6: borde de red Docker aparece como contexto


---

### Ilustración 4: Stack de Observabilidad

**Ubicación**: Slide `Grafana: Unificando todo` (sección con `data-transition="zoom" data-background-color="#1a1a2e"`, actualmente tiene `.grid-3` de cards y tags de texto).

**Integración**: Reemplaza el `.grid-3` de cards y las tags de texto. El heading `<h3>Grafana: Unificando todo</h3>` se mantiene. El nuevo contenido es un SVG que muestra los 3 pilares fluyendo con flechas convergentes hacia Grafana.

**Estructura HTML/SVG**:

```html
<section data-transition="zoom" data-background-color="#1a1a2e">
  <h3>Grafana: Unificando todo</h3>
  <p class="center small-font" style="opacity:0.6;">Los 3 pilares → un solo panel de control</p>

  <svg viewBox="0 0 900 380" style="width:100%; max-height:420px; margin-top:10px;"
       xmlns="http://www.w3.org/2000/svg">

    <defs>
      <marker id="obs-arr" markerWidth="9" markerHeight="7"
              refX="9" refY="3.5" orient="auto">
        <polygon points="0 0,9 3.5,0 7" fill="#f46800"/>
      </marker>
    </defs>

    <!-- ====== PROMETHEUS (Métricas) ====== -->
    <g class="fragment" data-fragment-index="1">
      <rect x="30" y="50" width="200" height="120" rx="12"
            fill="rgba(230,82,44,0.12)" stroke="#e6522c" stroke-width="2"/>
      <!-- Prometheus logo: filled circle with "P" fire symbol -->
      <circle cx="130" cy="95" r="30" fill="none" stroke="#e6522c" stroke-width="2"/>
      <path d="M 115 80 Q 130 68 145 80 Q 152 95 130 105 Q 108 95 115 80 Z"
            fill="#e6522c" opacity="0.7"/>
      <text x="130" y="147" text-anchor="middle"
            fill="#f87171" font-size="13" font-weight="bold" font-family="sans-serif">Prometheus</text>
      <text x="130" y="163" text-anchor="middle"
            fill="#f87171" font-size="10" font-family="sans-serif">Métricas · PromQL</text>
    </g>

    <!-- ====== LOKI (Logs) ====== -->
    <g class="fragment" data-fragment-index="2">
      <rect x="30" y="230" width="200" height="120" rx="12"
            fill="rgba(240,165,0,0.12)" stroke="#f0a500" stroke-width="2"/>
      <!-- Loki simplified: stacked log lines -->
      <rect x="88" y="258" width="84" height="8" rx="2" fill="#f0a500" opacity="0.8"/>
      <rect x="88" y="272" width="60" height="8" rx="2" fill="#f0a500" opacity="0.6"/>
      <rect x="88" y="286" width="72" height="8" rx="2" fill="#f0a500" opacity="0.7"/>
      <rect x="88" y="300" width="48" height="8" rx="2" fill="#f0a500" opacity="0.5"/>
      <text x="130" y="333" text-anchor="middle"
            fill="#fbbf24" font-size="13" font-weight="bold" font-family="sans-serif">Loki</text>
      <text x="130" y="349" text-anchor="middle"
            fill="#fbbf24" font-size="10" font-family="sans-serif">Logs · LogQL</text>
    </g>

    <!-- ====== TEMPO (Traces) ====== -->
    <g class="fragment" data-fragment-index="3">
      <rect x="670" y="140" width="200" height="120" rx="12"
            fill="rgba(59,130,246,0.12)" stroke="#3b82f6" stroke-width="2"/>
      <!-- Tempo simplified: trace spans -->
      <rect x="700" y="170" width="140" height="8" rx="2" fill="#3b82f6" opacity="0.8"/>
      <rect x="714" y="184" width="100" height="8" rx="2" fill="#3b82f6" opacity="0.6"/>
      <rect x="728" y="198" width="70" height="8" rx="2" fill="#3b82f6" opacity="0.7"/>
      <rect x="742" y="212" width="40" height="8" rx="2" fill="#3b82f6" opacity="0.5"/>
      <text x="770" y="237" text-anchor="middle"
            fill="#93c5fd" font-size="13" font-weight="bold" font-family="sans-serif">Tempo</text>
      <text x="770" y="253" text-anchor="middle"
            fill="#93c5fd" font-size="10" font-family="sans-serif">Traces · TraceQL</text>
    </g>

    <!-- ====== FLECHAS HACIA GRAFANA ====== -->
    <g class="fragment" data-fragment-index="4">
      <!-- Prometheus → Grafana -->
      <path d="M 230 110 Q 370 110 390 190"
            fill="none" stroke="#e6522c" stroke-width="2" stroke-dasharray="6,3"
            marker-end="url(#obs-arr)"/>
      <!-- Loki → Grafana -->
      <path d="M 230 290 Q 370 290 390 270"
            fill="none" stroke="#f0a500" stroke-width="2" stroke-dasharray="6,3"
            marker-end="url(#obs-arr)"/>
      <!-- Tempo → Grafana -->
      <path d="M 670 200 Q 570 200 560 230"
            fill="none" stroke="#3b82f6" stroke-width="2" stroke-dasharray="6,3"
            marker-end="url(#obs-arr)"/>
    </g>

    <!-- ====== GRAFANA (centro) ====== -->
    <g class="fragment" data-fragment-index="4">
      <rect x="360" y="140" width="220" height="160" rx="16"
            fill="rgba(244,104,0,0.18)" stroke="#f46800" stroke-width="2.5"/>
      <!-- Grafana G logo simplified -->
      <circle cx="470" cy="195" r="35" fill="none" stroke="#f46800" stroke-width="3"/>
      <path d="M 470 195 L 470 175 A 20 20 0 0 1 490 195" 
            fill="none" stroke="#f46800" stroke-width="3" stroke-linecap="round"/>
      <line x1="470" y1="195" x2="490" y2="195"
            stroke="#f46800" stroke-width="3" stroke-linecap="round"/>
      <text x="470" y="250" text-anchor="middle"
            fill="#f46800" font-size="16" font-weight="bold" font-family="sans-serif">Grafana</text>
      <text x="470" y="268" text-anchor="middle"
            fill="#f46800" font-size="10" font-family="sans-serif">Dashboard unificado</text>
      <text x="470" y="284" text-anchor="middle"
            fill="#f46800" font-size="10" font-family="sans-serif">Alerting · Explore</text>
    </g>

    <!-- ====== CORRELACIÓN LABEL ====== -->
    <g class="fragment" data-fragment-index="5">
      <text x="450" y="48" text-anchor="middle"
            fill="rgba(255,255,255,0.6)" font-size="11" font-family="sans-serif">
        Alerta Prometheus → Log Loki → Trace Tempo
      </text>
      <path d="M 250 42 L 640 42" fill="none"
            stroke="rgba(255,255,255,0.2)" stroke-width="1"
            marker-end="url(#obs-arr)"/>
    </g>

  </svg>
</section>
```

**Comportamiento de animación**:
- Fragments 1–3: cada pilar aparece de forma independiente (Prometheus, Loki, Tempo)
- Fragment 4: flechas convergentes hacia Grafana + la caja Grafana aparece simultáneamente
- Fragment 5: etiqueta de correlación en la parte superior


---

### Ilustración 5: Roadmap Visual (Pipeline)

**Ubicación**: Slide `Hoja de Ruta` (actualmente tiene 6 `.stack-step` divs con íconos de número y texto).

**Integración**: Reemplaza los 6 `.stack-step` divs por un SVG de pipeline horizontal. Los colores de estado (done/current/next) se conservan de la paleta existente. Se mantiene la misma lógica visual: pasos 1-3 done (verde), paso 4 current (naranja), pasos 5-6 next (gris).

**Estructura HTML/SVG**:

```html
<section data-transition="zoom">
  <h2>Hoja de Ruta</h2>
  <p class="center small-font" style="opacity:0.6;">
    10:00 AM - 12:00 PM &bull; De un contenedor suelto a un stack observable
  </p>

  <svg viewBox="0 0 1100 260" style="width:100%; max-height:300px; margin-top:20px;"
       xmlns="http://www.w3.org/2000/svg">

    <!-- Línea de pipeline base -->
    <line x1="80" y1="110" x2="1020" y2="110"
          stroke="rgba(255,255,255,0.15)" stroke-width="3"/>

    <!-- Segmento done: pasos 1-3 -->
    <line x1="80" y1="110" x2="550" y2="110"
          stroke="#2ecc71" stroke-width="3"/>

    <!-- Segmento current: paso 4 -->
    <line x1="550" y1="110" x2="720" y2="110"
          stroke="#f39c12" stroke-width="3" stroke-dasharray="8,4"/>

    <!-- ====== PASO 1: Contenedores ====== -->
    <g class="fragment" data-fragment-index="1">
      <!-- Nodo done -->
      <circle cx="80" cy="110" r="24" fill="#2ecc71"/>
      <text x="80" y="116" text-anchor="middle"
            fill="white" font-size="14" font-weight="bold" font-family="sans-serif">1</text>
      <!-- Docker icon: whale (simplified) -->
      <image href="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg"
             x="56" y="48" width="48" height="48"/>
      <text x="80" y="155" text-anchor="middle"
            fill="#2ecc71" font-size="11" font-weight="bold" font-family="sans-serif">Contenedores</text>
      <text x="80" y="170" text-anchor="middle"
            fill="rgba(46,204,113,0.7)" font-size="9" font-family="sans-serif">Docker · Imágenes</text>
    </g>

    <!-- ====== PASO 2: Compose ====== -->
    <g class="fragment" data-fragment-index="2">
      <circle cx="250" cy="110" r="24" fill="#2ecc71"/>
      <text x="250" y="116" text-anchor="middle"
            fill="white" font-size="14" font-weight="bold" font-family="sans-serif">2</text>
      <!-- Compose: simplified stacked boxes -->
      <rect x="227" y="54" width="46" height="12" rx="3" fill="#2ecc71" opacity="0.9"/>
      <rect x="227" y="68" width="46" height="12" rx="3" fill="#2ecc71" opacity="0.7"/>
      <rect x="227" y="82" width="46" height="12" rx="3" fill="#2ecc71" opacity="0.5"/>
      <text x="250" y="155" text-anchor="middle"
            fill="#2ecc71" font-size="11" font-weight="bold" font-family="sans-serif">Compose</text>
      <text x="250" y="170" text-anchor="middle"
            fill="rgba(46,204,113,0.7)" font-size="9" font-family="sans-serif">Multi-container local</text>
    </g>

    <!-- ====== PASO 3: Kubernetes ====== -->
    <g class="fragment" data-fragment-index="3">
      <circle cx="420" cy="110" r="24" fill="#2ecc71"/>
      <text x="420" y="116" text-anchor="middle"
            fill="white" font-size="14" font-weight="bold" font-family="sans-serif">3</text>
      <image href="https://cdn.jsdelivr.net/gh/kubernetes/kubernetes@master/logo/logo.png"
             x="396" y="50" width="48" height="48"/>
      <text x="420" y="155" text-anchor="middle"
            fill="#2ecc71" font-size="11" font-weight="bold" font-family="sans-serif">Kubernetes</text>
      <text x="420" y="170" text-anchor="middle"
            fill="rgba(46,204,113,0.7)" font-size="9" font-family="sans-serif">Pods · Services</text>
    </g>

    <!-- ====== PASO 4: Configuración (CURRENT) ====== -->
    <g class="fragment" data-fragment-index="4">
      <circle cx="590" cy="110" r="26" fill="#f39c12"/>
      <text x="590" y="116" text-anchor="middle"
            fill="white" font-size="14" font-weight="bold" font-family="sans-serif">4</text>
      <!-- Config icon: gear simplified -->
      <path d="M 580 55 L 590 50 L 600 55 L 604 65 L 598 72 L 582 72 L 576 65 Z"
            fill="none" stroke="#f39c12" stroke-width="1.5"/>
      <circle cx="590" cy="63" r="6" fill="none" stroke="#f39c12" stroke-width="1.5"/>
      <!-- YOU ARE HERE -->
      <text x="590" y="44" text-anchor="middle"
            fill="#f39c12" font-size="8" font-family="sans-serif">▼ AQUÍ</text>
      <text x="590" y="156" text-anchor="middle"
            fill="#f39c12" font-size="11" font-weight="bold" font-family="sans-serif">Configuración</text>
      <text x="590" y="171" text-anchor="middle"
            fill="rgba(243,156,18,0.7)" font-size="9" font-family="sans-serif">ConfigMaps · Secrets</text>
    </g>

    <!-- ====== PASO 5: Escalado (NEXT) ====== -->
    <g class="fragment" data-fragment-index="5">
      <circle cx="760" cy="110" r="24" fill="rgba(255,255,255,0.15)"/>
      <text x="760" y="116" text-anchor="middle"
            fill="rgba(255,255,255,0.5)" font-size="14" font-weight="bold" font-family="sans-serif">5</text>
      <!-- Scale up arrows -->
      <text x="760" y="68" text-anchor="middle"
            fill="rgba(255,255,255,0.25)" font-size="24" font-family="sans-serif">⬆</text>
      <text x="760" y="155" text-anchor="middle"
            fill="rgba(255,255,255,0.4)" font-size="11" font-weight="bold" font-family="sans-serif">Escalado</text>
      <text x="760" y="170" text-anchor="middle"
            fill="rgba(255,255,255,0.25)" font-size="9" font-family="sans-serif">HPA · Autoscaling</text>
    </g>

    <!-- ====== PASO 6: Observabilidad (NEXT) ====== -->
    <g class="fragment" data-fragment-index="6">
      <circle cx="940" cy="110" r="24" fill="rgba(255,255,255,0.15)"/>
      <text x="940" y="116" text-anchor="middle"
            fill="rgba(255,255,255,0.5)" font-size="14" font-weight="bold" font-family="sans-serif">6</text>
      <!-- Grafana icon simplified -->
      <circle cx="940" cy="63" r="18" fill="none" stroke="rgba(244,104,0,0.4)" stroke-width="1.5"/>
      <text x="940" y="68" text-anchor="middle"
            fill="rgba(244,104,0,0.5)" font-size="16" font-weight="bold" font-family="sans-serif">G</text>
      <text x="940" y="155" text-anchor="middle"
            fill="rgba(255,255,255,0.4)" font-size="11" font-weight="bold" font-family="sans-serif">Observabilidad</text>
      <text x="940" y="170" text-anchor="middle"
            fill="rgba(255,255,255,0.25)" font-size="9" font-family="sans-serif">Prometheus · Grafana</text>
    </g>

    <!-- Leyenda de estado -->
    <g class="fragment" data-fragment-index="7">
      <circle cx="320" cy="218" r="7" fill="#2ecc71"/>
      <text x="334" y="223" fill="rgba(255,255,255,0.5)"
            font-size="10" font-family="sans-serif">Completado</text>
      <circle cx="440" cy="218" r="7" fill="#f39c12"/>
      <text x="454" y="223" fill="rgba(255,255,255,0.5)"
            font-size="10" font-family="sans-serif">En curso</text>
      <circle cx="540" cy="218" r="7" fill="rgba(255,255,255,0.15)"/>
      <text x="554" y="223" fill="rgba(255,255,255,0.5)"
            font-size="10" font-family="sans-serif">Próximo</text>
    </g>

  </svg>
</section>
```

**Comportamiento de animación**:
- Fragments 1–6: cada paso del pipeline aparece secuencialmente de izquierda a derecha
- Fragment 7: leyenda de colores aparece al final
- Los segmentos de línea (done en verde, current en naranja punteado) son estáticos y establecen el contexto desde el inicio


---

## Modelos de Datos

### Modelo: Mapa de Integración de Slides

Describe la relación entre cada ilustración y el slide de destino en `html/index.html`:

```
IllustrationSlideMap = [
  {
    id:            "vm-vs-container",
    targetSlide:   "¿Por qué contenedores?" (section data-auto-animate),
    action:        "replace",          // reemplaza .grid-2 con 2 cards
    insertBefore:  null,               // modifica slide existente
    fragmentCount: 2
  },
  {
    id:            "k8s-architecture",
    targetSlide:   "Arquitectura" (section data-transition="zoom"),
    action:        "replace",          // reemplaza .grid-2 con 7 cards
    insertBefore:  null,
    fragmentCount: 8
  },
  {
    id:            "url-shortener-flow",
    targetSlide:   nueva sección dentro de STEP 2 (Compose),
    action:        "insert",           // nuevo slide
    insertBefore:  "Stack local completo",
    fragmentCount: 6
  },
  {
    id:            "observability-stack",
    targetSlide:   "Grafana: Unificando todo",
    action:        "replace",          // reemplaza .grid-3 + tags
    insertBefore:  null,
    fragmentCount: 5
  },
  {
    id:            "roadmap-pipeline",
    targetSlide:   "Hoja de Ruta" (section data-transition="zoom"),
    action:        "replace",          // reemplaza .stack-step divs
    insertBefore:  null,
    fragmentCount: 7
  }
]
```

### Modelo: Restricciones de Renderizado

```
RenderConstraints = {
  resolution:       "1920x1080",
  revealVersion:    "5.1.0",
  margin:           0.04,              // 4% padding Reveal.js
  svgMaxWidth:      "100%",            // siempre relativo al viewport
  svgMaxHeight:     "420-520px",       // ajustado por slide para no desbordar
  externalAllowed:  ["cdn.jsdelivr.net"],  // CDNs ya usados en el proyecto
  noNewFiles:       true,              // todo inline en index.html
  cssScope:         "<style> en <head>",   // CSS compartido ya definido
  animationType:    "fragment",        // Reveal.js fragments (no CSS animation)
}
```

## Manejo de Errores

### Escenario 1: Íconos SVG externos no cargan (CDN caído)

**Condición**: `<image href="...cdn.../docker-original.svg">` falla.  
**Respuesta**: Cada SVG de ícono tiene texto alternativo adyacente (el nombre del componente) que es visible independientemente de si carga la imagen. Los íconos son decorativos, no informativos.  
**Recuperación**: La ilustración sigue siendo legible porque los labels de texto y las formas geométricas SVG son completamente inline.

### Escenario 2: Slide desborda en resolución menor (ej. proyector 1280×800)

**Condición**: El SVG a `max-height:420px` puede desbordar en pantallas pequeñas.  
**Respuesta**: Todos los SVGs usan `viewBox` con aspect ratio fijo y `width:100%`, así el browser escala automáticamente. `Reveal.js` aplica `transform: scale()` a toda la presentación.  
**Recuperación**: El layout se comprime proporcionalmente sin cortar contenido.

### Escenario 3: Fragmentos fuera de orden (click accidental)

**Condición**: El presentador retrocede al medio de una animación de fragmentos.  
**Respuesta**: Reveal.js maneja el estado de fragments automáticamente — retroceder oculta fragmentos en orden inverso.  
**Recuperación**: No requiere acción especial; el comportamiento es nativo de Reveal.js.

## Estrategia de Testing

### Unit Testing: Validación Visual

No aplica testing automatizado para SVGs inline. La validación es manual:

**Checklist de verificación visual por ilustración**:
1. Abrir `html/index.html` en navegador local
2. Navegar al slide objetivo
3. Verificar que el SVG es legible a 1920×1080 sin scroll
4. Avanzar fragments uno a uno y verificar orden de aparición
5. Verificar en modo proyector (zoom 75%) que no hay texto cortado
6. Verificar que colores coinciden con la paleta del proyecto

### Pruebas de Integración

**Prueba de no-regresión**: Los slides anteriores y posteriores al modificado no deben verse afectados. Verificar navegación completa antes y después de cada cambio.

**Prueba de transiciones**: Verificar que `data-auto-animate` en la ilustración VM vs Contenedor no genera efectos inesperados al navegar entre slides adyacentes.

### Prueba de Accesibilidad Básica

Todos los elementos informativos deben tener `aria-label` o texto alternativo via `<title>` dentro del SVG. Colores críticos (verde/rojo) nunca deben ser el único indicador de estado.

## Consideraciones de Rendimiento

- **Tamaño inline**: Cada SVG agrega ~3-8 KB de HTML. Total estimado: ~30 KB adicionales. La presentación completa seguirá cargando desde CDN sin archivos locales nuevos.
- **Rendering**: Los SVGs inline se renderizan en el mismo thread del DOM. No hay impacto en el rendimiento de navegación de Reveal.js.
- **Íconos externos**: `<image>` en SVG carga lazily. Los íconos decorativos (Docker, K8s logos) no bloquean el renderizado del slide.
- **Fragment performance**: Con hasta 8 fragments por slide, no hay impacto measurable en la fluidez de las animaciones.

## Consideraciones de Seguridad

- Todo el contenido es SVG/HTML estático sin scripts. No hay vectores de XSS.
- Los íconos cargados desde `cdn.jsdelivr.net` están limitados a imágenes (atributo `href` de `<image>` SVG), sin posibilidad de ejecutar código.
- No se almacenan ni transmiten datos del usuario.

## Dependencias

| Recurso | URL | Uso | Tipo |
|---|---|---|---|
| Docker icon | `https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg` | Roadmap, paso 1 | `<image>` SVG |
| K8s logo | `https://cdn.jsdelivr.net/gh/kubernetes/kubernetes@master/logo/logo.png` | Roadmap paso 3, slides existentes | `<image>` SVG |
| K8s API Server icon | `https://cdn.jsdelivr.net/gh/kubernetes/community/icons/svg/control_plane_components/labeled/api.svg` | Arquitectura K8s | `<image>` SVG |
| Reveal.js 5.1.0 | `https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/` | Framework de presentación | Scripts/CSS ya cargados |

Todas las dependencias de CDN ya están referenciadas en el proyecto o son del mismo origen (`cdn.jsdelivr.net`). No se introducen nuevos dominios externos.
