<template>
  <div id="app" class="app-container">
    <Barra_navegacion />

    <main class="contenido-principal">
      <router-view></router-view>
    </main>

    <Pie_pagina />
  </div>
</template>

<script>
import Barra_navegacion from './components/Barra_navegacion.vue'
import Pie_pagina from './components/Pie_pagina.vue'

export default {
  name: 'App',
  components: {
    Barra_navegacion,
    Pie_pagina
  }
}
</script>

<style>
:root {
  --color-fondo: #fff8fb;
  --color-superficie: #ffffff;
  --color-texto: #3d2630;
  --color-secundario: #7b5361;
  --color-principal: #c2185b;
  --color-principal-hover: #9c1249;
  --color-borde: #f0dce4;
  --sombra: 0 10px 30px rgba(116, 48, 76, 0.12);
}

[data-theme='dark'] {
  --color-fondo: #21181d;
  --color-superficie: #302229;
  --color-texto: #fff0f5;
  --color-secundario: #d8b9c5;
  --color-principal: #f06292;
  --color-principal-hover: #ec407a;
  --color-borde: #563b46;
  --sombra: 0 10px 30px rgba(0, 0, 0, 0.3);
}

* {
  box-sizing: border-box;
}

html,
body,
#app {
  margin: 0;
  min-height: 100%;
}

body {
  background: var(--color-fondo);
  color: var(--color-texto);
  font-family: 'Segoe UI', Arial, sans-serif;
  transition: background 0.3s ease, color 0.3s ease;
}

.app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.contenido-principal {
  flex: 1;
}
</style>