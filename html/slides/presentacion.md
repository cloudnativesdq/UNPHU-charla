# Presentaciones UNPHU

## Compartiendo conocimiento de forma abierta

Note: Bienvenidos al sistema de presentaciones UNPHU

---

## Colaboración en tiempo real

Esta presentación está disponible públicamente en internet.

- Cualquiera con el link puede verla
- El presentador controla las slides
- La audiencia sigue en sincronía

--

## Cómo funciona

| Rol | URL |
|-----|-----|
| **Presentador** | `https://tu-url.trycloudflare.com/?secret=unphu-secret-2026` |
| **Audiencia** | `https://tu-url.trycloudflare.com/` |

---

## Cómo editar las slides

1. Edita el archivo `slides/presentacion.md`
2. Usa `---` para separar slides horizontales
3. Usa `--` para separar slides verticales
4. Recarga el navegador para ver cambios

---

## Markdown básico

- **Negrita** con `**texto**`
- *Cursiva* con `*texto*`
- `Código inline` con backticks
- [Links](https://revealjs.com) con `[texto](url)`

---

## Código con syntax highlighting

```python
def hola_mundo():
    print("Hola UNPHU!")
    return True
```

```javascript
const presentacion = {
  tema: "Docker & Presentaciones",
  framework: "Reveal.js",
  tunnel: "Cloudflare"
};
```

---

## Inspiración

> "La mejor manera de aprender es enseñar"

Basado en el formato de [container.training](https://qconuk2019.container.training/)

---

## Imágenes

![Reveal.js](https://revealjs.com/images/logo/reveal-black-text.svg)

---

## Dos columnas

<div class="columns">
<div>

### Columna izquierda

- Punto 1
- Punto 2
- Punto 3

</div>
<div>

### Columna derecha

- Punto A
- Punto B
- Punto C

</div>
</div>

---

## Listo para empezar!

### Pasos siguientes

1. Edita `slides/presentacion.md` con tu contenido
2. Ejecuta `docker compose up -d`
3. Revisa los logs: `docker compose logs tunnel`
4. Comparte la URL pública

<div class="center">

**Gracias!**

</div>
