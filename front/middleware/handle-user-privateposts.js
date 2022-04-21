export default function ({ from, redirect, route, store }) {
  // ダイレクトアクセス禁止
  if(from.name === route.name) {
    redirect('/notAllowPage')
  }
}