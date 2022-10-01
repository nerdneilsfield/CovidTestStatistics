<template>
  <footer>
    <van-divider
      :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"
    >
      &copy; 2022 Shu YuHao; 数据仅供参考!
    </van-divider>
  </footer>
</template>

<style scoped></style>

<script lang="ts">
import { defineComponent } from "vue";
export default defineComponent({
  name: "Footer",
  setup() {
    return {};
  },
});
</script>
