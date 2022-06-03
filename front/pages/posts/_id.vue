<template>
  <div>
    <v-card class="mb-4">
      <v-card-text class="font-weight-bold text-h6"
        ><v-icon @click="$router.back()" class="mr-4">mdi-arrow-left</v-icon
        >メモ</v-card-text
      >
      <v-divider></v-divider>
      <v-card-actions class="pb-0">
        <p><UserCard v-if="post.user" :user="post.user" /></p>
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
      <v-card-title class="br-content body-1 pt-0">{{
        post.content
      }}</v-card-title>
      <v-card-text class="text-center" v-if="post.image_url">
        <img
          :src="post.image_url"
          alt="投稿の画像"
          style="max-width: 100%; max-height: 200px"
        />
      </v-card-text>
      <v-card-text v-if="post.created_at">
        {{ $dateFns.format(new Date(post.created_at), "yyyy/MM/dd HH:mm") }}
        <span v-if="post.created_at !== post.updated_at">(編集済み)</span>
      </v-card-text>
      <v-divider></v-divider>
      <v-card-text>
        <span v-if="post.tag" class="mr-4"
          ><v-icon>mdi-tag</v-icon>{{ post.tag }}</span
        >
        <span v-if="post.privacy" class="red--text font-weight-bold">
          Private
        </span>
      </v-card-text>
    </v-card>
    <PostCommentForm :post="post" @submit="addPostComment" />
    <h3 v-if="count" class="text-center my-4">
      <span class="green--text">{{ count }}</span
      >件のコメント
    </h3>
    <h3 v-else class="text-center my-4">コメントはまだありません</h3>
    <v-row v-for="comment in post_comments" :key="comment.id">
      <v-col>
        <v-card>
          <v-card-actions class="pb-0">
            <p><UserCard :user="comment.user" /></p>
            <v-spacer></v-spacer>
            <!-- ドロップダウン -->
            <v-menu bottom v-model="comment.postCommentMenu">
              <template v-slot:activator="{ on, attrs }">
                <v-icon v-bind="attrs" v-on="on">mdi-dots-vertical</v-icon>
              </template>
              <v-list>
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
          <v-divider></v-divider>
          <v-card-title class="br-content body-1">{{
            comment.content
          }}</v-card-title>
          <v-card-text class="text-center" v-if="comment.image_url">
            <img
              :src="comment.image_url"
              alt="メモコメントの画像"
              style="max-width: 100%; max-height: 200px"
            />
          </v-card-text>
          <v-card-text>
            {{
              $dateFns.format(new Date(comment.created_at), "yyyy/MM/dd HH:mm")
            }}
            <span v-if="comment.created_at !== comment.updated_at"
              >(編集済み)</span
            >
          </v-card-text>
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