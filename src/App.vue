<template>
  <header></header>

  <main>
    <div class="title">
      <h2 id="title">上海科技大学7号楼核酸迟交次数查询系统</h2>
    </div>
    <LookUp />
    <Footer />
  </main>
</template>

<style scoped>
header {
  line-height: 1.5;
}

.title {
  display: flex;
  align-items: center;
  justify-content: center;
  /* height: 100%; */
}

main {
  align-items: center;
  max-width: 900px;
}

/* @media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
  }
} */
</style>

<script setup lang="ts">
import LookUp from "./components/LookUp.vue";
import Footer from "./components/Footer.vue";
</script>
