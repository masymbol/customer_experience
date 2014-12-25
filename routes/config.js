module.exports = {
	development: {
		db: "mongodb://localhost/social-media",
		errorHandlerOptions: {"dumpExceptions": true, "showStack": true}
	},

	test: {
		db: "mongodb://localhost/social-media-test",
		errorHandlerOptions: {"dumpExceptions": true, "showStack": true}
	},

	production: {
		db: "mongodb://trail:eVEzZEtweXBwQzJGNzlGMWpabmwrKzAxeDdPbUgxWEFyODgxSlo3N0pLOD0K@172.17.1.50:27017/trail-production",
		errorHandlerOptions: {"dumpExceptions": true, "showStack": true}
	} 
};