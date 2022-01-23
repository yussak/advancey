<template>
  <div>
    <Header />
    <router-view />
  </div>
</template>

<script>
import Header from "./packs/components/Header";

export default {
  components: {
    Header,
  },
};
</script>