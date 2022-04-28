<template>
  <div>
    <v-dialog v-model="editPostDialog" scrollable fullscreen hide-overlay>
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="primary"
          dark
          v-bind="attrs"
          v-on="on"
          @click="openEditPostDialog()"
        >
          投稿を編集する
        </v-btn>
      </template>
      <v-card>
        <v-card-title>投稿編集</v-card-title>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="editPostDialog = false">
            戻る
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="(editPostDialog = false), handleSubmit()"
          >
            保存する
          </v-btn>
        </v-card-actions>
        <v-card-text style="height: 300px">
          <form>
            <v-row>
              <v-col cols="12" md="8">
                <v-text-field v-model="content" counter="10"></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" md="8">
                <v-select v-model="tag" :items="items"></v-select>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="3">
                <v-checkbox v-model="privacy" label="非公開にする"></v-checkbox>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" md="8">
                <v-file-input
                  v-model="image"
                  accept="image/*"
                  label="画像を追加（任意）"
                  @change="setImage"
                ></v-file-input>
              </v-col>
            </v-row>
          </form>
        </v-card-text>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="editPostDialog = false">
            戻る
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="(editPostDialog = false), handleSubmit()"
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
  props: ["post"],
  data() {
    return {
      editPostDialog: false,
      content: "",
      tag: "",
      items: ["", "実践中", "実践したい", "身についた"],
      privacy: false,
      imageFile: null,
      image: [],
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
    openEditPostDialog() {
      this.content = this.post.content;
      this.tag = this.post.tag;
      this.privacy = this.post.privacy;
    },
    handleSubmit() {
      const post = new FormData();
      post.append("post[content]", this.content);
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
    },
  },
};
</script>