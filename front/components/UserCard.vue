<template>
  <div style="background: orange; width: 150px">
    <nuxt-link
      :to="`/users/${user.id}`"
      style="text-decoration: none; color: black"
      class="user-link"
    >
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
          <!-- コミュニティでmessage.user_idとしたときと違う値が出る… -->
          <!-- {{ user.id }} -->
        </v-avatar>
        <p class="bold-text">{{ user.name }}</p>
      </v-card-actions>
    </nuxt-link>
  </div>
</template>

<script>
export default {
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
};
</script>

<style scoped>
/* user-linkここにまとめたい */
.user-link {
  text-decoration: none;
  color: black;
}
</style>