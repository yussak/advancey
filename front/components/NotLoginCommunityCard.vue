<template>
  <div>
    <v-card>
      <v-card-text>コミュニティ名：{{ community.name }}</v-card-text>
      <v-card-text>概要：{{ community.description }}</v-card-text>
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
  props: ["user", "community"],
  components: {
    RequestLoginDialog,
  },
  methods: {
    openRequestLoginDialog() {
      this.$refs.requestLoginDialog.open();
    },
  },
};
</script>