<template>
  <div>
    <v-card>
      <nuxt-link
        :to="`/users/${user.id}`"
        style="text-decoration: none; color: black"
        class="user-link"
      >
        <v-card-actions>
          <v-avatar>
            <!-- アイコン設定がないとき→条件は後で追加 -->
            <img
              src="~assets/default-user-icon.png"
              style="width: 45px; height: 45px"
            />
          </v-avatar>
          <v-card-text>
            <v-row>
              <p>
                <!-- user#show読んでた -->
                <span style="font-weight: bold">{{ post.user.name }}さん</span
                >が
              </p>
              <p>
                {{
                  $dateFns.format(new Date(post.created_at), "yyyy/MM/dd HH:mm")
                }}
                に投稿
              </p>
            </v-row>
          </v-card-text>
        </v-card-actions>
      </nuxt-link>
      <v-card-title v-text="post.content"></v-card-title>
      <v-card-text>
        <img v-if="post.image_url" :src="post.image_url" alt="test" />
      </v-card-text>
      <v-card-text>
        <v-row>
          <!-- わかりやすさのため残す -->
          <p v-if="post.privacy === true" style="color: red; font-weight: bold">
            Private
          </p>
          <v-icon @click="deleteItem(post)">delete</v-icon>
          <v-icon @click="showItem(post)">mdi-magnify</v-icon>
          <!-- タグがある時だけアイコン表示 -->
          <p v-if="post.tag !== ''"><v-icon>mdi-tag</v-icon>{{ post.tag }}</p>
          <v-icon
            v-if="isLiked === true"
            @click="deleteLike(post)"
            style="color: red"
          >
            mdi-thumb-up
          </v-icon>
          <v-icon v-else @click="createLike(post)">mdi-thumb-up-outline</v-icon>
          <p>{{ likeCount }}</p>
        </v-row>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  props: ["post"],
  data() {
    return {
      likes: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    isLiked() {
      if (this.likes.length === 0) {
        return false;
      }
      return Boolean(this.findLikeId());
    },
    likeCount() {
      return this.likes.length;
    },
  },
  created() {
    this.fetchLikeByPostId().then((res) => {
      this.likes = res;
    });
  },
  methods: {
    async fetchLikeByPostId() {
      const res = await axios.get(`/v1/likes/`);
      return res.data;
    },
    async createLike(post) {
      await axios.post(`/v1/likes`, {
        user_id: this.$store.state.auth.currentUser.id,
        post_id: post.id,
      });
      this.fetchLikeByPostId()
        .then((res) => {
          this.likes = res;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteLike(post) {
      const likeId = this.findLikeId();
      await axios.delete(`/v1/likes/${post.id}`);
      this.likes = this.likes.filter((n) => n.id !== likeId);
    },
    findLikeId() {
      const like = this.likes.find((like) => {
        return like.user_id === this.user.id;
      });
      if (like) {
        return like.id;
      }
    },
    async showItem(post) {
      this.$router.push(`/posts/${post.id}`);
    },
    // 消せるけどエラー出る・リロードしないと反映されないので対処
    async deleteItem(item) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/posts/${item.id}`);
        // 一覧から削除するよう修正したい
        // const posts = this.user.posts.filter((post) => {
        //   return post.id !== item.id;
        // });
        // const newUser = {
        //   ...this.user,
        //   posts,
        // };
        // 削除フラッシュ表示する（成功時）
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "メモを削除しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
        // 削除フラッシュ表示する（失敗時）
        // this.$store.commit("auth/setUser", newUser);
      }
    },
  },
};
</script>
