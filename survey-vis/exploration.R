list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/survey-vis")

load("historical_dhs-mics_handwashing.RData")


wash = subset(dhs.mics,handwashing!=-1)
sleep = subset(dhs.mics,sleeping!=-1 & sleeping!="Inf")
sleep$sleeping = as.numeric(sleep$sleeping)

ggplot(sleep,aes(x=sleeping, group=p20, color=p20)) +
  geom_density() +
  theme_classic()
ggplot(wash,aes(group=handwashing, fill=handwashing, x=p20)) +
  geom_bar(position="fill") +
  scale_y_continuous(labels=percent) +
  theme_classic()
