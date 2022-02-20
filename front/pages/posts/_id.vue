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
    <v-data-table :headers="headers" :items="comments"></v-data-table>
    {{ comment_content }}
    {{ post.comment_content }}
    {{ post.comment_content }}
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      headers: [
        {
          text: "コメント",
          value: "comment_content",
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
      const url = `/v1/posts/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.post = res.data;
      });
    },
    // openModal() {
    //   this.content = this.post.content;
    // },
    // asyncにすればTOPに反映される？（なんとなく）
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
          console.log("失敗");
        });
    },
    // async addComment(comment) {
    async addComment() {
      const url = `/v1/posts/${this.$route.params.id}/comments`;
      await axios
        // .post(url, { comment })
        .post(url, this.comment_params)
        .then((res) => {
          alert("success");
        })
        .catch((error) => {
          console.log(error);
        });

      // const { data } = await axios.post(url, { comment });
      // this.$store.dispatch("auth/setUser", {
      //   ...this.user,
      //   comments: [...this.user.comments, data],
      // });
    },
  },
};
</script>
