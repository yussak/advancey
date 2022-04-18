<template>
  <div>
    <h1>コミュニティ一覧</h1>
    <!-- 全て・参加中と分けたい -->
    <!-- 検索もしたい -->
    <v-form>
      <v-container>
        <v-text-field
          v-model="name"
          counter="100"
          label="コミュニティ名（必須）"
          required
        ></v-text-field>
        <v-textarea
          v-model="description"
          counter="200"
          label="詳細を入力（必須）"
          required
        ></v-textarea>
        <v-btn @click="createCommunity">コミュニティを作成</v-btn>
      </v-container>
    </v-form>

    <div v-for="community in communities" :key="community.id">
      <p>コミュニティ名:{{ community.name }}</p>
      <!-- 参加判定がうまく出来ない→一旦だれでも出入り可能にする -->
      <v-btn @click="showCommunity(community)">チャットルームに入る</v-btn>
      <v-icon
        v-if="user.id === community.user_id"
        @click="deleteCommunity(community)"
        >delete</v-icon
      >
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
      description: "",
    };
  },
  mounted() {
    this.fetchCommunityList();
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    createCommunity() {
      const url = "/v1/communities";
      axios
        .post(url, {
          user_id: this.user.id,
          name: this.name,
          description: this.description,
        })
        .then((res) => {
          this.community = res.data;
          this.fetchCommunityList();
          (this.name = ""),
            (this.description = ""),
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
    async showCommunity(community) {
      this.$router.push(`/communities/${community.id}`);
    },
    async deleteCommunity(community) {
      const url = `/v1/communities/${community.id}`;
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios.delete(url).then(() => {
          this.fetchCommunityList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コミュニティを削除しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        });
      }
    },
    // joinCommunity(community) {
    //   const url = `/v1/communities/${community.id}/belongings`;
    //   axios
    //     .post(url, {
    //       community_id: community.id,
    //       user_id: this.user.id,
    //     })
    //     .then(() => {
    //       this.fetchCommunityList();
    //     })
    //     .catch((err) => {
    //       console.log(err);
    //     });
    // },
    fetchCommunityList() {
      const url = `/v1/communities`;
      axios.get(url).then((res) => {
        this.communities = res.data;
      });
    },
  },
};
</script>
