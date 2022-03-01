<template>
  <div>
    <v-form>
      <v-container>
        <v-row>
          <v-col cols="12" md="8">
            <v-text-field
              v-model="content"
              counter="10"
              label="思いついたことなど何でも書いてみましょう！"
              required
            ></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="8">
            <v-select
              v-model="tag"
              :items="items"
              label="選択してください"
            ></v-select>
          </v-col>
        </v-row>
        <v-row>
          <v-col>
            <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="8">
            <v-btn @click="handleSubmit">作成</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      content: "",
      tag: "",
      items: ["実践したい", "実践中", "身についた"],
      // privacy: null,
      privacy: false,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    handleSubmit() {
      const post = {
        content: this.content,
        user_id: this.user.id,
        tag: this.tag,
        privacy: this.privacy,
      };
      this.$emit("submit", post);
      this.content = "";
      this.tag = "";
    },
  },
};
</script>

<style>
</style>

