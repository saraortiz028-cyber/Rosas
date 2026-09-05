<template>
  <div class="auth-container">
    <div class="auth-box">
      <div class="tabs">
        <button :class="{ active: esLogin }" @click="esLogin = true">Iniciar Sesión</button>
        <button :class="{ active: !esLogin }" @click="esLogin = false">Registrarse</button>
      </div>

      <!-- FORMULARIO DE INICIO DE SESIÓN -->
      <form v-if="esLogin" @submit.prevent="handleLogin" class="form">
        <h2>Iniciar Sesión</h2>
        <div class="input-group">
          <label>Correo Electrónico</label>
          <input type="email" v-model="loginData.correo" required />
        </div>
        
        <div class="input-group">
          <label>Contraseña</label>
          <div class="password-wrapper">
            <input :type="mostrarPassword ? 'text' : 'password'" v-model="loginData.password" required />
            <button 
              type="button" 
              class="btn-eye" 
              @click="mostrarPassword = !mostrarPassword"
              :title="mostrarPassword ? 'Ocultar contraseña' : 'Mostrar contraseña'"
            >
              <svg v-if="!mostrarPassword" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
              <svg v-else xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
              </svg>
            </button>
          </div>
        </div>

        <button type="submit" class="btn-submit">Entrar</button>
      </form>

      <!-- FORMULARIO DE REGISTRO -->
      <form v-else @submit.prevent="handleRegistro" class="form">
        <h2>Crear Cuenta</h2>
        <div class="input-group">
          <label>Nombre</label>
          <input type="text" v-model="registroData.nombre" required />
        </div>
        <div class="input-group">
          <label>Apellido</label>
          <input type="text" v-model="registroData.apellido" required />
        </div>
        <div class="input-group">
          <label>Teléfono</label>
          <input type="text" v-model="registroData.telefono" required />
        </div>
        <div class="input-group">
          <label>Correo Electrónico</label>
          <input type="email" v-model="registroData.correo" required />
        </div>

        <div class="input-group">
          <label>Contraseña</label>
          <div class="password-wrapper">
            <input :type="mostrarPassword ? 'text' : 'password'" v-model="registroData.password" required />
            <button 
              type="button" 
              class="btn-eye" 
              @click="mostrarPassword = !mostrarPassword"
              :title="mostrarPassword ? 'Ocultar contraseña' : 'Mostrar contraseña'"
            >
              <svg v-if="!mostrarPassword" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
              <svg v-else xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
              </svg>
            </button>
          </div>
        </div>

        <button type="submit" class="btn-submit">Registrarse</button>
      </form>

      <p v-if="mensaje" class="mensaje">{{ mensaje }}</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Auth',
  data() {
    return {
      esLogin: true,
      mostrarPassword: false,
      loginData: { correo: '', password: '' },
      registroData: { nombre: '', apellido: '', telefono: '', correo: '', password: '' },
      mensaje: ''
    }
  },
  methods: {
    async handleLogin() {
      try {
        const respuesta = await fetch('http://localhost:3000/api/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.loginData)
        });
        const datos = await respuesta.json();
        
        if (respuesta.ok) {
          localStorage.setItem('cliente', JSON.stringify(datos.cliente));
          this.$router.push('/cuenta');
        } else {
          this.mensaje = datos.error || 'Error al iniciar sesión';
        }
      } catch (error) {
        this.mensaje = 'No se pudo conectar con el servidor backend';
      }
    },
    async handleRegistro() {
      try {
        const respuesta = await fetch('http://localhost:3000/api/registro', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.registroData)
        });
        const datos = await respuesta.json();
        
        if (respuesta.ok) {
          alert('¡Cuenta creada con éxito! Ahora puedes iniciar sesión.');
          this.esLogin = true;
        } else {
          this.mensaje = datos.error || 'Error al registrarse';
        }
      } catch (error) {
        this.mensaje = 'No se pudo conectar con el servidor backend';
      }
    }
  }
}
</script>

<style scoped>
.auth-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px;
  min-height: 100%;
}
.auth-box {
  background: var(--color-superficie);
  padding: 30px;
  border-radius: 8px;
  box-shadow: var(--sombra);
  width: 100%;
  max-width: 400px;
}
.tabs {
  display: flex;
  margin-bottom: 20px;
}
.tabs button {
  flex: 1;
  padding: 10px;
  background: var(--color-fondo);
  border: none;
  cursor: pointer;
  font-weight: bold;
}
.tabs button.active {
  background: var(--color-principal);
  color: white;
}
.input-group {
  margin-bottom: 15px;
  display: flex;
  flex-direction: column;
}
.input-group label {
  margin-bottom: 5px;
  font-size: 14px;
}
.input-group input {
  width: 100%;
  padding: 8px 35px 8px 8px;
  border: 1px solid var(--color-borde);
  border-radius: 4px;
  box-sizing: border-box;
}
.password-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}
.btn-eye {
  position: absolute;
  right: 10px;
  background: none;
  border: none;
  cursor: pointer;
  color: var(--color-secundario);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
}
.btn-eye:hover {
  color: var(--color-principal);
}
.btn-submit {
  width: 100%;
  padding: 10px;
  background: var(--color-principal);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}
.btn-submit:hover {
  background: var(--color-principal-hover);
}
.mensaje {
  margin-top: 15px;
  color: var(--color-principal-hover);
  text-align: center;
  font-size: 14px;
}
</style>