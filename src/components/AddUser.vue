<template>
  <section>
    <van-form @submit="onSubmit">
      <van-cell-group inset>
        <van-field
          v-model="email"
          clearable
          name="邮箱"
          label="邮箱"
          placeholder="密码"
          :rules="[
            { required: true, message: '请填写邮箱' },
            { validator, message: '请输入正确的邮箱地址' },
          ]"
        />
        <van-field
          v-model="password"
          type="password"
          clearable
          name="密码"
          label="密码"
          placeholder="密码"
          :rules="[{ required: true, message: '请填写密码' }]"
        />
        <van-field
          v-model="pastedData"
          rows="5"
          clearable
          label="粘贴用户"
          type="textarea"
          placeholder="请在这里粘贴复制的用户表格(每行为学号\t姓名), 注意不要复制头"
        />
      </van-cell-group>
      <div style="margin: 16px">
        <div id="buttons">
          <van-button round block type="primary" @click="onProcess">
            解析
          </van-button>
          <van-button round block type="success" @click="onSubmit">
            上传
          </van-button>
        </div>
      </div>
    </van-form>

    <van-notice-bar v-show="show" left-icon="volume-o" :text="displayStr" />

    <van-list
      v-show="show"
      v-model:loading="loading"
      :finished="finished"
      finished-text="解析完毕"
    >
      <van-cell
        v-for="user in userList"
        center
        :key="user"
        size="large"
        :title="user[0]"
        :value="user[1]"
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
  name: "AddUser",
  setup() {
    const email = ref("");
    const password = ref("");
    const pastedData = ref("");
    const show = ref(false);
    const loading = ref(false);
    const finished = ref(false);
    const userList = ref<any[]>([]);
    const displayStr = ref("");

    // use regex to validate email address
    const validator = (val: string) => {
      const reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
      return reg.test(val);
    };

    const onProcess = async () => {
      show.value = true;
      loading.value = true;
      const data = pastedData.value;
      const lines = data.split("\n");
      const splitData = lines.map((line) => {
        const [id, name] = line.split("\t");
        if (id !== null && name !== null) {
          return [id, name];
        } else {
          return null;
        }
      });
      //       console.log(splitData);
      // remove empty lines
      userList.value = splitData.filter(
        (item) =>
          item != null &&
          item.length === 2 &&
          item[0] != undefined &&
          item[1] != undefined
      );
      //       console.log(userList.value);
      Notify(`解析了 ${userList.value.length} 个用户记录`);
      displayStr.value = `解析了 ${userList.value.length} 个用户记录`;
      console.log(displayStr.value);
      loading.value = false;
      finished.value = true;
    };

    const onSubmit = async () => {
      const userListToUpload = userList.value.map((user) => {
        return {
          school_id: Number(user[0]) as Number,
          name: user[1] as String,
          late_count: 0 as Number,
        };
      });
      if (userListToUpload.length === 0) {
        Notify("请先解析表格或者无用户可以上传");
        displayStr.value = `请先解析表格或者无用户可以上传`;
        console.log(displayStr.value);
        return;
      }

      const userAuthData1 = await client.users.authViaEmail(
        email.value,
        password.value
      );

      if (userAuthData1.user !== null) {
        Notify("登录成功");
        displayStr.value = `登录成功`;
        console.log(displayStr.value);
      } else {
        Notify("登录失败");
        displayStr.value = `登录失败`;
        console.log(displayStr.value);
        return;
      }

      const alreadyUserList = await client.records.getFullList("users", 1000);
      const alreadyUserListId = alreadyUserList.map(
        (user) => user.school_id as Number
      );
      //       console.log(alreadyUserListId);

      // for user in userListToUpload:
      for (let i = 0; i < userListToUpload.length; i++) {
        let user = userListToUpload[i];
        // console.log(user);
        // console.log(already_list);
        if (alreadyUserListId.includes(user.school_id)) {
          Notify(`用户 ${user.name} 已存在`);
          displayStr.value = `用户 ${user.name} 已存在`;
          console.log(displayStr.value);
        } else {
          //   console.log("creting user");
          // 必须防止并发写入，不然会失败
          const userRecord = await client.records.create("users", user);
          if (userRecord !== null) {
            console.log(`用户 ${user.name} 创建成功`);
            console.log(displayStr.value);
          } else {
            console.log(`用户 ${user.name} 创建失败`);
            console.log(displayStr.value);
          }

          //   console.log("userRecord", userRecord);
        }
      }
      displayStr.value = `上传完毕`;
    };

    return {
      email,
      password,
      pastedData,
      show,
      loading,
      finished,
      userList,
      displayStr,
      validator,
      onSubmit,
      onProcess,
    };
  },
});
</script>
