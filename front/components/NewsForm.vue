<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="addNewsObserver">
      <v-form v-if="user.admin" class="white mb-4">
        <v-container>
          <ValidationProvider
            rules="required|max:200"
            name="お知らせ"
            v-slot="{ errors }"
          >
            <v-textarea
              v-model="content"
              counter="200"
              label="お知らせ内容（必須）"
            ></v-textarea>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-btn :disabled="invalid" color="primary" @click="handleSubmitNews"
            >お知らせを投稿</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
  </div>
</template>

<script>
export default {
  data() {
    return {
      content: "",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    handleSubmitNews() {
      const news = new FormData();
      news.append("news[user_id]", this.user.id);
      news.append("news[content]", this.content);
      this.$emit("submit", news);
      this.content = "";
      this.$refs.addNewsObserver.reset();
    },
  },
};
</script>