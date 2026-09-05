<template>
  <main class="inicio">
    <section class="hero">
      <div class="hero-contenido">
        <span class="etiqueta">Rosa Eterna</span>

        <h1>Momentos que florecen</h1>

     

        <router-link to="/catalogo" class="btn-principal">
          Explorar catálogo
          <span>→</span>
        </router-link>

        <div class="beneficios">
          <span>✦ Flores frescas</span>
          <span>✦ Entrega a domicilio</span>
        </div>
      </div>
    </section>
  </main>
</template>

<script>
export default {
  name: 'Inicio'
}
</script>

<style scoped>
.inicio {
  min-height: calc(100vh - 80px);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--color-texto);
}

.hero {
  width: 100%;
  max-width: 1120px;
  margin: auto;
  padding: 70px 30px;
  text-align: center;
}

.hero-contenido {
  max-width: 600px;
  margin: auto;
}

.etiqueta {
  color: var(--color-principal);
  font-size: 13px;
  font-weight: bold;
  letter-spacing: 3px;
  text-transform: uppercase;
}

h1 {
  margin: 16px 0;
  font-family: Georgia, serif;
  font-size: clamp(44px, 7vw, 76px);
  font-weight: 500;
  line-height: 1.05;
}



.btn-principal {
  display: inline-flex;
  align-items: center;
  gap: 18px;
  padding: 15px 23px;
  border-radius: 30px;
  background: var(--color-principal);
  color: white;
  font-weight: bold;
  text-decoration: none;
  box-shadow: 0 8px 20px rgba(194, 24, 91, 0.25);
  transition: 0.25s ease;
}

.btn-principal:hover {
  background: var(--color-principal-hover);
  transform: translateY(-3px);
}

.btn-principal span {
  font-size: 22px;
}

.beneficios {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 18px;
  margin-top: 30px;
  color: var(--color-principal);
  font-size: 14px;
}

@media (max-width: 700px) {
  .inicio {
    min-height: calc(100vh - 70px);
  }

  .hero {
    padding: 55px 24px;
    text-align: center;
  }

  .hero-contenido {
    max-width: 100%;
  }

  .hero-contenido p {
    margin-right: auto;
    margin-left: auto;
  }

  .btn-principal {
    margin: auto;
  }

  .beneficios {
    justify-content: center;
  }
}
</style>