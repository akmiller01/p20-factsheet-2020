list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/covid-projections")

# 2011 PPP ####
pre = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Oct19.csv")
pre = subset(pre, !(PovertyLine %in% c(3.2, 5.5)))
pre$PovertyType = "P20"
pre$PovertyType[which(pre$PovertyLine==1.9)] = "Extreme poverty"

post = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Apr20.csv")
post_ext = subset(post, PovertyLine==1.9)
post_ext$PovertyType = "Extreme poverty"
post = subset(post, !(PovertyLine %in% c(1.9, 3.2, 5.5)))
post[,"min":=.SD$PovertyLine==min(.SD$PovertyLine), by=.(CountryCode, ProjYear, variable)]
post_p20 = subset(post,min)
post_p20$min = NULL
post_p20$PovertyType = "P20"
post = rbind(post_ext, post_p20)

pre_global = subset(pre,Level=="Global" & PovertyType %in% c("Extreme poverty", "P20") & variable=="HeadCount")
post_global = subset(post,Level=="Global" & PovertyType %in% c("Extreme poverty", "P20") & variable=="HeadCount")

common_global = subset(post_global,ProjYear<=2015)
post_global = subset(post_global,ProjYear>2015)

common_global$covid= F
pre_global$covid = F
post_global$covid = T

global = rbind(common_global, pre_global,post_global)
global = subset(global,ProjYear>=2010)
global$estimate = F
global$estimate[which(global$ProjYear>2018)] = T

pre_national = subset(pre,Level %in% c("National", "Regional") & PovertyType %in% c("Extreme poverty", "P20") & variable=="HeadCount")
post_national = subset(post,Level %in% c("National", "Regional") & PovertyType %in% c("Extreme poverty", "P20") & variable=="HeadCount")

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
keep = c("DisplayName","Level", "region", "ProjYear", "PovertyType", "value","covid","estimate")
all = all[,keep,with=F]
names(all) = c("name","level","region","year","povtype","value","covid","estimate")
all$ppp = 2011

all_2011 = all
vars_to_remove = ls()
vars_to_remove = vars_to_remove[which(vars_to_remove!="all_2011")]
rm(list=vars_to_remove)

# 2017 PPP ####

pre = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Oct19_2017PPP.csv")
pre_ext = subset(pre, PovertyLine==2.195249)
pre_ext$PovertyType = "Extreme poverty"
pre_p20_thresh = fread("/home/alex/git/poverty_predictions/output/P20_proj_Oct2019_2017PPP.csv")
names(pre_p20_thresh) = c("ProjYear","PovertyLine")
pre_p20_thresh$PovertyLine = round(pre_p20_thresh$PovertyLine, 6)
pre_p20_thresh$PovertyType = "P20"
pre_p20 = merge(pre, pre_p20_thresh, by=c("ProjYear","PovertyLine"))
pre = rbind(pre_ext, pre_p20)

post = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Apr20_2017PPP.csv")
post_ext = subset(post, PovertyLine==2.195249)
post_ext$PovertyType = "Extreme poverty"
post_p20_thresh = fread("/home/alex/git/poverty_predictions/output/P20_proj_Apr2020_2017PPP.csv")
names(post_p20_thresh) = c("ProjYear","PovertyLine")
post_p20_thresh$PovertyLine = round(post_p20_thresh$PovertyLine, 6)
post_p20_thresh$PovertyType = "P20"
post_p20 = merge(post, post_p20_thresh, by=c("ProjYear","PovertyLine"))
post = rbind(post_ext, post_p20)

pre_global = subset(pre,Level=="Global" & PovertyType %in% c("Extreme poverty", "P20") & variable=="HeadCount")
post_global = subset(post,Level=="Global" & PovertyType %in% c("Extreme poverty", "P20") & variable=="HeadCount")

common_global = subset(post_global,ProjYear<=2015)
post_global = subset(post_global,ProjYear>2015)

common_global$covid= F
pre_global$covid = F
post_global$covid = T

global = rbind(common_global, pre_global,post_global)
global = subset(global,ProjYear>=2010)
global$estimate = F
global$estimate[which(global$ProjYear>2018)] = T

pre_national = subset(pre,Level %in% c("National", "Regional") & PovertyType %in% c("Extreme poverty", "P20") & variable=="HeadCount")
post_national = subset(post,Level %in% c("National", "Regional") & PovertyType %in% c("Extreme poverty", "P20") & variable=="HeadCount")

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
keep = c("DisplayName","Level", "region", "ProjYear", "PovertyType","value","covid","estimate")
all = all[,keep,with=F]
names(all) = c("name","level","region","year","povtype","value","covid","estimate")
all$ppp = 2017

# all = rbind(all_2011, all)
all = all_2011

fwrite(all,"covid_proj.csv")
