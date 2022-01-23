import Vue from 'vue';
import * as VueRouter from 'vue-router';
import { createRouter, createWebHistory } from 'vue-router'

import About from './components/About.vue';

const routes = [
  {
    path: '/about',
    component: About
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;