<template>
  <v-row>
    <v-col offset-md="1" md="10" class="mt-3">
      <h3 class="text-center">登録ページ</h3>

      <Notification :message="error" v-if="error" class="mb-4 pb-3" />

      <form @submit.prevent="signup">
        <v-text-field v-model="name" label="名前" required type="text">
        </v-text-field>
        <v-text-field
          v-model="email"
          label="メールアドレス"
          required
          type="email"
        >
        </v-text-field>
        <v-text-field
          v-model="password"
          label="パスワード"
          required
          type="password"
        ></v-text-field>
        <v-text-field
          v-model="password_confirmation"
          label="パスワ確認用"
          required
          type="password"
        ></v-text-field>
        <v-btn class="mr-4" @click="signup">新規登録！！！</v-btn>
        <p v-if="error" class="errors">{{ error }}</p>
      </form>
    </v-col>
  </v-row>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      name: "",
      email: "",
      password: "",
      password_confirmation: "",
      error: null,
    };
  },
  methods: {
    async signup() {
      try {
        await this.axios.get("/v1/signup", {
          name: this.name,
          email: this.email,
          password: this.password,
          password_confirmation: this.password_confirmation,
        });
      } catch (e) {
        this.error = e.response.data.errors.full_messages;
      }
    },
  },
};
</script>

<style></style>