<template>
  <div>
    <v-dialog v-model="editTopicCommentDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          text
          v-bind="attrs"
          v-on="on"
          @click="openEditTopicCommentDialog()"
        >
          <v-icon>edit</v-icon>編集
        </v-btn>
      </template>
      <v-card>
        <v-card-title>コメント編集</v-card-title>
        <v-card-text>
          <v-form>
            <v-container>
              <v-textarea
                v-model="modal_text"
                counter="100"
                rows="3"
                label="コメント"
              ></v-textarea>
              <v-file-input
                v-if="!image_url"
                v-model="image"
                accept="image/*"
                label="画像を追加（任意）"
                @change="setImage"
              ></v-file-input>
              <v-file-input
                v-else
                v-model="image"
                accept="image/*"
                label="画像を変更"
                @change="setImage"
              ></v-file-input>
              <img
                v-if="image_url"
                :src="image_url"
                alt="質問コメントの画像"
                style="max-width: 600px; max-height: 300px"
              />
            </v-container>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-btn
            color="blue darken-1"
            text
            @click="editTopicCommentDialog = false"
          >
            キャンセル
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="
              handleSubmitEditTopicComment();
              editTopicCommentDialog = false;
            "
          >
            保存する
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  props: ["topic", "comment"],
  data() {
    return {
      editTopicCommentDialog: false,
      content: "",
      image: [],
      imageFile: null,
      modal_text: "",
      image_url: "",
      id: "", //コメント編集のため
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
    openEditTopicCommentDialog() {
      this.modal_text = this.comment.content;
      this.image_url = this.comment.image_url;
      this.id = this.comment.id;
    },
    handleSubmitEditTopicComment() {
      const comment = new FormData();
      comment.append("comment[user_id]", this.user.id);
      comment.append("comment[topic_id]", this.topic.id);
      comment.append("comment[content]", this.modal_text);
      if (this.imageFile !== null) {
        comment.append("comment[image]", this.imageFile);
      }
      this.commendId = this.id;
      this.$emit("submitEditTopicComment", comment, this.commendId);
    },
  },
};
</script>