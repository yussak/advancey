<template>
  <div>
    <CommunityForm @submit="addCommunity" />
    <h2 class="text-center">コミュニティ一覧</h2>
    <v-row>
      <v-col v-for="community in communities" :key="community.id" :cols="12">
        <CommunityCard
          :community="community"
          @submitDeleteCommunity="deleteCommunity"
        />
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import CommunityForm from "@/components/CommunityForm";
import CommunityCard from "@/components/CommunityCard";

export default {
  head() {
    return {
      title: "コミュニティ一覧",
    };
  },
  components: {
    CommunityForm,
    CommunityCard,
  },
  data() {
    return {
      communities: [],
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  mounted() {
    this.fetchCommunityList();
  },
  methods: {
    fetchCommunityList() {
      axios
        .get(`/v1/communities`)
        .then((res) => {
          this.communities = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async addCommunity(community) {
      axios
        .post(`/v1/communities`, community)
        .then(() => {
          this.fetchCommunityList();
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コミュニティを作成しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
        })
        .catch((err) => {
          console.log(err);
        });
    },
    async deleteCommunity(community) {
      const res = confirm("本当に削除しますか？");
      if (res) {
        await axios
          .delete(`/v1/communities/${community.id}`)
          .then(() => {
            this.fetchCommunityList();
            this.$store.dispatch("notification/setNotice", {
              status: true,
              message: "コミュニティを削除しました",
            });
            setTimeout(() => {
              this.$store.dispatch("notification/setNotice", {});
            }, 3000);
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
  },
};
</script>
