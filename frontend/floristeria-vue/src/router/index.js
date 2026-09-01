 import { createRouter, createWebHistory } from 'vue-router'
import Inicio from '../views/Inicio.vue'
import catalogo from '../views/catalogo.vue'
import rastrearPedidos from '../views/rastrearPedidos.vue'
import ProcesarCompra from '../views/ProcesarCompra.vue'
import Auth from '../views/Auth.vue' // <--- 1. Importa la nueva vista

const routes = [
  { path: '/', name: 'Inicio', component: Inicio },
  { path: '/catalogo', name: 'catalogo', component: catalogo },
  { path: '/rastrearPedidos', name: 'rastrearPedidos', component: rastrearPedidos },
  { path: '/procesar-compra', name: 'ProcesarCompra', component: ProcesarCompra },
  { path: '/auth', name: 'Auth', component: Auth } // <--- 2. Agrega la ruta aquí
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router 