var express = require('express');
var fs = require('fs');
var router = express.Router();

var mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');
var bcrypt = require('bcrypt-nodejs');
var apptitle = "Masocial";

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
    user_search:{ type: String},
    previous_data:{ type: Boolean, default: false},
    created_at:{type: Date, default: Date.now}
});

// Apply the uniqueValidator plugin to userSchema.
userSchema.plugin(uniqueValidator);

/* ==================================
 * MongoDB connection using Mongoose
 */
 
var db = mongoose.createConnection('mongodb://localhost/trail-production'),
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


router.get('/', function(req, res) { 
	res.render('comming_soon', { title: apptitle }); 
});

/* GET home page. */
/*router.get('/', function(req, res) {
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var message = req.flash('info');
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
		  res.render('index', { title: 'Dashboard Page', req:req, message: message, search_query:user.user_search });

		});
  }else{
		res.render('login', { title: 'Login', req:req, message: '' });
  }
});*/

router.get('/register', function(req, res) {
    res.render("register", {title:"Register", req:req, message: ""});
});


router.get('/login', function(req, res) {
    res.render("login", {title:"Login", req:req, message: ""});
});

router.get('/preview', function(req, res) {
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var userdata = req.session.userdata;
    	var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/users/users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/geoLocation/geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+"/post/Twitter/"+user.user_search+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/wordcloud_img/wordcloud.jpg'; 
    	var sentiment_graph_csv = '/users_data/'+login_user+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/TimeLine/timeline.csv';
    	var influencers_success = '/users_data/'+login_user+'/influencers/_success.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv, influencers_success: influencers_success};
    	console.log("user.user_search: "+user.user_search);
    	if (user.previous_data){
				res.render('preview', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: userdata, disp_data: disp_data, search_query:user.user_search });
			} else{
				res.redirect('/');
			}
    	
    });             
  }else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
});

router.get('/dashboard1', function(req, res) {
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var userdata = req.session.userdata;
    	var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/users/users.csv';
    	var post_csv = '/users_data/'+login_user+"/post/Twitter/"+user.user_search+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/wordcloud_img/wordcloud.jpg'; 
    	var timeframe_csv = '/users_data/'+login_user+'/TimeLine/timeline.csv';

    	var disp_data = {users_csv: users_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, timeframe_csv: timeframe_csv};
    	console.log("user.user_search: "+user.user_search);
    	if (user.previous_data){
				res.render('dashboard1', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: userdata, disp_data: disp_data, search_query:user.user_search });
			} else{
				res.redirect('/');
			}
    	
    });             
  }else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
});

router.get('/dashboard2', function(req, res) {
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var userdata = req.session.userdata;
    	var working_directory = process.env.PWD;
    	var influencers_csv = '/users_data/'+login_user+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/geoLocation/geoLocations.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/Some_pos_neg/some_neg.csv';
    	var influencers_success = '/users_data/'+login_user+'/influencers/_success.csv';

    	var disp_data = { influencers_csv: influencers_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, influencers_success: influencers_success, geo_location_csv: geo_location_csv };
    	console.log("user.user_search: "+user.user_search);
    	if (user.previous_data){
				res.render('dashboard2', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: userdata, disp_data: disp_data, search_query:user.user_search });
			} else{
				res.redirect('/');
			}
    	
    });             
  }else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
});

router.get('/dashboard3', function(req, res) {
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var userdata = req.session.userdata;
    	var working_directory = process.env.PWD;

    	if (user.previous_data){
				res.render('dashboard3', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: userdata, search_query:user.user_search });
			} else{
				res.redirect('/');
			}
    	
    });             
  }else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
});

