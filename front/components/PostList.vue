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
                  <!-- サンプル画像 -->
                  <img
                    src="~assets/test.jpg"
                    style="width: 45px; height: 45px; border-radius: 50%"
                  />
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
        </v-tab-item>
        <v-tab-item>
          <v-card>
            <v-container fluid>
              <v-row dense>
                <!-- 空のときテキスト表示したい -->
                <v-col v-for="post in posts" :key="post.id" :cols="6">
                  <!-- 新しいのが下に追加されるので修正したい -->
                  <v-card>
                    <!-- サンプル画像 -->
                    <img
                      src="~assets/test.jpg"
                      style="width: 45px; height: 45px; border-radius: 50%"
                    />
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
                    <!-- サンプル画像 -->
                    <img
                      src="~assets/test.jpg"
                      style="width: 45px; height: 45px; border-radius: 50%"
                    />
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
      tab: null,
      titles: [
        { name: "全部のメモ" },
        { name: "自分のメモ" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "身についた" },
        { name: "いいね" },
      ],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    doi() {
      // これで絞り込める（けどリロードでエラー）
      return this.posts.filter((post) => {
        return post.tag === "実践中";
      });
    },
  },
  methods: {
    async showItem(item) {
      this.$router.push(`/posts/${item.id}`);
    },
    async deleteItem(item) {
      // 削除フラッシュ表示する（成功・失敗時）
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
        this.$store.commit("auth/setUser", newUser);
      }
    },
  },
};
</script>

<style>
</style>
