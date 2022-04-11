export const state = () => ({
  // currentUser: {}
  currentUser: {
  name:"",
  profile:"",
  // imageFile:"",
  // image:"",
  image:[],
  // image_url:"",
  }
});

export const mutations = {
  setUser(state, payload) {
    state.currentUser = payload
  },
};

export const actions = {
  setUser (context, data) {
    context.commit('setUser', data)
  }
};
