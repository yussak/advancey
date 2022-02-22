<template>
  <div>
    <h2 style="text-align: center">投稿詳細ページ</h2>
    {{ post.content }}
    <a @click="$router.back()">もどる</a>
    <p style="color: red">コメント機能のためボタン一時廃止</p>
    <!-- 編集モーダル 後でコンポーネント化する -->
    <!-- 自分の投稿の時だけ表示したい -->
    <!-- <div>
        <v-app id="inspire">
          <v-row justify="center">
            <v-dialog v-model="dialog" scrollable max-width="300px">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  color="primary"
                  dark
                  v-bind="attrs"
                  v-on="on"
                  @click="openModal()"
                >
                  投稿を編集する
                </v-btn>
              </template>
              <v-card>
                <v-card-title>投稿編集</v-card-title>
                <v-divider></v-divider>
                <v-card-text style="height: 300px">
                  <form>
                    <v-text-field
                      v-model="content"
                      label="content"
                      data-vv-name="content"
                      required
                    ></v-text-field>
                  </form>
                </v-card-text>
                <v-divider></v-divider>
                <v-card-actions>
                  <v-btn color="blue darken-1" text @click="dialog = false">
                    Close
                  </v-btn>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click="(dialog = false), update()"
                  >
                    Save
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-row>
        </v-app>
      </div> -->
    <v-divider></v-divider>
    <form>
      <v-text-field
        v-model="comment_content"
        counter="100"
        label="コメント"
        required
      ></v-text-field>
      <v-btn @click="addComment">コメントする</v-btn>
    </form>
    <v-divider></v-divider>
    <h3 style="text-align: center">コメント一覧</h3>
    <v-data-table
      :headers="headers"
      :items="comments"
      :sort-by="['created_at']"
      :sort-desc="[true]"
    >
      <template v-slot:[`item.action`]="{ item }">
        <v-icon small @click="deleteItem(item)">delete</v-icon>
      </template>
    </v-data-table>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      comments: [],
      headers: [
        {
          text: "コメント",
          value: "comment_content",
        },
        {
          text: "コメント日時",
          value: "created_at",
        },
        {
          text: "",
          value: "action",
        },
      ],
      content: "",
      post: [],
      // dialogm1: "",
      // dialog: false,
      comments: [],
      comment_content: "",
    };
  },
  mounted() {
    this.fetchContent();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    // post_paramsにするかも
    params() {
      return {
        post: {
          content: this.content,
        },
      };
    },
    comment_params() {
      return {
        comment: {
          comment_content: this.comment_content,
        },
      };
    },
  },
  methods: {
    fetchContent() {
      const post_url = `/v1/posts/${this.$route.params.id}`;
      const comment_url = `/v1/posts/${this.$route.params.id}/comments`;
      axios.get(post_url).then((res) => {
        this.post = res.data;
      });
      axios.get(comment_url).then((res) => {
        this.comments = res.data;
      });
    },
    // openModal() {
    //   this.content = this.post.content;
    // },
    // updatePost()に変えたい
    update() {
      const url = `/v1/posts/${this.$route.params.id}`;
      axios
        .put(url, this.params)
        .then((res) => {
          this.fetchContent();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "編集しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async addComment() {
      const comment_url = `/v1/posts/${this.$route.params.id}/comments`; // comments#createのルーティングに送る（違うところに送ってないか後で確認）
      await axios
        .post(comment_url, this.comment_params)
        .then((res) => {
          alert("ok");
          this.fetchContent();
        })
        .catch((error) => {
          alert("failed");
          console.log(error);
        });
    },
    async deleteItem(item) {
      const hoge = `/v1/posts/${this.$route.params.id}/comments/${item.id}`;
      // console.log(hoge);
      // console.log(item.id);
      // console.log(comment.id);
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(
          `/v1/posts/${this.$route.params.id}/comments/${item.id}`
        );
        const comments = this.comments.filter((comment) => {
          return comment.id !== item.id;
        });
        const newUser = {
          // ...this.user,
          comments,
        };
        this.$store.commit("auth/setUser", newUser);
      }
    },
  },
};
</script>
