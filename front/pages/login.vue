<template>
  <v-row>
    <v-col cols="12" md="4">
      <h2>Login</h2>
      <form>
        <v-text-field v-model="email" label="email" required></v-text-field>
        <v-text-field
          v-model="password"
          label="password"
          required
          :type="show1 ? 'text' : 'password'"
        ></v-text-field>
        <v-btn class="mr-4" @click="login">submit</v-btn>
        <p v-if="error" class="errors">{{ error }}</p>
      </form>
    </v-col>
  </v-row>
</template>

<script>
export default {
  data: function () {
    return {
      email: "",
      password: "",
      error: null,
    };
  },
  methods: {
    async login() {
      await this.$auth
        .loginWith("local", {
          data: {
            password: this.password,
            email: this.email,
          },
        })
        .then(
          (response) => {},
          (error) => {
            this.error = error.response.data.errors;
          }
        );
    },
  },
};
</script>


<style scoped>
</style>

