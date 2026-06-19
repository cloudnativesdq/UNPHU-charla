# Requirements Document

## Introduction

Este documento especifica los requisitos funcionales y no funcionales para agregar 5 ilustraciones visuales SVG/HTML inline a la presentación Reveal.js `html/index.html` de la charla "De 0 a Observabilidad" (UNPHU 2026). Las ilustraciones reemplazan o complementan secciones de texto existentes con diagramas animados que usan la paleta de colores del proyecto y el mecanismo de fragments de Reveal.js. Todo el código es inline dentro del archivo HTML existente, sin archivos externos adicionales.

## Glossary

- **Presentation**: El archivo `html/index.html` con la presentación Reveal.js 5.1.0.
- **Illustration**: Un bloque SVG/HTML inline que reemplaza o complementa el contenido textual de un slide.
- **Fragment**: Elemento con clase `.fragment` de Reveal.js que aparece progresivamente al avanzar con el teclado/click del presentador.
- **Slide**: Elemento `<section>` dentro del DOM de Reveal.js.
- **Control_Plane_Diagram**: La ilustración SVG del diagrama de Arquitectura Kubernetes (Ilustración 2).
- **VM_Container_Diagram**: La ilustración SVG de comparación VM vs Contenedor (Ilustración 1).
- **URL_Flow_Diagram**: La ilustración SVG del flujo del Acortador de URLs (Ilustración 3).
- **Observability_Stack_Diagram**: La ilustración SVG del stack de observabilidad con Grafana (Ilustración 4).
- **Roadmap_Pipeline**: La ilustración SVG del roadmap visual en formato pipeline (Ilustración 5).
- **CDN**: Red de distribución de contenido, específicamente `cdn.jsdelivr.net` ya usado en el proyecto.
- **ViewBox**: Atributo SVG que define el sistema de coordenadas internas del diagrama.
- **Projector_Resolution**: Resolución objetivo de 1920×1080 px con la configuración de Reveal.js existente (margin 0.04).

## Requirements

### Requirement 1: Ilustración VM vs Contenedor

**User Story:** Como presentador, quiero reemplazar las 2 cards de texto del slide "¿Por qué contenedores?" con un diagrama SVG comparativo, para que la audiencia visualice el overhead de VMs versus la ligereza de contenedores de forma inmediata.

#### Acceptance Criteria

1. WHEN el presentador navega al slide "Por que contenedores?", THE Presentation SHALL mostrar el `VM_Container_Diagram` en lugar de las dos `.card` existentes dentro del `.grid-2`.
2. WHEN el presentador avanza un fragment en el slide "Por que contenedores?", THE VM_Container_Diagram SHALL revelar la columna izquierda (stack VM) con etiqueta de color `#e74c3c` y texto "⚠ Máquina Virtual".
3. WHEN el presentador avanza un segundo fragment en el slide "Por que contenedores?", THE VM_Container_Diagram SHALL revelar la columna derecha (stack Contenedor) con etiqueta de color `#2ecc71` y texto "✓ Contenedores".
4. THE VM_Container_Diagram SHALL contener en la columna VM las capas: Hardware, Hypervisor, dos bloques "OS Completo ~1 GB" con sus Apps A y B, y la etiqueta "2-3 GB overhead".
5. THE VM_Container_Diagram SHALL contener en la columna Contenedor las capas: Hardware, "Host OS (kernel compartido) ~0 MB extra", "containerd / Docker", y dos bloques de namespace "App A ~30MB" y "App B ~30MB", con la etiqueta "Arranque en milisegundos".
6. THE VM_Container_Diagram SHALL usar el separador visual "VS" entre ambas columnas con opacidad 0.4.
7. THE VM_Container_Diagram SHALL mantener el atributo `data-auto-animate` y `data-transition="convex"` en el `<section>` padre, preservando el comportamiento de transición original, incluso si estos atributos generan efectos visuales no ideales con el nuevo diagrama SVG.
8. IF el recurso SVG externo de un ícono no carga desde la CDN, THEN THE VM_Container_Diagram SHALL seguir siendo legible mediante los labels de texto inline SVG y las formas geométricas. THE VM_Container_Diagram SHALL ser legible en todo momento, independientemente del estado de carga de la CDN.

