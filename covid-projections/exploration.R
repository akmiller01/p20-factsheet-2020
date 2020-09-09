list.of.packages <- c("data.table","jsonlite","ggplot2","scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/covid-projections")

pre = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Oct19.csv")
post = fread("/home/alex/git/poverty_predictions/output/globalproj_long_Apr20.csv")

pre_global = subset(pre,Level=="Global" & PovertyLine==1.9 & variable=="HeadCount")
post_global = subset(post,Level=="Global" & PovertyLine==1.9 & variable=="HeadCount")

pre_global$covid = "Global estimates before COVID-19"
post_global$covid = "Global etimates after COVID-19"

global = rbind(pre_global,post_global)
global = subset(global,ProjYear>=2010)
global_real = subset(global,ProjYear<=2018)
global_est = subset(global,ProjYear>=2018)

pre_ug = subset(pre,DisplayName=="Uganda" & PovertyLine==1.9 & variable=="HeadCount")
post_ug = subset(post,DisplayName=="Uganda" & PovertyLine==1.9 & variable=="HeadCount")

pre_ug$covid = "Uganda estimates before COVID-19"
post_ug$covid = "Uganda estimates after COVID-19"

ug = rbind(pre_ug,post_ug)
ug = subset(ug,ProjYear>=2010)
ug_real = subset(ug,ProjYear<=2018)
ug_est = subset(ug,ProjYear>=2018)

global_real = rbind(global_real, ug_real)
global_est = rbind(global_est, ug_est)

ggplot(global_real,aes(x=ProjYear, y=value, group=covid, color=covid)) +
  geom_line(show.legend=F) +
  geom_line(data=global_est,linetype="dashed") +
  theme_classic()
