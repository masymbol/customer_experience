var express = require('express');
var router = express.Router();

var mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');
var bcrypt = require('bcrypt-nodejs');
var apptitle = "Masymbol";

//var flash = require('./flash');

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
    	var message = req.flash('info');
    	console.log("message: "+message);
      res.render('index', { title: 'Dashboard Page', req:req, message: message });
    });             
  }else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
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
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var userdata = req.session.userdata;
    	var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/users/'+userdata+'users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/influencers/'+userdata+'influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/geoLocation/'+userdata+'geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+'/post/post.csv';
    	var wordcloud_image = '/users_data/'+login_user+'/wordcloud_img/wordcloud.jpg'; 
    	var sentiment_graph_csv = '/users_data/'+login_user+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/Timeframe/Timeframe.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv};
    	res.render('preview', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: userdata, disp_data: disp_data });
    });             
  }else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
});

router.post('/google_search', function(req, res){
	var working_dir = process.env.PWD;
	var user_name = req.session.username;
	exec("rm -rf "+working_dir+"/public/users_data/"+user_name+"/*",function(err, data){			
				if (err){
					console.log("Error when old files deleted : "+err); 

				}else{
					console.log("old files deleted .........");
					//res.redirect("/preview");
				}
		});
	setTimeout(function(){
		var searchQuery = req.body.search;
		console.log("searchQuery: "+searchQuery);
		req.session.userdata = searchQuery;
		
		var java_script_file_path = working_dir+"/java_Twitter_project/twitter_script.sh";
		var rscript_script_path = working_dir+"/swaps/R_program_script.sh";
		var java_files_path = working_dir+"/public/users_data/"+user_name+"/";
		var log_file_path = working_dir+"/Logs/";
		var rscript_file = working_dir+"/swaps/twitter/search.R"
		
		function puts(error, stdout, stderr) { sys.puts(stdout) }

		exec("bash "+java_script_file_path+" "+searchQuery+" "+java_files_path+" "+log_file_path, function(err, data){
				if (err){
					console.log("Error while running jar file: "+err); 
				}else{
					console.log("jar jar file running.........");				
				}
		});
		
			//exec("sudo Rscript "+rscript_file+" "+searchQuery+" "+java_files_path, function(err, data){
			exec("bash "+rscript_script_path+" "+searchQuery+" "+java_files_path, function(err, data){			
				if (err){
					console.log("Error in Rscript : "+err); 
					req.flash('info', "Error in Rscript : "+err);
					res.redirect("/");

				}else{
					console.log("Rscript file running.........");
					res.redirect("/preview");
				}
		});

	}, 1000);

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
    req.session.userdata = ''
    res.redirect('/');
});


module.exports = router;
