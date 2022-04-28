<template>
  <div>
    <v-row class="text-center">
      <v-col cols="12">
        <h2 class="about_heading about-heading-large">
          Advanceyは、学んだことや考えたことを<br />気軽にメモして実践しよう！というサービスです。
        </h2>
        <h3 class="about_heading about-heading-middle">Advanceyのメリット</h3>
        <div style="margin-top: 40px">
          <h4 class="about_heading about-heading-small">
            自分が今継続していることを一覧で見てモチベーションを高めましょう
          </h4>
          <p class="about-text">
            自分はこんなことを頑張っているのだ！ということを確認でき、より一層励むことができます。
          </p>
          <h4 class="about_heading about-heading-small">
            自分が今やりたいことをメモして後で見直すことができます
          </h4>
          <p class="about-text">
            何か新しいことを学んだらとりあえずメモしてみましょう。そして気が向いたらチャレンジしてみましょう
          </p>
          <h4 class="about_heading about-heading-small">
            やってよかった行動を見ることができます
          </h4>
          <p class="about-text">意味のあったことは何度でも繰り返しましょう。</p>
          <h4 class="about_heading about-heading-small">
            ユーザー一覧からいろんな人の投稿を見てみましょう！
          </h4>
          <p class="about-text">
            他のユーザーが実践している投稿を見ることでモチベーションに繋がります
          </p>
          <h4 class="about_heading about-heading-small">
            他のユーザーに質問をすることができます
          </h4>
          <p class="about-text">
            問題を自分だけで解決できる人はいません。気になることは気軽に質問してみましょう！新しいアイデアを取り入れられるかも。
          </p>
          <h4 class="about_heading about-heading-small">
            目標を立てることができます
          </h4>
          <p class="about-text">
            目標に向けてやったことをカレンダーに記録することが出来ます
          </p>
          <h4 class="about_heading about-heading-small">
            コミュニティで仲間とつながることが出来ます
          </h4>
          <p class="about-text">
            好きなテーマを立ててチャットで盛り上がりましょう！
          </p>
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
export default {
  head() {
    return {
      title: "サービス詳細",
    };
  },
  data() {
    return {
      Title:
        "Advanceyは、学んだことや考えたことを気軽にメモして実践しよう！というサービスです。",
    };
  },
};
</script>

<style scoped lang="scss">
.about_heading {
  color: green;
}
.about-heading-large {
  font-weight: bold;
}

.about-heading-middle {
  font-size: 32px;
}

.about-heading-small {
  font-size: 20px;
  font-weight: bold;
}

.about-text {
  font-size: 16px;
  margin-top: 1em;
}
</style>