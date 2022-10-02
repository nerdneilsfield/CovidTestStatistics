<template>
  <section>
    <van-form @submit="onSubmit">
      <van-cell-group inset>
        <van-field
          left-icon="smile-o"
          label="学号"
          v-model="school_id"
          name="school_id"
          placeholder="请输入学号"
          :rules="[{ validator, message: '请输入正确的学号' }]"
          error
          required
        />
      </van-cell-group>
      <div style="margin: 16px">
        <van-button round block type="primary" native-type="submit">
          查询
        </van-button>
      </div>
    </van-form>

    <van-notice-bar v-show="show" left-icon="volume-o" :text="displayStr" />

    <van-list
      v-show="show"
      v-model:loading="loading"
      :finished="finished"
      finished-text="没有更多了"
    >
      <van-cell
        v-for="item in lateList"
        center
        :key="item"
        size="large"
        :title="item[0]"
        :value="item[1]"
        icon="location-o"
      >
      </van-cell>
    </van-list>
  </section>
</template>

<style scoped>
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
  name: "LookUp",
  setup() {
    const school_id = ref("");
    const show = ref(false);
    const lateList = ref<any[]>([]);
    const loading = ref(false);
    const finished = ref(false);
    const displayStr = ref("");
    const validator = (val: string) => /\d{9,10}/.test(val);

    const onSubmit = async (values: any) => {
      //       console.log("submit", values);
      const resultList = await client.records.getFullList("users", 200, {
        filter: "school_id = " + values.school_id,
      });
      //       console.log(resultList);
      if (resultList.length === 0) {
        Notify("学号不存在");
      } else {
        loading.value = true;
        const lateListGet = await client.records.getFullList(
          "late_record",
          200 /* batch size */,
          {
            sort: "-date",
            filter: "school_id = " + values.school_id,
          }
        );
        show.value = true;
        loading.value = false;
        finished.value = true;

        lateList.value = lateListGet.map((item: any) => {
          return [item.school_id, item.date];
        });

        // console.log(lateList.value.length);

        // console.log(lateListGet);
        displayStr.value = `${resultList[0].name} 已迟交${lateListGet.length}次`;
      }
    };
    return {
      school_id,
      onSubmit,
      validator,
      show,
      lateList,
      loading,
      finished,
      displayStr,
    };
  },
});
</script>
