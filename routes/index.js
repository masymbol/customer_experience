var express = require('express');
var router = express.Router();

var mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');
var bcrypt = require('bcrypt-nodejs');
var apptitle = "Masymbol";

var flash = require('./flash');

var exec = require('child_process').exec;

/*
 * UserSchema
 *
 */
userSchema = new mongoose.Schema({
    username:{ type: String, required: true, unique: true },
    password:{ type: String, required: true },
    email:{ type: String, required: true, unique: true },
    created_at:{type: Date, default: Date.now}
});

// Apply the uniqueValidator plugin to userSchema.
userSchema.plugin(uniqueValidator);

/* ==================================
 * MongoDB connection using Mongoose
 */
 
var db = mongoose.createConnection('mongodb://localhost/social-media'),
    User = db.model('users', userSchema);
    

db.on('connected', function () {
    console.log('social-media database MongoDB.');
    dbmessage = 'social-media mongodb connected.';
});

db.on('error', function () {
    console.error.bind(console, 'Connection error!');
    dbmessage = 'social-media MongoDB error!';
});


userSchema.pre('save', function(next) {
  var user = this;
  var SALT_FACTOR = 5;

  if (!user.isModified('password')) return next();

  bcrypt.genSalt(SALT_FACTOR, function(err, salt) {
    if (err) return next(err);

    bcrypt.hash(user.password, salt, null, function(err, hash) {
      if (err) return next(err);
      user.password = hash;
      next();
    });
  });
});



/* GET home page. */
router.get('/', function(req, res) {
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
      res.render('index', { title: 'Dashboard Page', req:req, message: "error" });
    });             
  }else{
		res.render('login', { title: 'Login', req:req, message:'ERROR: ' });
    //res.render('login', { title: 'Login', req:req, flash: req.flash('info') });
  }
});

router.get('/register', function(req, res) {
    res.render("register", {title:apptitle, req:req, message: ""});
});


router.get('/login', function(req, res) {
    res.render("login", {title:apptitle, req:req, message: ""});
});

router.get('/preview', function(req, res) {
    res.render("preview", {title:apptitle, req:req, message: ""});
});

router.post('/preview', function(req, res) {
	var searchQuery = req.body.search;
	console.log("searchQuery: "+searchQuery);
	var user_name = req.session.username;
    res.render('preview', {
						title:apptitle, req:req, message:'Preview'
					});
});

router.post('/google_search', function(req, res){
	var searchQuery = req.body.search;
	console.log("searchQuery: "+searchQuery);
	var user_name = req.session.username;
	
	
	function puts(error, stdout, stderr) { sys.puts(stdout) }

		exec("bash /home/raghuvarma/Documents/nodejs_examples/social_media/java_Twitter_project/twitter_script.sh "+searchQuery+" /home/raghuvarma/Documents/nodejs_examples/social_media/public/user_data/ /home/raghuvarma/Documents/nodejs_examples/social_media/Logs/", function(err, data){
			if (err){
				console.log("Error while running jar file: "+err); 

			}else{
				console.log("jar jar file running.........");
				res.redirect("/preview", );
			}
	});
	
	/*exec(" sudo Rscript /home/raghuvarma/Desktop/swaps/twitter/search.R "+searchQuery, function(err, data){
			if (err){
				console.log("Error in Rscript : "+err); 

			}else{
				console.log("Rscript file running.........");
			}
	});*/
	
	

});



router.post('/login', function (req, res) { 
	User.findOne({ username: req.body.username }, function (err, user) {
		if (err) return done(err);
      if (!user){
			console.log('ERROR: Incorrect username.');
			
			res.render('login', {
				title:apptitle, req:req, message:'ERROR: Incorrect username.'
			});
		}else{
			bcrypt.compare(req.body.password, user.password, function(err, isMatch) {
				if (isMatch) {
					req.session.loggedIn = true;
					req.session.username = req.body.username;
					res.redirect('/')
				} else {
					console.log('ERROR: Incorrect Password');
					res.render('login', {
						title:apptitle, req:req, message:'ERROR: Incorrect Password.'
					});
				}
			});
		}
	}); 	
});

router.post("/register", function (req, res) {

    var user = new User({
        username:req.body.username,
        password:req.body.password,
        email:req.body.email
    });

    user.save(function (err, user) {
		if (err){ 
			console.log('ERROR: You are created account with existed details..');
			res.render('register', {
				title:apptitle, req:req, message:'ERROR: '+err
			});
		}else{
	        req.session.loggedIn = true;
	        req.session.username = req.body.username;
	        var username = req.body.username;
	        exec("mkdir public/users_data/"+username, function(err, data){
	        	if (err){
					console.log("Error while creating "+username+" directory in public as public/users_data/"+username+" :"+err); 
				}else{
					console.log("Creating "+username+" directory in hdfs as public/users_data/"+username+" :");
				}
	        });
	        res.redirect('/');
        }        
    });
    
});

router.get('/logout', function(req, res) {
    // clear user session
    req.session.loggedIn = false;
    req.session.username = '';
    res.redirect('/');
});


module.exports = router;
