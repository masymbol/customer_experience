import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;

import org.apache.log4j.Appender;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.DailyRollingFileAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;

import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.User;

public class TrialTwitterTest {

	public Logger loggerFileCreation(String loggerPath) {
		Logger logger = Logger.getRootLogger();
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String logPathWithDate = loggerPath + "/" + dateFormat.format(date)
				+ "_file.log";
		Appender fh = null;
		try {
			fh = new DailyRollingFileAppender(new PatternLayout(
					"%d{ISO8601} %-5p [%t] %c: %m%n"), logPathWithDate,
					"'.'yyyy-MM-dd");
			logger.setLevel(Level.INFO);
			BasicConfigurator.configure(fh);
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return logger;
	}

	public void recentUsers(TreeMap<String, String> _recentUserData,
			String outputPath, Logger logger) {
		logger.info("recentUsers method start");
		FileWriter fw;
		BufferedWriter bw;

		String realPathofUsers = outputPath + "/users";
		File file2 = new File(realPathofUsers);
		boolean mkdir1 = file2.mkdir();
		File usersFile = new File(realPathofUsers + "/users.csv");
		if (!usersFile.exists()) {
			try {
				usersFile.createNewFile();
				fw = new FileWriter(usersFile.getAbsoluteFile(), true);
				bw = new BufferedWriter(fw);
				Set<Entry<String, String>> usersEntrySet = _recentUserData
						.entrySet();
				Iterator<Entry<String, String>> usersIterator = usersEntrySet
						.iterator();
				while (usersIterator.hasNext()) {
					Map.Entry<String, String> entry = (Map.Entry<String, String>) usersIterator
							.next();
					String screenName = entry.getKey();
					String imageData = entry.getValue();
					bw.write(screenName + ",");
					bw.write(imageData + "\n");
				}
				bw.close();
				File userSuccess = new File(realPathofUsers + "/_success.csv");
				boolean createNewFile = userSuccess.createNewFile();
			} catch (IOException e) {
				System.out
						.println("IO Exception due to Output File of recentUsersfile");
				logger.error("IO Exception due to Output File of recentUsersfile ");
			}
		}
		logger.info("recentUsers method end");
	}

	public void geoLoctionData(ArrayList<String> geoData, String outputPath,
			Logger logger) {
		logger.info("Geo Location method start");
		FileWriter fw;
		BufferedWriter bw;

		String realpathOfGeoLocation = outputPath + "/geoLocation";
		File file1 = new File(realpathOfGeoLocation);
		boolean mkdir = file1.mkdir();
		File geoLocationFile = new File(realpathOfGeoLocation
				+ "/geoLocations.csv");
		if (!geoLocationFile.exists()) {
			try {
				geoLocationFile.createNewFile();
				fw = new FileWriter(geoLocationFile.getAbsoluteFile(), true);
				bw = new BufferedWriter(fw);
				Iterator<String> geoDataIterator = geoData.iterator();
				bw.write("lat,lon" + "\n");
				while (geoDataIterator.hasNext()) {
					String geoLocations = (String) geoDataIterator.next();
					bw.write(geoLocations + "\n");
				}
				bw.close();
				File geolocationSuccess = new File(realpathOfGeoLocation
						+ "/_success.csv");
				boolean createNewFile2 = geolocationSuccess.createNewFile();

			} catch (IOException e) {
				System.out
						.println("IO Exception due to Output File of GeoLocation ");
				logger.error("IO Exception due to Output File of GeoLocation ");
			}
		}
		logger.info("Geo Location method end");
	}

	public void mostInfluencers(
			TreeMap<Integer, ArrayList<String>> influencersData,
			String outputPath, Logger logger) {
		logger.info("MostInfluencers method start");
		FileWriter fw;
		BufferedWriter bw = null;
		String realpath = outputPath + "/influencers";
		File file1 = new File(realpath);
		boolean mkdir = file1.mkdir();
		File mostInfluencersFile = new File(realpath + "/influencers.csv");
		if (!mostInfluencersFile.exists()) {
			try {
				mostInfluencersFile.createNewFile();
				Map<Integer, ArrayList<String>> map = new TreeMap<Integer, ArrayList<String>>(
						influencersData);

				Set<Entry<Integer, ArrayList<String>>> entrySet = map
						.entrySet();
				Iterator<Entry<Integer, ArrayList<String>>> iterator = entrySet
						.iterator();
				fw = new FileWriter(mostInfluencersFile.getAbsoluteFile(), true);
				bw = new BufferedWriter(fw);
				while (iterator.hasNext()) {
					Map.Entry<Integer, ArrayList<String>> entry = (Map.Entry<Integer, ArrayList<String>>) iterator
							.next();
					Integer key = entry.getKey();
					ArrayList<String> value = entry.getValue();
					Iterator iterator3 = value.iterator();
					while (iterator3.hasNext()) {
						String _influecerUserData = (String) iterator3.next();
						bw.write(_influecerUserData + ",");
					}
					bw.write("\n");
				}
				bw.close();
				File influencerSuccess = new File(realpath + "/_success.csv");
				boolean createNewFile = influencerSuccess.createNewFile();
			} catch (IOException e) {
				System.out
						.println("IO Exception due to Output File of influencers ");
				logger.error("IO Exception due to Output File of influencers ");
			}
		}
		logger.info("MostInfluencers method end");
	}

	public static void main(String[] args) {
		if (args.length < 3) {
			System.out.println("Enter Three arguments :");
			System.exit(-1);
		}
		long currentTimeMillis = System.currentTimeMillis();
		String userKeyword = args[0];
		String outputPath = args[1];
		String logPath = args[2];
		TrialTwitterTest trial = new TrialTwitterTest();
		Logger logger = trial.loggerFileCreation(logPath);
		logger.info("Main Method start");
		int LIMIT = 1000;
		Twitter twitter = new TwitterFactory().getInstance();
		Query query = new Query(userKeyword);
		query.setCount(100);
		int count = 0;
		QueryResult r;
		ArrayList<String> _geoLocationData = new ArrayList<String>();
		TreeMap<Integer, ArrayList<String>> _influencersMap = new TreeMap<Integer, ArrayList<String>>(
				Collections.reverseOrder());
		TreeMap<String, String> _recentUserData = new TreeMap<String, String>(
				Collections.reverseOrder());
		try {
			do {
				r = twitter.search(query);
				ArrayList ts = (ArrayList) r.getTweets();
				for (int i = 0; i < ts.size() && count < LIMIT; i++) {
					Status tweet = (Status) ts.get(i);
					if (tweet.getUser() != null) {
						count++;
						User user = tweet.getUser();
						// Recent Users
						String biggerProfileImageURL = user
								.getBiggerProfileImageURL();
						String screenName = user.getScreenName();
						long id = tweet.getId();
						_recentUserData.put(screenName, biggerProfileImageURL
								+ ",https://twitter.com/" + screenName
								+ "/status/" + id);
						// Most Influencers
						ArrayList<String> _userDataForInfluencers = new ArrayList<String>();
						_userDataForInfluencers.add(biggerProfileImageURL);
						_userDataForInfluencers.add(screenName);
						_userDataForInfluencers.add("https://twitter.com/"
								+ user.getScreenName());
						_influencersMap.put(user.getFollowersCount(),
								_userDataForInfluencers);
						if (tweet.getGeoLocation() != null) {
							count++;
							_geoLocationData.add(tweet.getGeoLocation()
									.getLatitude()
									+ ","
									+ tweet.getGeoLocation().getLongitude());
						}
					}
				}

			} while ((query = r.nextQuery()) != null && count < LIMIT);
			trial.recentUsers(_recentUserData, outputPath, logger);
			trial.geoLoctionData(_geoLocationData, outputPath, logger);
			trial.mostInfluencers(_influencersMap, outputPath, logger);
		} catch (TwitterException e) {
			System.out.println("Twitter Exception");
			logger.error("Twitter Excepiton ");
		}
		long currentTimeMillis1 = System.currentTimeMillis();
		System.out.println("Total time :"
				+ (currentTimeMillis1 - currentTimeMillis) / 1000);
		logger.info("Total Time :" + (currentTimeMillis1 - currentTimeMillis)
				/ 1000);
		logger.info("Main method End");
	}
}
