<template>
  <div>
    <h2>private_posts</h2>
    <p>このページの投稿は自分だけが閲覧可能です</p>
    <v-container fluid>
      <v-row dense>
        <!-- 空のときテキスト表示できた -->
        <v-col v-if="!(privatePosts && privatePosts.length)"
          >非公開のメモがありません</v-col
        >
        <v-col v-else v-for="post in privatePosts" :key="post.id" :cols="4">
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
              </v-row>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>
<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "非公開メモ一覧",
    };
  },
  data() {
    return {
      private_posts: [],
      content: "",
    };
  },
  mounted() {
    this.fetchPrivatePosts();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
    privatePosts() {
      // これで自分＆非公開の投稿に絞れた
      // 新しい投稿を上に表示もできた
      return this.private_posts
        .slice()
        .reverse()
        .filter((post) => {
          if (post.privacy === true && post.user_id === this.user.id) {
            return true;
          }
        });
    },
  },
  methods: {
    fetchPrivatePosts() {
      const url = `/v1/private_posts`;
      axios.get(url).then((res) => {
        this.private_posts = res.data;
      });
    },
    async showItem(item) {
      this.$router.push(`/posts/${item.id}`);
    },
    async deleteItem(item) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/posts/${item.id}`);
        this.fetchPrivatePosts();
        this.$store.dispatch("notification/setNotice", {
          status: true,
          message: "メモを削除しました",
        });
        setTimeout(() => {
          this.$store.dispatch("notification/setNotice", {});
        }, 3000);
      }
    },
  },
};
</script>
