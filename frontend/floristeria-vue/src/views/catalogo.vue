<!-- filepath: c:\Users\egam4\Desktop\Rosas-main\frontend\floristeria-vue\src\views\catalogo.vue -->
<template>
  <section class="catalogo-pagina">
    <header class="catalogo-header">
      <p class="etiqueta">Nuestras flores</p>
      <h1>Catálogo de productos</h1>
      <p>Encuentra el detalle perfecto para cada ocasión.</p>
    </header>

    <div class="busqueda-filtros">
      <div class="barra-busqueda">
        <span class="icono-lupa">⌕</span>
        <input
          v-model="busqueda"
          type="search"
          placeholder="Buscar productos..."
          aria-label="Buscar productos"
        />
      </div>

      <button
        class="btn-filtros"
        type="button"
        @click="mostrarFiltros = !mostrarFiltros"
        :aria-expanded="mostrarFiltros"
      >
        <span>☷</span>
        Filtros
      </button>
    </div>

    <div v-if="mostrarFiltros" class="filtros">
      <div class="filtro-seccion">
        <h3>Tipo</h3>
        <div class="filtros-grupo">
          <button :class="{ activo: filtroTipo === '' }" @click="filtroTipo = ''">Todos</button>
          <button :class="{ activo: filtroTipo === 1 }" @click="filtroTipo = 1">Flores sueltas</button>
          <button :class="{ activo: filtroTipo === 2 }" @click="filtroTipo = 2">Ramos</button>
          <button :class="{ activo: filtroTipo === 3 }" @click="filtroTipo = 3">Arreglos</button>
          <button :class="{ activo: filtroTipo === 4 }" @click="filtroTipo = 4">Detalles</button>
          <button :class="{ activo: filtroTipo === 5 }" @click="filtroTipo = 5">Accesorios</button>
        </div>
      </div>

      <div class="filtro-seccion">
        <h3>Ocasión</h3>
        <div class="filtros-grupo">
          <button :class="{ activo: filtroOcasion === '' }" @click="filtroOcasion = ''">Todas</button>
          <button :class="{ activo: filtroOcasion === 10 }" @click="filtroOcasion = 10">Bodas</button>
          <button :class="{ activo: filtroOcasion === 11 }" @click="filtroOcasion = 11">Cumpleaños</button>
          <button :class="{ activo: filtroOcasion === 12 }" @click="filtroOcasion = 12">Ceremonias</button>
          <button :class="{ activo: filtroOcasion === 14 }" @click="filtroOcasion = 14">Corporativos</button>
          <button :class="{ activo: filtroOcasion === 15 }" @click="filtroOcasion = 15">Graduaciones</button>
        </div>
      </div>
    </div>

    <div v-if="cargando" class="sin-resultados">Cargando productos...</div>

    <div v-else-if="productosFiltrados.length" class="cuadricula-productos">
      <article
        v-for="producto in productosFiltrados"
        :key="producto.idProducto"
        class="tarjeta-producto"
      >
        <div class="contenedor-img-producto">
          <img
            :src="obtenerRutaImagen(producto.imagen)"
            :alt="producto.nombreProducto"
            loading="lazy"
          />
        </div>

        <div class="producto-contenido">
          <h3>{{ producto.nombreProducto }}</h3>
          <span class="precio-producto">$ {{ producto.precioActual }}</span>
          <div class="acciones-producto">
            <button @click="iniciarCompra(producto)" class="btn-pedido">
              Comprar ahora
            </button>
            <button @click="agregarAlCarrito(producto)" class="btn-carrito">
              Agregar al carrito
            </button>
          </div>
        </div>
      </article>
    </div>

    <p v-else class="sin-resultados">
      No encontramos productos con esos filtros.
    </p>
  </section>
</template>

<script>
const imagenes = import.meta.glob('../assets/**/*', {
  eager: true,
  query: '?url',
  import: 'default'
})

