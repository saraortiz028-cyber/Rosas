<template>
  <div class="cuenta-container">
    <div class="perfil-card">
      <h2>Mi Perfil</h2>
      <p><strong>Nombre:</strong> {{ cliente.nombre }}</p>
      <p><strong>Correo:</strong> {{ cliente.correo }}</p>
      <button @click="cerrarSesion" class="btn-logout">Cerrar Sesión</button>
    </div>

    <div class="pedidos-card">
      <h2>Historial de Mis Pedidos</h2>

      <div v-if="cargando" class="estado-texto">Cargando tus compras...</div>
      
      <div v-else-if="pedidos.length === 0" class="estado-texto">
        Aún no has realizado ningún pedido.
      </div>

      <div v-else class="pedidos-grid">
        <div v-for="pedido in pedidos" :key="pedido.idPedido" class="pedido-card">
          <div class="pedido-header">
            <span class="id-pedido">Pedido #{{ pedido.idPedido }}</span>
            <span class="estado" :class="pedido.estadoPedido.toLowerCase()">{{ pedido.estadoPedido }}</span>
          </div>

          <div class="pedido-info">
            <p><strong>Producto:</strong> {{ pedido.nombreProducto }}</p>
            <p><strong>Fecha:</strong> {{ formatearFecha(pedido.fechaPedido) }}</p>
            <p><strong>Lugar de Entrega:</strong> {{ pedido.lugarEntrega }}</p>
            <p class="total"><strong>Total:</strong> C$ {{ pedido.total }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Cuenta',
  data() {
    return {
      cliente: {},
      pedidos: [],
      cargando: true
    }
  },
  mounted() {
    const clienteGuardado = localStorage.getItem('cliente');
    if (!clienteGuardado) {
      this.$router.push('/auth');
      return;
    }
    
    this.cliente = JSON.parse(clienteGuardado);
    this.obtenerPedidos();
  },
  methods: {
    async obtenerPedidos() {
      try {
        const respuesta = await fetch(`http://localhost:3000/api/mis-pedidos/${this.cliente.id}`);
        const datos = await respuesta.json();
        
        if (respuesta.ok) {
          this.pedidos = datos.pedidos;
        }
      } catch (error) {
        console.error("Error cargando los pedidos:", error);
      } finally {
        this.cargando = false;
      }
    },
    cerrarSesion() {
      localStorage.removeItem('cliente');
      this.$router.push('/auth');
    },
    formatearFecha(fechaStr) {
      if (!fechaStr) return 'N/A';
      return new Date(fechaStr).toLocaleDateString('es-ES', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    }
  }
}
</script>

<style scoped>
.cuenta-container {
  max-width: 900px;
  margin: 30px auto;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;

}
.perfil-card, .pedidos-card {
  background: var(--color-superficie);
  padding: 20px;
  border-radius: 8px;
  box-shadow: var(--sombra);
}
.btn-logout {
  margin-top: 10px;
  background: var(--color-principal);
  color: white;
  border: none;
  padding: 8px 15px;
  border-radius: 4px;
  cursor: pointer;
}
.pedidos-grid {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-top: 15px;
}
.pedido-card {
  border: 1px solid var(--color-borde);
  border-radius: 6px;
  padding: 15px;
  background: var(--color-fondo);
}
.pedido-header {
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid var(--color-borde);
  padding-bottom: 8px;
  margin-bottom: 10px;
  font-weight: bold;
}
.estado {
  padding: 3px 8px;
  border-radius: 4px;
  background: var(--color-borde);
  font-size: 13px;
}
.total {
  color: var(--color-principal);
  font-size: 16px;
}
.estado-texto {
  margin-top: 15px;
  color: var(--color-secundario);
}
</style>