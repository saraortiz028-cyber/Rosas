<template>
  <nav class="navbar">
    <div class="nav-links">
      <button class="theme-toggle" @click="cambiarTema" title="Cambiar tema" aria-label="Cambiar tema">
        {{ temaActual === 'dark' ? '☀️' : '🌙' }}
      </button>

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

      <router-link
        to="/procesar-compra"
        active-class="activo"
        class="enlace-carrito"
        title="Abrir carrito"
        aria-label="Abrir carrito"
      >
        <svg class="icono-carrito" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
          <path d="M3 4h2l2.2 10.2a2 2 0 0 0 2 1.6h7.9a2 2 0 0 0 1.9-1.4L21 8H6" />
          <circle cx="9" cy="19" r="1.3" />
          <circle cx="18" cy="19" r="1.3" />
        </svg>
        <span v-if="cantidadCarrito" class="contador-carrito">{{ cantidadCarrito }}</span>
      </router-link>

    </div>
  </nav>
</template>

<script>
export default {
  name: 'Barra_navegacion',
  data() {
    return {
      haIniciadoSesion: false,
      temaActual: 'light',
      cantidadCarrito: 0
    }
  },
  mounted() {
    this.verificarSesion();
    this.actualizarCarrito();
    window.addEventListener('carrito-actualizado', this.actualizarCarrito);

    //Al cargar la página, lee el tema guardado en localStorage
    this.temaActual = localStorage.getItem('theme') || 'light';
    
    //Le aplica el atributo al HTML
    document.documentElement.setAttribute('data-theme', this.temaActual);
  },
  beforeUnmount() {
    window.removeEventListener('carrito-actualizado', this.actualizarCarrito);
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
    actualizarCarrito() {
      const carrito = JSON.parse(localStorage.getItem('carrito') || '[]');
      this.cantidadCarrito = carrito.reduce((total, item) => total + Number(item.cantidad || 0), 0);
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
  justify-content: center;
  gap: 25px; /* Espaciado entre los textos */
  width: min(1250px, 100%);
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

.theme-toggle {
  flex-shrink: 0;
  padding: 4px 7px;
  border: 0;
  border-radius: 0;
  background: transparent;
  color: var(--color-texto);
  cursor: pointer;
  font-size: 16px;
}

.theme-toggle:hover {
  color: var(--color-principal);
}

.enlace-carrito {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  margin-left: 0;
}

.icono-carrito {
  width: 25px;
  height: 25px;
  line-height: 1;
  fill: none;
  stroke: currentColor;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 1.8;
}

.contador-carrito {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 20px;
  height: 20px;
  padding: 0 5px;
  border-radius: 10px;
  background: var(--color-principal);
  color: white;
  font-size: 12px;
  font-weight: bold;
}

.enlace-carrito .contador-carrito {
  position: absolute;
  top: -5px;
  right: -6px;
}

@media (max-width: 700px) {
  .navbar {
    padding: 12px;
  }

  .nav-links {
    flex-wrap: wrap;
    justify-content: center;
    gap: 14px;
  }
}
</style>