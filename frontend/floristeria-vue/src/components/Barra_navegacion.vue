<template>
  <nav class="navbar">
    <div class="nav-links">
      <router-link to="/" active-class="activo">Inicio</router-link>
      <router-link to="/catalogo" active-class="activo">Catálogo</router-link>
      <router-link to="/rastrearPedidos" active-class="activo">Rastreo de pedidos</router-link>

      <!-- SI EL USUARIO HA INICIADO SESIÓN -->
      <template v-if="haIniciadoSesion">
        <router-link to="/cuenta" active-class="activo">Mi Cuenta</router-link>
      
      </template>

      <!-- SI NO HA INICIADO SESIÓN -->
      <template v-else>
        <router-link to="/auth" active-class="activo">Iniciar Sesión / Registro</router-link>
      </template>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'Barra_navegacion',
  data() {
    return {
      haIniciadoSesion: false
    }
  },
  mounted() {
    this.verificarSesion();
  },
  watch: {
    $route() {
      this.verificarSesion();
    }
  },
  methods: {
    verificarSesion() {
      this.haIniciadoSesion = !!localStorage.getItem('cliente');
    },
    cerrarSesion() {
      localStorage.removeItem('cliente');
      this.haIniciadoSesion = false;
      this.$router.push('/auth');
    }
  }
}
</script>

<style scoped>
.navbar {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 15px 20px;
  background-color: #ffffff;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 25px; /* Espaciado entre los textos */
}

/* Aplica el mismo formato a los enlaces y al botón */
.nav-links a,
.nav-btn-logout {
  text-decoration: none;
  color: #2c3e50;
  font-size: 16px;
  font-weight: 500;
  background: transparent;
  border: none;
  padding: 0;
  margin: 0;
  font-family: inherit;
  cursor: pointer;
  transition: color 0.2s ease;
}

/* Cambio de color al pasar el cursor */
.nav-links a:hover,
.nav-btn-logout:hover {
  color: #d81b60;
}

/* Enlace activo */
.nav-links a.activo {
  color: #d81b60;
  font-weight: bold;
}
</style>