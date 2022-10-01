<template>
  <header></header>

  <main>
    <div class="title">
      <h2 id="title">添加迟交记录</h2>
    </div>
    <AddRecord />
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
  max-width: 50em;
  min-width: 25em;
}

@media (min-width: 1024px) {
  main {
    align-items: center;
    max-width: 800em;
  }
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
import AddRecord from "@/components/AddRecord.vue";
import Footer from "@/components/Footer.vue";
</script>
