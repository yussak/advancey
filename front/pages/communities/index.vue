<template>
  <div>
    <h1>コミュニティ一覧</h1>
    <!-- 全て・参加中と分けたい -->
    <!-- 検索もしたい -->
    <v-form>
      <v-container>
        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="name"
              counter="100"
              label="コミュニティ名（必須）"
              required
            ></v-text-field>
          </v-col>
        </v-row>
        <!-- 詳細カラム後で作る -->
        <v-row>
          <v-col cols="12">
            <v-btn @click="createCommunity">コミュニティを作成</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>

    <div v-for="community in communities" :key="community.id">
      <p>コミュニティ名:{{ community.name }}</p>
      <!-- 作成者名も表示 -->
      <!-- 参加済みか判定でハマってる -->
      <v-btn v-if="isJoined">入る</v-btn>
      <v-btn v-else @click="joinCommunity(community)">参加する</v-btn>
      <v-divider></v-divider>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  head() {
    return {
      title: "コミュニティ一覧",
    };
  },
  data() {
    return {
      community: [],
      communities: [],
      name: "",
      isJoined: false,
    };
  },
  mounted() {
    this.fetchCommunities();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    joinCommunity(community) {
      const url = `/v1/communities/${community.id}/belongings`;
      axios
        .post(url, {
          community_id: community.id,
          user_id: this.user.id,
        })
        .then(() => {
          // community.isJoined = true;
          // this.isJoined = true;
          alert("ok");
        })
        .catch((err) => {
          console.log(err);
        });
    },
    fetchCommunities() {
      const url = `/v1/communities`;
      axios.get(url).then((res) => {
        this.communities = res.data;
      });
    },
    createCommunity() {
      // const urlに変えたい
      axios
        .post(`/v1/communities`, {
          name: this.name,
        })
        .then((res) => {
          this.community = res.data;
          this.fetchCommunities();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "質問を削除しました",
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
