<template>
  <div>
    <v-list dense>
      <v-list-item>
        <v-btn color="pink lighten-4" :to="`/users/${this.user.id}`" v-if="user"
          >投稿する</v-btn
        >
        <v-btn color="pink lighten-4" v-else @click="openRequestLoginDialog"
          >投稿する</v-btn
        >
      </v-list-item>
      <v-list-item>
        <v-btn color="blue lighten-4" :to="`/topics`" v-if="user"
          >質問する</v-btn
        >
        <v-btn color="blue lighten-4" v-else @click="openRequestLoginDialog"
          >質問する</v-btn
        >
      </v-list-item>
      <v-list-item>
        <v-btn class="lime lighten-4" :to="`/goals`" v-if="user"
          >目標作成</v-btn
        >
        <v-btn color="lime lighten-4" v-else @click="openRequestLoginDialog"
          >目標作成</v-btn
        >
      </v-list-item>
      <v-list-item>
        <v-btn class="orange lighten-4" :to="`/communities`" v-if="user"
          >コミュ作成</v-btn
        >
        <v-btn color="orange lighten-4" v-else @click="openRequestLoginDialog"
          >コミュ作成</v-btn
        >
      </v-list-item>
    </v-list>
    <RequestLoginDialog ref="requestLoginDialog" />
  </div>
</template>


<script>
import RequestLoginDialog from "@/components/RequestLoginDialog";

export default {
  components: {
    RequestLoginDialog,
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>