<template>
  <div>
    <h2 style="text-align: center">投稿詳細ページ</h2>
    <UserCard v-if="user" :user="user" />
    <p v-if="post.user">ユーザー名：{{ post.user.name }}</p>
    <p>content:{{ post.content }}</p>
    <p v-if="post.tag !== ''">tag:{{ post.tag }}</p>
    <p v-else-if="post.tag === ''">tag:null</p>
    <p>privacy:{{ post.privacy }}</p>
    <div v-if="post.image_url !== null">
      <p>img:</p>
      <img :src="post.image_url" alt="投稿の画像" style="max-width: 600px" />
    </div>
    <a @click="$router.back()">投稿一覧に戻る</a>
    <EditPostDialog
      v-if="user.id === post.user_id"
      @submit="updatePostContents"
      :post="post"
    />
    <!-- コメントフォーム コンポ化したい-->
    <v-form>
      <v-container>
        <v-text-field
          v-model="comment_content"
          counter="100"
          label="コメント"
          required
        ></v-text-field>
        <v-file-input
          v-model="image"
          accept="image/*"
          label="画像を追加"
          @change="setImage"
        ></v-file-input>
        <v-btn @click="addPostComment">コメントする</v-btn>
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
          <UserCard :user="user" />
          <!-- <UserCard :user="item.user" /> -->
        </template>
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
          <!-- 編集済みとしたい -->
          <v-icon small @click="openChildElement(item)">edit</v-icon>
          <v-icon small @click="deletePostComment(item)">delete</v-icon>
        </template>
      </v-data-table>
    </v-card>

    <EditPostCommentDialog
      ref="child"
      :post="post"
      @submitEditPostComment="editPostComment"
    />
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import EditPostDialog from "@/components/EditPostDialog";
import EditPostCommentDialog from "@/components/EditPostCommentDialog";

export default {
  head() {
    return {
      title: "メモ詳細",
    };
  },
  components: {
    EditPostDialog,
    EditPostCommentDialog,
  },
  data() {
    return {
      imageFile: null,
      image: [],
      post: [],
      content: "",
      tag: "",
      privacy: false,
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
    this.fetchPostComments();
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
    openChildElement(item) {
      this.$refs.child.openEditPostCommentDialog(item);
    },
    editPostComment(comment, commendId) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const url = `/v1/posts/${this.$route.params.id}/comments/${commendId}`;
      axios.put(url, comment, config).then(() => {
        this.fetchPostComments();
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "コメントを編集しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
      });
    },
    // コメント・投稿両方でつかう→コメントもコンポ化したらここから消す
    setImage(e) {
      this.imageFile = e;
    },
    addPostComment() {
      const comment = new FormData();
      comment.append("comment[comment_content]", this.comment_content);
      // comment.append("comment[user_id]", 3);
      // comment.append("comment[user_id]", this.user.id);
      // comment.append("comment[post_id]", this.post.id);
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      if (this.imageFile !== null) {
        comment.append("comment[image]", this.imageFile);
      }
      // topic commentにならって不要アクション消したい
      axios
        .post(`/v1/posts/${this.$route.params.id}/comments`, comment, config)
        .then((res) => {
          console.log(res.data);
          this.fetchPostComments();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを追加しました",
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
    // updatePostCont
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