export default {
  name: 'Catalogo',

  data() {
    return {
      productos: [],
      busqueda: '',
      mostrarFiltros: false,
      filtroTipo: '',
      filtroOcasion: '',
      cargando: true
    }
  },

  computed: {
    productosFiltrados() {
      const texto = this.normalizarTexto(this.busqueda)

      return this.productos.filter(producto => {
        const nombre = this.normalizarTexto(producto.nombreProducto)

        const coincideNombre =
          !texto || nombre.includes(texto)

        const coincideCategoria =
          !texto || this.coincideConCategoria(texto, producto)

        const coincideTipo =
          !this.filtroTipo || producto.id_tipo == this.filtroTipo

        const coincideOcasion =
          !this.filtroOcasion || producto.id_ocasion == this.filtroOcasion

        return (coincideNombre || coincideCategoria) &&
          coincideTipo &&
          coincideOcasion
      })
    }
  },

  mounted() {
    fetch('http://localhost/backend/get_productos.php')
      .then(response => response.json())
      .then(data => {
        this.productos = Array.isArray(data) ? data : []
      })
      .catch(error => console.error('Error al traer productos:', error))
      .finally(() => {
        this.cargando = false
      })
  },

  methods: {
    obtenerRutaImagen(rutaImagen) {
      if (!rutaImagen) return ''

      const ruta = String(rutaImagen)
        .replace(/\\/g, '/')
        .replace(/^\/+/, '')
        .trim()

      const imagen = Object.entries(imagenes).find(([archivo]) => {
        const archivoNormalizado = archivo.replace(/\\/g, '/')
        return archivoNormalizado.endsWith(`/assets/${ruta}`)
      })

      if (!imagen) {
        console.warn('Imagen no encontrada:', ruta)
        return ''
      }

      return imagen[1]
    },

    iniciarCompra(producto) {
      localStorage.setItem('productoSeleccionado', JSON.stringify(producto))
      this.$router.push('/procesar-compra')
    },

    agregarAlCarrito(producto) {
      const carrito = JSON.parse(localStorage.getItem('carrito') || '[]')
      const productoExistente = carrito.find(item => item.producto.idProducto === producto.idProducto)

      if (productoExistente) {
        productoExistente.cantidad += 1
      } else {
        carrito.push({ producto, cantidad: 1 })
      }

      localStorage.setItem('carrito', JSON.stringify(carrito))
      window.dispatchEvent(new Event('carrito-actualizado'))
    },

    normalizarTexto(texto) {
      return String(texto || '')
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .trim()
    },

    coincideConCategoria(texto, producto) {
      const categorias = {
        boda: {
          id: 10,
          palabras: ['boda', 'bodas', 'novia', 'matrimonio', 'nupcial']
        },
        cumpleaños: {
          id: 11,
          palabras: ['cumple', 'cumpleanos', 'cumpleaños', 'aniversario']
        },
        ceremonia: {
          id: 12,
          palabras: ['ceremonia', 'ceremonias', 'religioso', 'religiosa']
        },
        corporativo: {
          id: 14,
          palabras: ['corporativo', 'corporativos', 'empresa', 'empresarial']
        },
        graduacion: {
          id: 15,
          palabras: ['graduacion', 'graduaciones', 'graduado', 'promocion']
        },
        flores: {
          id: 1,
          palabras: ['flor', 'flores', 'flor suelta']
        },
        ramos: {
          id: 2,
          palabras: ['ramo', 'ramos', 'bouquet']
        },
        arreglos: {
          id: 3,
          palabras: ['arreglo', 'arreglos', 'centro de mesa']
        },
        detalles: {
          id: 4,
          palabras: ['detalle', 'detalles', 'regalo']
        },
        accesorios: {
          id: 5,
          palabras: ['accesorio', 'accesorios']
        }
      }

      return Object.values(categorias).some(categoria => {
        const palabraEncontrada = categoria.palabras.some(palabra =>
          texto.includes(this.normalizarTexto(palabra))
        )

        return palabraEncontrada &&
          (producto.id_ocasion == categoria.id ||
           producto.id_tipo == categoria.id)
      })
    }
  }
}
</script>

<style scoped>
.catalogo-pagina {
  max-width: 1250px;
  margin: auto;
  padding: 45px 24px 70px;

}

.catalogo-header {
  text-align: center;
  margin-bottom: 30px;
}

