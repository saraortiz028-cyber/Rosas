<template>
  <div class="filtros">
    <h3>Tipo</h3>
    <div class="filtros-grupo">
       <button @click="filtroTipo=''">Todos</button>
       <button @click="filtroTipo=1">Flores sueltas</button>
       <button @click="filtroTipo=2">Ramos</button>
       <button @click="filtroTipo=3">Arreglos</button>
       <button @click="filtroTipo=4">Detalle individual</button>
       <button @click="filtroTipo=5">Accesorios</button>
    </div> 
    
    <h3>Ocasión</h3>
    <div class="filtros-grupo">
       <button @click="filtroOcasion=''">Todas</button>
       <button @click="filtroOcasion=10">Bodas</button>
       <button @click="filtroOcasion=11">Cumpleaños</button>
       <button @click="filtroOcasion=12">Ceremonias religiosas</button>
       <button @click="filtroOcasion=14">Eventos corporativos</button>
       <button @click="filtroOcasion=15">Actos y graduaciones</button>
    </div>
  </div>

  <main class="catalogo-seccion">
    <div class="cuadricula-productos">
      <div
        class="tarjeta-producto"
        v-for="producto in productosFiltrados"
        :key="producto.idProducto"
      >
        <div class="contenedor-img-producto">
          <img :src="obtenerRutaImagen(producto.imagen)" :alt="producto.nombreProducto">
        </div>

        <h3>{{ producto.nombreProducto }}</h3>
        <span class="precio-producto">$ {{ producto.precioActual }}</span>

        <!-- Botón modificado para enviar a compra -->
        <button @click="iniciarCompra(producto)" class="btn-pedido">
          Pedir ahora
        </button>
      </div>
    </div>
  </main>
</template>

<script>
const imagenes = import.meta.glob(
  '../assets/**/*.{jpg,jpeg,png}',
  { eager: true, import: 'default' }
);

export default {
  name: 'Catalogo',
  data() {
    return {
      productos: [],
      filtroTipo: '',
      filtroOcasion: ''
    }
  },
  computed: {
    productosFiltrados() {
      return this.productos.filter(producto => {
        const coincideTipo = !this.filtroTipo || producto.id_tipo == this.filtroTipo;
        const coincideOcasion = !this.filtroOcasion || producto.id_ocasion == this.filtroOcasion;
        return coincideTipo && coincideOcasion;
      });
    }
  },
  mounted() {
    fetch('http://localhost/floristeria/backend/get_productos.php')
      .then(response => response.json())
      .then(data => { this.productos = data; })
      .catch(error => console.error("Error al traer productos:", error));
  },
  methods: {
    obtenerRutaImagen(rutaImagen) {
      const rutaCompleta = `../assets/${rutaImagen}`;
      return imagenes[rutaCompleta];
    },
    iniciarCompra(producto) {
      localStorage.setItem('productoSeleccionado', JSON.stringify(producto));
      this.$router.push('/procesar-compra');
    }
  }
}
</script>