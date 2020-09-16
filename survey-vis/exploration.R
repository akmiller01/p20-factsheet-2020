list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/survey-vis")

load("historical_dhs-mics_handwashing.RData")

# available.vars = names(dhs.mics)
# av = data.frame(var.name=available.vars, var.description=NA)
# fwrite(av, "available_vars.csv")

wash = subset(dhs.mics,handwashing!=-1)
sleep = subset(dhs.mics,sleeping!=-1 & sleeping!="Inf")
sleep$sleeping = as.numeric(sleep$sleeping)
sleep$cat = "Less than 5 people per room"
sleep$cat[which(sleep$sleeping >= 5)] = "5 people per room or more"

wash.tab = data.table(wash)[,.(value=sum(value,na.rm=T)),by=.(handwashing,p20,povcal_year)]
sleep.tab = data.table(sleep)[,.(value=sum(value,na.rm=T)),by=.(cat,p20,povcal_year)]

sleep.tab = subset(sleep.tab, p20!="(P20) No data")
ggplot(sleep.tab,aes(x=p20, y=value, group=cat, fill=cat)) +
  geom_bar(stat="identity",position="fill") +
  scale_y_continuous(labels=percent) +
  facet_wrap(~povcal_year) +
  theme_classic()
wash.tab = subset(wash.tab,p20!="(P20) No data" & povcal_year<2019)
ggplot(wash.tab,aes(group=handwashing, fill=handwashing, x=p20, y=value)) +
  geom_bar(stat="identity",position="fill") +
  scale_y_continuous(labels=percent) +
  facet_wrap(~povcal_year) +
  theme_classic()
