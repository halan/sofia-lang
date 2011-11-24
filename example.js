var util = require('util');
var parser = require('./grammar');

console.log(util.inspect(parser.parse('3+4'), false, null));