---

### Requirement 2: Ilustración Arquitectura Kubernetes

**User Story:** Como presentador, quiero reemplazar el grid de 7 cards del slide "Arquitectura" con un diagrama SVG de dos paneles (Control Plane y Worker Node), para que los estudiantes vean la arquitectura completa con sus componentes y conexiones de forma progresiva.

#### Acceptance Criteria

1. WHEN el presentador navega al slide "Arquitectura", THE Presentation SHALL mostrar el `Control_Plane_Diagram` en lugar del `.grid-2` con 7 cards `.fragment` existentes. El `.grid-2` existente no requiere ser ocultado explícitamente; el `<section>` es reemplazado en su totalidad.
2. WHEN el presentador avanza el fragment con `data-fragment-index="1"`, THE Control_Plane_Diagram SHALL revelar el componente API Server con fondo `rgba(50,108,229,0.25)`, borde `#326CE5`, y los textos "API Server" y "Puerta de entrada · REST".
3. WHEN el presentador avanza al fragment `data-fragment-index="2"`, THE Control_Plane_Diagram SHALL revelar el componente etcd con texto "Estado del cluster".
4. WHEN el presentador avanza al fragment `data-fragment-index="3"`, THE Control_Plane_Diagram SHALL revelar el componente Scheduler con texto "Asigna pods".
5. WHEN el presentador avanza al fragment `data-fragment-index="4"`, THE Control_Plane_Diagram SHALL revelar el componente Controller Manager con texto "Reconciliation loops · estado deseado".
6. WHEN el presentador avanza activamente al fragment `data-fragment-index="5"`, THE Control_Plane_Diagram SHALL revelar simultáneamente las flechas bidireccionales entre Control Plane y Worker Node, y el componente kubelet con texto "Agente del nodo · gestiona pods". El componente kubelet podrá ser visible de forma independiente antes de que dicho fragment sea alcanzado si Reveal.js así lo determina.
7. WHEN el presentador avanza al fragment `data-fragment-index="6"`, THE Control_Plane_Diagram SHALL revelar el componente kube-proxy con texto "Reglas iptables".
8. WHEN el presentador avanza al fragment `data-fragment-index="7"`, THE Control_Plane_Diagram SHALL revelar el componente containerd con texto "Container runtime".
9. WHEN el presentador avanza al fragment `data-fragment-index="8"`, THE Control_Plane_Diagram SHALL revelar el bloque de Pods con tres pods (Pod A, Pod B en azul, Pod C en verde).
10. THE Control_Plane_Diagram SHALL usar un rectángulo con fondo `rgba(50,108,229,0.10)` y borde `#326CE5` para el panel Control Plane, y un rectángulo con fondo `rgba(243,156,18,0.10)` y borde `#f39c12` para el panel Worker Node.
11. THE Control_Plane_Diagram SHALL usar marcadores de flecha SVG (`<marker>`) para las conexiones bidireccionales entre paneles: color `#326CE5` para la dirección API→kubelet y color `#f39c12` para la dirección kubelet→API.
12. THE Control_Plane_Diagram SHALL mantener `data-transition="zoom"` y `data-background-color="#1a1a2e"` en el `<section>` padre.
13. IF el ícono CDN del API Server no carga, THEN THE Control_Plane_Diagram SHALL seguir siendo legible mediante los textos "API Server" y "Puerta de entrada · REST" que son inline SVG.

---

### Requirement 3: Ilustración Flujo del Acortador de URLs

**User Story:** Como presentador, quiero insertar un nuevo slide con el flujo de petición del Acortador de URLs dentro de la sección de Docker Compose, para que los estudiantes visualicen cómo se conectan los servicios de la app demo antes de ver el código de Compose.

#### Acceptance Criteria

