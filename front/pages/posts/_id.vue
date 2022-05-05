<template>
  <div>
    <h2 class="text-center">投稿詳細ページ</h2>
    <UserCard v-if="post.user" :user="post.user" />
    <p>content:{{ post.content }}</p>
    <p v-if="post.tag !== ''">tag:{{ post.tag }}</p>
    <p v-else-if="post.tag === ''">tag:null</p>
    <p>privacy:{{ post.privacy }}</p>
    <div v-if="post.image_url !== null">
      <p>img:</p>
      <img :src="post.image_url" alt="投稿の画像" style="max-width: 600px" />
    </div>
    <a @click="$router.back()">戻る</a>
    <EditPostDialog
      v-if="user.id === post.user_id"
      @submit="updatePost"
      :post="post"
    />
    <PostCommentForm @submit="addPostComment" :post="post" />
    <h3 v-if="count" class="text-center">
      <span class="green--text">{{ count }}</span
      >件のコメント
    </h3>
    <h3 v-else class="text-center">コメントはまだありません</h3>
    <v-card>
      <v-data-table
        :headers="headers"
        :items="post_comments"
        :sort-by="['created_at']"
        :sort-desc="[true]"
      >
        <template v-slot:[`item.username`]="{ item }">
          <UserCard :user="item.user" />
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
          <!-- 編集済みとしたい -->
          <v-icon
            v-if="item.user_id === user.id"
            @click="openEditPostCommentDialog(item)"
            >edit</v-icon
          >
          <v-icon
            v-if="item.user_id === user.id || user.admin"
            @click="deletePostComment(item)"
            >delete</v-icon
          >
        </template>
      </v-data-table>
    </v-card>

    <EditPostCommentDialog
      ref="child"
      :post="post"
      @submitEditPostComment="updatePostComment"
    />
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import EditPostDialog from "@/components/EditPostDialog";
import EditPostCommentDialog from "@/components/EditPostCommentDialog";
import PostCommentForm from "@/components/PostCommentForm";

export default {
  head() {
    return {
      title: "メモ詳細",
    };
  },
  components: {
    EditPostDialog,
    EditPostCommentDialog,
    PostCommentForm,
  },
  data() {
    return {
      imageFile: null,
      image: [],
      post: [],
      content: "",
      tag: "",
      privacy: false,
      post_comments: [],
      headers: [
        {
          text: "ユーザー名",
          value: "username",
        },
        {
          text: "コメント",
          value: "content",
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
    this.fetchPost();
    this.fetchPostCommentList();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    count() {
      return this.post_comments.length;
    },
  },
  methods: {
    // メモ
    fetchPost() {
      axios
        .get(`/v1/posts/${this.$route.params.id}`)
        .then((res) => {
          this.post = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async updatePost(post) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
        .put(`/v1/posts/${this.$route.params.id}`, post, config)
        .then(() => {
          this.fetchPost();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "メモを編集しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // コメント
    fetchPostCommentList() {
      axios
        .get(`/v1/posts/${this.$route.params.id}/`)
        .then((res) => {
          this.post_comments = res.data.post_comments;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async addPostComment(comment) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
        .post(
          `/v1/posts/${this.$route.params.id}/post_comments`,
          comment,
          config
        )
        .then(() => {
          this.fetchPostCommentList();
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
    },
    async deletePostComment(comment) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(
            `/v1/posts/${this.$route.params.id}/post_comments/${comment.id}`
          )
          .then(() => {
            this.fetchPostCommentList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "コメントを削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
    openEditPostCommentDialog(item) {
      this.$refs.child.openEditPostCommentDialog(item);
    },
    async updatePostComment(comment, commendId) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      await axios
        .put(
          `/v1/posts/${this.$route.params.id}/post_comments/${commendId}`,
          comment,
          config
        )
        .then(() => {
          this.fetchPostCommentList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コメントを編集しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>