<template>
  <div class="auth-container">
    <div class="auth-box">
      <!-- Pestañas para cambiar entre Iniciar Sesión y Registrarse -->
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
          <input type="password" v-model="loginData.password" required />
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
          <input type="password" v-model="registroData.password" required />
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
      loginData: {
        correo: '',
        password: ''
      },
      registroData: {
        nombre: '',
        apellido: '',
        telefono: '',
        correo: '',
        password: ''
      },
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
          alert('¡Bienvenido de nuevo, ' + datos.cliente.nombre + '!');
          this.$router.push('/');
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
}
.auth-box {
  background: #fff;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
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
  background: #eee;
  border: none;
  cursor: pointer;
  font-weight: bold;
}
.tabs button.active {
  background: #d81b60;
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
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
}
.btn-submit {
  width: 100%;
  padding: 10px;
  background: #d81b60;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}
.btn-submit:hover {
  background: #ad1457;
}
.mensaje {
  margin-top: 15px;
  color: red;
  text-align: center;
  font-size: 14px;
}
</style>