import { createApp } from "vue";
import Link from "../components/Links.vue";
import router from './router'

document.addEventListener("DOMContentLoaded", () => {
  const app = createApp(Link);
app.use(router).mount("#spa-link-test");
  
});