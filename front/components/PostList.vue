<template>
  <div>
    <h2 class="text-center">メモ一覧</h2>
    <v-card>
      <v-tabs grow>
        <!-- タイトル -->
        <v-tab v-for="title in titles" :key="title.id">
          {{ title.name }}
        </v-tab>
        <!-- タブ1中身 -->
        <v-tab-item>
          <v-container fluid>
            <v-row dense>
              <!-- 空のときテキスト表示したい -->
              <v-col v-for="post in posts" :key="post.id" :cols="6">
                <!-- 新しいのが下に追加されるので修正したい -->
                <v-card>
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
                        <span style="font-weight: bold"
                          >{{ post.username }}さん</span
                        >が
                      </p>
                      <p>{{ post.created_at }}に投稿</p>
                    </v-row>
                  </v-card-text>
                  <v-card-title v-text="post.content"></v-card-title>
                  <v-card-text>
                    <!-- v-if="post.image_url" -->
                    <img :src="post.image_url" alt="test" />
                  </v-card-text>
                  <v-card-text>
                    <v-row>
                      <!-- 後で消す→非公開の投稿自体ここに表示しないので -->
                      <p
                        v-if="post.privacy === true"
                        style="color: red; font-weight: bold"
                      >
                        Private
                      </p>
                      <v-icon @click="deleteItem(post)">delete</v-icon>
                      <v-icon @click="showItem(post)">mdi-magnify</v-icon>
                      <!-- タグがある時だけアイコン表示 -->
                      <p v-if="post.tag !== ''">
                        <v-icon>mdi-tag</v-icon>{{ post.tag }}
                      </p>
                      <v-icon
                        v-if="isLiked === true"
                        @click="deleteLike(post)"
                        style="color: red"
                      >
                        mdi-thumb-up
                      </v-icon>
                      <v-icon v-else @click="createLike(post)"
                        >mdi-thumb-up-outline</v-icon
                      >
                      <p>いいね数：{{ likeCount }}</p>
                    </v-row>
                  </v-card-text>
                </v-card>
              </v-col>
            </v-row>
          </v-container>
        </v-tab-item>
        <v-tab-item>
          <v-card>
            <v-container fluid>
              <v-row dense>
                <!-- 空のときテキスト表示したい -->
                <v-col v-for="post in posts" :key="post.id" :cols="6">
                  <!-- 新しいのが下に追加されるので修正したい -->
                  <v-card>
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
                          <span style="font-weight: bold"
                            >{{ post.username }}さん</span
                          >が
                        </p>
                        <p>{{ post.created_at }}に投稿</p>
                      </v-row>
                    </v-card-text>
                    <v-card-title v-text="post.content"></v-card-title>
                    <v-card-text>
                      <v-row>
                        <!-- 後で消す→非公開の投稿自体ここに表示しないので -->
                        <p
                          v-if="post.privacy === true"
                          style="color: red; font-weight: bold"
                        >
                          Private
                        </p>
                        <v-icon @click="deleteItem(post)">delete</v-icon>
                        <v-icon @click="showItem(post)">mdi-magnify</v-icon>
                        <!-- タグがある時だけアイコン表示 -->
                        <p v-if="post.tag !== ''">
                          <v-icon>mdi-tag</v-icon>{{ post.tag }}
                        </p>
                      </v-row>
                    </v-card-text>
                  </v-card>
                </v-col>
              </v-row>
            </v-container>
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card>
            <v-container fluid>
              <v-row dense>
                <!-- 空のときテキスト表示したい -->
                <!-- <v-col v-for="post in doi" :key="post.id" :cols="6"> -->
                <v-col v-for="post in posts" :key="post.id" :cols="6">
                  <!-- 新しいのが下に追加されるので修正したい -->
                  <v-card>
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
                          <span style="font-weight: bold"
                            >{{ post.username }}さん</span
                          >が
                        </p>
                        <p>{{ post.created_at }}に投稿</p>
                      </v-row>
                    </v-card-text>
                    <v-card-title v-text="post.content"></v-card-title>
                    <v-card-text>
                      <v-row>
                        <!-- 後で消す→非公開の投稿自体ここに表示しないので -->
                        <p
                          v-if="post.privacy === true"
                          style="color: red; font-weight: bold"
                        >
                          Private
                        </p>
                        <v-icon @click="deleteItem(post)">delete</v-icon>
                        <v-icon @click="showItem(post)">mdi-magnify</v-icon>
                        <!-- タグがある時だけアイコン表示 -->
                        <p v-if="post.tag !== ''">
                          <v-icon>mdi-tag</v-icon>{{ post.tag }}
                        </p>
                      </v-row>
                    </v-card-text>
                  </v-card>
                </v-col>
              </v-row>
            </v-container>
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card>
            <v-card-text> タブ4の内容をここに記述します。 </v-card-text>
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card>
            <v-card-text> タブ5の内容をここに記述します。 </v-card-text>
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card>
            <v-card-text> タブ6の内容をここに記述します。 </v-card-text>
          </v-card>
        </v-tab-item>
      </v-tabs>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  props: ["posts"],
  data() {
    return {
      search: "",
      titles: [
        { name: "全部のメモ" },
        { name: "自分のメモ" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "身についた" },
        { name: "いいね" },
      ],
      likes: [],
      post: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    // doi() {
    //   // これで絞り込める（けどリロードでエラー→mountedに書いてみる?それかシンプルにもう一度タブ分類で調べる）
    //   return this.posts.filter((post) => {
    //     return post.tag === "実践中";
    //   });
    // },
    // 一応動く
    likeCount() {
      return this.likes.length;
    },
    //1つでもあれば他の投稿もいいね有になってしまう説
    isLiked() {
      if (this.likes.length === 0) {
        return false;
      }
      return Boolean(this.findLikeId());
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
      if (res.status !== 200) {
        console.log(err); //これだとerr出ないので書き換える
      }
      return res.data;
    },
    async createLike(post) {
      await axios.post(`/v1/likes`, {
        // like{}で囲まなくても動く
        // user_id: this.$store.state.auth.currentUser.id,
        // post_id: post.id,
        // likes: {
        like: {
          user_id: this.$store.state.auth.currentUser.id,
          post_id: post.id,
        },
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
      const res = await axios.delete(`/v1/likes/${post.id}`);
      if (res.status !== 200) {
        console.log(err);
      }
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
    async showItem(item) {
      this.$router.push(`/posts/${item.id}`);
    },
    async deleteItem(item) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/posts/${item.id}`);
        const posts = this.user.posts.filter((post) => {
          return post.id !== item.id;
        });
        const newUser = {
          ...this.user,
          posts,
        };
        // 削除フラッシュ表示する（成功時）
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "メモを削除しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
        // 削除フラッシュ表示する（失敗時）
        this.$store.commit("auth/setUser", newUser);
      }
    },
  },
};
</script>

<style>
</style>
