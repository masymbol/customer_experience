var express = require('express');
var router = express.Router();
var cookieParser = require('cookie-parser');
var session = require('express-session');
var fs = require('fs');
var directory = "./sessions/";

var app = express();

app.use(session({ resave: true,saveUninitialized: true,secret: 'Maasymbol' }));

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Masymbol' });
  fs.mkdir(directory+req.session.id, 0777, true, function (err) {
  if (err) {
    console.log(err);
  } else {
    console.log('Directory ' + directory + ' created.');
  }
});
});

module.exports = router;
