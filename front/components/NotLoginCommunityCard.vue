<template>
  <div>
    <v-card>
      <v-card-title>名前</v-card-title>
      <v-card-text>{{ community.name }}</v-card-text>
      <v-card-title>概要</v-card-title>
      <v-card-text class="br-content">{{ community.description }}</v-card-text>
      <v-card-actions
        ><v-btn @click="openRequestLoginDialog" color="primary"
          >チャットルームに入る</v-btn
        >
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
  props: ["user", "community"],
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>