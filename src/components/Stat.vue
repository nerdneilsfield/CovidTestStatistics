<template>
  <section>
    <van-form @submit="onSubmit">
      <van-cell-group inset>
        <van-field
          left-icon="smile-o"
          label="每页人数:"
          v-model="itemPerPage"
          name="itemPerPage"
          placeholder="每页显示的人数"
          :rules="[{ validator, message: '请输入正确的页码' }]"
          error
          required
        />
      
      </van-cell-group>
      <!-- <div style="margin: 16px"> -->
        <van-button round block plain  type="primary" native-type="submit">
          设置
        </van-button>
      <!-- </div> -->
    </van-form>
    <div id="buttons">
      <van-button round plain type="success" @click="onLastPage" size="small">
        上一页
      </van-button>
      <van-button round plain type="warning" @click="onLoad" size="small">
        载入
      </van-button>
      <van-button round plain type="success" @click="onNextPage" size="small">
        下一页
      </van-button>
    </div>

    <van-notice-bar v-show="show" left-icon="volume-o" :text="displayStr" />

    <van-list
      v-show="show"
      v-model:loading="loading"
      :finished="finished"
      finished-text="载入完毕"
    >
      <van-cell
        v-for="item in userList"
        center
        :key="item"
        size="large"
        :title="item[0]"
        :value="item[2]"
        :label="item[1]"
        icon="friends-o"
      >
      </van-cell>
    </van-list>
  </section>
</template>

<style scoped>
#buttons {
  margin: 16px;
  display: flex;
  justify-content: space-between;
}
.wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
}

.block {
  width: 120px;
  height: 120px;
  background-color: #fff;
}
</style>

<script lang="ts">
import { defineComponent, ref } from "vue";
import { Notify } from "vant";
import PocketBase from "pocketbase";

const client = new PocketBase(window.location.origin);

export default defineComponent({
  name: "Stat",
  setup() {
    const show = ref(false);
    const loading = ref(false);
    const finished = ref(false);
    const userList = ref<any[]>([]);
    const currentPage = ref(1);
    const itemPerPage = ref(50);
    const displayStr = ref("");

    const validator = (val: string) => {
      return /^[0-9]+$/.test(val);
    };

    const onSubmit = async (values: any) => {
      if (values.itemPerPage) {
        itemPerPage.value = values.itemPerPage;
        currentPage.value = 1;
      }
    };

    const onNextPage = async () =>  {
      currentPage.value += 1;
      await onLoad();
    };

    const onLastPage = async () => {
      if (currentPage.value > 1) {
        currentPage.value -= 1;
        await onLoad();
      } else {
        Notify("已经是第一页啦");
      }
    };

    const onLoad = async () => {
      show.value = true;
      loading.value = true;
      const resultList = await client.records.getList(
        "users",
        currentPage.value,
        itemPerPage.value,
        {
          sort: "-late_count",
        }
      );

      userList.value = resultList.items.map((item: any) => [
        item.name,
        item.school_id,
        item.late_count,
      ]);

      loading.value = false;
      finished.value = true;
      displayStr.value = `现在是第${currentPage.value}页`;
    };

    return {
      show,
      loading,
      finished,
      userList,
      displayStr,
      itemPerPage,
      validator,
      onSubmit,
      onLastPage,
      onNextPage,
      onLoad,
    };
  },
});
</script>
