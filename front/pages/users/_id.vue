<template>
  <div>
    <h1 v-if="user.id === currentUser.id">マイページ</h1>
    <h1 v-else>ユーザー詳細</h1>
    <UserCard :user="currentUser" v-if="user.id === currentUser.id" />
    <UserCard :user="user" v-else />
    <p v-if="user.id === currentUser.id && currentUser.profile">
      自己紹介：{{ currentUser.profile }}
    </p>
    <p v-else-if="user.id !== currentUser.id && user.profile">
      自己紹介：{{ user.profile }}
    </p>
    <a @click="$router.back()">ユーザー一覧に戻る</a>

    <!-- 右辺、ぜんぶeditUserに統一できるはず(画像以外) -->
    <!-- refsは親から子コンポーネントのモーダルを閉じるため -->
    <EditUserDialog
      v-if="user.id === currentUser.id"
      ref="editUserDialog"
      @submitEditName="editUserName"
      @submitEditProfile="editUserProfile"
      @submitEditImage="editUserImage"
    />
    <v-dialog v-model="addPostDialog" max-width="700">
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="primary" dark v-bind="attrs" v-on="on">
          メモを追加
        </v-btn>
      </template>
      <v-card>
        <v-card-title>
          <span>メモを追加</span>
        </v-card-title>
        <v-card-text>
          <PostForm @submitPost="addPost" />
        </v-card-text>
      </v-card>
    </v-dialog>

    <PostList
      :posts="posts"
      :doing_posts="doing_posts"
      :want_posts="want_posts"
      :master_posts="master_posts"
      @submitDeletePost="deletePost"
    />
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";
import PostList from "@/components/PostList";
import EditUserDialog from "@/components/EditUserDialog";

export default {
  head() {
    return {
      title: "ユーザー詳細",
    };
  },
  components: {
    PostList,
    EditUserDialog,
  },
  data() {
    return {
      user: [], // 自分以外のページで必要
      posts: [],
      doing_posts: [],
      want_posts: [],
      master_posts: [],
      addPostDialog: false,
    };
  },
  mounted() {
    this.fetchUserInfoAndPostList();
  },
  computed: {
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async deletePost(post) {
      await axios.delete(`/v1/posts/${post.id}`).then(() => {
        this.fetchPostList();
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "メモを削除しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
      });
    },
    async addPost(post) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      axios
        .post(`/v1/posts`, post, config)
        .then(() => {
          this.fetchPostList();
          this.addPostDialog = false;
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "メモを追加しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    fetchPostList() {
      const url = `/v1/users/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.posts = res.data.posts;
        this.doing_posts = res.data.doing_posts;
        this.want_posts = res.data.want_posts;
        this.master_posts = res.data.master_posts;
      });
    },
    fetchUserInfoAndPostList() {
      const url = `/v1/users/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.user = res.data.user;
        this.posts = res.data.posts;
        this.doing_posts = res.data.doing_posts;
        this.want_posts = res.data.want_posts;
        this.master_posts = res.data.master_posts;
      });
    },
    async editUserName(user) {
      const { data } = await axios.put(
        `/v1/users/${this.$route.params.id}`,
        user
      );
      this.$store.dispatch("auth/setUser", data);
    },
    async editUserProfile(user) {
      const { data } = await axios.put(
        `/v1/users/${this.$route.params.id}`,
        user
      );
      this.$store.dispatch("auth/setUser", data);
    },
    async editUserImage(user) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const { data } = await axios.put(
        `/v1/users/${this.$route.params.id}`,
        user,
        config
      );
      this.$store.dispatch("auth/setUser", data);
      this.image = [];
      // 親から子のモーダルを閉じる
      this.$refs.editUserDialog.changeUserImageDialog = false;
    },
    async updateUserInfo(user) {
      const test = await firebase.auth().currentUser; //VuexのcuUじゃなくfirebase側の？
      // test.updateEmail(this.email);
      // const { data } = axios.put(`/v1/users/${this.$route.params.id}`, {
      //   user: { email: this.email },
      // });
      // this.$store.dispatch("auth/setUser", data).then(() => {
      //   alert("ok");
      // });
      // test
      //   .updateEmail(this.email)
      //   .then(() => {
      //     const { data } = axios.put(`/v1/users/${this.$route.params.id}`, {
      //       // user: { email: this.email },
      //       user,
      //     });
      //     this.$store.dispatch("auth/setUser", data).then(() => {
      //       alert("ok");
      //     });
      //   })
      //   .catch((error) => {
      //     this.error = ((code) => {
      //       switch (code) {
      //         case "auth/email-already-in-use":
      //           return "既にそのメールアドレスは使われています";
      //         case "auth/wrong-password":
      //           return "※パスワードが正しくありません";
      //         case "auth/weak-password":
      //           return "※パスワードは最低６文字以上にしてください";
      //         default:
      //           return "※メールアドレスとパスワードをご確認ください";
      //       }
      //     })(error.code);
      //   });

      // const config = {
      //   headers: {
      //     "content-type": "multipart/form-data",
      //   },
      // };
      // const { data } = await axios.put(
      //   `/v1/users/${this.$route.params.id}`,
      //   user,
      //   config
      // );
      // this.$store.dispatch("auth/setUser", data);
    },
  },
};
</script>