<template>
  <div style="background: gainsboro">
    <h2>Links.vue</h2>
    <router-link to="/" style="margin-right: 5px">Home</router-link>
    <router-link to="/about-router" style="margin-right: 5px"
      >about</router-link
    >
    <router-view></router-view>
  </div>
</template>