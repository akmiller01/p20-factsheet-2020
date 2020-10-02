list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/survey-vis")

wash.tab1 = fread("p20_handwashing.csv")
wash.tab2 = fread("p20_urban_handwashing.csv")
wash.tab3 = fread("p20_sex_handwashing.csv")
setnames(wash.tab1, "handwashing", "indicator")
setnames(wash.tab2, "handwashing", "indicator")
setnames(wash.tab3, "handwashing", "indicator")
wash.tab1$demographic_category = "Poorest/richest 20% of population"
wash.tab2$demographic_category = "Poverty status and location"
wash.tab3$demographic_category = "Poverty status and sex"
sleeping.tab1 = fread("p20_crowding.csv")
sleeping.tab2 = fread("p20_urban_crowding.csv")
sleeping.tab3 = fread("p20_sex_crowding.csv")
setnames(sleeping.tab1, "sleeping.category", "indicator")
setnames(sleeping.tab2, "sleeping.category", "indicator")
setnames(sleeping.tab3, "sleeping.category", "indicator")
sleeping.tab1$demographic_category = "Poorest/richest 20% of population"
sleeping.tab2$demographic_category = "Poverty status and location"
sleeping.tab3$demographic_category = "Poverty status and sex"
educ.tab1 = fread("p20_educ.csv")
educ.tab2 = fread("p20_urban_educ.csv")
educ.tab3 = fread("p20_sex_educ.csv")
setnames(educ.tab1, "educ.category", "indicator")
setnames(educ.tab2, "educ.category", "indicator")
setnames(educ.tab3, "educ.category", "indicator")
educ.tab1$demographic_category = "Poorest/richest 20% of population"
educ.tab2$demographic_category = "Poverty status and location"
educ.tab3$demographic_category = "Poverty status and sex"
birth.reg.tab1 = fread("p20_birth.reg.csv")
birth.reg.tab2 = fread("p20_urban_birth.reg.csv")
birth.reg.tab3 = fread("p20_sex_birth.reg.csv")
setnames(birth.reg.tab1, "birth.reg", "indicator")
setnames(birth.reg.tab2, "birth.reg", "indicator")
setnames(birth.reg.tab3, "birth.reg", "indicator")
birth.reg.tab1$demographic_category = "Poorest/richest 20% of population"
birth.reg.tab2$demographic_category = "Poverty status and location"
birth.reg.tab3$demographic_category = "Poverty status and sex"

dat = rbindlist(
  list(
    wash.tab1,
    wash.tab2,
    wash.tab3,
    sleeping.tab1,
    sleeping.tab2,
    sleeping.tab3,
    educ.tab1,
    educ.tab2,
    educ.tab3,
    birth.reg.tab1,
    birth.reg.tab2,
    birth.reg.tab3
  ),
  fill=T
)


keep = c(
  "indicator",
  "demographic",
  "demographic_category",
  "iso3",
  "povcal_year",
  "percentage"
)

dat = dat[,keep,with=F]

codes = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Apr20.csv")
codes = subset(codes,!endsWith(DisplayName,"-Rural") & !endsWith(DisplayName,"-Urban"))
codes = unique(codes[,c("DisplayName","CountryCode")])
names(codes) = c("name","iso3")

dat = merge(dat,codes,all.x=T,by="iso3")
dat$indicator[which(dat$indicator=="no soap and water")] = "No access to soap and water"
dat$indicator[which(dat$indicator=="5 people per room or more")] = "Crowded living conditions"
dat$indicator[which(dat$indicator=="Registered")] = "Birth registered"

setnames(dat,"povcal_year","year")
setnames(dat,"percentage","value")

dat$demographic[which(dat$demographic=="Not P20")] = "Rest of population"
dat$demographic[which(dat$demographic=="P20")] = "Poorest 20%"
dat$demographic[which(dat$demographic=="Not P20 Urban")] = "Rest of population Urban"
dat$demographic[which(dat$demographic=="P20 Rural")] = "Poorest 20% Rural"
dat$demographic[which(dat$demographic=="P20 Urban")] = "Poorest 20% Urban"
dat$demographic[which(dat$demographic=="Not P20 Rural")] = "Rest of population Rural"
dat$demographic[which(dat$demographic=="Not P20 Male")] = "Rest of population Male"
dat$demographic[which(dat$demographic=="P20 Male")] = "Poorest 20% Male"
dat$demographic[which(dat$demographic=="Not P20 Female")] = "Rest of population Female"
dat$demographic[which(dat$demographic=="P20 Female")] = "Poorest 20% Female"

fwrite(dat,"all_survey.csv")
