list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/covid-projections")

pre = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Oct19.csv")
post = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Apr20.csv")

pre_global = subset(pre,Level=="Global" & PovertyLine==1.9 & variable=="HeadCount")
post_global = subset(post,Level=="Global" & PovertyLine==1.9 & variable=="HeadCount")

common_global = subset(post_global,ProjYear<=2015)
post_global = subset(post_global,ProjYear>2015)

common_global$covid= F
pre_global$covid = F
post_global$covid = T

global = rbind(common_global, pre_global,post_global)
global = subset(global,ProjYear>=2010)
global$estimate = F
global$estimate[which(global$ProjYear>2018)] = T

pre_national = subset(pre,Level %in% c("National", "Regional") & PovertyLine==1.9 & variable=="HeadCount")
post_national = subset(post,Level %in% c("National", "Regional") & PovertyLine==1.9 & variable=="HeadCount")

common_national = subset(post_national,ProjYear<=2015)
post_national = subset(post_national,ProjYear>2015)

common_national$covid= F
pre_national$covid = F
post_national$covid = T

national = rbind(common_national, pre_national,post_national)
national = subset(national,ProjYear>=2010)
national$estimate = F
national$estimate[which(national$ProjYear>2018)] = T
national$estimate[which(national$DisplayName=="India" & national$ProjYear>2016)] = T

global = global[order(global$ProjYear),]
national = national[order(-national$Level, national$DisplayName, national$ProjYear),]


all = data.table(rbind(global, national))
keep = c("DisplayName","Level", "region", "ProjYear", "value","covid","estimate")
all = all[,keep,with=F]
names(all) = c("name","level","region","year","value","covid","estimate")

fwrite(all,"covid_proj.csv")
