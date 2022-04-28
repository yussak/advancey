<template>
  <div>
    <h1 v-if="user.id === currentUser.id">マイページ</h1>
    <h1 v-else>ユーザー詳細</h1>
    <UserCard :user="user" />
    <p v-if="user.profile">自己紹介：{{ user.profile }}</p>
    <nuxt-link :to="`/users`">ユーザー一覧に戻る</nuxt-link>

    <!-- 右辺、ぜんぶeditUserに統一できるはず(画像以外) -->
    <!-- refsは親から子コンポーネントのモーダルを閉じるため -->
    <!-- ユーザー編集ダイアログ 自分のページだけ表示 -->
    <EditUserDialog
      v-if="user.id === currentUser.id"
      ref="editUserDialog"
      @submitEditName="editUserName"
      @submitEditProfile="editUserProfile"
      @submitEditImage="editUserImage"
    />
    <PostList :posts="posts" />
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
    fetchUserInfoAndPostList() {
      const url = `/v1/users/${this.$route.params.id}`;
      axios.get(url).then((res) => {
        this.user = res.data;
        axios
          .get(`/v1/posts`, {
            params: { user_id: this.user.id },
          })
          .then((res) => {
            this.posts = res.data;
          });
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