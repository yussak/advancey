import About from '../pages/about.vue'

describe('pages/about.vue', () => {
  it('has a default value', () => {
    const defaultData = About.data()
    expect(defaultData.Title).toBe("Advanceyは、学んだことや考えたことを気軽にメモして実践しよう！というサービスです。")
  })
})