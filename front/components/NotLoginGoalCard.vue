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
            $dateFns.format(new Date(goal.created_at), "yyyy/MM/dd HH:mm")
          }}に追加
        </p>
        <p v-if="goal.achieve_status" class="green--text font-weight-bold">
          達成済み
        </p>
        <p v-else class="red--text font-weight-bold">未達成</p>
      </v-card-actions>
      <v-card-title>{{ goal.title }}</v-card-title>
      <v-card-title>達成したいこと</v-card-title>
      <v-card-text>{{ goal.content }} </v-card-text>
      <v-card-title>理由</v-card-title>
      <v-card-text>{{ goal.reason }}</v-card-text>
      <v-card-title>そのためにやること</v-card-title>
      <v-card-text>{{ goal.todo }}</v-card-text>
      <v-card-text>
        <img
          v-if="goal.image_url"
          :src="goal.image_url"
          style="max-width: 100%; max-height: 300px"
          alt="目標画像"
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
  props: ["user", "goal"],
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>
