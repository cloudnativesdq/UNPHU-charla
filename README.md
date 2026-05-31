# UNPHU - De 0 a Observabilidad

Charla de introduccion a contenedores y Kubernetes. UNPHU 2026.

Presentacion hecha con [Reveal.js](https://revealjs.com), servida con Docker + Nginx y expuesta a internet via Cloudflare Tunnel (sin login).

## Estructura del proyecto

```
.
├── docker-compose.yml          # Nginx + Cloudflare tunnel
├── html/
│   ├── index.html              # Presentacion principal (Reveal.js)
│   ├── nginx.conf              # Configuracion Nginx
│   └── slides/                 # Markdown adicional (respaldo)
│       └── presentacion.md
├── .opencode/
│   └── skills/revealjs/        # Skill para editar presentaciones con IA
│       ├── SKILL.md
│       ├── references/         # CSS base, features avanzadas, charts
│       └── scripts/            # Scaffold, overflow check, browser editor
└── README.md
```

## Requisitos

- [Docker](https://docs.docker.com/get-docker/) (Docker Desktop o Docker Engine)
- [Git](https://git-scm.com/)
- Navegador web moderno (Chrome, Firefox, Safari)
- (Opcional) [Node.js 18+](https://nodejs.org/) para la skill de edicion con IA

## Inicio rapido

```bash
# 1. Clonar el repo
git clone https://github.com/cloudnativesdq/UNPHU-charla.git
cd UNPHU-charla

# 2. Levantar presentacion + tunel publico
docker compose up -d

# 3. Ver localmente
#    http://localhost:8000

# 4. Obtener URL publica (compartir con audiencia)
docker compose logs tunnel | grep trycloudflare.com
```

La URL publica es temporal y cambia cada vez que se reinicia el tunel.

## Como ver la presentacion

| Accion | Como |
|--------|------|
| Ver slides | Navegar con flechas del teclado o swipe |
| Vista de presentador | Presionar `S` |
| Vista overview | Presionar `O` |
| Buscar en slides | `Ctrl+Shift+F` |
| Zoom en elemento | `Alt+Click` (Linux: `Ctrl+Click`) |
| Pantalla completa | Presionar `F` |

## Contenido de la charla (10:00 AM - 12:00 PM)

| Paso | Tema | Duracion aprox. |
|------|------|-----------------|
| 1 | **Contenedores** - Docker, imagenes, Dockerfile | 20 min |
| 2 | **Docker Compose** - Multi-container local | 15 min |
| 3 | **Kubernetes** - Arquitectura, Pods, Deployments, Services | 30 min |
| 4 | **Configuracion** - ConfigMaps, Secrets, Namespaces | 15 min |
| 5 | **Escalado** - HPA, auto-scaling | 15 min |
| 6 | **Observabilidad** - Prometheus, Loki, Tempo, Grafana | 25 min |

## Editar la presentacion

### Opcion 1: Editar HTML directamente

El archivo principal es `html/index.html`. Es HTML puro con Reveal.js cargado desde CDN. Editar y recargar el navegador.

```bash
# Tu editor favorito
code html/index.html

# O vim
vim html/index.html

# Reiniciar nginx para ver cambios
docker compose restart revealjs
```

### Opcion 2: Usar la skill de Reveal.js con IA (opencode)

La skill permite generar y editar presentaciones con comandos de lenguaje natural usando [opencode](https://opencode.ai).

```bash
# Instalar dependencias de la skill
npm install --prefix .opencode/skills/revealjs

# Iniciar opencode en el directorio del proyecto
opencode
```

Dentro de opencode, la skill se activa automaticamente cuando pidas crear o editar presentaciones. Ejemplos:

```
> Agrega un slide sobre Ingress Controllers despues del slide de Services
> Cambia el tema a blanco con acentos verdes
> Agrega un diagrama de la arquitectura de observabilidad
> Crea una nueva presentacion sobre Helm
```

### Opcion 3: Browser editor (edicion visual)

```bash
node .opencode/skills/revealjs/scripts/edit-html.js html/index.html
```

Abre un servidor local donde puedes hacer click en cualquier texto para editarlo directamente.

## Comandos utiles

```bash
# Levantar todo
docker compose up -d

# Ver estado de los contenedores
docker compose ps

# Ver URL del tunel publico
docker compose logs tunnel | grep trycloudflare.com

# Reiniciar despues de editar
docker compose restart revealjs

# Detener todo
docker compose down

# Detener y limpiar todo (incluyendo tuneles huerfanos)
docker compose down --remove-orphans
```

## Recursos

- [Reveal.js - Documentacion](https://revealjs.com/)
- [Kubernetes - Docs](https://kubernetes.io/docs/)
- [container.training](https://container.training/) - Workshops interactivos
- [CNCF Landscape](https://landscape.cncf.io/) - Ecosistema completo
- [Grafana Tutorials](https://grafana.com/tutorials/) - Prometheus, Loki, Tempo
- [OpenTelemetry Docs](https://opentelemetry.io/docs/)

## Licencia

MIT
