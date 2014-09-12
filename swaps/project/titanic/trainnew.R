7+9
Sys.setenv(HIVE_HOME="/usr/lib/hive/hive-0.10.0")
library(rJava)
library(Rserve)
library(RHive)
library(stats)
library(BiocGenerics)
library(e1071)
library(rpart)

rhive.init()
rhive.connect()
rhive.query("show databases")
1+0
result =tryCatch({
   rhive.query("use bhakti")
}, warning = function(w) {
    1+1
}, error = function(e) {
4+1
    rhive.query("show tables")
}, finally = {
    2+1
rhive.query("show tables")
})
rhive.query("show tables")
rhive.query("select * from bhk2")
b1<-rhive.query("select * from bhk2")
rhive.query("DESC bhk2")
rhive.query("select * from bhk4")
b2<-rhive.query("select * from bhk4")
rhive.query("DESC bhk4")

head(b1)
b1$name = paste(b1$name, b1$last, sep=",")
b2$name = paste(b2$name, b2$last, sep=",")
b1=b1[-c(5)]
b2=b2[-c(4)]
head(b1)
plot(density(b1$age, na.rm = TRUE))
plot(density(b1$fare, na.rm = TRUE))
counts <- table(b1$survived, b1$sex)
counts
barplot(counts, xlab = "Gender", ylab = "Number of People", main = "survived and deceased between male and female")
counts[2] / (counts[1] + counts[2])
counts[4] / (counts[3] + counts[4])
pclass_survival <- table(b1$survived, b1$pclass)
pclass_survival
barplot(pclass_survival, xlab = "cabin Class", ylab = "Number of People",main = "survived and deceased between male and female")
View(b1)
b1 = b1[-c(1,9:12)]
View(b1)
b1$sex = gsub("female", 1, b1$sex)
b1$sex = gsub("male", 0, b1$sex)
View(b1$sex)
master_vector = grep("Master.",b1$name, fixed=TRUE)
miss_vector = grep("Miss.", b1$name, fixed=TRUE)
mrs_vector = grep("Mrs.", b1$name, fixed=TRUE)
mr_vector = grep("Mr.", b1$name, fixed=TRUE)
dr_vector = grep("Dr.", b1$name, fixed=TRUE)
View(b1)
for(i in master_vector) {
  b1$name[i] = "Master"
}
for(i in miss_vector) {
  b1$name[i] = "Miss"
}
for(i in mrs_vector) {
  b1$name[i] = "Mrs"
}
for(i in mr_vector) {
  b1$name[i] = "Mr"
}
for(i in dr_vector) {
  b1$name[i] = "Dr"
}
master_age = round(mean(b1$age[b1$name == "Master"], na.rm = TRUE), digits = 2)
miss_age = round(mean(b1$age[b1$name == "Miss"], na.rm = TRUE), digits =2)
mrs_age = round(mean(b1$age[b1$name == "Mrs"], na.rm = TRUE), digits = 2)
mr_age = round(mean(b1$age[b1$name == "Mr"], na.rm = TRUE), digits = 2)
dr_age = round(mean(b1$age[b1$name == "Dr"], na.rm = TRUE), digits = 2)

for (i in 1:nrow(b1)) {
  if (is.na(b1[i,5])) {
    if (b1$name[i] == "Master") {
      b1$age[i] = master_age
    } else if (b1$name[i] == "Miss") {
      b1$age[i] = miss_age
    } else if (b1$name[i] == "Mrs") {
      b1$age[i] = mrs_age
    } else if (b1$name[i] == "Mr") {
      b1$age[i] = mr_age
    } else if (b1$name[i] == "Dr") {
      b1$age[i] = dr_age
    } else {
      print("Uncaught Title")
    }
  }
}
b1["Child"]=NA
for (i in 1:nrow(b1)) {
  if (b1$age[i] <= 12) {
    b1$Child[i] = 1
  } else {
    b1$Child[i] = 2
  }
}



b1["Family"] = NA
print(b1$sibsp[1])
for(i in 1:nrow(b1)) {

  x = b1$sibsp[i]
  y = b1$parch[i]
  b1$Family[i] = x + y + 1
}

str(b1)
str(b2)

