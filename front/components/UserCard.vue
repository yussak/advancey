<template>
  <div>
    <v-card-actions @click="showUser(user)" v-on:click.stop class="user-link">
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
      <v-card-text class="pa-0 font-weight-bold">{{ user.name }}</v-card-text>
    </v-card-actions>
  </div>
</template>

<script>
export default {
  props: ["user"],
  methods: {
    showUser(user) {
      this.$router.push(`/users/${user.id}`);
    },
  },
};
</script>

<style>
.user-link:hover {
  text-decoration: underline !important;
}
</style>