1. WHEN el presentador navega a la sección de Compose (PASO 2), THE Presentation SHALL mostrar el `URL_Flow_Diagram` como un slide nuevo insertado **antes** del slide "Stack local completo".
2. THE URL_Flow_Diagram SHALL incluir los componentes Browser, Frontend (React · Vite · Nginx), Backend (Flask · Python), y Redis, dispuestos horizontalmente de izquierda a derecha en ese orden.
3. WHEN el presentador avanza activamente al fragment con `data-fragment-index="1"`, THE URL_Flow_Diagram SHALL revelar el componente Browser con una representación simplificada de ventana de navegador y el texto "GET /abc123".
4. WHILE el fragment `data-fragment-index="2"` esté activo, THE URL_Flow_Diagram SHALL mostrar simultáneamente la flecha "HTTP" desde Browser hacia Frontend y el componente Frontend con el logo React (elipses rotadas) y textos "Frontend", "React · Vite · Nginx".
5. WHEN el presentador avanza al fragment `data-fragment-index="3"`, THE URL_Flow_Diagram SHALL revelar simultáneamente la flecha "fetch /api" desde Frontend hacia Backend y el componente Backend con forma de matraz (Flask) y textos "Backend", "Flask · Python".
6. WHEN el presentador avanza activamente al fragment `data-fragment-index="4"`, THE URL_Flow_Diagram SHALL revelar simultáneamente la flecha "GET key" desde Backend hacia Redis y el componente Redis con el texto "url:{code} → URL".
7. WHEN el presentador avanza activamente al fragment `data-fragment-index="5"`, THE URL_Flow_Diagram SHALL revelar un arco de retorno curvo de color `#2ecc71` con línea discontinua desde Redis de vuelta hacia Browser, con la etiqueta "301 Redirect → URL original".
8. WHEN el presentador avanza activamente al fragment `data-fragment-index="6"`, THE URL_Flow_Diagram SHALL revelar un rectángulo perimetral discontinuo con la etiqueta "Docker network: shortener_default".
9. THE URL_Flow_Diagram SHALL usar `data-transition="slide"` y `data-background-color="#1a1a2e"` en el `<section>`.
10. THE URL_Flow_Diagram SHALL usar flechas de solicitud con color `#326CE5` (marcador `flow-arr`) y la flecha de respuesta con color `#2ecc71` (marcador `flow-arr-green`).

---

### Requirement 4: Ilustración Stack de Observabilidad

**User Story:** Como presentador, quiero reemplazar el grid de cards del slide "Grafana: Unificando todo" con un diagrama SVG que muestre los 3 pilares convergiendo en Grafana, para que los estudiantes visualicen la arquitectura de observabilidad y el rol unificador de Grafana.

#### Acceptance Criteria

1. WHEN el presentador navega al slide "Grafana: Unificando todo", THE Presentation SHALL mostrar el `Observability_Stack_Diagram` en lugar del `.grid-3` con cards y tags existentes.
2. WHEN el presentador avanza el fragment con `data-fragment-index="1"`, THE Observability_Stack_Diagram SHALL revelar el bloque Prometheus con fondo `rgba(230,82,44,0.12)`, borde `#e6522c`, y los textos "Prometheus" y "Métricas · PromQL".
3. WHEN el presentador avanza al fragment `data-fragment-index="2"`, THE Observability_Stack_Diagram SHALL revelar el bloque Loki con fondo `rgba(240,165,0,0.12)`, borde `#f0a500`, y los textos "Loki" y "Logs · LogQL".
4. WHEN el presentador avanza al fragment `data-fragment-index="3"`, THE Observability_Stack_Diagram SHALL revelar el bloque Tempo con fondo `rgba(59,130,246,0.12)`, borde `#3b82f6`, y los textos "Tempo" y "Traces · TraceQL".
5. WHEN el presentador avanza al fragment `data-fragment-index="4"`, THE Observability_Stack_Diagram SHALL revelar simultáneamente las 3 flechas curvas convergentes y el bloque central Grafana con fondo `rgba(244,104,0,0.18)`, borde `#f46800`, y los textos "Grafana", "Dashboard unificado", y "Alerting · Explore".
6. WHEN el presentador avanza al fragment `data-fragment-index="5"`, THE Observability_Stack_Diagram SHALL revelar la etiqueta de correlación "Alerta Prometheus → Log Loki → Trace Tempo" en la parte superior del diagrama.
7. THE Observability_Stack_Diagram SHALL posicionar Prometheus en la parte superior izquierda, Loki en la parte inferior izquierda, Tempo en la derecha, y Grafana en el centro del viewBox.
8. THE Observability_Stack_Diagram SHALL usar flechas discontinuas (`stroke-dasharray="6,3"`) coloreadas según el pilar de origen: `#e6522c` para Prometheus, `#f0a500` para Loki, `#3b82f6` para Tempo.
9. THE Observability_Stack_Diagram SHALL mantener `data-transition="zoom"` y `data-background-color="#1a1a2e"` en el `<section>` padre.
10. THE Observability_Stack_Diagram SHALL preservar el subtítulo existente "Los 3 pilares → un solo panel de control" bajo el `<h3>`. No se requiere preservar otros elementos visuales existentes del slide.