b1["Mother"]=NA
for(i in 1:nrow(b1)) {
  if(b1$name[i] == "Mrs" & b1$parch[i] > 0) {
    b1$Mother[i] = 1
  } else {
    b1$Mother[i] = 2
  }
}
passengerid = b2[1]
b2 = b2[-c(1, 8:11)]

b2$sex = gsub("female", 1, b2$sex)
b2$sex = gsub("^male", 0, b2$sex)

test_master_vector = grep("Master.",b2$name)
test_miss_vector = grep("Miss.", b2$name)
test_mrs_vector = grep("Mrs.", b2$name)
test_mr_vector = grep("Mr.", b2$name)
test_dr_vector = grep("Dr.", b2$name)

for(i in test_master_vector) {
  b2[i, 2] = "Master"
}
for(i in test_miss_vector) {
  b2[i, 2] = "Miss"
}
for(i in test_mrs_vector) {
  b2[i, 2] = "Mrs"
}
for(i in test_mr_vector) {
  b2[i, 2] = "Mr"
}
for(i in test_dr_vector) {
  b2[i, 2] = "Dr"
}

test_master_age = round(mean(b2$age[b2$name == "Master"], na.rm = TRUE), digits = 2)
test_miss_age = round(mean(b2$age[b2$name == "Miss"], na.rm = TRUE), digits =2)
test_mrs_age = round(mean(b2$age[b2$name == "Mrs"], na.rm = TRUE), digits = 2)
test_mr_age = round(mean(b2$age[b2$name == "Mr"], na.rm = TRUE), digits = 2)
test_dr_age = round(mean(b2$age[b2$name == "Dr"], na.rm = TRUE), digits = 2)

for (i in 1:nrow(b2)) {
  if (is.na(b2[i,4])) {
    if (b2[i, 2] == "Master") {
      b2[i, 4] = test_master_age
    } else if (b2[i, 2] == "Miss") {
      b2[i, 4] = test_miss_age
    } else if (b2[i, 2] == "Mrs") {
      b2[i, 4] = test_mrs_age
    } else if (b2[i, 2] == "Mr") {
      b2[i, 4] = test_mr_age
    } else if (b2[i, 2] == "Dr") {
      b2[i, 4] = test_dr_age
    } else {
      print(paste("Uncaught title at: ", i, sep=""))
      print(paste("The title unrecognized was: ", b2[i,2], sep=""))
    }
  }
}

#We do a manual replacement here, because we weren't able to programmatically figure out the title.
#We figured out it was 89 because the above print statement should have warned us.
b2[89, 4] = test_miss_age

b2["Child"] = NA

for (i in 1:nrow(b2)) {
  if (b2[i, 4] <= 12) {
    b2[i, 7] = 1
  } else {
    b2[i, 7] = 1
  }
}

b2["Family"] = NA

for(i in 1:nrow(b2)) {
  b2[i, 8] = b2[i, 5] + b2[i, 6] + 1
}

b2["Mother"] = NA

for(i in 1:nrow(b2)) {
  if(b2[i, 2] == "Mrs" & b2[i, 6] > 0) {
    b2[i, 9] = 1
  } else {
    b2[i, 9] = 2
  }
}
b2["surived"]=NA
for(i in 1:nrow(b2))
{
b2$surived[i]=0
}
train.glm <- glm(survived ~ pclass + sex + age + Child + sex*pclass + Family + Mother, family = binomial, data = b1)
summary(train.glm)
p.hats <- predict.glm(train.glm, newdata = b2, type = "response")

survival <- vector()
for(i in 1:length(p.hats)) {
  if(p.hats[i] > .5) {
    survival[i] <- 1
  } else {
    survival[i] <- 0
  }
}
kaggle.sub <- cbind(passengerid,survival)
colnames(kaggle.sub) <- c("passengerid", "survived")
dir.create("/home/purva/1/")
write.csv(kaggle.sub, file = "/home/purva/1/finalresult1.csv", row.names = FALSE)
model  <- svm(survived~., data = b1, kernel="radial", gamma=0.001, cost=10)
summary(model)
str(b2)
summary(train.glm)
for(i in 1:20) {
  if(p.hats[i] > .5) {
    print(p.hats[i])
  } else {
    print(p.hats[i])
  }
}
head(b1)
