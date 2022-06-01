<template>
  <div>
    <v-carousel
      cycle
      height="400"
      hide-delimiter-background
      show-arrows-on-hover
    >
      <v-carousel-item
        src="https://images.pexels.com/photos/56832/road-asphalt-space-sky-56832.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
      >
        <v-row
          class="fill-height"
          align="center"
          justify="center"
          style="padding: 0 30px"
        >
          <div class="text-center">
            <p class="text-h3 black--text font-weight-bold">Advanceyの使い方</p>
          </div>
        </v-row>
      </v-carousel-item>
      <v-carousel-item
        src="https://images.pexels.com/photos/316466/pexels-photo-316466.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
      >
        <v-row
          class="fill-height"
          align="center"
          justify="center"
          style="padding: 0 30px"
        >
          <div class="text-center">
            <p class="text-h5 font-weight-bold">メモを追加しましょう！</p>
            <p class="text-h6">役立ったことなど何でもメモしてみましょう</p>
            <p class="text-h6">
              やっていること・やりたいこと・やってよかったこと<br />に分類できます
            </p>
            <p class="text-h6">非公開にすると自分だけが閲覧できます</p>
          </div>
        </v-row>
      </v-carousel-item>
      <v-carousel-item
        src="https://images.pexels.com/photos/3683053/pexels-photo-3683053.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
      >
        <v-row
          class="fill-height"
          align="center"
          justify="center"
          style="padding: 0 30px"
        >
          <div class="text-center">
            <p class="text-h5 font-weight-bold">質問してましょう！</p>
            <p class="text-h6">分かる質問には回答してみましょう</p>
            <p class="text-h6">解決した問題はクローズすることができます。</p>
          </div>
        </v-row>
      </v-carousel-item>
      <v-carousel-item
        src="https://images.pexels.com/photos/3680111/pexels-photo-3680111.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
      >
        <v-row
          class="fill-height"
          align="center"
          justify="center"
          style="padding: 0 30px"
        >
          <div class="text-center" color="grey lighten-3">
            <p class="text-h5 font-weight-bold">目標を達成しましょう！</p>
            <p class="text-h6">
              達成したいこと・その理由・やること<br />を明確にし、継続・達成しましょう
            </p>
            <p class="text-h6">カレンダーにコメントできます</p>
          </div>
        </v-row>
      </v-carousel-item>
      <v-carousel-item
        src="https://images.pexels.com/photos/1111368/pexels-photo-1111368.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
      >
        <v-row
          class="fill-height"
          align="center"
          justify="center"
          style="padding: 0 30px"
        >
          <div class="text-center white--text">
            <p class="text-h5 font-weight-bold">
              コミュニティに参加しましょう！
            </p>
            <p class="text-h6">テーマを決めて仲間と集まりましょう</p>
            <p class="text-h6">リアルタイムチャットで盛り上がりましょう</p>
            <p class="text-h6">出入りは自由です</p>
          </div>
        </v-row>
      </v-carousel-item>
    </v-carousel>
  </div>
</template>