---

### Requirement 5: Ilustración Roadmap Visual Pipeline

**User Story:** Como presentador, quiero reemplazar los 6 divs `.stack-step` del slide "Hoja de Ruta" con un diagrama SVG de pipeline horizontal, para que los estudiantes vean el progreso de la charla de forma visual y orientada espacialmente.

#### Acceptance Criteria

1. WHEN el presentador navega al slide "Hoja de Ruta", THE Presentation SHALL mostrar el `Roadmap_Pipeline` en lugar de los 6 elementos `.stack-step` con sus `.stack-number`.
2. THE Roadmap_Pipeline SHALL mostrar 6 nodos circulares numerados del 1 al 6 dispuestos horizontalmente sobre una línea base a lo largo del viewBox de 1100×260 px.
3. THE Roadmap_Pipeline SHALL usar círculos de color `#2ecc71` para los pasos 1, 2 y 3 (done), un círculo de color `#f39c12` para el paso 4 (current), y círculos con `fill="rgba(255,255,255,0.15)"` para los pasos 5 y 6 (next).
4. THE Roadmap_Pipeline SHALL dibujar un segmento de línea de color `#2ecc71` entre los pasos 1 y 3, un segmento discontinuo de color `#f39c12` entre los pasos 3 y 4, y una línea base de `rgba(255,255,255,0.15)` para el resto del pipeline.
5. WHEN el presentador avanza activamente al fragment `data-fragment-index="1"`, THE Roadmap_Pipeline SHALL revelar el nodo 1 con ícono de Docker cargado desde CDN y el texto "Contenedores / Docker · Imágenes". Los fragments podrán ser visibles independientemente del índice de fragment actual según el comportamiento nativo de Reveal.js.
6. WHEN el presentador avanza al fragment `data-fragment-index="2"`, THE Roadmap_Pipeline SHALL revelar el nodo 2 con representación de cajas apiladas y el texto "Compose / Multi-container local".
7. WHEN el presentador avanza al fragment `data-fragment-index="3"`, THE Roadmap_Pipeline SHALL revelar el nodo 3 con el logo de Kubernetes cargado desde CDN y el texto "Kubernetes / Pods · Services".
8. WHEN el presentador avanza al fragment `data-fragment-index="4"`, THE Roadmap_Pipeline SHALL revelar el nodo 4 con color `#f39c12`, la etiqueta "▼ AQUÍ" sobre el nodo, y el texto "Configuración / ConfigMaps · Secrets".
9. WHEN el presentador avanza al fragment `data-fragment-index="5"`, THE Roadmap_Pipeline SHALL revelar el nodo 5 con opacidad reducida y el texto "Escalado / HPA · Autoscaling".
10. WHEN el presentador avanza al fragment `data-fragment-index="6"`, THE Roadmap_Pipeline SHALL revelar el nodo 6 con opacidad reducida, un ícono simplificado de Grafana (círculo con "G"), y el texto "Observabilidad / Prometheus · Grafana".
11. WHEN el presentador avanza al fragment `data-fragment-index="7"`, THE Roadmap_Pipeline SHALL revelar la leyenda de estado con tres indicadores: círculo verde "Completado", círculo naranja "En curso", círculo gris "Próximo".
12. THE Roadmap_Pipeline SHALL mantener `data-transition="zoom"` en el `<section>` padre, preservando la transición original.

---

### Requirement 6: Restricciones de Integración y Compatibilidad

**User Story:** Como mantenedor de la presentación, quiero que todas las ilustraciones sean self-contained dentro de `html/index.html`, para que la presentación funcione offline y no requiera herramientas de build adicionales.

#### Acceptance Criteria

