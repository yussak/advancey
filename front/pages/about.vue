<template>
  <div>
    <h1 class="text-h3 text-center green--text mb-4">Advanceyとは</h1>
    <p class="text-center font-weight-bold">
      目標に向かって行動するのが楽しくなるSNSサービスです。
    </p>
    <h2 class="green--text text-center my-4">Advanceyの使い方</h2>
    <h3>メモして分類できます</h3>
    <ul class="mb-8 mt-2">
      <li>
        タメになったこと・印象に残ったこと・やってみたいこと・やってよかったことなど何でもメモしてみましょう！
      </li>
      <li>
        メモを「実践中・実践したい・実践済み・やって良かった」と分類でき、情報を整理できます。<br />今継続しているメモには「実践中」をつけることで「今私はこんなことを頑張っている」ということを確認できモチベーションにつながります。<br />後々やってみたいメモには「実践したい」をつけてみましょう。そしてどんどん挑戦していきましょう！<br />そうして効果があった行動には「やって良かった」をつけてみましょう！
      </li>
      <li>
        他のユーザーに見られたくないメモは非公開にすることができます。投稿時チェックをすると「非公開メモ」ページだけから閲覧可能になります。
      </li>
      <li>
        ホームやユーザーページから他のユーザーのメモなどを見てみましょう！モチベーションをもらえるかもしれません。
      </li>
    </ul>
    <h3>他のユーザーに質問できます</h3>
    <ul class="mb-8 mt-2">
      <li>
        問題を自分だけで解決できる人はいません。気になることは気軽に質問してみましょう！
      </li>
      <li>自由に回答も可能です。</li>
      <li>クローズにすると回答受付を終了できます。</li>
    </ul>
    <h3>目標を立てることができます</h3>
    <ul class="mb-8 mt-2">
      <li>
        作成時に達成したいこと・達成したい理由・そのためにやることを入力するのでモチベーションを保てます。
      </li>
      <li>
        カレンダーに毎日コメントを追加でき、やったこと・気づいたこと・感想などをメモして眺めるとモチベーションになります。
      </li>
    </ul>
    <h3>コミュニティで仲間とつながれます</h3>
    <ul class="mb-4">
      <li>好きなテーマについて、リアルタイムチャットで盛り上がりましょう！</li>
      <li>申請はなく自由にチャットルームに出入りできます。</li>
    </ul>
    <nuxt-link :to="`/signup`" v-if="!user">新規登録はこちら</nuxt-link>
  </div>
</template>

<script>
export default {
  head() {
    return {
      title: "サービス詳細",
    };
  },
  computed: {
    user() {
      return this.$store.state.auth.currentUser;
    },
  },
};
</script>