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
.app-container{
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.contenido-principal{
  flex: 1;
}
</style>