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

        <input
          type="text"
          v-model="numeroPedido"
          placeholder="# Número de Pedido (Ej: 15)"
          class="input-rastreo"
        >

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