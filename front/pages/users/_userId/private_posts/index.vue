<template>
  <div>
    <h2>非公開メモ一覧</h2>
    <p>このページのメモは自分だけが閲覧可能です</p>
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
            <v-col v-if="!(private_posts && private_posts.length)"
              >非公開のメモがありません</v-col
            >
            <v-col
              v-else
              v-for="post in private_posts"
              :key="post.id"
              :cols="6"
            >
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
                    <p
                      v-if="post.privacy === true"
                      style="color: red; font-weight: bold"
                    >
                      Private
                    </p>
                    <v-icon @click="deleteItem(post)">delete</v-icon>
                    <v-icon @click="showItem(post)">mdi-magnify</v-icon>
                    <p v-if="post.tag !== ''">
                      <v-icon>mdi-tag</v-icon>{{ post.tag }}
                    </p>
                  </v-row>
                </v-card-text>
              </v-card>
            </v-col>
          </v-row>
        </v-tab-item>
      </v-tabs>
    </v-card>
  </div>
</template>
<script>
import axios from "@/plugins/axios";

export default {
  middleware: "handle-user-privateposts",
  head() {
    return {
      title: "非公開メモ一覧",
    };
  },
  data() {
    return {
      private_posts: [],
      titles: [
        { name: "全部のメモ" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "身についた" },
      ],
    };
  },
  mounted() {
    this.fetchPrivatePostList();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    fetchPrivatePostList() {
      const url = `/v1/users/${this.$route.params.userId}/private_posts`;
      axios
        .get(url)
        .then((res) => {
          this.private_posts = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async showItem(item) {
      this.$router.push(`/posts/${item.id}`);
    },
    async deleteItem(item) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(`/v1/posts/${item.id}`);
        this.fetchPrivatePostList();
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
