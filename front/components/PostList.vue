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
          <v-row dense>
            <!-- 中身があってもリロード時空のテキストが一瞬表示されてしまうの要修正→createdなどに条件書くかも -->
            <!-- これで空の時テキスト表示出来たと思う -->
            <v-col v-if="!(posts && revPosts.length)">メモがありません</v-col>
            <v-col v-else v-for="post in revPosts" :key="post.id" :cols="6">
              <!-- <v-col v-else v-for="post in posts" :key="post.id" :cols="6"> -->
              <!-- 新しいのが下に追加されるので修正したい -->
              <v-card>
                <!-- ユーザー詳細ではリンクにしないようにしたい -->
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
                          <span style="font-weight: bold"
                            >{{ post.username }}さん</span
                          >が
                        </p>
                        <p>
                          {{
                            $dateFns.format(
                              new Date(post.created_at),
                              "yyyy/MM/dd HH:mm"
                            )
                          }}
                          に投稿
                        </p>
                      </v-row>
                    </v-card-text>
                  </v-card-actions>
                </nuxt-link>
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
        </v-tab-item>
        <!-- タブ2中身 -->
        <v-tab-item>
          <v-card>
            <v-row dense>
              <!-- これで空の時テキスト表示出来たと思う -->
              <v-col v-if="!(posts && revPosts.length)">メモがありません</v-col>
              <v-col v-else v-for="post in revPosts" :key="post.id" :cols="6">
                <!-- 新しいのが下に追加されるので修正したい -->
                <v-card>
                  <!-- ユーザー詳細ではリンクにしないようにしたい -->
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
                            <span style="font-weight: bold"
                              >{{ post.username }}さん</span
                            >が
                          </p>
                          <p>
                            {{
                              $dateFns.format(
                                new Date(post.created_at),
                                "yyyy/MM/dd HH:mm"
                              )
                            }}
                            に投稿
                          </p>
                        </v-row>
                      </v-card-text>
                    </v-card-actions>
                  </nuxt-link>
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
          </v-card>
        </v-tab-item>
        <!-- 実践中 -->
        <v-tab-item>
          <v-row dense>
            <!-- これで空の時テキスト表示出来たと思う -->
            <v-col v-if="!(posts && doingPosts.length)">メモがありません</v-col>
            <v-col v-else v-for="post in doingPosts" :key="post.id" :cols="6">
              <v-card>
                <!-- ユーザー詳細ではリンクにしないようにしたい -->
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
                          <span style="font-weight: bold"
                            >{{ post.username }}さん</span
                          >が
                        </p>
                        <p>
                          {{
                            $dateFns.format(
                              new Date(post.created_at),
                              "yyyy/MM/dd HH:mm"
                            )
                          }}
                          に投稿
                        </p>
                      </v-row>
                    </v-card-text>
                  </v-card-actions>
                </nuxt-link>
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
        </v-tab-item>
        <!-- 実践したい -->
        <v-tab-item>
          <v-row dense>
            <!-- これで空の時テキスト表示出来たと思う -->
            <v-col v-if="!(posts && wantPosts.length)">メモがありません</v-col>
            <v-col v-else v-for="post in wantPosts" :key="post.id" :cols="6">
              <v-card>
                <!-- ユーザー詳細ではリンクにしないようにしたい -->
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
                          <span style="font-weight: bold"
                            >{{ post.username }}さん</span
                          >が
                        </p>
                        <p>
                          {{
                            $dateFns.format(
                              new Date(post.created_at),
                              "yyyy/MM/dd HH:mm"
                            )
                          }}
                          に投稿
                        </p>
                      </v-row>
                    </v-card-text>
                  </v-card-actions>
                </nuxt-link>
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
        </v-tab-item>
        <!-- 身についた -->
        <v-tab-item>
          <v-row dense>
            <!-- これで空の時テキスト表示出来たと思う -->
            <v-col v-if="!(posts && masterPosts.length)"
              >メモがありません</v-col
            >
            <v-col v-else v-for="post in masterPosts" :key="post.id" :cols="6">
              <v-card>
                <!-- ユーザー詳細ではリンクにしないようにしたい -->
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
                          <span style="font-weight: bold"
                            >{{ post.username }}さん</span
                          >が
                        </p>
                        <p>
                          {{
                            $dateFns.format(
                              new Date(post.created_at),
                              "yyyy/MM/dd HH:mm"
                            )
                          }}
                          に投稿
                        </p>
                      </v-row>
                    </v-card-text>
                  </v-card-actions>
                </nuxt-link>
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
    revPosts() {
      return this.posts
        .slice()
        .reverse()
        .filter((post) => {
          if (post.user_id === this.user.id && post.privacy === false) {
            return true;
          }
        });
    },
    // タグ絞る＋若い投稿を上に表示+非公開投稿を除外
    doingPosts() {
      return this.posts
        .slice()
        .reverse()
        .filter((post) => {
          if (
            post.user_id === this.user.id &&
            post.privacy === false &&
            post.tag === "実践中"
          ) {
            return true;
          }
        });
    },
    wantPosts() {
      return this.posts
        .slice()
        .reverse()
        .filter((post) => {
          if (
            post.user_id === this.user.id &&
            post.privacy === false &&
            post.tag === "実践したい"
          ) {
            return true;
          }
        });
    },
    masterPosts() {
      return this.posts
        .slice()
        .reverse()
        .filter((post) => {
          if (
            post.user_id === this.user.id &&
            post.privacy === false &&
            post.tag === "身についた"
          ) {
            return true;
          }
        });
    },
    likeCount() {
      return this.likes.length;
    },
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
      return res.data;
    },
    async createLike(post) {
      await axios.post(`/v1/likes`, {
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
.user-link:hover {
  text-decoration: underline !important;
}
</style>
