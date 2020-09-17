list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/survey-vis")

load("historical_dhs-mics_handwashing.RData")

dhs.mics = subset(dhs.mics,iso3!="-1" & p20!="(P20) No data" & povcal_year<2019)

# No soap/water, by national P20/rest over time by country
# Can we do add any other disaggregation? urban/rural, sex (not both together but one or the other so we only have a max of 4 lines)

wash = subset(dhs.mics,handwashing!=-1)

wash.tab1 = data.table(wash)[,.(value=sum(value,na.rm=T)),by=.(handwashing,p20,povcal_year,iso3)]
wash.tab1[,"total":=sum(value,na.rm=T),by=.(p20,povcal_year,iso3)]
wash.tab1$percentage = wash.tab1$value/wash.tab1$total
wash.tab1 = subset(wash.tab1,handwashing=="no soap and water")
wash.tab1$demographic = wash.tab1$p20

wash.sub2 = subset(wash,urban!="(Area) No data")
wash.tab2 = data.table(wash.sub2)[,.(value=sum(value,na.rm=T)),by=.(handwashing,p20,urban,povcal_year,iso3)]
wash.tab2[,"total":=sum(value,na.rm=T),by=.(p20,urban,povcal_year,iso3)]
wash.tab2$percentage = wash.tab2$value/wash.tab2$total
wash.tab2 = subset(wash.tab2,handwashing=="no soap and water")
wash.tab2$demographic = paste(wash.tab2$p20, wash.tab2$urban)

wash.sub3 = subset(wash,sex!="(Sex) No data")
wash.tab3 = data.table(wash.sub3)[,.(value=sum(value,na.rm=T)),by=.(handwashing,p20,sex,povcal_year,iso3)]
wash.tab3[,"total":=sum(value,na.rm=T),by=.(p20,sex,povcal_year,iso3)]
wash.tab3$percentage = wash.tab3$value/wash.tab3$total
wash.tab3 = subset(wash.tab3,handwashing=="no soap and water")
wash.tab3$demographic = paste(wash.tab3$p20, wash.tab3$sex)

ggplot(subset(wash.tab3,iso3=="KEN"),aes(group=demographic, color=demographic, x=povcal_year, y=percentage)) +
  geom_line() +
  scale_y_continuous(labels=percent) +
  theme_classic() +
  labs(title="No access to soap/water in Kenya",y="Percentage",x="Year",color="Demographic")

fwrite(wash.tab1,"p20_handwashing.csv")
fwrite(wash.tab2,"p20_urban_handwashing.csv")
fwrite(wash.tab3,"p20_sex_handwashing.csv")
rm(wash,wash.tab1,wash.sub2,wash.tab2,wash.sub3,wash.tab3)
# 5 people or more per room, by national P20/rest over time by country
# As above can we do add any other disaggregation? urban/rural, sex (not both together but one or the other so we only have a max of 4 lines)

sleeping = subset(dhs.mics,sleeping!=-1 & sleeping!="Inf")
sleeping$sleeping = as.numeric(sleeping$sleeping)
sleeping$sleeping.category = "Less than 5 people per room"
sleeping$sleeping.category[which(sleeping$sleeping >= 5)] = "5 people per room or more"

sleeping.tab1 = data.table(sleeping)[,.(value=sum(value,na.rm=T)),by=.(sleeping.category,p20,povcal_year,iso3)]
sleeping.tab1[,"total":=sum(value,na.rm=T),by=.(p20,povcal_year,iso3)]
sleeping.tab1$percentage = sleeping.tab1$value/sleeping.tab1$total
sleeping.tab1 = subset(sleeping.tab1,sleeping.category=="5 people per room or more")
sleeping.tab1$demographic = sleeping.tab1$p20

sleeping.sub2 = subset(sleeping,urban!="(Area) No data")
sleeping.tab2 = data.table(sleeping.sub2)[,.(value=sum(value,na.rm=T)),by=.(sleeping.category,p20,urban,povcal_year,iso3)]
sleeping.tab2[,"total":=sum(value,na.rm=T),by=.(p20,urban,povcal_year,iso3)]
sleeping.tab2$percentage = sleeping.tab2$value/sleeping.tab2$total
sleeping.tab2 = subset(sleeping.tab2,sleeping.category=="5 people per room or more")
sleeping.tab2$demographic = paste(sleeping.tab2$p20, sleeping.tab2$urban)

sleeping.sub3 = subset(sleeping,sex!="(Sex) No data")
sleeping.tab3 = data.table(sleeping.sub3)[,.(value=sum(value,na.rm=T)),by=.(sleeping.category,p20,sex,povcal_year,iso3)]
sleeping.tab3[,"total":=sum(value,na.rm=T),by=.(p20,sex,povcal_year,iso3)]
sleeping.tab3$percentage = sleeping.tab3$value/sleeping.tab3$total
sleeping.tab3 = subset(sleeping.tab3,sleeping.category=="5 people per room or more")
sleeping.tab3$demographic = paste(sleeping.tab3$p20, sleeping.tab3$sex)

ggplot(subset(sleeping.tab3,iso3=="KEN"),aes(group=demographic, color=demographic, x=povcal_year, y=percentage)) +
  geom_line() +
  scale_y_continuous(labels=percent) +
  theme_classic() +
  labs(title="Percentage with 5 or more people per room in Kenya",y="Percentage",x="Year",color="Demographic")

fwrite(sleeping.tab1,"p20_crowding.csv")
fwrite(sleeping.tab2,"p20_urban_crowding.csv")
fwrite(sleeping.tab3,"p20_sex_crowding.csv")
rm(sleeping,sleeping.tab1,sleeping.sub2,sleeping.tab2,sleeping.sub3,sleeping.tab3)

