<template>
  <div>
    <!-- <div style="background: orange"> -->
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
        </v-avatar>
        <p class="font-weight-bold">{{ user.name }}</p>
        <p v-if="user.admin" class="ml-2 blue--text font-weight-bold">
          admin<v-icon class="blue--text">mdi-crown</v-icon>
        </p>
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
/* user-linkここにまとめたい */
.user-link {
  text-decoration: none;
  color: black;
}
</style>