<template>
  <div v-if="user">
    <!-- <UserCard :user="user" /> -->
    <!-- <PostForm @submit="addPost" /> -->
    <!-- <PostList :posts="posts" /> -->
    <v-card>
      <v-tabs grow>
        <!-- メモ、質問、目標、コミュニティ -->
        <v-tab v-for="title in outerTitles" :key="title.id">
          {{ title.name }}
        </v-tab>
        <!-- メモ -->
        <!-- PostList使いたい -->
        <v-tab-item>
          <v-row dense>
            <v-col>
              <v-card>
                <v-tabs grow>
                  <v-tab v-for="title in memoTitles" :key="title.id">
                    {{ title.name }}
                  </v-tab>
                  <v-tab-item>
                    <v-row dense>
                      <!-- 中身があってもリロード時空のテキストが一瞬表示されてしまうの要修正 -->
                      <!-- これで行けたかも→削除なおしたらまた検証 -->
                      <v-col
                        v-for="post in posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard :post="post" v-if="posts && posts.length" />
                        <p v-else>no MEMO</p>
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(posts && doing_posts.length)"
                        >メモがありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="post in doing_posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard :post="post" />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(posts && want_posts.length)"
                        >メモがありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="post in want_posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard :post="post" />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col v-if="!(posts && master_posts.length)"
                        >メモがありません</v-col
                      >
                      <v-col
                        v-else
                        v-for="post in master_posts"
                        :key="post.id"
                        cols="12"
                        md="6"
                      >
                        <PostCard :post="post" />
                      </v-col>
                    </v-row>
                  </v-tab-item>
                </v-tabs>
              </v-card>
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 質問 -->
        <v-tab-item>
          <v-row dense>
            <v-col>
              <v-card>
                <v-tabs grow>
                  <v-tab v-for="title in topicTitles" :key="title.id">
                    {{ title.name }}
                  </v-tab>
                  <v-tab-item>
                    <v-row dense>
                      <v-col>topic1</v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col>topic2</v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col>topic3</v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col>topic4</v-col>
                    </v-row>
                  </v-tab-item>
                </v-tabs>
              </v-card>
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- 目標 -->
        <v-tab-item>
          <v-row dense>
            <v-col>
              <v-card>
                <v-tabs grow>
                  <v-tab v-for="title in goalTitles" :key="title.id">
                    {{ title.name }}
                  </v-tab>
                  <v-tab-item>
                    <v-row dense>
                      <v-col>goal1</v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col>goal2</v-col>
                    </v-row>
                  </v-tab-item>
                  <v-tab-item>
                    <v-row dense>
                      <v-col>goal3</v-col>
                    </v-row>
                  </v-tab-item>
                </v-tabs>
              </v-card>
            </v-col>
          </v-row>
        </v-tab-item>
        <!-- コミュニティ -->
        <v-tab-item>
          <v-row dense>
            <v-col>
              <v-card>
                <v-tabs grow>
                  <v-tab v-for="title in communityTitles" :key="title.id">
                    {{ title.name }}
                  </v-tab>
                  <v-tab-item>
                    <v-row dense>
                      <v-col>community1</v-col>
                    </v-row>
                  </v-tab-item>
                </v-tabs>
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
import PostForm from "@/components/PostForm";
import PostList from "@/components/PostList";

export default {
  // middleware: "login-check", //ログイン後でもリロードするとリダイレクトされる
  head() {
    return {
      title: "ホーム",
    };
  },
  components: {
    PostForm,
    PostList,
  },
  data() {
    return {
      posts: [],
      doing_posts: [],
      want_posts: [],
      master_posts: [],
      outerTitles: [
        { name: "メモ" },
        { name: "Q&A" },
        { name: "目標" },
        { name: "コミュニティ" },
      ],
      memoTitles: [
        { name: "全て" },
        { name: "実践中" },
        { name: "実践したい" },
        { name: "身についた" },
      ],
      topicTitles: [{ name: "全て" }, { name: "未解決" }, { name: "解決済み" }],
      goalTitles: [{ name: "全て" }, { name: "未達成" }, { name: "達成済み" }],
      communityTitles: [{ name: "全て" }],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchTopObjects();
  },
  methods: {
    fetchTopObjects() {
      const url = `/v1/top_page/posts`;
      axios.get(url).then((res) => {
        console.log(res.data);
        this.posts = res.data.posts;
        this.doing_posts = res.data.doing_posts;
        this.want_posts = res.data.want_posts;
        this.master_posts = res.data.master_posts;
      });
    },
    async addPost(post) {
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      axios
        .post(`/v1/posts`, post, config)
        .then(() => {
          this.fetchPostList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "投稿を追加しました",
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