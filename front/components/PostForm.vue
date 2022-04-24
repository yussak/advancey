<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="observer">
      <v-form class="white">
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
          <v-radio-group v-model="tag" row>
            <v-radio label="実践中" value="実践中"></v-radio>
            <v-radio label="実践したい" value="実践したい"></v-radio>
            <v-radio label="身についた" value="身についた"></v-radio>
          </v-radio-group>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加（任意）"
            @change="setImage"
          ></v-file-input>
          <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
          <v-btn
            v-if="$route.params === '/'"
            :disabled="invalid"
            @click="handleSubmitPost"
            >メモを作成</v-btn
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
      tag: "",
      image: [],
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
    handleSubmitPost() {
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
      this.image = [];
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