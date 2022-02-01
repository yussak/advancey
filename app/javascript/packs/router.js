import { createRouter, createWebHistory } from 'vue-router'
import About from '../components/About.vue'
import UserIndex from '../components/Users/Index.vue'
import UserShow from '../components/Users/Show.vue'

const routes = [ //nameは必須
    {
    path: '/about-router',
    component: About,
    name:"About"
  },
  {
    path: '/users',
    component: UserIndex,
    name:"UserIndex"
  },
  {
    path: '/users/:id',
    component: UserShow,
    name:"UserShow"
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router