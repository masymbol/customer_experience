var express = require('express');
var fs = require('fs');
var router = express.Router();

var mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');
var bcrypt = require('bcrypt-nodejs');
var apptitle = "Masocial";

var flash = require('./flash');

var exec = require('child_process').exec;

var CronJob = require('cron').CronJob;
var time = require('time');

/*
 * UserSchema
 *
 */

SearchKeyword = new mongoose.Schema({
  name: { type: String},
});

userSchema = new mongoose.Schema({
    username:{ type: String, required: true, unique: true },
    password:{ type: String, required: true },
    email:{ type: String, required: true, unique: true },
    user_search:{ type: String},
    searchkeywords: [SearchKeyword],
    previous_data:{ type: Boolean, default: false},
    previous_data_error:{ type: Boolean, default: false},
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

  if(!user.isModified('password')) return next();

  bcrypt.genSalt(SALT_FACTOR, function(err, salt) {
    if(err) return next(err);

    bcrypt.hash(user.password, salt, null, function(err, hash) {
      if(err) return next(err);
      user.password = hash;
      next();
    });
  });
});

/*router.get('/', function(req, res) { 
	res.render('comming_soon', { title: apptitle }); 
});*/

/* GET home page. */
router.get('/', function(req, res) {
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var message = req.flash('info');
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {

    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})

		  res.render('index', { title: 'Dashboard Page', req:req, message: message, search_query:user.user_search, process_info: req.flash('process_info'), search_keywords: search_keywords });

		});
  }else{
		res.render('login', { title: 'Login', req:req, message: '' });
  }
});

router.get('/register', function(req, res) {
    res.render("register", {title:"Register", req:req, message: ""});
});

router.get('/previous_search1', function(req, res) {
	if(req.session.loggedIn){
    console.log("username: "+req.session.username );

    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {

    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})

			var arr_index = search_keywords.length - 1;
			
    	var user_data = search_keywords[arr_index]

			var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/'+user_data+'/users/users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/'+user_data+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/'+user.user_search+'/geoLocation/geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+'/'+user_data+"/Tweeter/"+user_data+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud.jpg';
    	var wordcloud_csv = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud_data.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/'+user_data+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/'+user_data+'/TimeLine/timeline.csv';
    	var influencers_success = '/users_data/'+login_user+'/'+user_data+'/influencers/_success.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, wordcloud_csv: wordcloud_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv, influencers_success: influencers_success, previous_data_error:user.previous_data_error};
    	console.log("user.user_search: "+user.user_search);

			res.render('previous_search1', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: user_data, disp_data: disp_data, search_query:user_data, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
		});

	}else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
    
});

router.get('/previous_search2', function(req, res) {
	if(req.session.loggedIn){
    console.log("username: "+req.session.username );

    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})
			
    	var arr_index = search_keywords.length - 2;
			
    	var user_data = search_keywords[arr_index]

			var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/'+user_data+'/users/users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/'+user_data+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/'+user.user_search+'/geoLocation/geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+'/'+user_data+"/Tweeter/"+user_data+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud.jpg';
    	var wordcloud_csv = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud_data.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/'+user_data+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/'+user_data+'/TimeLine/timeline.csv';
    	var influencers_success = '/users_data/'+login_user+'/'+user_data+'/influencers/_success.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, wordcloud_csv: wordcloud_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv, influencers_success: influencers_success, previous_data_error:user.previous_data_error};
    	console.log("user.user_search: "+user.user_search);

			res.render('previous_search1', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: user_data, disp_data: disp_data, search_query:user_data, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
		});
	}else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
    
});

