<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="addTopicCommentObserver">
      <v-form v-if="!topic.solve_status" class="white">
        <v-container>
          <ValidationProvider
            rules="required|max:100"
            name="コメント"
            v-slot="{ errors }"
          >
            <v-textarea
              v-model="content"
              counter="100"
              label="質問へのコメント"
            ></v-textarea>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加（任意）"
            @change="setImage"
          ></v-file-input>
          <v-btn
            :disabled="invalid"
            color="primary"
            @click="handleSubmitTopicComment"
            >コメントする</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
  </div>
</template>

<script>
export default {
  props: ["topic"],
  data() {
    return {
      content: "",
      image: [],
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
    handleSubmitTopicComment() {
      const comment = new FormData();
      comment.append("comment[content]", this.content);
      comment.append("comment[user_id]", this.user.id);
      comment.append("comment[topic_id]", this.topic.id);
      if (this.imageFile !== null) {
        comment.append("comment[image]", this.imageFile);
      }
      this.$emit("submit", comment);
      this.content = "";
      this.image = [];
      this.$refs.addTopicCommentObserver.reset();
    },
  },
};
</script>