.catalogo-header h1 {
  margin: 8px 0;
  color: var(--color-texto);
  font-size: clamp(28px, 4vw, 42px);
}

.catalogo-header p {
  color: var(--color-secundario);
}

.etiqueta {
  color: var(--color-principal) !important;
  font-weight: bold;
  text-transform: uppercase;
  letter-spacing: 2px;
  font-size: 13px;
}

.busqueda-filtros {
  display: flex;
  gap: 12px;
  margin-bottom: 18px;
}

.barra-busqueda {
  display: flex;
  align-items: center;
  flex: 1;
  min-height: 48px;
  padding: 0 16px;
  background: var(--color-superficie);
  border: 1px solid var(--color-borde);
  border-radius: 14px;
  box-shadow: var(--sombra);
}

.icono-lupa {
  margin-right: 10px;
  color: var(--color-principal);
  font-size: 28px;
  line-height: 1;
}

.barra-busqueda input {
  width: 100%;
  border: 0;
  outline: 0;
  background: transparent;
  color: var(--color-texto);
  font-size: 16px;
}

.btn-filtros {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0 18px;
  border: 0;
  border-radius: 14px;
  background: var(--color-principal);
  color: white;
  font-weight: bold;
  cursor: pointer;
}

.btn-filtros:hover,
.btn-pedido:hover {
  background: var(--color-principal-hover);
}

.filtros {
  display: flex;
  flex-wrap: wrap;
  gap: 25px;
  justify-content: center;
  padding: 22px;
  margin-bottom: 35px;
  background: var(--color-superficie);
  border: 1px solid var(--color-borde);
  border-radius: 18px;
  box-shadow: var(--sombra);
}

.filtro-seccion h3 {
  margin: 0 0 10px;
  text-align: center;
  color: var(--color-texto);
}

.filtros-grupo {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 8px;
}

.filtros button {
  padding: 9px 14px;
  border: 1px solid var(--color-borde);
  border-radius: 20px;
  background: transparent;
  color: var(--color-secundario);
  cursor: pointer;
}

.filtros button:hover,
.filtros button.activo {
  background: var(--color-principal);
  border-color: var(--color-principal);
  color: white;
}

.cuadricula-productos {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
  gap: 25px;
}

.tarjeta-producto {
  overflow: hidden;
  background: var(--color-superficie);
  border: 1px solid var(--color-borde);
  border-radius: 18px;
  box-shadow: var(--sombra);
}

.contenedor-img-producto {
  aspect-ratio: 1 / 1;
  overflow: hidden;
  background: #f8e9ef;
}

.contenedor-img-producto img {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;
  object-position: center;
}

.producto-contenido {
  padding: 18px;
}

.producto-contenido h3 {
  min-height: 48px;
  margin: 0 0 10px;
  color: var(--color-texto);
  font-size: 18px;
}

.precio-producto {
  display: block;
  margin-bottom: 16px;
  color: var(--color-principal);
  font-size: 20px;
  font-weight: bold;
}

.btn-pedido {
  width: 100%;
  padding: 11px;
  border: 0;
  border-radius: 10px;
  background: var(--color-principal);
  color: white;
  font-weight: bold;
  cursor: pointer;
}

.acciones-producto {
  display: grid;
  gap: 8px;
}

.btn-carrito {
  width: 100%;
  padding: 10px;
  border: 1px solid var(--color-principal);
  border-radius: 10px;
  background: transparent;
  color: var(--color-principal);
  font-weight: bold;
  cursor: pointer;
}

.btn-carrito:hover {
  background: var(--color-principal);
  color: white;
}

.sin-resultados {
  padding: 35px;
  text-align: center;
  color: var(--color-secundario);
}

@media (max-width: 600px) {
  .catalogo-pagina {
    padding: 30px 14px 50px;
    
  }

  .btn-filtros {
    padding: 0 14px;
    font-size: 0;
  }

  .btn-filtros span {
    font-size: 24px;
  }

  .cuadricula-productos {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px;
  }

  .producto-contenido {
    padding: 12px;
  }

  .producto-contenido h3 {
    font-size: 15px;
  }

  .precio-producto {
    font-size: 17px;
  }
}
</style>