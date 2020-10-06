list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/covid-proj-np20")

load("all_pov_complete.RData")
all_pov = subset(all_pov,HeadCount<=0.99)

# P20main$P20average = P20main$povertyLine -((P20main$povertyLine*P20main$pg*P20main$pop)/P20main$P20pop)
# P20main$restpop = P20main$population - P20main$P20pop
# P20main$restaverage = (((P20main$mean/(365/12))*P20main$population)-(P20main$P20average * P20main$P20pop))/P20main$restpop
all_pov$p20pop = all_pov$HeadCount * all_pov$ReqYearPopulation
all_pov$p20 = all_pov$PovertyLine -((all_pov$PovertyLine*all_pov$PovGap*all_pov$ReqYearPopulation)/all_pov$p20pop)
all_pov$restpop = all_pov$ReqYearPopulation - all_pov$p20pop
all_pov$rest = (((all_pov$Mean/(365.25/12))*all_pov$ReqYearPopulation)-(all_pov$p20 * all_pov$p20pop))/all_pov$restpop

keep = c("CountryName","ProjYear","covid","estimate","p20","rest")
all_pov = all_pov[,keep,with=F]

names(all_pov) = c("name","year","covid","estimate","Poorest 20%","Rest of population")

all_pov_melt = melt(all_pov,id.vars=c("name","year","covid","estimate"))
setnames(all_pov_melt,"variable","povtype")

all_pov_melt = all_pov_melt[order(all_pov_melt$name, all_pov_melt$year),]

new_names = fread("../name_mapping.csv")
new_names$order = 1:nrow(new_names)
all_pov_melt = merge(all_pov_melt,new_names,by='name',all.x=T)
sum(is.na(all_pov_melt$new_name))
all_pov_melt$name = NULL
setnames(all_pov_melt,"new_name","name")
all_pov_melt = all_pov_melt[order(all_pov_melt$order,all_pov_melt$year),]
all_pov_melt = all_pov_melt[,c("name","year","povtype","covid","estimate","value")]

fwrite(all_pov_melt, "covid_proj2.csv")