# % of population completed secondary education by national P20/rest over time by country
# As above we do add any other disaggregation? urban/rural, sex (not both together but one or the other so we only have a max of 4 lines)

educ = subset(dhs.mics,education_max!="(Education_max) No data")
educ$educ.category = "Completed secondary education"
educ$educ.category[which(educ$education_max == "Max: Less than primary")] = "Not completed secondary education"
educ$educ.category[which(educ$education_max == "Max: Primary")] = "Not completed secondary education"

educ.tab1 = data.table(educ)[,.(value=sum(value,na.rm=T)),by=.(educ.category,p20,povcal_year,iso3)]
educ.tab1[,"total":=sum(value,na.rm=T),by=.(p20,povcal_year,iso3)]
educ.tab1$percentage = educ.tab1$value/educ.tab1$total
educ.tab1 = subset(educ.tab1,educ.category=="Completed secondary education")
educ.tab1$demographic = educ.tab1$p20

educ.sub2 = subset(educ,urban!="(Area) No data")
educ.tab2 = data.table(educ.sub2)[,.(value=sum(value,na.rm=T)),by=.(educ.category,p20,urban,povcal_year,iso3)]
educ.tab2[,"total":=sum(value,na.rm=T),by=.(p20,urban,povcal_year,iso3)]
educ.tab2$percentage = educ.tab2$value/educ.tab2$total
educ.tab2 = subset(educ.tab2,educ.category=="Completed secondary education")
educ.tab2$demographic = paste(educ.tab2$p20, educ.tab2$urban)

educ.sub3 = subset(educ,sex!="(Sex) No data")
educ.tab3 = data.table(educ.sub3)[,.(value=sum(value,na.rm=T)),by=.(educ.category,p20,sex,povcal_year,iso3)]
educ.tab3[,"total":=sum(value,na.rm=T),by=.(p20,sex,povcal_year,iso3)]
educ.tab3$percentage = educ.tab3$value/educ.tab3$total
educ.tab3 = subset(educ.tab3,educ.category=="Completed secondary education")
educ.tab3$demographic = paste(educ.tab3$p20, educ.tab3$sex)

ggplot(subset(educ.tab3,iso3=="KEN"),aes(group=demographic, color=demographic, x=povcal_year, y=percentage)) +
  geom_line() +
  scale_y_continuous(labels=percent) +
  theme_classic() +
  labs(title="Percentage completed secondary education in Kenya",y="Percentage",x="Year",color="Demographic")

fwrite(educ.tab1,"p20_educ.csv")
fwrite(educ.tab2,"p20_urban_educ.csv")
fwrite(educ.tab3,"p20_sex_educ.csv")
rm(educ,educ.tab1,educ.sub2,educ.tab2,educ.sub3,educ.tab3)

# % of population with birth registration by national P20/rest over time by country
# As above we do add any other disaggregation? urban/rural, sex (not both together but one or the other so we only have a max of 4 lines)

birth.reg = subset(dhs.mics,birth.reg!=-1)

birth.reg.tab1 = data.table(birth.reg)[,.(value=sum(value,na.rm=T)),by=.(birth.reg,p20,povcal_year,iso3)]
birth.reg.tab1[,"total":=sum(value,na.rm=T),by=.(p20,povcal_year,iso3)]
birth.reg.tab1$percentage = birth.reg.tab1$value/birth.reg.tab1$total
birth.reg.tab1 = subset(birth.reg.tab1,birth.reg=="Registered")
birth.reg.tab1$demographic = birth.reg.tab1$p20

birth.reg.sub2 = subset(birth.reg,urban!="(Area) No data")
birth.reg.tab2 = data.table(birth.reg.sub2)[,.(value=sum(value,na.rm=T)),by=.(birth.reg,p20,urban,povcal_year,iso3)]
birth.reg.tab2[,"total":=sum(value,na.rm=T),by=.(p20,urban,povcal_year,iso3)]
birth.reg.tab2$percentage = birth.reg.tab2$value/birth.reg.tab2$total
birth.reg.tab2 = subset(birth.reg.tab2,birth.reg=="Registered")
birth.reg.tab2$demographic = paste(birth.reg.tab2$p20, birth.reg.tab2$urban)

birth.reg.sub3 = subset(birth.reg,sex!="(Sex) No data")
birth.reg.tab3 = data.table(birth.reg.sub3)[,.(value=sum(value,na.rm=T)),by=.(birth.reg,p20,sex,povcal_year,iso3)]
birth.reg.tab3[,"total":=sum(value,na.rm=T),by=.(p20,sex,povcal_year,iso3)]
birth.reg.tab3$percentage = birth.reg.tab3$value/birth.reg.tab3$total
birth.reg.tab3 = subset(birth.reg.tab3,birth.reg=="Registered")
birth.reg.tab3$demographic = paste(birth.reg.tab3$p20, birth.reg.tab3$sex)

ggplot(subset(birth.reg.tab3,iso3=="KEN"),aes(group=demographic, color=demographic, x=povcal_year, y=percentage)) +
  geom_line() +
  scale_y_continuous(labels=percent) +
  theme_classic() +
  labs(title="Percentage birth registered in Kenya",y="Percentage",x="Year",color="Demographic")

fwrite(birth.reg.tab1,"p20_birth.reg.csv")
fwrite(birth.reg.tab2,"p20_urban_birth.reg.csv")
fwrite(birth.reg.tab3,"p20_sex_birth.reg.csv")
rm(birth.reg,birth.reg.tab1,birth.reg.sub2,birth.reg.tab2,birth.reg.sub3,birth.reg.tab3)
