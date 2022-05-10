<template>
  <div>
    <v-row>
      <v-col>
        <v-card class="mb-4">
          <v-card-actions>
            <p><UserCard v-if="post.user" :user="post.user" /></p>
            <v-card-text class="hidden-sm-and-down">
              <p v-if="post.created_at">
                {{
                  $dateFns.format(
                    new Date(post.created_at),
                    "yyyy/MM/dd HH:mm"
                  )
                }}に投稿
                <span v-if="post.created_at !== post.updated_at"
                  >(編集済み)</span
                >
              </p>
            </v-card-text>
            <v-spacer></v-spacer>
            <!-- ドロップダウン -->
            <v-menu v-if="user.id === post.user_id" v-model="postMenu">
              <template v-slot:activator="{ on, attrs }">
                <v-icon v-bind="attrs" v-on="on">mdi-dots-vertical</v-icon>
              </template>
              <v-list>
                <v-list-item>
                  <EditPostDialog :post="post" @submit="updatePost" />
                </v-list-item>
              </v-list>
            </v-menu>
          </v-card-actions>
          <v-card-text>
            <div class="hidden-md-and-up">
              <div class="d-flex">
                <p v-if="post.created_at">
                  {{
                    $dateFns.format(
                      new Date(post.created_at),
                      "yyyy/MM/dd HH:mm"
                    )
                  }}に投稿
                </p>
                <p v-if="post.created_at !== post.updated_at" class="ml-2">
                  (編集済み)
                </p>
              </div>
            </div>
          </v-card-text>
          <v-card-title class="br-content">{{ post.content }}</v-card-title>
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
              style="width: 100%; height: auto"
            />
          </v-card-text>
          <v-card-actions>
            <v-icon @click="$router.back()">mdi-arrow-left-bottom</v-icon>
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
            <p><UserCard :user="comment.user" /></p>
            <div class="hidden-sm-and-down">
              <p>
                {{
                  $dateFns.format(
                    new Date(comment.created_at),
                    "yyyy/MM/dd HH:mm"
                  )
                }}に投稿
                <span v-if="comment.created_at !== comment.updated_at"
                  >(編集済み)</span
                >
              </p>
            </div>
            <v-spacer></v-spacer>
            <!-- ドロップダウン -->
            <v-menu bottom v-model="comment.postCommentMenu">
              <template v-slot:activator="{ on, attrs }">
                <v-icon v-bind="attrs" v-on="on">mdi-dots-vertical</v-icon>
              </template>
              <v-list v-model="postCommentMenu">
                <v-list-item>
                  <EditPostCommentDialog
                    :post="post"
                    :comment="comment"
                    @submitEditPostComment="updatePostComment"
                  />
                </v-list-item>
                <v-list-item>
                  <v-btn text
                    ><v-icon
                      v-if="user.id === comment.user_id || user.admin"
                      @click="deletePostComment(comment)"
                      >delete</v-icon
                    >削除</v-btn
                  >
                </v-list-item>
              </v-list>
            </v-menu>
          </v-card-actions>
          <v-card-text>
            <div class="hidden-md-and-up">
              <p v-if="comment.created_at">
                {{
                  $dateFns.format(
                    new Date(comment.created_at),
                    "yyyy/MM/dd HH:mm"
                  )
                }}に投稿
              </p>
              <p v-if="comment.created_at !== comment.updated_at">(編集済み)</p>
            </div>
          </v-card-text>
          <v-card-title class="br-content">{{ comment.content }}</v-card-title>
          <img
            v-if="comment.image_url"
            :src="comment.image_url"
            alt="メモコメントの画像"
            style="width: 100%; height: auto"
          />
        </v-card>
      </v-col>
    </v-row>
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
      postMenu: false,
      postCommentMenu: false,
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    count() {
      return this.post_comments.length;
    },
  },
  mounted() {
    this.fetchPost();
    this.fetchPostCommentList();
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
          this.postMenu = false;
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

<style>
body {
  box-sizing: border-box;
}
</style>