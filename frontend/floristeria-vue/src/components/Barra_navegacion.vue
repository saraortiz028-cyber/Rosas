<template>
    <nav>
      <div class="nav-contenedor">
            <router-link to="/" class="nav-logo">
                <img src="../assets/Logo Rosa Eterna sin fondo.png"
                     alt="Rosa Eterna"
                     style="height: 50px; object-fit: contain; display: block;">
            </router-link>

            <div class="nav-links">
                <router-link to="/" active-class="activo">Inicio</router-link>
                <router-link to="/catalogo" active-class="activo">Catálogo</router-link>
                <router-link to="/rastrearPedidos" active-class="activo">Rastreo de pedidos</router-link>
            </div>
      </div>   
    </nav>
</template> 

<script>
export default {
  name: 'Barra_navegacion'
}
</script>