list.of.packages <- c("data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/covid-proj-np20")

url = "http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx?RefYears=all&C0=UGA&PovertyLine=1.9&display=c"

data.list = list()
data.index = 1

pre = fread("/home/alex/git/poverty_predictions/output/p20_p80_incomes_Oct19.csv")
post = fread("/home/alex/git/poverty_predictions/output/p20_p80_incomes_Apr20.csv")
pre_common = subset(pre,ProjYear<2018)
post_common = subset(post,ProjYear<2018)
common = merge(pre_common, post_common, all=T)
pre = subset(pre,ProjYear>=2018)
post = subset(post,ProjYear>=2018)

for(i in 1:nrow(common)){
  row = common[i,]
  cc = row$CountryCode
  ProjYear = row$ProjYear
  pl = row$p20
  url = paste0(
    "http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx?RefYears=",
    ProjYear,
    "&C0=",
    cc,
    "&PovertyLine=",
    pl,
    "&display=c"
  )
  pov = fread(url)
  pov = pov[1,]
  pov$ProjYear = ProjYear
  pov$covid = F
  pov$estimate = F
  data.list[[data.index]] = pov
  data.index = data.index + 1
}

# all_pov_common = rbindlist(data.list)
# save(all_pov_common,file="all_pov_common.RData")
# load("all_pov.RData")
# all_pov$estimate = T
# all_pov = rbind(all_pov_common, all_pov)
# save(all_pov,file="all_pov_complete.RData")
# fwrite(all_pov,"all_pov_complete.csv")

for(i in 1:nrow(pre)){
  row = pre[i,]
  cc = row$CountryCode
  ProjYear = row$ProjYear
  pl = row$p20
  url = paste0(
    "http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx?RefYears=all",
    "&C0=",
    cc,
    "&PovertyLine=",
    pl,
    "&display=c"
  )
  pov = fread(url)
  pov <- pov[pov[!is.na(HeadCount), .I[which.max(RequestYear)], by=.(CountryCode, CoverageType)]$V1]
  pov$ProjYear = ProjYear
  pov$covid = F
  data.list[[data.index]] = pov
  data.index = data.index + 1
}
for(i in 1:nrow(post)){
  row = post[i,]
  cc = row$CountryCode
  ProjYear = row$ProjYear
  pl = row$p20
  url = paste0(
    "http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx?RefYears=all",
    "&C0=",
    cc,
    "&PovertyLine=",
    pl,
    "&display=c"
  )
  pov = fread(url)
  pov <- pov[pov[!is.na(HeadCount), .I[which.max(RequestYear)], by=.(CountryCode, CoverageType)]$V1]
  pov$ProjYear = ProjYear
  pov$covid = T
  data.list[[data.index]] = pov
  data.index = data.index + 1
}

all_pov = rbindlist(data.list)
save(all_pov,file="all_pov_complete.RData")
fwrite(all_pov,"all_pov_complete.csv")
