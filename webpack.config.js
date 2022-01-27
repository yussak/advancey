const path = require('path')
const { VueLoaderPlugin } = require('vue-loader')

module.exports = {
  module: {
    rules: [
      {
        test: /\.vue$/,
        use: ['vue-style-loader']
      }
    ]
  },
    plugins: [
      new VueLoaderPlugin()
    ]
  }

// module.exports = {
//   module: {
//     rules: [
//       {
//         test: /\.vue$/,
//         loader: 'vue-loader'
//       }
//     ]
//   },
//   plugins: [
//     new VueLoaderPlugin()
//   ]
// }