<template>
  <div>
    <v-card>
      <nuxt-link
        :to="`/users/${user.id}`"
        style="text-decoration: none; color: black"
        class="user-link"
      >
        <v-card-actions>
          <!-- ここUserCardに変える -->
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
        </v-row>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  props: ["post"],
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    async showItem(post) {
      this.$router.push(`/posts/${post.id}`);
    },
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
        // this.$store.commit("auth/setUser", newUser);
      }
    },
  },
};
</script>
