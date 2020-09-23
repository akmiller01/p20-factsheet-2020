list.of.packages <- c("data.table","jsonlite","ggplot2","scales", "plotly")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("~/git/p20-factsheet-2020/covid-projections")

all = fread("covid_proj_wide.csv")
names(all) = make.names(names(all))

# all[is.na(all)] <- NaN

fig <- plot_ly(all, x = ~year, y = ~Pre.Covid.measured.extreme.poverty, name = 'Pre-Covid measured extreme poverty', type = 'scatter', mode = 'lines',
               line = list(color = 'rgb(232, 68, 57)', width = 4), connectgaps = TRUE, text = ~paste('Country: ', name),transforms = list(
                 list(
                   type = 'filter',
                   target = ~name,
                   operation = '=',
                   value = unique(all$name)[1]
                 )
               )) 
fig <- fig %>% add_trace(y = ~Pre.Covid.estimated.extreme.poverty, name = 'Pre-Covid estimated extreme poverty',
                line = list(color = 'rgb(232, 68, 57)', width = 4, dash = 'dash'), connectgaps = TRUE) 
fig <- fig %>% add_trace(y = ~Post.Covid.measured.extreme.poverty, name = 'Post-Covid measured extreme poverty',
                         line = list(color = 'rgb(143, 27, 19)', width = 4), connectgaps = TRUE)
fig <- fig %>% add_trace(y = ~Post.Covid.estimated.extreme.poverty, name = 'Post-Covid estimated extreme poverty',
                         line = list(color = 'rgb(143, 27, 19)', width = 4, dash = 'dash'), connectgaps = TRUE) 
fig <- fig %>% add_trace(y = ~Pre.Covid.measured.P20.poverty, name = 'Pre-Covid measured P20 poverty',
                         line = list(color = 'rgb(232, 68, 57)', width = 4), connectgaps = TRUE) 
fig <- fig %>% add_trace(y = ~Pre.Covid.estimated.P20.poverty, name = 'Pre-Covid estimated P20 poverty',
                         line = list(color = 'rgb(232, 68, 57)', width = 4, dash = 'dash'), connectgaps = TRUE) 
fig <- fig %>% add_trace(y = ~Post.Covid.measured.P20.poverty, name = 'Post-Covid measured P20 poverty',
                         line = list(color = 'rgb(143, 27, 19)', width = 4), connectgaps = TRUE) 
fig <- fig %>% add_trace(y = ~Post.Covid.estimated.P20.poverty, name = 'Post-Covid estimated P20 poverty',
                         line = list(color = 'rgb(143, 27, 19)', width = 4, dash = 'dash'), connectgaps = TRUE) 
fig <- fig %>% layout(title = "COVID-19 effects on global poverty",
                      xaxis = list(title = "Year"),
                      yaxis = list (title = "Percentage in poverty", tickformat="%"))

fig
