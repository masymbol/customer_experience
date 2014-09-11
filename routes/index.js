var express = require('express');
var router = express.Router();

var exec = require('child_process').exec;

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Masymbol' });
});


router.post('/google-search', function(req, res){
	var searchQuery = req.body.search;
	console.log("searchQuery: "+searchQuery);
	
	function puts(error, stdout, stderr) { sys.puts(stdout) }

	exec("java -jar /home/raghuvarma/Documents/nodejs_examples/social-media/twitterMultiThread.jar "+searchQuery+" /home/raghuvarma/Documents/nodejs_examples/social-media/user_data", function(err, data){
			if (err){
				console.log("Error while running jar file: "+err); 

			}else{
				console.log("jar jar file running.........");
			}
	});
	
	/*exec("sudo  Rscript /home/raghuvarma/Desktop/swaps/twitter/rprog3.R", function(err, data){
			if (err){
				console.log("Error in Rscript : "+err); 

			}else{
				console.log("Rscript file running.........");
			}
	});

});*/



module.exports = router;
