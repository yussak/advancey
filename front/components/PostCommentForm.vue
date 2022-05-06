<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="addPostCommentObserver">
      <v-form class="white mb-4">
        <v-container>
          <ValidationProvider
            rules="required|max:100"
            name="コメント"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="content"
              counter="100"
              label="コメント"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-file-input
            v-model="image"
            accept="image/*"
            label="画像を追加"
            @change="setImage"
          ></v-file-input>
          <v-btn
            :disabled="invalid"
            color="primary"
            @click="
              handleSubmitPostComment();
              addPostCommentDialog = false;
            "
            >コメントを追加</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
  </div>
</template>

<script>
export default {
  props: ["post"],
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
    handleSubmitPostComment() {
      const comment = new FormData();
      comment.append("comment[content]", this.content);
      comment.append("comment[user_id]", this.user.id);
      comment.append("comment[post_id]", this.post.id);
      if (this.imageFile !== null) {
        comment.append("comment[image]", this.imageFile);
      }
      this.$emit("submit", comment);
      this.content = "";
      this.image = [];
      this.$refs.addPostCommentObserver.reset();
    },
  },
};
</script>