<template>
  <div>
    <table class="hogera">
      <tr v-for="user in initialData.users" v-bind:key="user.id">
        <td>{{ user.name }}</td>
        <td>
          <router-link :to="{ name: 'UserShow', params: { id: user.id } }"
            >Profile</router-link
          >
        </td>
      </tr>
    </table>
    <router-view />
  </div>
</template>

<script>
export default {
  props: {
    initialData: {
      type: Object,
      default: () => {},
    },
  },
};
</script>

<style scoped>
.hogera {
  margin: 0 auto;
}
</style>