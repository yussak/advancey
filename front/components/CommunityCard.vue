<template>
  <div>
    <v-card>
      <v-card-title>名前</v-card-title>
      <v-card-text>{{ community.name }}</v-card-text>
      <v-card-title>概要</v-card-title>
      <v-card-text>{{ community.description }}</v-card-text>
      <v-card-actions
        ><v-btn @click="showCommunity(community)" color="primary"
          >チャットルームに入る</v-btn
        >
        <v-icon
          v-if="user.id === community.user_id || user.admin"
          @click="handleSubmitDeleteCommunity(community)"
          >delete</v-icon
        >
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  props: ["community"],
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async handleSubmitDeleteCommunity(community) {
      this.$emit("submitDeleteCommunity", community);
    },
    async showCommunity(community) {
      this.$router.push(`/communities/${community.id}`);
    },
  },
};
</script>