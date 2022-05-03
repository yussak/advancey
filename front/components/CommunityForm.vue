<template>
  <div>
    <ValidationObserver v-slot="{ invalid }" ref="addCommunityObserver">
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
          <v-btn :disabled="invalid" @click="handleSubmitCreateCommunity"
            >コミュニティを作成</v-btn
          >
        </v-container>
      </v-form>
    </ValidationObserver>
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: "",
      description: "",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
  methods: {
    handleSubmitCreateCommunity() {
      const community = new FormData();
      community.append("community[user_id]", this.user.id);
      community.append("community[name]", this.name);
      community.append("community[description]", this.description);
      this.$emit("submit", community);
      this.name = "";
      this.description = "";
      this.$refs.addCommunityObserver.reset();
    },
  },
};
</script>