<template>
  <div class="contenedor-principal">
    <div class="hero-contenido"> 
      <h1>Flores para toda ocasión</h1>
      <p>Haz tus pedidos de manera rápida, eficiente y sin complicaciones. 
        ¡Nosotros nos encargamos de llevar la magia a domicilio!</p>
      <router-link to="/catalogo" class="btn-principal">Ver Catálogo</router-link>
    </div>

    <div class="seccion-info">
      <div class="tarjeta-bienvenida">
        <h3>Gracias a nuestro servicio en línea</h3>
        <p>Eliges tu diseño favorito, programas la hora de entrega y listo. 
           Flores frescas de invernadero directo a su puerta el mismo día.</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Inicio'
}
</script>