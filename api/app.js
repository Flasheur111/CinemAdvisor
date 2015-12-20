var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var bodyParser = require('body-parser');


var cinema = require('./routes/cinema');
var room = require('./routes/room');
var comment = require('./routes/comment');

var app = express();

app.set('view engine', 'jade');
// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use('/cinema', cinema);
app.use('/room', room);
app.use('/comment', comment);

module.exports = app;
