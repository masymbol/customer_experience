import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Appender;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.DailyRollingFileAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;

import au.com.bytecode.opencsv.CSVReader;

public class TrailTimeLineVersion {
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

	public File createOutputFolder(String outputPath, Logger logger) {
		logger.info("output File creation Start");
		String realpath = outputPath + "/TimeLine";
		File file1 = new File(realpath);
		boolean mkdir = file1.mkdir();
		File datesFile = null;
		datesFile = new File(realpath + "/timeline.csv");
		if (!datesFile.exists()) {
			try {
				datesFile.createNewFile();
			} catch (IOException e) {
				System.out.println("Io exception");
			}
		}
		logger.info("output File creation End");
		return datesFile;

	}

	@SuppressWarnings("resource")
	public ArrayList<String> getDates(String inputPath, Logger logger) {
		logger.info("Input  File Reading Start");
		ArrayList<String> _totalDates = new ArrayList<String>();
		CSVReader reader;
		try {
			reader = new CSVReader(new FileReader(inputPath), ',');
			List<String[]> csvEntries = reader.readAll();
			Iterator<String[]> iterator = csvEntries.iterator();
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			while (iterator.hasNext()) {
				String[] row = iterator.next();
				Date parse;
				try {
					parse = dateFormat.parse(row[5]);
					_totalDates.add(dateFormat.format(parse));
				} catch (ParseException e) {
					System.out.println("Parse Exception");
				}

			}
		} catch (FileNotFoundException e) {
			System.out.println("FileNotFound Exception");
		} catch (IOException e) {
			System.out.println("IO Excepiton");
		}
		logger.info("Input  File Reading End");
		return _totalDates;
	}

	public void successFileCreation(String outputPath, Logger logger) {
		logger.info("success file  Start");
		File influencerSuccess = new File(outputPath
				+ "/datesOfCompative/_success.csv");
		try {
			boolean createNewFile = influencerSuccess.createNewFile();
		} catch (IOException e) {
			System.out.println("success file of influencers");
		}
		logger.info("success file end");
	}

	public static void main(String[] args) {

		if (args.length < 3) {
			System.out.println("Please Enter three arugumets :");
			System.exit(-1);
		}
		long currentTimeMillis = System.currentTimeMillis();
		String inputPath = args[0];
		String outputPath = args[1];
		String logPath = args[2];

		TrailTimeLineVersion timeLine = new TrailTimeLineVersion();
		Logger logger = timeLine.loggerFileCreation(logPath);
		logger.info("Main mehod start");
		File outputFile = timeLine.createOutputFolder(outputPath, logger);
		ArrayList<String> dates = timeLine.getDates(inputPath, logger);
		FileWriter fw;
		BufferedWriter bw = null;

		try {
			fw = new FileWriter(outputFile.getAbsoluteFile(), true);
			bw = new BufferedWriter(fw);

			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

			Calendar now = Calendar.getInstance();
			Calendar now1 = Calendar.getInstance();
			Calendar now2 = Calendar.getInstance();
			Calendar now3 = Calendar.getInstance();
			Calendar now4 = Calendar.getInstance();
			Calendar now5 = Calendar.getInstance();
			Calendar now6 = Calendar.getInstance();
			Calendar now7 = Calendar.getInstance();
			Calendar now8 = Calendar.getInstance();
			Calendar now9 = Calendar.getInstance();

			now1.add(Calendar.DAY_OF_WEEK, -1);
			now2.add(Calendar.DAY_OF_WEEK, -2);
			now3.add(Calendar.DAY_OF_WEEK, -3);
			now4.add(Calendar.DAY_OF_WEEK, -4);
			now5.add(Calendar.DAY_OF_WEEK, -5);
			now6.add(Calendar.DAY_OF_WEEK, -6);
			now7.add(Calendar.DAY_OF_WEEK, -7);
			now8.add(Calendar.DAY_OF_WEEK, -8);
			now9.add(Calendar.DAY_OF_WEEK, -9);
			bw.write("time,no_of_posts" + "\n");

			int presentDate = 0;
			int secondDate = 0;
			int thirdDate = 0;
			int fourthDate = 0;
			int fifthDate = 0;
			int sixthDate = 0;
			int seventhDate = 0;
			int eightDate = 0;
			int ninthDate = 0;
			int tenthDate = 0;

			Iterator<String> iterator = dates.iterator();
			while (iterator.hasNext()) {
				String string = (String) iterator.next();
				if (dateFormat.format(now.getTime()).equalsIgnoreCase(string)) {
					presentDate++;
				}
				if (dateFormat.format(now1.getTime()).equalsIgnoreCase(string)) {
					secondDate++;
				}
				if (dateFormat.format(now2.getTime()).equalsIgnoreCase(string)) {
					thirdDate++;
				}
				if (dateFormat.format(now3.getTime()).equalsIgnoreCase(string)) {
					fourthDate++;
				}
				if (dateFormat.format(now4.getTime()).equalsIgnoreCase(string)) {
					fifthDate++;
				}
				if (dateFormat.format(now5.getTime()).equalsIgnoreCase(string)) {
					sixthDate++;
				}
				if (dateFormat.format(now6.getTime()).equalsIgnoreCase(string)) {
					seventhDate++;
				}
				if (dateFormat.format(now7.getTime()).equalsIgnoreCase(string)) {
					eightDate++;
				}
				if (dateFormat.format(now8.getTime()).equalsIgnoreCase(string)) {
					ninthDate++;
				}
				if (dateFormat.format(now9.getTime()).equalsIgnoreCase(string)) {
					tenthDate++;
				}
			}
			bw.write(dateFormat.format(now.getTime()) + "," + presentDate
					+ "\n");
			bw.write(dateFormat.format(now1.getTime()) + "," + secondDate
					+ "\n");
			bw.write(dateFormat.format(now2.getTime()) + "," + thirdDate + "\n");
			bw.write(dateFormat.format(now3.getTime()) + "," + fourthDate
					+ "\n");
			bw.write(dateFormat.format(now4.getTime()) + "," + fifthDate + "\n");
			bw.write(dateFormat.format(now5.getTime()) + "," + sixthDate + "\n");
			bw.write(dateFormat.format(now6.getTime()) + "," + seventhDate
					+ "\n");
			bw.write(dateFormat.format(now7.getTime()) + "," + eightDate + "\n");
			bw.write(dateFormat.format(now8.getTime()) + "," + ninthDate + "\n");
			bw.write(dateFormat.format(now9.getTime()) + "," + tenthDate + "\n");

			bw.close();
		} catch (IOException e) {
			System.out.println("IO Exception");
			logger.error("IO Exception");
		}
		timeLine.successFileCreation(outputPath, logger);
		long currentTimeMillis1 = System.currentTimeMillis();
		System.out.println("Total Time : "
				+ (currentTimeMillis1 - currentTimeMillis) / 1000);
		logger.info("Main method End");
		logger.info("Total Time : " + (currentTimeMillis1 - currentTimeMillis)
				/ 1000);
	}
}
