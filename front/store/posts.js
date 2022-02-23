// とりあえずコメント削除機能のためこのファイルに処理を書く（教材・ガジェコミ見ながら）

// 状態を保存
export const state = () => ({
  // foo: {}
});

// 保存をするためStateに書き込む
export const mutations = {
  hogeFuga(state, payload) {
    // state.foo = payload
  },
};

// Mutationを発火させる
export const actions = {
  hogeFuga (context, data) {
    // context.commit('hogeFuga', data)
  }
};