router.get('/previous_search3', function(req, res) {
	if(req.session.loggedIn){
    console.log("username: "+req.session.username );

    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {

    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})
			
    	var arr_index = search_keywords.length - 3;
			
    	var user_data = search_keywords[arr_index]

			var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/'+user_data+'/users/users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/'+user_data+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/'+user.user_search+'/geoLocation/geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+'/'+user_data+"/Tweeter/"+user_data+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud.jpg';
    	var wordcloud_csv = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud_data.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/'+user_data+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/'+user_data+'/TimeLine/timeline.csv';
    	var influencers_success = '/users_data/'+login_user+'/'+user_data+'/influencers/_success.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, wordcloud_csv: wordcloud_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv, influencers_success: influencers_success, previous_data_error:user.previous_data_error};
    	console.log("user.user_search: "+user.user_search);

			res.render('previous_search1', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: user_data, disp_data: disp_data, search_query:user_data, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
		});
	}else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
    
});

router.get('/previous_search4', function(req, res) {
	if(req.session.loggedIn){
    console.log("username: "+req.session.username );

    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})
			
    	var arr_index = search_keywords.length - 4;
			
    	var user_data = search_keywords[arr_index]

			var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/'+user_data+'/users/users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/'+user_data+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/'+user.user_search+'/geoLocation/geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+'/'+user_data+"/Tweeter/"+user_data+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud.jpg';
    	var wordcloud_csv = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud_data.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/'+user_data+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/'+user_data+'/TimeLine/timeline.csv';
    	var influencers_success = '/users_data/'+login_user+'/'+user_data+'/influencers/_success.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, wordcloud_csv: wordcloud_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv, influencers_success: influencers_success, previous_data_error:user.previous_data_error};
    	console.log("user.user_search: "+user.user_search);

			res.render('previous_search1', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: user_data, disp_data: disp_data, search_query:user_data, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
		});
	}else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
    
});

router.get('/previous_search5', function(req, res) {
	if(req.session.loggedIn){
    console.log("username: "+req.session.username );

    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {

    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})
			
    	var arr_index = search_keywords.length - 5;
			
    	var user_data = search_keywords[arr_index]

			var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/'+user_data+'/users/users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/'+user_data+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/'+user.user_search+'/geoLocation/geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+'/'+user_data+"/Tweeter/"+user_data+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud.jpg';
    	var wordcloud_csv = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud_data.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/'+user_data+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/'+user_data+'/TimeLine/timeline.csv';
    	var influencers_success = '/users_data/'+login_user+'/'+user_data+'/influencers/_success.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, wordcloud_csv: wordcloud_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv, influencers_success: influencers_success, previous_data_error:user.previous_data_error};
    	console.log("user.user_search: "+user.user_search);

			res.render('previous_search1', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: user_data, disp_data: disp_data, search_query:user_data, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
		});
	}else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
    
});

