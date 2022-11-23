#install.packages(c("data.table","DBI","RMySQL","ply"))
# install.packages('car')
library(data.table)
library(DBI)
library(RMySQL)
library(plyr)


# SQL DB(정보 생략)
con <- dbConnect()
dbListTables(con)

rs <- dbGetQuery(con, 'set character set utf8') # Change Encoding

# Raw + Advertiser Info
query_temp <-"select adImageId, adImageCategoryId, adImageTitle, adImageAlt, regDate, regYear, regMonth, regDay,targetInfo ,brand, category1, category2, advertiser,cnt
FROM 
(SELECT t2.adImageId, t2.adImageCategoryId, t2.adImageTitle, t2.adImageAlt, t2.regDate, t2.regYear, t2.regMonth, t2.regDay, t2.targetInfo,cnt, t1.brand, t1.category1, t1.category2, t1.advertiser 
from advertiser AS t1, adImageInfo_summary2_daily AS t2
WHERE t1.adImageTitle = t2.adImageTitle
AND t2.regDate between '2018-05-01' and '2019-11-30'
AND t2.adImageCategoryId in(18,19)
AND t2.targetInfo not IN ('sovf3first','sovf3last','sovf31first','sovf31last','iam30later','samhugirl','aprilapril3211')
AND (t2.adImageHeight IN(120,155) or t2.adImageHeight = '')
UNION ALL
SELECT t2.adImageId, t2.adImageCategoryId, t2.adImageTitle, t2.adImageAlt, t2.regDate, t2.regYear, t2.regMonth, t2.regDay, t2.targetInfo,cnt, t1.brand, t1.category1, t1.category2, t1.advertiser 
from advertiser AS t1, adImageInfo_summary2_daily AS t2
WHERE t1.adImageTitle = t2.adImageAlt
AND t2.regDate between '2018-05-01' and '2019-11-30'
AND t2.adImageCategoryId in(18,19)
AND t2.targetInfo not IN ('sovf3first','sovf3last','sovf31first','sovf31last','iam30later','samhugirl','aprilapril3211')
AND (t2.adImageHeight IN (120,155) or t2.adImageHeight = '')
) AS bt
GROUP BY adImageId"

temp_dt <- dbGetQuery(con, query_temp)
#write.csv(temp_dt,"/home/pyosang82/temp_dt_11.csv")

dim(temp_dt) #3131586*14

branding_dt <- subset(temp_dt, temp_dt$brand != "2018지방선거")
branding_dt$weeknum <- as.integer(strftime(branding_dt$regDate,format="%V"))
branding_dt$regDate <- as.Date(strftime(branding_dt$regDate, format = "%Y-%m-%d"))
branding_dt$adImageCategoryId <- 18
branding_dt$regYear_weeknum <- ifelse(branding_dt$regDate>="2018-12-31","2019","2018") # 2018-12-31: 2019 1th week

# Replace 8/2~3 with 8/1 Dataset(8/2~3 Naver Login Error)
branding_dt <- subset(branding_dt, branding_dt$regDate!="2018-08-02")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2018-08-03")
#dim(branding_dt) # 3348933*17

branding_dt81 <- subset(branding_dt, branding_dt$regDate=="2018-08-01")
#dim(branding_dt81) # 5186*17

branding_dt82 <- branding_dt81
branding_dt82$regDay <- "02"
branding_dt82$regDate <- "2018-08-02"


branding_dt83 <- branding_dt81
branding_dt83$regDay <- "03"
branding_dt83$regDate <- "2018-08-03"


branding_dt <- rbind(branding_dt,branding_dt82,branding_dt83)
#dim(branding_dt) # 1019470*15

# Replace 4/3~5 with 4/2
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-04-03")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-04-04")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-04-05")
#dim(branding_dt) #1016632*15

branding_dt42 <- subset(branding_dt,branding_dt$regDate=="2019-04-02")
#dim(branding_dt42) #1911*15

branding_dt43 <- branding_dt42
branding_dt43$regDay <- "03"
branding_dt43$regDate <- "2019-04-03"


branding_dt44 <- branding_dt42
branding_dt44$regDay <- "04"
branding_dt44$regDate <- "2019-04-04"


branding_dt45 <- branding_dt42
branding_dt45$regDay <- "05"
branding_dt45$regDate <- "2019-04-05"


branding_dt <- rbind(branding_dt,branding_dt43,branding_dt44,branding_dt45)
#dim(branding_dt) #1022365*15

# Replace 6/1~2 with 5/31
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-01")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-02")
#dim(branding_dt) #1019716*15

