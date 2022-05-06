<template>
  <div>
    <h2 class="text-center">投稿詳細ページ</h2>
    <v-row>
      <v-col>
        <v-card class="mb-4">
          <v-card-actions>
            <UserCard v-if="post.user" :user="post.user" />
            <p v-if="post.created_at">
              {{
                $dateFns.format(new Date(post.created_at), "yyyy/MM/dd HH:mm")
              }}に投稿
            </p>
            <v-spacer></v-spacer>
            <EditPostDialog
              v-if="user.id === post.user_id"
              :post="post"
              @submit="updatePost"
            />
            <a @click="$router.back()">戻る</a>
          </v-card-actions>
          <v-card-title>
            {{ post.content }}
          </v-card-title>
          <v-card-text v-if="post.tag"
            ><v-icon>mdi-tag</v-icon>{{ post.tag }}</v-card-text
          >
          <v-card-text v-if="post.privacy" class="red--text font-weight-bold"
            >Private</v-card-text
          >
          <v-card-text>
            <img
              v-if="post.image_url"
              :src="post.image_url"
              alt="投稿の画像"
              style="width: 100%; max-height: 500px; height: 100%"
            />
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <EditPostDialog
              v-if="user.id === post.user_id"
              :post="post"
              @submit="updatePost"
            />
            <a @click="$router.back()">戻る</a>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
    <h3 class="text-center">コメントを追加する</h3>
    <PostCommentForm :post="post" @submit="addPostComment" />
    <h3 v-if="count" class="text-center">
      <span class="green--text">{{ count }}</span
      >件のコメント
    </h3>
    <h3 v-else class="text-center">コメントはまだありません</h3>
    <v-row v-for="comment in post_comments" :key="comment.id">
      <v-col>
        <v-card>
          <v-card-actions>
            <UserCard :user="comment.user" />
            <p>
              {{
                $dateFns.format(
                  new Date(comment.created_at),
                  "yyyy/MM/dd HH:mm"
                )
              }}に投稿
            </p>
            <v-spacer></v-spacer>
            <!-- 編集済みとしたい -->
            <v-icon
              v-if="comment.user_id === user.id"
              @click="openEditPostCommentDialog(comment)"
              >edit</v-icon
            >
            <v-icon
              v-if="comment.user_id === user.id || user.admin"
              @click="deletePostComment(comment)"
              >delete</v-icon
            >
          </v-card-actions>
          <v-card-title>{{ comment.content }}</v-card-title>
          <img
            v-if="comment.image_url"
            :src="comment.image_url"
            alt="メモコメントの画像"
            style="width: 100%; max-height: 400px; height: 100%"
          />
        </v-card>
      </v-col>
    </v-row>
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
import PostCommentForm from "@/components/PostCommentForm";
import EditPostCommentDialog from "@/components/EditPostCommentDialog";

export default {
  head() {
    return {
      title: "メモ詳細",
    };
  },
  components: {
    EditPostDialog,
    PostCommentForm,
    EditPostCommentDialog,
  },
  data() {
    return {
      post: [],
      post_comments: [],
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
        .get(`/v1/posts/${this.$route.params.id}`)
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