<template>
  <div>
    <v-card>
      <v-card-actions>
        <v-avatar>
          <img
            v-if="user.image_url"
            :src="user.image_url"
            alt="ユーザーアイコン"
          />
          <img
            v-else
            src="~assets/default-user-icon.png"
            alt="ユーザーアイコン"
          />
        </v-avatar>
        <p class="font-weight-bold">{{ user.name }}</p>
        <p class="mx-2">
          {{
            $dateFns.format(new Date(topic.created_at), "yyyy/MM/dd HH:mm")
          }}に追加
        </p>
        <p v-if="topic.solve_status" class="green--text font-weight-bold">
          解決済み
        </p>
        <p v-else class="red--text font-weight-bold">受付中</p>
      </v-card-actions>
      <v-card-title>タイトル</v-card-title>
      <v-card-text>{{ topic.title }}</v-card-text>
      <v-card-title v-if="topic.content">詳細</v-card-title>
      <v-card-text v-if="topic.content">{{ topic.content }}</v-card-text>
      <v-card-text>
        <img
          v-if="topic.image_url"
          :src="topic.image_url"
          style="max-width: 100%"
          alt="質問画像"
        />
      </v-card-text>
      <v-card-actions>
        <v-icon @click="openRequestLoginDialog">mdi-magnify</v-icon>
      </v-card-actions>
    </v-card>
    <RequestLoginDialog ref="requestLoginDialog" />
  </div>
</template>

<script>
import RequestLoginDialog from "@/components/RequestLoginDialog";

export default {
  components: {
    RequestLoginDialog,
  },
  props: ["user", "topic"],
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>