1. THE Presentation SHALL integrar todas las ilustraciones como HTML/SVG inline dentro del archivo `html/index.html` existente, sin crear archivos externos adicionales.
2. THE Presentation SHALL cargar todos los íconos externos únicamente desde `cdn.jsdelivr.net`, que ya es el dominio CDN usado por el proyecto.
3. THE Presentation SHALL mantener la compatibilidad con Reveal.js 5.1.0 ya cargado en el `<head>`.
4. WHILE la presentación es proyectada, THE Presentation SHALL renderizar cada ilustración SVG usando `viewBox` y `width:100%` para escalar proporcionalmente con el sistema `transform: scale()` de Reveal.js.
5. THE Presentation SHALL configurar cada SVG con una `max-height` entre 300 px y 520 px según el contenido del slide, para evitar desbordamiento en resolución 1920×1080 con margin 0.04 de Reveal.js.
6. THE Presentation SHALL mantener la legibilidad completa en todo momento, independientemente del estado de carga de los íconos externos. IF un ícono SVG externo no carga desde CDN, THEN THE Presentation SHALL mantener legibilidad completa mediante los labels de texto y formas geométricas inline SVG de cada ilustración. Esta garantía de legibilidad aplica solo a fallos de carga de íconos, no a fallos de renderizado del SVG inline.
7. THE Presentation SHALL definir los marcadores de flecha SVG (`<defs><marker>`) dentro de cada `<svg>` que los utilice, con `id` únicos por ilustración para evitar conflictos en el DOM global.
8. WHILE el presentador avanza o retrocede fragments, THE Presentation SHALL delegar el control del estado de visibilidad de cada `.fragment` al mecanismo nativo de Reveal.js, sin scripts adicionales.
9. THE Presentation SHALL preservar todos los `<aside class="notes">` de los slides modificados, reubicándolos dentro del nuevo `<section>` cuando sea necesario.

---

### Requirement 7: Consistencia Visual

**User Story:** Como presentador, quiero que todas las ilustraciones sean visualmente coherentes con el diseño actual de la presentación, para que la audiencia perciba un estilo unificado durante toda la charla.

#### Acceptance Criteria

1. THE Presentation SHALL usar en todas las ilustraciones exclusivamente los colores definidos en la paleta del proyecto: `#326CE5`, `#2ecc71`, `#f39c12`, `#e74c3c`, `#1a1a2e`, `#f46800`, `#e6522c`, `#f0a500`, `#3b82f6`, `#61dafb`, `#dc382c`.
2. THE Presentation SHALL usar `font-family="sans-serif"` para textos de títulos y etiquetas, y `font-family="monospace"` para textos técnicos y nombres de comandos dentro de los SVGs.
3. THE Presentation SHALL aplicar bordes redondeados (`rx` entre 4 y 16 según el tamaño del elemento) en todos los rectángulos de los diagramas.
4. THE Presentation SHALL usar fondos semi-transparentes (`rgba`) para los rectángulos de componentes, con opacidad entre 0.10 y 0.25, para mantener la legibilidad sobre el fondo oscuro `#1a1a2e`.
5. THE Presentation SHALL mostrar los headings `<h3>` existentes de cada slide modificado, preservando su contenido exacto.

---

### Requirement 8: Legibilidad en Proyector

**User Story:** Como presentador en sala de charla presencial, quiero que todas las ilustraciones sean legibles desde la última fila del aula, para que todos los estudiantes puedan seguir el diagrama independientemente de su posición.

#### Acceptance Criteria

1. THE Presentation SHALL usar en todos los SVGs un tamaño mínimo de fuente de 9 px en coordenadas de viewBox para textos secundarios, y 11 px para textos primarios de componentes.
2. THE Presentation SHALL usar un `stroke-width` mínimo de 1.5 px para bordes de componentes y 2 px para flechas de conexión, en coordenadas de viewBox.
3. THE Presentation SHALL asegurar que ningún texto crítico (nombre de componente, tipo de tecnología) quede solapado con otro elemento gráfico dentro de su viewBox.
4. WHERE un elemento es puramente decorativo (separadores, fondos), THE Presentation SHALL aplicar opacidad inferior a 0.5 para no competir visualmente con el contenido informativo.