branding_dt31 <- subset(branding_dt,branding_dt$regDate=="2019-05-31")
#dim(branding_dt31) #1779*15

branding_dt01 <- branding_dt31
branding_dt01$regDay <- "01"
branding_dt01$regDate <- "2019-06-01"


branding_dt02 <- branding_dt31
branding_dt02$regDay <- "02"
branding_dt02$regDate <- "2019-06-02"


branding_dt <- rbind(branding_dt,branding_dt01,branding_dt02)

# Replace 6/11~16 with 6/10
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-11")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-16")
#dim(branding_dt) #1020929*15

branding_dt10 <- subset(branding_dt,branding_dt$regDate=="2019-06-10")
#dim(branding_dt10) #2076*15

branding_dt11 <- branding_dt10
branding_dt11$regDay <- "11"
branding_dt11$regDate <- "2019-06-11"


branding_dt16 <- branding_dt10
branding_dt16$regDay <- "16"
branding_dt16$regDate <- "2019-06-16"

branding_dt <- rbind(branding_dt,branding_dt11,branding_dt16)

# Replace 6/23 with 6/22
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-23")
#dim(branding_dt) #1023314*15

branding_dt22 <- subset(branding_dt,branding_dt$regDate=="2019-06-22")
#dim(branding_dt22) #2124*15

branding_dt23 <- branding_dt22
branding_dt23$regDay <- "23"
branding_dt23$regDate <- "2019-06-23"


branding_dt <- rbind(branding_dt,branding_dt23)

# Replace 6/24 with 6/25
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-24")
#dim(branding_dt) #1024010*15

branding_dt25 <- subset(branding_dt,branding_dt$regDate=="2019-06-25")
#dim(branding_dt25) #1397*15

branding_dt24 <- branding_dt25
branding_dt24$regDay <- "24"
branding_dt24$regDate <- "2019-06-24"


branding_dt <- rbind(branding_dt,branding_dt24)


# Replace 6/27~30 with 6/26
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-27")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-28")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-29")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-06-30")
#dim(branding_dt) #1021325*15

branding_dt26 <- subset(branding_dt,branding_dt$regDate=="2019-06-26")
#dim(branding_dt26) #924*15

branding_dt27 <- branding_dt26
branding_dt27 $regDay <- "27"
branding_dt27$regDate <- "2019-06-27"


branding_dt28 <- branding_dt26
branding_dt28$regDay <- "28"
branding_dt28$regDate <- "2019-06-28"


branding_dt29 <- branding_dt26
branding_dt29$regDay <- "29"
branding_dt29$regDate <- "2019-06-29"


branding_dt30 <- branding_dt26
branding_dt30$regDay <- "30"
branding_dt30$regDate <- "2019-06-30"


branding_dt <- rbind(branding_dt,branding_dt27,branding_dt28,branding_dt29,branding_dt30)

# Replace 10/28~30 with 10/31
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-10-28")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-10-29")
branding_dt <- subset(branding_dt, branding_dt$regDate!="2019-10-30")
#dim(branding_dt) #1021325*15

branding_dt1031 <- subset(branding_dt,branding_dt$regDate=="2019-10-31")
#dim(branding_dt26) #924*15

branding_dt1028 <- branding_dt1031
branding_dt1028$regDay <- "28"
branding_dt1028$regDate <- "2019-10-28"


branding_dt1029 <- branding_dt1031
branding_dt1029$regDay <- "29"
branding_dt1029$regDate <- "2019-10-29"


branding_dt1030 <- branding_dt1031
branding_dt1030$regDay <- "30"
branding_dt1030$regDate <- "2019-10-30"

branding_dt <- rbind(branding_dt,branding_dt1028,branding_dt1029,branding_dt1030)

#write.csv(branding_dt,"/home/pyosang82/branding_dt.csv")

# Import Korean Click Data
#dataset_click <- read.csv("/home/pyosang82/koreanclick_1907.csv")
#summary(dataset_click)

# Merge Data
#branding_dt <- merge(x=branding_dt,y=dataset_click,by.x=c("regYear_weeknum","weeknum"),by.y=c("year","week"),all.x=T)

# Import Real Data including Targeting Info
#install_github("plgrmr/readAny", force = TRUE)
library(readAny) # Package for Importing Hangeul File

