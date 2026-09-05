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

       <!-- Boton modo oscuro / claro -->
       <button class="theme-toggle" @click="cambiarTema" title="Cambiar tema">
  {{ temaActual === 'dark' ? '☀️' : '🌙' }}
</button>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'Barra_navegacion',
  data() {
    return {
      haIniciadoSesion: false,
      temaActual: 'light' // Guarda si es 'light' o 'dark'
    }
  },
  mounted() {
    this.verificarSesion();

    //Al cargar la página, lee el tema guardado en localStorage
    this.temaActual = localStorage.getItem('theme') || 'light';
    
    //Le aplica el atributo al HTML
    document.documentElement.setAttribute('data-theme', this.temaActual);
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
    },
    // Función que se ejecuta al presionar el botón de la Luna / Sol
    cambiarTema() {
      this.temaActual = this.temaActual === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', this.temaActual);
      localStorage.setItem('theme', this.temaActual);
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
  background-color: var(--color-superficie);
  border-bottom: 1px solid var(--color-borde);
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
  color: var(--color-texto);
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
  color: var(--color-principal);
}

/* Enlace activo */
.nav-links a.activo {
  color: var(--color-principal);
  font-weight: bold;
}
</style>