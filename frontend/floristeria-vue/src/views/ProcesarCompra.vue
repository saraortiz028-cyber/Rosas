<template>
  <div class="seccion-compra">
    <h2>{{ esCompraDirecta ? 'Finalizar Pedido' : 'Mi carrito' }}</h2>

    <div v-if="itemsCarrito.length" class="carrito-contenido">
      <div v-for="item in itemsCarrito" :key="item.producto.idProducto" class="detalle-producto">
        <img :src="obtenerRutaImagen(item.producto.imagen)" :alt="item.producto.nombreProducto">
        <div class="producto-info">
          <h3>{{ item.producto.nombreProducto }}</h3>
          <p>Precio: ${{ item.producto.precioActual }}</p>
          <label>
            Cantidad
            <input v-model.number="item.cantidad" type="number" min="1" @change="actualizarCantidad(item)">
          </label>
          <button class="btn-eliminar" type="button" @click="eliminarDelCarrito(item)">Eliminar</button>
        </div>
      </div>

      <p class="total-carrito">Total: ${{ totalCarrito.toFixed(2) }}</p>
      <button class="btn-confirmar" type="button" :disabled="guardando" @click="confirmarPedido">
        {{ guardando ? 'Registrando...' : 'Confirmar Pedido' }}
      </button>
    </div>

    <div v-else>
      <p>Tu carrito está vacío.</p>
      <button class="btn-confirmar" type="button" @click="router.push('/catalogo')">Ver catálogo</button>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

const imagenes = import.meta.glob('../assets/**/*', { eager: true, query: '?url', import: 'default' });
const itemsCarrito = ref([]);
const esCompraDirecta = ref(false);
const guardando = ref(false);
const router = useRouter();

onMounted(() => {
  const productoDirecto = localStorage.getItem('productoSeleccionado');
  if (productoDirecto) {
    itemsCarrito.value = [{ producto: JSON.parse(productoDirecto), cantidad: 1 }];
    esCompraDirecta.value = true;
  } else {
    itemsCarrito.value = JSON.parse(localStorage.getItem('carrito') || '[]');
  }
});

const totalCarrito = computed(() => itemsCarrito.value.reduce((total, item) => {
  return total + Number(item.producto.precioActual || 0) * Number(item.cantidad || 0);
}, 0));

function obtenerRutaImagen(rutaImagen) {
  const ruta = String(rutaImagen || '').replace(/\\/g, '/').replace(/^\/+/, '').trim();
  const imagen = Object.entries(imagenes).find(([archivo]) => archivo.replace(/\\/g, '/').endsWith(`/assets/${ruta}`));
  return imagen ? imagen[1] : '';
}

function actualizarCantidad(item) {
  item.cantidad = Math.max(1, Number(item.cantidad) || 1);
  guardarCarrito();
}

function eliminarDelCarrito(item) {
  itemsCarrito.value = itemsCarrito.value.filter(actual => actual !== item);
  guardarCarrito();
}

function guardarCarrito() {
  if (!esCompraDirecta.value) {
    localStorage.setItem('carrito', JSON.stringify(itemsCarrito.value));
  }
  window.dispatchEvent(new Event('carrito-actualizado'));
}

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
    for (const item of itemsCarrito.value) {
      for (let cantidad = 0; cantidad < item.cantidad; cantidad += 1) {
        const respuesta = await fetch('http://localhost:3000/api/pedidos', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ clienteId: cliente.id, productoId: item.producto.idProducto })
        });
        const datos = await respuesta.json();
        if (!respuesta.ok) throw new Error(datos.error || 'No se pudo registrar la compra');
      }
    }

    localStorage.removeItem('productoSeleccionado');
    localStorage.removeItem('carrito');
    itemsCarrito.value = [];
    window.dispatchEvent(new Event('carrito-actualizado'));
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
.seccion-compra { max-width: 760px; margin: auto; padding: 40px 20px 70px; text-align: center; }
.carrito-contenido { display: grid; gap: 14px; }
.detalle-producto { display: flex; gap: 18px; align-items: center; background: var(--color-superficie); border: 1px solid var(--color-borde); padding: 16px; border-radius: 10px; box-shadow: var(--sombra); text-align: left; }
.detalle-producto img { width: 110px; height: 110px; flex-shrink: 0; object-fit: cover; border-radius: 8px; background: var(--color-fondo); }
.producto-info { flex: 1; }
.producto-info h3 { margin: 0 0 8px; color: var(--color-texto); }
.producto-info p { margin: 0 0 12px; color: var(--color-secundario); }
.producto-info label { display: flex; align-items: center; gap: 8px; color: var(--color-texto); font-size: 14px; }
.producto-info input { width: 64px; padding: 7px; border: 1px solid var(--color-borde); border-radius: 6px; background: var(--color-superficie); color: var(--color-texto); }
.btn-eliminar { margin-top: 12px; padding: 0; border: 0; background: transparent; color: var(--color-principal); cursor: pointer; }
.total-carrito { margin: 8px 0; color: var(--color-texto); font-size: 20px; font-weight: bold; text-align: right; }
.btn-confirmar { background: var(--color-principal); color: white; padding: 11px 18px; border: none; border-radius: 6px; cursor: pointer; }
.btn-confirmar:hover { background: var(--color-principal-hover); }
.btn-confirmar:disabled { cursor: wait; opacity: 0.7; }

@media (max-width: 500px) {
  .detalle-producto { align-items: flex-start; }
  .detalle-producto img { width: 80px; height: 80px; }
}
</style>