dataset05 <- read.any("/home/pyosang82/realdata_1805.csv",header=T) # Real dataset(april, may)
dataset06 <- read.any("/home/pyosang82/realdata_1806.csv",header=T)
dataset07 <- read.any("/home/pyosang82/realdata_1807.csv",header=T)
dataset08 <- read.any("/home/pyosang82/realdata_1808.csv",header=T)
dataset09 <- read.any("/home/pyosang82/realdata_1809.csv",header=T)
dataset10 <- read.any("/home/pyosang82/realdata_1810.csv",header=T)
dataset11 <- read.any("/home/pyosang82/realdata_1811.csv",header=T)
dataset12 <- read.any("/home/pyosang82/realdata_1812.csv",header=T)
dataset1901 <- read.any("/home/pyosang82/realdata_1901.csv",header=T)
dataset1902 <- read.any("/home/pyosang82/realdata_1902.csv",header=T)
dataset1903 <- read.any("/home/pyosang82/realdata_1903.csv",header=T)
dataset1904 <- read.any("/home/pyosang82/realdata_1904.csv",header=T)
dataset1905 <- read.any("/home/pyosang82/realdata_1905.csv",header=T)
dataset1906 <- read.any("/home/pyosang82/realdata_1906.csv",header=T)
dataset1907 <- read.any("/home/pyosang82/realdata_1907.csv",header=T)
dataset1908 <- read.any("/home/pyosang82/realdata_1908.csv",header=T)
dataset1909 <- read.any("/home/pyosang82/realdata_1909.csv",header=T)
dataset1910 <- read.any("/home/pyosang82/realdata_1910.csv",header=T)
dataset1911 <- read.any("/home/pyosang82/realdata_1911.csv",header=T)
#summary(dataset1909)

dataset <- rbind(dataset05[,-13],dataset06[,-13],dataset07[,-13],dataset08[,-13],dataset09,dataset10,dataset11)

dataset$year <- 2018
dataset <- dataset[,c(1:12,14,13)]
dataset <- rbind(dataset,dataset12,dataset1901,dataset1902,dataset1903,dataset1904,dataset1905,dataset1906,dataset1907,dataset1908,dataset1909,dataset1910,dataset1911)
#summary(dataset)
#dim(dataset) # 1994*14

# Create Dummy Varible
dataset$targetingGender2 <- ifelse(dataset$targetingGender=="Y",1,0)
dataset$targetingAge2 <- ifelse(dataset$targetingAge=="Y",1,0)

# Mean by Week
adCost1_mean <- aggregate(adCost1~brand+year+week,dataset,mean)
adCost2_mean <- aggregate(adCost2~brand+year+week,dataset,mean)
imp_mean <- aggregate(UV~brand+year+week,dataset,mean)
tarGen_mean <- aggregate(targetingGender2~brand+year+week,dataset,mean)
#summary(tarGen_mean)
tarAge_mean <- aggregate(targetingAge2~brand+year+week,dataset,mean)
#summary(tarAge_mean)

# Add Frequency Variable

countWeek <- aggregate(cnt~adImageCategoryId+brand+category1+regYear_weeknum+weeknum+regDate,branding_dt,sum)
#write.csv(countWeek,"/home/pyosang82/countWeek(new2).csv")
#countWeek22 <- subset(branding_dt,select=c(adImageCategoryId,brand,category1,regYear_weeknum,weeknum,regDate,cnt))
#countWeek11 <- count(branding_dt,adImageCategoryId,brand,category1,regYear_weeknum,weeknum,regDate)

day_sum <- aggregate(cnt~regDate,countWeek,sum)
colnames(day_sum)[2] <- "n_day"
countWeek2 <- merge(x=countWeek,y=day_sum,by="regDate",all.x=T)
countWeek2$freqProb_day <- countWeek2$cnt/countWeek2$n_day

# Merge Data(Capture + Korean Click + Real Dataset)
freqProb_sum <- aggregate(freqProb_day~regYear_weeknum+weeknum+brand+category1,countWeek2,sum)
n_capture <- aggregate(cnt~regYear_weeknum+weeknum+brand+category1,countWeek2,sum) # Number of Capture by brandWeek(Using costResult)


capture2 <- merge(x=freqProb_sum,y=n_capture,by=c("regYear_weeknum","weeknum","brand","category1"))

dataset2 <- cbind(adCost1_mean,tarGen_mean[,3],tarAge_mean[,3])
colnames(dataset2) <- c("brand","regYear_weeknum","week","adCost1_mean","tarGen_mean","tarAge_mean")
dataset3 <- merge(x=capture2,y=dataset2,by.x=c("regYear_weeknum","weeknum","brand"),by.y=c("regYear_weeknum","week","brand"))
#write.csv(dataset3,"/home/pyosang82/dataset3(new).csv")
#dataset3_chk <- merge(n_capture,dataset2,by.x=c("regYear_weeknum","weeknum","brand"),by.y=c("regYear_weeknum","week","brand"),all.x=F,all.y=T)
#dataset3_chk2 <- dataset3_chk[is.na(dataset3_chk$category1)&!(dataset3_chk$regYear_weeknum==2018&dataset3_chk$weeknum<18),]
#dim(dataset3_chk2) # 61*8

