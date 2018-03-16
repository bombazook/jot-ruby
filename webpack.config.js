var webpack = require("webpack");
var path = require("path");

module.exports = {
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'jot.js'
  },
  entry: './jot/browser_example/browserfy_root',
  mode: 'production'
}