router.post('/google_search', function(req, res){
	var working_dir = process.env.PWD;
	var user_name = req.session.username;
	var success_script = 0;
	var page_redirect = true;
	var redirectProcess_timer = 10000;
	var errors_array = [];

	exec("rm -rf "+working_dir+"/public/users_data/"+user_name+"/*",function(err, data){			
		if (err){
			console.log("Error when old files deleted : "+err); 
		}else{
			console.log("old files deleted .........");
		}
	});

	setTimeout(function(){
		var searchQuery = req.body.search;
		console.log("searchQuery: "+searchQuery);
		req.session.userdata = searchQuery;
		
		var java_script_file_path = working_dir+"/TrailVersionTwitter_Project/twitter_script.sh";
		var rscript_script_path = working_dir+"/swaps/R_program_script.sh";
		var java_files_path = working_dir+"/public/users_data/"+user_name+"/";
		var log_file_path = working_dir+"/Logs/";
		var rscript_file = working_dir+"/swaps/twitter/search.R";
		var timeline_script = working_dir+"/TrailVersionTwitter_Project/timeline_script.sh";
		var dates_file = working_dir+"/public/users_data/"+user_name+"/post/Twitter/"+searchQuery+".csv";
		var timeline_output = working_dir+"/public/users_data/"+user_name;
		
		function puts(error, stdout, stderr) { sys.puts(stdout) }

		exec("bash "+java_script_file_path+" "+searchQuery+" "+java_files_path+" "+log_file_path, function(err, data){
			console.log("jar file started.........");
				if (err){
					console.log("Error while running jar file: "+err);
					errors_array.push("Error while running jar ");

				}else{
					console.log("jar file running.........");
					success_script +=1 ;				
				}
		});

		exec("Rscript "+working_dir+"/swaps/new_changes/material_collection.R "+searchQuery+" "+working_dir+"/public/users_data/"+user_name+"/", function(err, data){
				if (err){
					console.log("Error in Rscript new : "+err);
					errors_array.push("Error while running Rscript ");
					console.log("1.errors_array in rcode error: "+errors_array);

				}else{
					timeline();
					sentimentScore();
					WordCloud();
					console.log("new 1 Rscript file running.........");
					success_script +=1 ;
					redirectProcess_timer = 5000;				
				}
		});

		function sentimentScore(){

			exec("Rscript "+working_dir+"/swaps/new_changes/Sentiment_score.R "+searchQuery+" "+working_dir+"/public/users_data/"+user_name+"/", function(err, data){
					if (err){
						console.log("Error in Rscript new : "+err);
						errors_array.push("Error while running Rscript ");
						console.log("2.errors_array in rcode error: "+errors_array);

					}else{						
						console.log("new 2 Rscript file running.........");
						success_script +=1 ;
						redirectProcess_timer = 5000;				
					}
			});
		}

		function WordCloud(){

			exec("Rscript "+working_dir+"/swaps/new_changes/wordcloud.R "+searchQuery+" "+working_dir+"/public/users_data/"+user_name+"/", function(err, data){
					if (err){
						console.log("Error in Rscript new : "+err);
						errors_array.push("Error while running Rscript ");
						console.log("3.errors_array in rcode error: "+errors_array);

					}else{
						console.log("new 3 Rscript file running.........");
						success_script +=1 ;
						redirectProcess_timer = 5000;				
						redirectPage();
					}
			});
		}

		function redirectPage(){
			var login_user = req.session.username;
			User.findOne({ username: login_user }, function (err, user) {
				user.user_search = searchQuery;
				user.previous_data = true;
				user.save();
			});

			
			console.log("errors_array: ", errors_array);

			setTimeout(function(){
				if(errors_array.length >= 1 ){
						console.log("errors_array in if condition: ", errors_array);
						req.flash('info', errors_array.join());
						res.redirect("/");
					}else{
						setTimeout(function(){
							res.redirect("/dashboard1");
						}, 2000);
					}
				}, 2000);
		}

		function timeline(){
			exec("bash "+timeline_script+" "+dates_file+" "+timeline_output+" "+log_file_path, function(err, data){			
				if (err){
					console.log("Timeline Script : "+err); 
					//errors_array.push("Error while running Timeline Script ");
				}else{
					console.log("Timeline File.........");
					success_script +=1 ;
					redirectProcess_timer = 5000;
				}
			});
		}
		function checkPostSuccess(){
			var login_user = req.session.username;
			var post_success= fs.existsSync(process.env.PWD+'/public/users_data/'+login_user+'/post/post_with_links_retweets_reshares.csv');
			console.log("post_success: "+post_success);

			var login_user = req.session.username;
			User.findOne({ username: login_user }, function (err, user) {
				user.user_search = searchQuery;
				user.previous_data = true;
				user.save();
			});

			
			console.log("errors_array: ", errors_array);

			setTimeout(function(){
				if(errors_array.length >= 1 || post_success == false){
						//clearInterval(redirectProcess);
						console.log("errors_array in if condition: ", errors_array);
						req.flash('info', errors_array.join());
						res.redirect("/");
					}else{
						setTimeout(function(){
							res.redirect("/dashboard1");
						}, 2000);
					}
				}, 2000);

			
		}

		/*setTimeout(function(){		


			var login_user = req.session.username;
			User.findOne({ username: login_user }, function (err, user) {
				user.user_search = searchQuery;
				user.previous_data = true;
				user.save();
			});

			setTimeout(function(){
				res.redirect("/dashboard1");
			}, 2000);
		}, 45000);*/

		/*if(page_redirect){
			var redirectProcess = setInterval(function(){
				if(success_script >= 2 && page_redirect){
					clearInterval(redirectProcess);
					page_redirect = false;
					var login_user = req.session.username;
    			User.findOne({ username: login_user }, function (err, user) {
    				user.user_search = searchQuery;
    				user.previous_data = true;
    				user.save();
    			});

    			setTimeout(function(){
						res.redirect("/preview");
					}, 2000);

				}
				if(errors_array.length >= 1){
					clearInterval(redirectProcess);
					req.flash('info', errors_array.join());
					res.redirect("/");
				}
			}, redirectProcess_timer);
		}	*/

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
					if (user.previous_data){
						res.redirect('/preview');
					} else{
						res.redirect('/');
					}
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