router.get('/previous_search6', function(req, res) {
	if(req.session.loggedIn){
    console.log("username: "+req.session.username );

    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})
			
    	var arr_index = search_keywords.length - 6;
			
    	var user_data = search_keywords[arr_index]

			var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/'+user_data+'/users/users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/'+user_data+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/'+user.user_search+'/geoLocation/geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+'/'+user_data+"/Tweeter/"+user_data+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud.jpg';
    	var wordcloud_csv = '/users_data/'+login_user+'/'+user_data+'/wordcloud_img/wordcloud_data.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/'+user_data+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/'+user_data+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/'+user_data+'/TimeLine/timeline.csv';
    	var influencers_success = '/users_data/'+login_user+'/'+user_data+'/influencers/_success.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, wordcloud_csv: wordcloud_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv, influencers_success: influencers_success, previous_data_error:user.previous_data_error};
    	console.log("user.user_search: "+user.user_search);

			res.render('previous_search1', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: user_data, disp_data: disp_data, search_query:user_data, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
		});
	}else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..' });
  }
    
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

    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})

    	if(userdata == user.user_search){
    	}else{
    		req.flash('info') == req.session.status_message;
    	}

    	var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/'+user.user_search+'/users/users.csv';
    	var influencers_csv = '/users_data/'+login_user+'/'+user.user_search+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/'+user.user_search+'/geoLocation/geoLocations.csv';
    	var post_csv = '/users_data/'+login_user+'/'+user.user_search+"/Tweeter/"+user.user_search+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/'+user.user_search+'/wordcloud_img/wordcloud.jpg';
    	var wordcloud_csv = '/users_data/'+login_user+'/'+user.user_search+'/wordcloud_img/wordcloud_data.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/'+user.user_search+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/'+user.user_search+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/'+user.user_search+'/Some_pos_neg/some_neg.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/'+user.user_search+'/TimeLine/timeline.csv';
    	var influencers_success = '/users_data/'+login_user+'/'+user.user_search+'/influencers/_success.csv';

    	var disp_data = {users_csv: users_csv, influencers_csv: influencers_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, wordcloud_csv: wordcloud_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, geo_location_csv: geo_location_csv, timeframe_csv: timeframe_csv, influencers_success: influencers_success, previous_data_error:user.previous_data_error};
    	console.log("user.user_search: "+user.user_search);
    	if(user.previous_data){
				res.render('preview', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: userdata, disp_data: disp_data, search_query:user.user_search, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
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
  	var search_keywords;
    console.log("username: "+req.session.username );
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {
    	var userdata = req.session.userdata;

    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})

    	console.log("allSearchQueries: ", search_keywords);

    	var working_directory = process.env.PWD;
    	var users_csv = '/users_data/'+login_user+'/'+user.user_search+'/users/users.csv';
    	var post_csv = '/users_data/'+login_user+'/'+user.user_search+"/Tweeter/"+user.user_search+".csv";
    	var wordcloud_image = '/users_data/'+login_user+'/'+user.user_search+'/wordcloud_img/wordcloud.jpg'; 
    	var wordcloud_csv = '/users_data/'+login_user+'/'+user.user_search+'/wordcloud_img/wordcloud_data.csv';
    	var timeframe_csv = '/users_data/'+login_user+'/'+user.user_search+'/TimeLine/timeline.csv';

    	var disp_data = {users_csv: users_csv, post_csv: post_csv, wordcloud_image: wordcloud_image, wordcloud_csv: wordcloud_csv, timeframe_csv: timeframe_csv};
    	console.log("user.user_search: "+user.user_search);
    	if(user.previous_data){
				res.render('dashboard1', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: userdata, disp_data: disp_data, search_query:user.user_search, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
			} else{
				res.redirect('/');
			}
    	
    });             
  }else{
		res.render('login', { title: 'Login', req:req, message: 'You have to login to access this site..', process_info: "Your Process started.. " });
  }
});

