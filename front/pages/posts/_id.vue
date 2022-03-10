<template>
  <div>
    <h2 style="text-align: center">投稿詳細ページ</h2>
    <!-- username表示したい -->
    <p>
      <v-avatar>
        <!-- アイコン設定がないとき→条件は後で追加 -->
        <img
          src="~assets/default-user-icon.png"
          style="width: 45px; height: 45px"
        />
      </v-avatar>
      投稿者：{{ post.username }}さん
    </p>
    {{ post.content }}
    <a @click="$router.back()">もどる</a>
    <!-- 編集モーダル 後でコンポーネント化する -->
    <!-- 自分の投稿の時だけ表示したい -->
    <v-row justify="center">
      <v-dialog v-model="dialog" scrollable fullscreen hide-overlay>
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
            <v-btn color="blue darken-1" text @click="dialog = false">
              戻る
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="(dialog = false), updatePost()"
            >
              保存する
            </v-btn>
          </v-card-actions>
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
          <v-card-actions>
            <v-btn color="blue darken-1" text @click="dialog = false">
              戻る
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="(dialog = false), updatePost()"
            >
              保存する
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-row>
    <!-- コメントフォーム -->
    <v-form>
      <v-container>
        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="comment_content"
              counter="100"
              label="コメント"
              required
            ></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12">
            <v-btn @click="addPostComment">コメントする</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <!-- ↓動かない -->
    <!-- <h3 v-if="comments === ''">コメントはまだありません</h3> -->
    <!-- <h3 v-else>{{ count }}件のコメント</h3> -->
    <h3>{{ count }}件のコメント</h3>
    <v-card>
      <v-data-table
        :headers="headers"
        :items="comments"
        :sort-by="['created_at']"
        :sort-desc="[true]"
      >
        <!-- usernameを表示したい -->
        <!-- 後でuser_id→usernameに変える -->
        <template v-slot:[`item.user_id`]="{ item }">
          <!-- <template v-slot:[`item.username`]="{ item }"> -->
          <p>
            <v-avatar>
              <!-- アイコン設定がないとき→条件は後で追加 -->
              <img
                src="~assets/default-user-icon.png"
                style="width: 45px; height: 45px"
              />
            </v-avatar>
            {{ item.user_id }}
            <!-- {{ item.username }} -->
          </p>
        </template>
        <template v-slot:[`item.action`]="{ item }">
          <!-- 自分のコメントだけに表示したい -->
          <!-- v-if="$store.state.auth.currentUser.id === item.user_id" -->
          <!-- v-if="$store.state.auth.currentUser.id === item.user.id" -->
          <!-- では出来なかった -->
          <!-- →topicでは出来たのになぜ？→paramsにuser_id作ってるの関係あるかも。試す -->
          <v-icon small @click="deletePostComment(item)">delete</v-icon>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      post: [],
      content: "",
      dialogm1: "",
      dialog: false,
      comments: [],
      comment_content: "",
      headers: [
        {
          // // コメントしたユーザー名も表示可能にする
          text: "ユーザーID(後でユーザー名に変更する)",
          value: "user_id",
          // value: "username",
        },
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
    };
  },
  mounted() {
    this.fetchPostContent();
    this.fetchPostComments(); //一覧表示されるまでラグあるの直したい
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    post_params() {
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
    count() {
      return this.comments.length;
    },
  },
  methods: {
    fetchPostContent() {
      const url = `/v1/posts/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.post = res.data;
      });
    },
    fetchPostComments() {
      // これでそのPostのコメントだけ取得できたと思う
      // URL 末尾のスラッシュ有無も統一したい
      const url = `/v1/posts/${this.$route.params.id}/`;
      axios.get(url).then((res) => {
        this.comments = res.data.comments;
      });
    },
    openEditPostDialog() {
      this.content = this.post.content;
    },
    // updatePostContentにしたいがContent以外も編集予定なので一旦このまま
    // →updatePostContentsにしたい
    updatePost() {
      const url = `/v1/posts/${this.$route.params.id}`;
      axios
        .put(url, this.post_params)
        .then((res) => {
          this.fetchPostContent();
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
    async addPostComment() {
      const url = `/v1/posts/${this.$route.params.id}/comments`; // comments#createのルーティングに送る（違うところに送ってないか後で確認）
      // 追加まで時間かかるの直したい
      await axios
        .post(url, this.comment_params)
        .then((res) => {
          this.fetchPostComments();
          this.comment_content = "";
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((error) => {
          alert("failed");
          console.log(error);
        });
    },
    async deletePostComment(item) {
      const url = `/v1/posts/${this.$route.params.id}/comments/${item.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
          this.fetchPostComments();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
  },
};
</script>
<style>
/* これで高さ小さくした上で、背景クリックでも消せた */
.v-application--wrap {
  min-height: 5vh;
}
</style>