<template>
  <div>
    <nuxt-link :to="`/users/${user.id}`" class="user-link">
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
        <v-card-text class="pa-0 font-weight-bold">{{ user.name }}</v-card-text>
      </v-card-actions>
    </nuxt-link>
  </div>
</template>

<script>
export default {
  props: ["user"],
};
</script>

<style scoped>
.user-link {
  text-decoration: none;
  color: black;
}
</style>