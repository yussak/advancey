import { createApp } from "vue";
import Link from "../components/Links.vue";
import router from './router'

document.addEventListener("DOMContentLoaded", () => {
  createApp(Link).use(router).mount("#spa-link-test");
});