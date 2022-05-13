import About from '../pages/about.vue'

describe('pages/about.vue', () => {
  it('タイトルが存在', () => {
    const head = About.head()
    expect(head.title).toBe("サービス詳細")
  })
})