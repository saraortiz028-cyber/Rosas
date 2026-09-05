<template>
  <main class="contenedor-rastreo">

    <div class="tarjeta-rastreo">

      <h1 class="titulo-rastreo">
        Rastrea tu Pedido
      </h1>

      <p class="subtitulo-rastreo">
        Ingresa tu número de pedido para conocer el estado de tus flores.
      </p>

      <div class="formulario-busqueda">
        <div class="barra-rastreo">
          <input
            type="text"
            v-model="numeroPedido"
            placeholder="# Número de Pedido (Ej: 15)"
            class="input-rastreo"
          >
        </div>

        <button
          class="btn-buscar"
          @click="buscarPedido"
        >
          Rastrear
        </button>

      </div>

      <div class="detalles-pedido"
       v-if="pedidoEncontrado">
        <div>
          <h3>
            Pedido:
            <strong>{{ numeroPedido || '#RE-1045' }}</strong>
          </h3>
        </div>

        <div>
          <p>
           <strong>Destinatario:</strong>
           {{ pedido.nombreDestinatario }}
          </p>
        </div>

        <div>
          <p>
            <strong>Entrega estimada:</strong>
            {{ pedido.fechaEntrega }}
          </p>
        </div>

      </div>

      <div class="timeline"
      v-if="pedidoEncontrado">

        <div class="timeline-paso completado">
          <div class="icono-paso">✓</div>
          <div class="texto-paso">
            <h4>Pedido Confirmado</h4>
            <p>Hemos recibido tu pedido.</p>
          </div>
        </div>

        <div class="timeline-paso completado">
          <div class="icono-paso">✓</div>
          <div class="texto-paso">
            <h4>En Preparación</h4>
            <p>Nuestros floristas están creando tu arreglo.</p>
          </div>
        </div>

        <div class="timeline-paso activo">
          <div class="icono-paso">🚚</div>
          <div class="texto-paso">
            <h4>En Camino</h4>
            <p>Tu pedido está en ruta de entrega.</p>
          </div>
        </div>

        <div class="timeline-paso pendiente">
          <div class="icono-paso">🎁</div>
          <div class="texto-paso">
            <h4>Entregado</h4>
            <p>Esperando confirmación de entrega.</p>
          </div>
        </div>

      </div>

    </div>

  </main>
</template>

<script>
export default {
  name: 'Rastreo',

  data() {
  return {
    numeroPedido: '',
    pedidoEncontrado: false,

    pedido: {}
  }
},

  methods: {
    async buscarPedido() {

  const respuesta = await fetch(
  `http://localhost/floristeria/backend/rastrear_pedidos.php?idPedido=${this.numeroPedido}`
);

  const datos = await respuesta.json();

  if (!datos.error) {

    this.pedido = datos;
    this.pedidoEncontrado = true;

  } else {

    alert("Pedido no encontrado");
    this.pedidoEncontrado = false;
    }
  }
}
}
</script>

<style scoped>
.formulario-busqueda {
  display: flex;
  gap: 12px;
  width: 100%;
}

.barra-rastreo {
  display: flex;
  align-items: center;
  flex: 1;
  min-height: 48px;
  padding: 0 16px;
  background: var(--color-superficie, #ffffff);
  border: 1px solid var(--color-borde, #ead1d8);
  border-radius: 14px;
  box-shadow: var(--sombra, 0 4px 14px rgba(59, 31, 36, 0.08));
}

.input-rastreo {
  flex: 1;
  min-width: 0;
  border: 0;
  outline: 0;
  background: transparent;
  color: var(--color-texto, #3b1f24);
  font-size: 16px;
}

.btn-buscar {
  display: flex;
  align-items: center;
  min-height: 48px;
  padding: 0 18px;
  border: 0;
  border-radius: 14px;
  background: var(--color-principal, #ea5e78);
  color: #ffffff;
  font-weight: bold;
  cursor: pointer;
}

.btn-buscar:hover {
  background: var(--color-principal-hover, #c45475);
}

@media (max-width: 600px) {
  .formulario-busqueda {
    gap: 8px;
  }

  .barra-rastreo {
    padding: 0 12px;
  }

  .btn-buscar {
    padding: 0 14px;
  }
}
</style>