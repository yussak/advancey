<template>
  <div>
    <!-- cycle -->
    <v-carousel height="400" hide-delimiter-background show-arrows-on-hover>
      <v-carousel-item>
        <v-sheet
          color="light-green lighten-3"
          height="100%"
          style="padding: 0 30px"
        >
          <v-row class="fill-height" align="center" justify="center">
            <div class="text-center">
              <p class="text-h4">Advanceyの使い方</p>
            </div>
          </v-row>
        </v-sheet>
      </v-carousel-item>
      <v-carousel-item>
        <v-sheet color="pink lighten-4" height="100%" style="padding: 0 30px">
          <v-row class="fill-height" align="center" justify="center">
            <div class="text-center">
              <p class="text-h5">メモを追加しましょう</p>
              <p class="text-h6">役立ったことなど何でもメモしてみましょう</p>
              <p class="text-h6">
                やっていること・やりたいこと・やってよかったことに<br />分類できます
              </p>
              <p class="text-h6">非公開にすると自分だけが閲覧できます</p>
            </div>
          </v-row>
        </v-sheet>
      </v-carousel-item>
      <v-carousel-item>
        <v-sheet color="blue lighten-4" height="100%" style="padding: 0 30px">
          <v-row class="fill-height" align="center" justify="center">
            <div class="text-center">
              <p class="text-h5">質問をしてみましょう</p>
              <p class="text-h6">分かる質問には回答してみましょう</p>
              <p class="text-h6">解決した問題はクローズすることができます。</p>
            </div>
          </v-row>
        </v-sheet>
      </v-carousel-item>
      <v-carousel-item>
        <v-sheet color="lime lighten-4" height="100%" style="padding: 0 30px">
          <v-row class="fill-height" align="center" justify="center">
            <div class="text-center">
              <p class="text-h5">目標を立てましょう</p>
              <p class="text-h6">
                達成したいこと・その理由・やること<br />を明確にし、継続・達成しましょう
              </p>
              <p class="text-h6">カレンダーに毎日コメントできます</p>
            </div>
          </v-row>
        </v-sheet>
      </v-carousel-item>
      <v-carousel-item>
        <v-sheet color="orange lighten-4" height="100%" style="padding: 0 30px">
          <v-row class="fill-height" align="center" justify="center">
            <div class="text-center">
              <p class="text-h5">コミュニティに参加しましょう</p>
              <p class="text-h6">テーマを決めて仲間と集まりましょう</p>
              <p class="text-h6">リアルタイムチャットで盛り上がりましょう</p>
              <p class="text-h6">出入りは自由です</p>
            </div>
          </v-row>
        </v-sheet>
      </v-carousel-item>
    </v-carousel>
  </div>
</template>