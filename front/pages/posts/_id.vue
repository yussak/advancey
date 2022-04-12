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
    </p>
    <p v-if="post.user">ユーザー名：{{ post.user.name }}</p>
    <p>content:{{ post.content }}</p>
    <p v-if="post.tag !== ''">tag:{{ post.tag }}</p>
    <p v-else-if="post.tag === ''">tag:null</p>
    <p>privacy:{{ post.privacy }}</p>
    <div v-if="post.image_url !== null">
      <p>img:</p>
      <!-- 切り替え有無が画像だけならv-ifもimgタグにかける（topics index参照 -->
      <img :src="post.image_url" alt="test" style="max-width: 600px" />
    </div>
    <a @click="$router.back()">投稿一覧に戻る</a>
    <!-- 編集モーダル -->
    <!-- 自分の投稿の時だけ表示 -->
    <v-row
      v-if="$store.state.auth.currentUser.id === post.user_id"
      justify="center"
    >
      <EditPostDialog @submit="updatePostContents" :post="post" />
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
        <template v-slot:[`item.username`]="{ item }">
          <div>
            <v-avatar>
              <!-- アイコン設定がないとき→条件は後で追加 -->
              <img
                src="~assets/default-user-icon.png"
                style="width: 45px; height: 45px"
              />
            </v-avatar>
            <p v-if="item.user">{{ item.user.name }}</p>
          </div>
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
import EditPostDialog from "@/components/EditPostDialog";

export default {
  head() {
    return {
      title: "メモ詳細",
    };
  },
  components: {
    EditPostDialog,
  },
  data() {
    return {
      imageFile: null,
      image: [],
      post: [],
      content: "",
      tag: "",
      privacy: false,
      dialogm1: "",
      dialog: false,
      comments: [],
      comment_content: "",
      items: ["", "実践中", "実践したい", "身についた"],
      headers: [
        {
          text: "ユーザー名",
          value: "username",
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
    count() {
      return this.comments.length;
    },
  },
  methods: {
    // コメント・投稿両方でつかう→コメントもコンポ化したらここから消す
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
      // topic commentにならって不要アクション消したい
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
      const url = `/v1/posts/${this.$route.params.id}/`;
      axios.get(url).then((res) => {
        this.comments = res.data.comments;
      });
    },
    updatePostContents(post) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      // const urlにしたい
      axios.put(`/v1/posts/${this.$route.params.id}`, post, config).then(() => {
        this.fetchPostContent();
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "メモを編集しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
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