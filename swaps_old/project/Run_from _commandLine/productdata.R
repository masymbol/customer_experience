
5+5

library(methods)
Sys.setenv(HADOOP_CMD="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop/bin/hadoop")
Sys.setenv(HADOOP_HOME="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop")
Sys.setenv(HADOOP_STREAMING="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop-mapreduce/hadoop-streaming-2.0.0-cdh4.7.0.jar")
1+27
Sys.setenv(HADOOP_COMMON_LIB_NATIVE_DIR="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop/lib/native/")
	
   library(rJava)
   library(splines)
library(grid)
library(Formula)
library(lattice)
library(survival)
library(plyr)
library(Hmisc)
library(testthat)
library(lubridate)
library(stringr)

   library(rmr2)
78+9
   library(rJava)


20+20
 library(rhdfs)
  3+56+56+10
     hdfs.init()
10+10

logistic <- function(ans)
{
x <- hdfs.read.text.file(ans)
data = read.table(textConnection(x),sep = ",",header = TRUE)
train <- data
test <- read.csv("/root/product/maanalytics/test.csv")
nrow(test)


trend_sales <- function(v_sales, v_id, v_dt, id_num, trend_fctr) {
  ind <- which(v_id == id_num)
  wks_between <- as.integer(difftime(v_dt[ind], min(v_dt[ind]), units="weeks"))
  fctr <- trend_fctr^(1/52 * (52 - wks_between))
  v_sales[ind] <- round(v_sales[ind] * fctr, 2)
  return(v_sales)
}

blend_weeks <- function(next_yr_dt, coef1 = NULL, coef2 = NULL) {
  stopifnot(wday(next_yr_dt) == 6)
  
  dt <- next_yr_dt - years(1)
  stopifnot(wday(dt) != 6)
  days_to_friday <- (13 - wday(dt)) %% 7
  next_friday <- dt + days(days_to_friday)
  prev_friday <- next_friday - days(7)
  stopifnot(wday(next_friday) == 6)
  stopifnot(wday(prev_friday) == 6)
  
  df1 <- subset(train, dt == next_friday)
  df2 <- subset(train, dt == prev_friday)
  df_valid <- subset(test, dt == next_yr_dt)[, c("Store", "Dept")]
  
  df_both <- merge(df1[, 1:4], df2[, 1:4], by = c("Store", "Dept"),
                   all = TRUE)
  df_both <- merge(df_valid, df_both, by = c("Store", "Dept"), all.x = T)
  df_both[, c("sales.x", "sales.y")] <-
    Hmisc::impute(df_both[, c("sales.x", "sales.y")], 0)
  
  if(is.null(coef1)) coef1 <- 1 - days_to_friday/7
  if(is.null(coef2)) coef2 <- days_to_friday/7
  blended_sales <- round(with(df_both, coef1 * sales.x +
                                coef2 * sales.y), 0)
  Id <- with(df_both, paste(Store, Dept, next_yr_dt, sep = "_"))
  df_ans <- data.frame(Id = Id, sales = blended_sales)
  return(df_ans)
}
  

expect_equal(nrow(train), 421570)  
expect_equal(nrow(test), 115064)
expect_equal(with(train, length(unique(paste(Store, Dept, Date)))), nrow(train))
expect_equal(with(test, length(unique(paste(Store, Dept, Date)))), nrow(test))  
train <- mutate(train, dt = ymd(Date), yr = year(dt), wk = week(dt))
train <- rename(train, replace = c("Weekly_Sales" = "sales"))
test <- mutate(test, dt = ymd(Date), yr = year(dt), wk = week(dt),prior_yr = yr - 1)
test$wk <- plyr::mapvalues(test$wk, from = c(47, 48, 14), to = c(48, 49, 15))


ans <- merge(test, train, by.x = c("Store", "Dept", "prior_yr", "wk"),by.y = c("Store", "Dept", "yr", "wk"), all.x = TRUE)
ans$sales[is.na(ans$sales)] <- 0
ans <- ans[, c("Store", "Dept", "Date.x", "sales")]
ans$Id <- with(ans, paste(Store, Dept, Date.x, sep = "_"))

UNBLENDED_DATES <- c("2012-11-23", "2012-11-30", "2013-04-05")
BLEND_DATES <- setdiff(as.character(ymd("2012-11-02") + weeks(0:38)),UNBLENDED_DATES)
ans <- subset(ans, !(Date.x %in% BLEND_DATES))
sub <- ans[, c("Id", "sales")]
blended_weeks <- plyr::rbind.fill(lapply(ymd(BLEND_DATES), blend_weeks))
sub <- rbind(sub, blended_weeks)

dt <- ymd(str_extract(sub$Id, ".{10}$" ))
store <- str_extract(sub$Id, "[0-9]+")
dept <- substr(str_extract(sub$Id, "_[0-9]+"), 2, 3)

store_trend_data <- list(c(1, 1.01), c(2, 1.01), c(3, 1.07), c(4, 1.02),
                         c(5, 1.05), c(6, 1.01), c(7, 1.03), c(8, 1.00),
                         c(9, 1.01), c(10, 0.97), c(11, 1.00), c(12, 0.99),
                         c(13, 1.01), c(14, 0.85), c(15, 0.95), c(16, 0.99),
                         c(17, 1.04), c(18, 1.03), c(19, 0.96), c(20, 0.99),
                         c(21, 0.90), c(22, 0.97), c(23, 1), c(24, 0.99),
                         c(25, 1.00), c(26, 1.00), c(27, 0.94), c(28, 0.95),
                         c(29, 0.98), c(30, 1.01), c(31, 0.96), c(32, 0.99),
                         c(33, 1.04), c(34, 1.01), c(35, 1.00), c(36, 0.80),
                         c(37, 0.97), c(38, 1.10), c(39, 1.07), c(40, 0.99),
                         c(41, 1.04), c(42, 1.00), c(43, 0.97), c(44, 1.08),
                         c(45, 0.97))
for(v in store_trend_data) {
  sub$sales <- trend_sales(sub$sales, store, dt, v[1], v[2])
}

dept_trend_data <- list(c(1, 0.96), c(2, 0.98), c(3, 1.01), c(4, 1),
                        c(5, 0.91), c(6, 0.79), c(7, 0.99), c(8, 0.99),
                        c(9, 1.03), c(10, 0.99), c(11, 0.98), c(12, 0.98),
                        c(13, 0.98), c(14, 1.02), c(16, 0.95), c(17, 0.97),
                        c(18, 0.87), c(19, 1.06), c(20, 0.98), c(21, 0.94),
                        c(22, 1.01), c(23, 1.02), c(24, 1), c(25, 0.96),
                        c(26, 0.96), c(27, 1.02), c(28, 0.89), c(29, 1.02),
                        c(30, 0.92), c(31, 0.9), c(32, 0.97), c(33, 0.99),
                        c(34, 1.02), c(35, 0.92), c(36, 0.79), c(37, 0.97),
                        c(38, 0.98), c(40, 1.01), c(41, 0.94), c(42, 1.01),
                        c(44, 1.02), c(45, 0.53), c(46, 0.99), c(48, 1.96),
                        c(49, 0.96), c(50, 0.97), c(52, 0.93), c(54, 0.54),
                        c(55, 0.83), c(56, 0.93), c(58, 1.13), c(59, 0.7),
                        c(60, 1.02), c(65, 1.09), c(67, 1.02), c(71, 0.98),
                        c(72, 0.96), c(74, 0.97), c(79, 0.98), c(80, 0.96),
                        c(81, 0.98), c(82, 1.02), c(83, 1.01), c(85, 0.9),
                        c(87, 1.14), c(90, 0.98), c(91, 0.98), c(92, 1.04),
                        c(93, 1.02), c(94, 0.96), c(95, 0.99), c(96, 1.04),
                        c(97, 0.97), c(98, 0.95), c(99, 1.19))
for(v in dept_trend_data) {
  sub$sales <- trend_sales(sub$sales, dept, dt, v[1], v[2])
}

sub <- sub[, c("Id", "sales")]
names(sub) <- c("Id", "Weekly_Sales")
sub <- arrange(sub, Id)
expect_equal(nrow(sub), 115064)
write.csv(sub,"subz.csv", row.names = FALSE)
}