# Divide Data(No Construction/Construction)
datasetA <- dataset3[dataset3$category1!="건설/부동산",]# Industry: All(excluding Construction)
datasetA2 <- datasetA[!(datasetA$weeknum==43 & datasetA$brand=="슈퍼크랩"),] # Remove Outlier(Location Targeting)
datasetA2 <- datasetA2[!(datasetA2$weeknum==51 & datasetA2$brand=="데자뷰"),] # Remove Outlier(Location Targeting)
datasetB <- dataset2[dataset3$category1=="건설/부동산",] # Industry: Construction
summary(datasetB)
#dim(datasetA2) # 50*14
#dim(datasetB) # 6*14


###########################################
# 1. All excluding Construction(datasetA) #
###########################################
# Regression Analysis
lmA <- lm(adCost1_mean~tarGen_mean+tarAge_mean+freqProb_day,data=datasetA2)
summary(lmA) # freqProb_day, pv

library(car)
outlierTest(lmA)

# Variable Selection
full.step.both <- step(lmA, direction='both')
print(summary(full.step.both)) # freqProb_day, pv

full.step.backward <- step(lmA, direction='backward')
print(summary(full.step.backward)) # freqProb_day, pv

lmA2 <- lm(adCost1_mean~freqProb_day,data=datasetA2)
summary(lmA2) # freqProb_day

# Multiple R-squared: 0.6298, Adjusted R-squred: 0.6282(Final Model)

# Multicollinearity
corA <- data.frame(datasetA2$tarGen_mean,datasetA2$freqProb_day)
cor(corA) # avgTime.min. & totTime.1000min.

vif(lmA2) # avgTime.min. & totTime.1000min. , uv


layout(1,1)
plot(datasetA2$adCost1_mean,lmA2$fitted.values)
abline(0,1,col=2)
#identify(datasetA2$adCost1_mean,lmA5$fitted.values,datasetA2$brand)

# Diagnostic Plots
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(lmA2)

############################################################################# Start Estimation!

# Estimate tarGen & tarAge variable
tarGenInfo <- substring(branding_dt$targetInfo,12,12) # Gender Targeting Info about Capture Data
tarAgeInfo <- substring(branding_dt$targetInfo,13,13) # Age Targeting Info about Capture Data

#table(tarAgeInfo)
branding_dt2 <- cbind(branding_dt,tarGenInfo,tarAgeInfo)

brandWeek <- paste(branding_dt2$brand,branding_dt2$regYear_weeknum,branding_dt2$weeknum,sep="_")
branding_dt3 <- cbind(branding_dt2,brandWeek)

###############################
# 1. Estimate tarGen variable #
###############################
tarGenTable <- table(branding_dt3$brandWeek,branding_dt3$tarGenInfo)
#head(tarGenTable)
colnames(tarGenTable)[1] <- "none"

tarGenTable2 <- as.data.frame.matrix(tarGenTable)

tarGen_mean <-rep(0,nrow(tarGenTable2))
for(i in 1:nrow(tarGenTable2)){
  if((tarGenTable2$none[i]+tarGenTable2$f[i]==0)&(tarGenTable2$m[i]>0)){tarGen_mean[i]=1
  }else if((tarGenTable2$none[i]+tarGenTable2$m[i]==0)&(tarGenTable2$f[i]>0)){tarGen_mean[i]=1
  }else if((tarGenTable2$none[i]==0)){tarGen_mean[i]=1 # Set Male and Female Targeting at The Same Time
  }else(tarGen_mean[i]=0)} # 1: Yes, 0:No

tarGenTable3 <- cbind(brandWeek=rownames(tarGenTable2),tarGenTable2,tarGen_mean)

###############################
# 2. Estimate tarAge variable #
###############################
tarAgeTable <- table(branding_dt3$brandWeek,branding_dt3$tarAgeInfo)

#head(tarAgeTable)
colnames(tarAgeTable)[1] <- "none"

tarAgeTable2 <- as.data.frame.matrix(tarAgeTable)

tarAge_mean <-rep(0,nrow(tarAgeTable2))
for(i in 1:nrow(tarAgeTable2)){
  if(tarAgeTable2$none[i]==0){tarAge_mean[i]=1
  }else(tarAge_mean[i]=0)} # 1: Yes, 0:No

