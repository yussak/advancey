const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
// const { VueLoaderPlugin } = require('vue-loader')

// environment.plugins.prepend(
//     'VueLoaderPlugin',
//     new VueLoaderPlugin()
// )

// environment.loaders.prepend('vue', {
//     test: /\.vue$/,
//     use: [{loader: 'vue-loader']
// })

environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
)


module.exports = environment