<template>
  <div>
    <v-dialog v-model="requestLoginDialog" max-width="500">
      <v-card>
        <v-card-title>ユーザー登録をすると全機能を利用できます</v-card-title>
        <v-card-actions>
          <nuxt-link :to="`/signup`">新規登録はこちら</nuxt-link>
        </v-card-actions>
        <v-card-actions>
          <nuxt-link :to="`/login`">ログインはこちら</nuxt-link>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      requestLoginDialog: false,
    };
  },
  methods: {
    open() {
      this.requestLoginDialog = true;
    },
  },
};
</script>