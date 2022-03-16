<template>
  <div>
    <h2 style="text-align: center">投稿詳細ページ</h2>
    <p>
      <v-avatar>
        <!-- アイコン設定がないとき→条件は後で追加 -->
        <img
          src="~assets/default-user-icon.png"
          style="width: 45px; height: 45px"
        />
      </v-avatar>
      <!-- username表示したい -->
      <!-- <p>投稿者：{{ post.username }}さん</p> -->
    </p>
    <!-- 一時的にid表示する -->
    <p>投稿者ID：{{ post.user_id }}さん</p>
    {{ post.content }}
    <div v-if="post.image_url !== null">
      <p>画像</p>
      <img :src="post.image_url" alt="test" style="max-width: 600px" />
    </div>
    <a @click="$router.back()">もどる</a>
    <!-- 編集モーダル 後でコンポーネント化する -->
    <!-- 自分の投稿の時だけ表示 -->
    <v-row
      v-if="$store.state.auth.currentUser.id === post.user_id"
      justify="center"
    >
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
          <v-col cols="12" md="8">
            <v-file-input
              v-model="image"
              accept="image/*"
              label="画像を追加（任意）"
              @change="setImage"
            ></v-file-input>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12">
            <v-btn @click="addPostComment">コメントする</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <h3 v-if="count === 0">コメントはまだありません</h3>
    <h3 v-else>{{ count }}件のコメント</h3>
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
        <!-- コメント詳細は作る予定無いので、この一覧で画像見やすくしたい -->
        <template v-slot:[`item.image_url`]="{ item }">
          <img
            v-if="item.image_url"
            :src="item.image_url"
            alt="test"
            width="30"
            height="30"
          />
        </template>
        <template v-slot:[`item.created_at`]="{ item }">
          {{ $dateFns.format(new Date(item.created_at), "yyyy/MM/dd HH:mm") }}
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
  head() {
    return {
      title: "メモ詳細",
    };
  },
  data() {
    return {
      imageFile: null,
      image: [],
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
          text: "画像表示（試し）",
          value: "image_url",
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
      // user_idとpost_id、画像追加のため書いたけど不要そう
      // user_id: "",
      // post_id: "",
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
    setImage(e) {
      this.imageFile = e;
    },
    addPostComment() {
      let formData = new FormData();
      formData.append("comment[comment_content]", this.comment_content);
      formData.append("comment[user_id]", this.user.id);
      formData.append("comment[post_id]", this.post.id);
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      if (this.imageFile !== null) {
        formData.append("comment[image]", this.imageFile);
      }
      axios
        .post(`/v1/posts/${this.$route.params.id}/comments`, formData, config)
        .then(() => {
          this.fetchPostComments();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
      this.comment_content = "";
      this.image = [];
    },
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