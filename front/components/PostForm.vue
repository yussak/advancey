<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="observer">
      <v-form>
        <v-container>
          <ValidationProvider
            rules="required|max:200"
            name="メモ"
            v-slot="{ errors }"
          >
            <v-textarea
              v-model="content"
              counter="200"
              label="思いついたことなど何でもメモしてみましょう！"
              required
            ></v-textarea>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-select
            v-model="tag"
            :items="items"
            label="アクションを選択してみましょう（任意）"
          ></v-select>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加（任意）"
            @change="setImage"
          ></v-file-input>
          <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
          <v-btn :disabled="invalid" @click="handleSubmit">メモを作成</v-btn>
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
      tag: "",
      image: [],
      items: ["", "実践中", "実践したい", "身についた"],
      privacy: false,
      imageFile: null,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    setImage(e) {
      this.imageFile = e;
    },
    handleSubmit() {
      const post = new FormData();
      post.append("post[content]", this.content);
      post.append("post[user_id]", this.user.id);
      if (this.tag !== null) {
        post.append("post[tag]", this.tag);
      }
      if (this.privacy !== null) {
        post.append("post[privacy]", this.privacy);
      }
      if (this.imageFile !== null) {
        post.append("post[image]", this.imageFile);
      }
      this.$emit("submit", post);
      this.content = "";
      this.tag = "";
      this.privacy = "";
      this.$refs.observer.reset();
    },
  },
};
</script>

<style>
/* scoped外したので他の所にもきくはず */
/* 共通スタイル作ってそこに移したい */
.error-message {
  color: red;
}
</style>