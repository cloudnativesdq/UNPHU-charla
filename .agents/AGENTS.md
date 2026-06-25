# Pautas de Estilo y Directrices para Agentes (AGENTS.md)

Este archivo define la identidad visual, paleta de colores, tipografías y recursos gráficos para el proyecto **UNPHU-charla**, asegurando la coherencia de diseño entre la comunidad **Cloud Native Santo Domingo** y la **Universidad Nacional Pedro Henríquez Ureña (UNPHU)**.

---

## 🎨 Paletas de Colores (Color Palettes)

### 1. Cloud Native Santo Domingo (CNCF Community Group)
Inspirada en la identidad oficial de la *Cloud Native Computing Foundation (CNCF)*.
*   **CNCF Blue (Azul CNCF):** `#0078d4` | HSL(206, 100%, 41%) — Utilizado para elementos principales del ecosistema cloud.
*   **CNCF Cyan (Cian CNCF):** `#00bcf2` | HSL(193, 100%, 47%) — Color de acento para llamadas a la acción, enlaces y transiciones dinámicas.
*   **Gradiente Recomendado:** `linear-gradient(to right, #0078d4, #00bcf2)`

### 2. UNPHU (Universidad Nacional Pedro Henríquez Ureña)
Representa el branding académico e institucional de la universidad.
*   **UNPHU Navy Blue (Azul Marino):** `#1a365d` | HSL(215, 56%, 23%) — Color principal de textos, títulos y crestas institucionales.
*   **UNPHU Gold (Oro):** `#c9a227` | HSL(45, 68%, 47%) — Color secundario para bordes, resaltados específicos y detalles heráldicos.
*   **Muted Text (Gris):** `#64748b` | HSL(215, 16%, 47%) — Para subtítulos y notas explicativas.

---

## ✍️ Tipografías (Typography)

### Cloud Native Santo Domingo
*   **Títulos / Enlaces destacados:** `Space Grotesk`, sans-serif (Fuentes geométricas y modernas).
*   **Cuerpo de Texto:** `Inter`, sans-serif (Legible, neutral y limpia).

### UNPHU (Institucional)
*   **Títulos y Subtítulos:** `Plus Jakarta Sans`, Arial, sans-serif.

---

## 🖼️ Logotipos (Logos & Assets)

### Logotipo de Cloud Native Santo Domingo
*   **Origen:** [cloudnativesdq.org/favicon.svg](https://cloudnativesdq.org/favicon.svg)
*   **Estructura Vectorial:**
    ```xml
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 85.3 85.3">
      <path fill="#0078d4" d="M0 0v85.3h85.3V0H0zm71.1 71.1H14.2V14.2h56.9v56.9z"/>
      <path fill="#00bcf2" d="M28.4 28.4h28.4v28.4H28.4z"/>
      <path fill="#0078d4" d="M14.2 14.2h14.2v14.2H14.2zM56.9 56.9h14.2v14.2H56.9z"/>
    </svg>
    ```

### Logotipo de UNPHU
*   **Ruta en el repositorio:** [unphu-logo.svg](file:///Users/tineoc/Documents/Code/UNPHU-charla/html/presentation/assets/unphu-logo.svg)
*   **Detalle:** Contiene el escudo tradicional de la universidad en `#1a365d` y `#c9a227` con el texto "UNPHU" y la inscripción "Universidad Nacional Pedro Henríquez Ureña".

---

## 🤝 Agradecimiento Institucional (Thank You Note)

> [!NOTE]
> **Mensaje de Agradecimiento a la UNPHU (Español):**
> 
> *"Queremos expresar nuestro más sincero agradecimiento a la **Universidad Nacional Pedro Henríquez Ureña (UNPHU)** por abrir sus puertas a la comunidad, y por su valiosa e incansable labor promoviendo e impulsando las prácticas **Cloud Native** en Santo Domingo. Su apoyo constante fomenta un espacio idóneo para la formación y el crecimiento tecnológico de las futuras generaciones de ingenieros en la República Dominicana."*

---

## ⚙️ Reglas de Comportamiento para Agentes (Agent Instructions)
1.  **Integridad de Marca:** Cuando modifiques o agregues nuevas diapositivas en [presentation.html](file:///Users/tineoc/Documents/Code/UNPHU-charla/html/presentation/presentation.html) o estilos en [styles.css](file:///Users/tineoc/Documents/Code/UNPHU-charla/html/presentation/styles.css), utiliza las variables CSS basadas en las paletas anteriores.
2.  **Combinación de Estilo:** El fondo general debe tender a claro (blanco/gris muy suave) o negro profundo de alto contraste, usando el Azul UNPHU como color primario institucional y el Gradiente Cloud Native SDQ (Blue a Cyan) como acento dinámico de tecnología.
3.  **Preservación de Comentarios:** No elimines los comentarios explicativos ni las notas de orador (`<aside class="notes">`) de la presentación.
