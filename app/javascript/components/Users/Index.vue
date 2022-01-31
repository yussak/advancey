<template>
  <div>
    <table>
      <tr v-for="user in initialData.users" v-bind:key="user.id">
        <td>{{ user.name }}</td>
      </tr>
    </table>
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
  background: green;
  margin: 0 auto;
}
</style>