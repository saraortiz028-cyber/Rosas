<template>
  <div class="seccion-compra">
    <h2>Finalizar Pedido</h2>
    
    <div v-if="productoPedido" class="detalle-producto">
      <img :src="imagenLocal" :alt="productoPedido.nombreProducto">
      <h3>{{ productoPedido.nombreProducto }}</h3>
      <p>Precio: ${{ productoPedido.precioActual }}</p>
      
      <!-- Aquí iría tu formulario de datos de envío -->
      <button
        class="btn-confirmar"
        type="button"
        :disabled="guardando"
        @click="confirmarPedido"
      >
        {{ guardando ? 'Registrando...' : 'Confirmar Pedido' }}
      </button>
    </div>
    
    <div v-else>
      <p>Cargando producto...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const productoPedido = ref(null);
const imagenLocal = ref('');
const guardando = ref(false);
const router = useRouter();

onMounted(() => {
  const datos = localStorage.getItem('productoSeleccionado');
  if (datos) {
    productoPedido.value = JSON.parse(datos);
    // Asumiendo que la imagen viene en el nombre del objeto
    imagenLocal.value = `/src/assets/${productoPedido.value.imagen}`; 
  }
});

async function confirmarPedido() {
  const clienteGuardado = localStorage.getItem('cliente');

  if (!clienteGuardado) {
    alert('Inicia sesión para registrar la compra.');
    router.push('/auth');
    return;
  }

  guardando.value = true;

  try {
    const cliente = JSON.parse(clienteGuardado);
    const respuesta = await fetch('http://localhost:3000/api/pedidos', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        clienteId: cliente.id,
        productoId: productoPedido.value.idProducto
      })
    });
    const datos = await respuesta.json();

    if (!respuesta.ok) {
      throw new Error(datos.error || 'No se pudo registrar la compra');
    }

    localStorage.removeItem('productoSeleccionado');
    alert('Compra simulada registrada correctamente.');
    router.push('/cuenta');
  } catch (error) {
    alert(error.message);
  } finally {
    guardando.value = false;
  }
}
</script>

<style scoped>
.seccion-compra { padding: 20px; text-align: center; }
.detalle-producto { background: var(--color-superficie); border: 1px solid var(--color-borde); padding: 20px; border-radius: 10px; box-shadow: var(--sombra); }
.btn-confirmar { background: var(--color-principal); color: white; padding: 10px; border: none; border-radius: 6px; cursor: pointer; }
.btn-confirmar:hover { background: var(--color-principal-hover); }
</style>