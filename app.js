var debug = require('debug')('social-media');
var express = require('express');
var fs = require('fs');
var path = require('path');
var favicon = require('serve-favicon');
var morgan = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var expressSession = require('express-session');

var routes = require('./routes/index');
var users = require('./routes/users');
var flash = require('./routes/flash');

var env_var =  process.env.NODE_ENV || "development"
var config = require('./routes/config')[env_var];


var app = express();

// create a write stream (in append mode)
var accessLogStream = fs.createWriteStream(__dirname + '/log/access.log', {flags: 'a'})

app.set('port', process.env.PORT || 3001);

// view engine setup
app.set('views', path.join(__dirname, 'views'));
//app.set('view engine', 'jade');
app.set('view engine', 'ejs');

// uncomment after placing your favicon in /public
app.use(favicon(__dirname + '/public/images/favicon.ico'));
// app.use(morgan('dev'));
// setup the logger
app.use(morgan('combined', {stream: accessLogStream}))

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(expressSession({ resave: true, saveUninitialized: true, secret: 'social-media-secret' }));
app.use(express.static(path.join(__dirname, 'public')));
app.use(flash());


app.use('/', routes);
app.use('/users', users);

var server = app.listen(app.get('port'), function() {
  console.log('Express server listening on port ' + server.address().port);
});