router.get('/dashboard2', function(req, res) {
  if(req.session.loggedIn){
    console.log("username: "+req.session.username );
    var login_user = req.session.username;
    User.findOne({ username: login_user }, function (err, user) {

    	var search_keywords = []
    	user.searchkeywords.map( function(item) {
     		search_keywords.push(item.name);
			})

    	var userdata = req.session.userdata;
    	var working_directory = process.env.PWD;
    	var influencers_csv = '/users_data/'+login_user+'/'+user.user_search+'/influencers/influencers.csv';    	
    	var geo_location_csv = '/users_data/'+login_user+'/'+user.user_search+'/geoLocation/geoLocations.csv';
    	var sentiment_graph_csv = '/users_data/'+login_user+'/'+user.user_search+'/sentiment_graphs/score_analysis.csv';
    	var some_positive_csv = '/users_data/'+login_user+'/'+user.user_search+'/Some_pos_neg/some_pos.csv';
    	var some_negative_csv = '/users_data/'+login_user+'/'+user.user_search+'/Some_pos_neg/some_neg.csv';
    	var influencers_success = '/users_data/'+login_user+'/'+user.user_search+'/influencers/_success.csv';

    	var disp_data = { influencers_csv: influencers_csv, sentiment_graph: sentiment_graph_csv, some_positive_csv: some_positive_csv, some_negative_csv: some_negative_csv, influencers_success: influencers_success, geo_location_csv: geo_location_csv };
    	console.log("user.user_search: "+user.user_search);
    	if(user.previous_data){
				res.render('dashboard2', { title: 'Dashboard Page', req:req, message: req.flash('info'), userdata: userdata, disp_data: disp_data, search_query:user.user_search, previous_data:user.previous_data, previous_data_error:user.previous_data_error, process_info: req.flash('process_info'), search_keywords: search_keywords });
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
	var searchQuery = req.body.search;
	searchQuery = searchQuery.toLowerCase();
	var search_keywords = [];

    User.findOne({ username: user_name }, function (err, user) {
    	if (user.searchkeywords.length > 0){
	    	user.searchkeywords.map( function(item) {
	     		search_keywords.push(item.name);

				});
	    }
		
		var previously_exist = search_keywords.indexOf(searchQuery);

		console.log("search_keywords: "+search_keywords);
		console.log("previously_exist: "+previously_exist);
		
		setTimeout(function(){

			if(previously_exist != -1){
				req.session.status_message = "Your Search Query '"+req.body.search+"' is in previous searching Process. So, your result is displaying now..";
				user.user_search = searchQuery;
				user.previous_data = true;
				user.previous_data_error = false;
				user.save();
				req.flash('process_info', req.session.status_message );
				setTimeout(function(){
				res.redirect("/dashboard1");
			}, 1000);

			}else{
				req.session.status_message = "Your Search Query '"+req.body.search+"' is under Process. Please, wait for a while.. ";
				runningBGProcess();
			}
		}, 2000);

	function runningBGProcess(){

		function checkPreviousData(data, data_error){
			var login_user = req.session.username;
				User.findOne({ username: login_user }, function (err, user) {

					if (data){
						user.user_search = req.body.search;
						user.searchkeywords.push({ name: req.body.search });
					}else{
						user.user_search = user.user_search;
					}

					user.previous_data = data;
					user.previous_data_error = data_error;
					user.save();
				});
		}

		exec("mkdir public/users_data/"+user_name+"/"+searchQuery, function(err, data){
		      if (err){
						console.log("Error while creating "+user_name+"/"+searchQuery+" directory in public as public/users_data/"+user_name+" :"+err); 
					}else{
						console.log("Creating "+user_name+"/"+searchQuery+" directory in hdfs as public/users_data/"+user_name+" :");
					}
				});

		setTimeout(function(){
			
			console.log("searchQuery: "+searchQuery);
			req.session.userdata = searchQuery;

			
			var java_script_file_path = working_dir+"/TrailVersionTwitter_Project/twitter_script.sh";
			var rscript_script_path = working_dir+"/analysis/R_program_script.sh";
			var java_files_path = working_dir+"/public/users_data/"+user_name+"/"+searchQuery+"/";
			var log_file_path = working_dir+"/Logs/";
			var rscript_file = working_dir+"/analysis/twitter/search.R";
			var timeline_script = working_dir+"/TrailVersionTwitter_Project/timeline_script.sh";
			var dates_file = working_dir+"/public/users_data/"+user_name+"/"+searchQuery+"/Tweeter/"+searchQuery+".csv";
			var timeline_output = working_dir+"/public/users_data/"+user_name+"/"+searchQuery;
			
			function puts(error, stdout, stderr) { sys.puts(stdout) }

			exec("bash "+java_script_file_path+" "+searchQuery+" "+java_files_path+" "+log_file_path, function(err, data){
				console.log("jar file started.........");
					if(err){
						console.log("Error while running jar file: "+err);
						errors_array.push("Error while running jar ");

					}else{
						console.log("jar file running.........");
					}
			});

			exec("Rscript "+working_dir+"/analysis/new_rcode/tweet_collection.R "+searchQuery+" "+working_dir+"/public/users_data/"+user_name+"/"+searchQuery+"/", function(err, data){
				
				console.log("tweet_collection inside");
					if(err){
						console.log("Error in tweet_collection Rscript new : "+err);
						errors_array.push("Error while running Rscript ");
					}else{
						console.log("tweet_collection Rscript file running.........");
						success_script +=1 ;		
						TwitterGPSuccess();
						timeline();
					}
			});

			exec("Rscript "+working_dir+"/analysis/new_rcode/post_collection.R "+searchQuery+" "+working_dir+"/public/users_data/"+user_name+"/"+searchQuery+"/", function(err, data){
					if(err){
						console.log("Error in post_collection Rscript : "+err);
						errors_array.push("Error while running post_collection Rscript ");
						req.session.status_message = "Your Search Query having less Google+ posts .. ";

						console.log("1.errors_array in rcode error: "+errors_array);
					}else{
						console.log("post_collection Rscript file running.........");
						success_script +=1 ;	
						TwitterGPSuccess();			
					}
			});

			function TwitterGPSuccess(){

				console.log("success_script: "+success_script);
				if(success_script >= 2 ){
					sentimentScore();
					WordCloud();
				}else{
					console.log("...success_script: "+success_script);
				}
			}

			console.log("new success_script: "+success_script);

			function sentimentScore(){

				exec("Rscript "+working_dir+"/analysis/new_rcode/Sentiment_score.R "+searchQuery+" "+working_dir+"/public/users_data/"+user_name+"/"+searchQuery+"/", function(err, data){
						if (err){
							console.log("Error in sentimentScore Rscript: "+err);
							errors_array.push("Error while running sentimentScore Rscript ");						
							console.log("2.errors_array in sentimentScore rcode error: "+errors_array);

						}else{						
							console.log("sentimentScore Rscript file running.........");
							success_script +=1 ;
							redirectProcess_timer = 5000;				
						}
				});
			}

			function WordCloud(){

				exec("Rscript "+working_dir+"/analysis/new_rcode/wordcloud.R "+searchQuery+" "+working_dir+"/public/users_data/"+user_name+"/"+searchQuery+"/", function(err, data){
						if (err){
							console.log("Error in WordCloud Rscript : "+err);
							errors_array.push("Error while running WordCloud Rscript ");
							console.log("errors_array in WordCloud rcode error: "+errors_array);

						}else{
							console.log("WordCloud Rscript file running.........");
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
					if(errors_array.length >= 1 && success_script < 5){
							console.log("errors_array in if condition: ", errors_array);
							req.session.status_message = "Check Your previous search Keyword.. ";
							checkPreviousData(false, true);
						}else{
								req.session.status_message = null;
								checkPreviousData(true, false); 
								console.log("req.session.status_message: "+req.session.status_message);
								console.log("Successfully Generated your output for '"+searchQuery+"'")
						}
					}, 2000);
			}

			function timeline(){
				exec("bash "+timeline_script+" "+dates_file+" "+timeline_output+" "+log_file_path, function(err, data){			
					if (err){
						console.log("Timeline Script : "+err); 
						errors_array.push("Error while running Timeline Script ");
					}else{
						console.log("Timeline File.........");
						success_script +=1 ;
						redirectProcess_timer = 5000;
					}
				});
			}
				setTimeout(function(){
							req.flash('process_info', req.session.status_message );
							res.redirect("/dashboard1");
						}, 5000);

			}, 1000);

		} //runningBGProcess() ending

	});

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

function runCronJob(){
	var previous_data_users = []

 	User.find({previous_data: true}, function(err, users) {
    var usersArr = [];

    for(var i=0; i < users.length; i++){

	    User.update({username: users[i]["username"]}, {$set: {searchkeywords: [], user_search: "", previous_data: false }}, function (err, data) {
	    	console.log("userdata deleted..")
	  	})

      usersArr.push(users[i]["username"]);
  	}

    console.log("usersArr: "+usersArr);;

    deleteOldFiles(usersArr);

  });

}

function deleteOldFiles(usersNameArr){
	usersNameArr.forEach(function(user) {

		exec("rm -rf "+process.env.PWD+"/public/users_data/"+user+"/*",function(err, data){			
			if(err){
				console.log("Error when old files deleted : "+err); 
			}else{
				console.log("old files deleted .........");
			}
		});

	});
}

new CronJob('59 59 23 * * *', function(){
    console.log('All Users data deleted .. every day at 23:59:59');
    runCronJob();

}, null, true, "Asia/Kolkata");

module.exports = router;