tarAgeTable3 <- cbind(brandWeek=rownames(tarAgeTable2),tarAgeTable2,tarAge_mean)

# Merge Data(Capture + Target Estimate Dataset)
capture2$brandWeek <- paste(capture2$brand,capture2$regYear_weeknum,capture2$weeknum,sep="_")

est_branding <- merge(x=capture2,y=tarAgeTable3[,c("brandWeek","tarAge_mean")],by="brandWeek")
est_branding2 <- merge(x=est_branding,y=tarGenTable3[,c("brandWeek","tarGen_mean")],by="brandWeek")

table(est_branding2$category1) # Max 16

# Divide Data(No Construction/Construction)
finalA<- est_branding2[est_branding2$category1!="건설/부동산",]# Industry: All(excluding Construction)
finalB<- est_branding2[est_branding2$category1=="건설/부동산",] # Industry: Construction
#dim(finalA) # 444*14
#dim(finalB) # 60*14

# Predict Advertising Cost2
ResultA <- predict(lmA2,finalA)
EstDataA <- cbind(finalA,ResultA)

#ResultB <- predict(lmB3,finalB)
#EstDataB <- cbind(finalB,ResultB)

# Substitute Daily cost for Weekly Average Cost
#table(EstDataA$regYear_weeknum,EstDataA$weeknum)

EstDataA$cost <- rep(0,nrow(EstDataA))
for(i in 1:nrow(EstDataA)){
  if(EstDataA$regYear_weeknum[i]=="2018"&EstDataA$weeknum[i]==18){EstDataA$cost[i]=EstDataA$ResultA[i]/EstDataA$cnt[i]*6
  }else if(EstDataA$regYear_weeknum[i]=="2019"&EstDataA$weeknum[i]==48){EstDataA$cost[i]=EstDataA$ResultA[i]/EstDataA$cnt[i]*6
  }else(EstDataA$cost[i]=EstDataA$ResultA[i]/EstDataA$cnt[i]*7)}

#EstDataB$cost <- rep(0,nrow(EstDataB))
#for(i in 1:nrow(EstDataB)){
#  if(EstDataA$regYear_weeknum[i]=="2018"&EstDataB$weeknum[i]==18){EstDataB$cost[i]=EstDataB$ResultB[i]/EstDataB$n[i]*6
#  }else if(EstDataA$regYear_weeknum[i]=="2019"&EstDataB$weeknum[i]==5){EstDataB$cost[i]=EstDataB$ResultB[i]/EstDataB$n[i]*4
#  }else(EstDataB$cost[i]=EstDataB$ResultB[i]/EstDataB$n[i]*7)}

colnames(EstDataA)[10] <- "Result"
#colnames(EstDataB)[15] <- "Result"
#EstData <- rbind(EstDataA,EstDataB)
EstData <- EstDataA
#dim(EstData) #7192*11



branding_result <- merge(branding_dt3,EstData[,c("brand","regYear_weeknum","weeknum","cost")],by=c("brand","regYear_weeknum","weeknum"),all.x=T,all.y=F)
write.csv(branding_result,"/home/pyosang82/branding_result_12.csv")
#summary(branding_result)

cost_na <- branding_result[is.na(branding_result$cost),]
table(cost_na$category1) # Only Construction

#branding_result$cost <- ifelse(!is.na(branding_result$cost),branding_result$cost,0)
#branding_result[branding_result$cost==max(branding_result$cost),]

branding_result3_sum <- aggregate(cost~adImageId+adImageCategoryId+targetInfo+brand+category1+category2+advertiser+regDate+regYear+regMonth+regDay,branding_result,sum)

regHour <- NA
weekday <- NA
time.UV <- NA
freq <- NA

branding_result2 <- cbind(branding_result,regHour,weekday,time.UV,freq)

branding_result3 <- branding_result2[,c("adImageId","adImageCategoryId","targetInfo","brand","category1","category2","advertiser","regDate","regYear","regMonth",
                                        "regDay","regHour","weekday","time.UV","freq","cost")]
# summary(branding_result3)
branding_result3$cost <- ifelse(branding_result3$cost<0,0,branding_result3$cost) # Substitute 0 for Minus Cost

branding_result3 <- branding_result3[branding_result3$category1!="건설/부동산",]


#write.csv(branding_result3,"/home/pyosang82/branding_result3(new1).csv")
#branding_result3<- read.csv("/home/pyosang82/branding_result3(new1).csv",header=T)
# Save Data
branding_result3_1 <- subset(branding_result3,branding_result3$regYear==2019 & branding_result3$regMonth==11)
dbWriteTable(con, "tempcostResult", branding_result3_1, overwrite = T)
