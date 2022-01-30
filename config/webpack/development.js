process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

const { VueLoaderPlugin } = require('vue-loader')
environment.plugins.prepend(
  'VueLoaderPlugin',
  new VueLoaderPlugin()
)

environment.loaders.prepend('vue', {
  test: /\.vue$/,
  use: [{
    loader: 'vue-loader'
}]
})

module.exports = environment.toWebpackConfig()
