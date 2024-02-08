process.env.NODE_ENV = process.env.NODE_ENV || 'demo'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()
