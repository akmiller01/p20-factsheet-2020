list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/covid-proj-np20")

post = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Apr20.csv")
country_code_mapping = unique(post[,c("CountryCode","DisplayName","region","Level")])

pre = fread("/home/alex/git/poverty_predictions/output/p20_p80_incomes_Oct19.csv")
post = fread("/home/alex/git/poverty_predictions/output/p20_p80_incomes_Apr20.csv")

pre_common = subset(pre,ProjYear<2018)
pre_national = subset(pre,ProjYear>=2018)
post_common = subset(post,ProjYear<2018)
post_national = subset(post,ProjYear>=2018)
common = merge(pre_common, post_common, all=T)
common$covid = F
pre_national$covid = F
post_national$covid = T

national = rbind(pre_national, post_national, common)
national = merge(national,country_code_mapping,by="CountryCode")

national = subset(national,ProjYear>=2010)
national$estimate = F
national$estimate[which(national$ProjYear>2018)] = T
national$estimate[which(national$DisplayName=="India" & national$ProjYear>2016)] = T

national = melt(national,id.vars=c("CountryCode","DisplayName","Level","region","ProjYear","covid","estimate"))
national$PovertyType = "National P20"
national$PovertyType[which(national$variable=="p80")] = "National P80"

all = national[order(-national$Level, national$DisplayName, national$ProjYear),]

keep = c("DisplayName","Level", "region", "ProjYear", "PovertyType", "value","covid","estimate")
all = all[,keep,with=F]
names(all) = c("name","level","region","year","povtype","value","covid","estimate")
all$ppp = 2011

all = subset(all,!endsWith(name,"-Rural") & !endsWith(name,"-Urban"))

fwrite(all,"covid_proj.csv")
