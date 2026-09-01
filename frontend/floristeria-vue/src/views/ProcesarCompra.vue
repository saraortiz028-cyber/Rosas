<template>
  <div class="seccion-compra">
    <h2>Finalizar Pedido</h2>
    
    <div v-if="productoPedido" class="detalle-producto">
      <img :src="imagenLocal" :alt="productoPedido.nombreProducto">
      <h3>{{ productoPedido.nombreProducto }}</h3>
      <p>Precio: ${{ productoPedido.precioActual }}</p>
      
      <!-- Aquí iría tu formulario de datos de envío -->
      <button class="btn-confirmar">Confirmar Pedido</button>
    </div>
    
    <div v-else>
      <p>Cargando producto...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const productoPedido = ref(null);
const imagenLocal = ref('');

onMounted(() => {
  const datos = localStorage.getItem('productoSeleccionado');
  if (datos) {
    productoPedido.value = JSON.parse(datos);
    // Asumiendo que la imagen viene en el nombre del objeto
    imagenLocal.value = `/src/assets/${productoPedido.value.imagen}`; 
  }
});
</script>

<style scoped>
.seccion-compra { padding: 20px; text-align: center; }
.detalle-producto { border: 1px solid #ccc; padding: 20px; border-radius: 10px; }
.btn-confirmar { background: green; color: white; padding: 10px; border: none; cursor: pointer; }
</style>