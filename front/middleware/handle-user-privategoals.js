export default function ({ from, redirect, route }) {
  // ダイレクトアクセス禁止
  if(from.name === route.name) {
    redirect('/notAllowPage')
  }
}