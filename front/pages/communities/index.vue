<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="addCommunityObserver">
      <!-- コンポ化したい -->
      <v-form class="white">
        <v-container>
          <ValidationProvider
            rules="required|max:100"
            name="名前"
            v-slot="{ errors }"
          >
            <v-text-field
              v-model="name"
              counter="100"
              label="コミュニティ名（必須）"
            ></v-text-field>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <ValidationProvider
            rules="required|max:200"
            name="概要"
            v-slot="{ errors }"
          >
            <v-textarea
              v-model="description"
              counter="200"
              label="概要を入力（必須）"
            ></v-textarea>
            <p v-if="errors" class="error-message">{{ errors[0] }}</p>
          </ValidationProvider>
          <v-btn :disabled="invalid" @click="createCommunity"
            >コミュニティを作成</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
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
import CommunityCard from "@/components/CommunityCard";

export default {
  components: {
    CommunityCard,
  },
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
      const url = `/v1/communities`;
      axios.get(url).then((res) => {
        this.communities = res.data;
      });
    },
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
          this.$store.dispatch("notification/setNotice", {
            status: true,
            message: "コミュニティを作成しました",
          });
          setTimeout(() => {
            this.$store.dispatch("notification/setNotice", {});
          }, 3000);
          this.name = "";
          this.description = "";
          this.$refs.addCommunityObserver.reset();
        })
        .catch((err) => {
          console.log(err);
        });
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
  },
};
</script>
