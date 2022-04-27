export default function ({  store, redirect }) {
  const isLoggedIn = store.getters['auth/isAuthenthicated'];

  if(!isLoggedIn){
    redirect('/about')
  }
}