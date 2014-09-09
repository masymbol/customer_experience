var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Masymbol' });
  
});

var google = require('google');

google.resultsPerPage = 10;
var nextCounter = 0;

router.get('/google-search', function(req, res){
	console.log("get method google-search");
	req.on('data', function (data) {
		console.log("req data.. ");
	});
});

router.post('/google-search', function(req, res){
	var obj = {};
	//console.log('body: ' + JSON.stringify(req.body));
		console.log("req.body: ", req.body);
	console.log("req.body.search: "+req.body.search);
var searchData;
google(req.body.search, function(err, next, links){
	searchData = links;
  if (err) console.error(err);

  for (var i = 0; i < links.length; ++i) {
    console.log(links[i].title + ' - ' + links[i].link); //link.href is an alias for link.link
    console.log(links[i].description + "\n");
  }

  if (nextCounter < 4) {
    nextCounter += 1;
    if (next) next();
  }
//return links;
 /*var div = document.getElementById('search-content');

div.innerHTML = div.innerHTML + links;*/

//$('#search-content').append(links);


});	
	
	res.send(searchData);

});



module.exports = router;
