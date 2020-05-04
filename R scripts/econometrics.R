# Author: Myrtille Genot
# Code : Econometrics 
# Date: 29/04/2020

# load relevant libraries

library('Rcpp')
library('haven') 
library('dplyr') 
library('AER')   
library('plm')
library('stargazer')
library('ggplot2')
library('forecast')
library('tseries')
library('zoo')
library('naniar') 
library('lubridate')
library('stringr')
library('rvest')
library('xml2')
library('tidyr')
library('extrafont')
library('lemon')
library('ggrepel')
library('ggtext')
library('gridExtra')
library('grid')
library('ggplot2')
library('lattice')
library('cowplot')
library('wesanderson')

# Steps for diff in diff 



# 1. load datasets. Datasets are cleaned, and have as columns :

# Sentence Date (Year-Mon), Time Sentenced, Court, County, Crime Desc, Race, Age. (*add judge) --> every obvs. is the first sentence for each inmate in dataset. 
# I.E : if you were convicted for the first time in 1995, and then again in 1998 on a new charge after initial release, only your 1996 is in the dataset. 

# Oklahoma

# a. load 
oklahomadt <- read_csv("~/Desktop/portfolio/oklahoma/data/oklahoma/oklahoma_v1.csv") %>% 
  disctinct()

# --> add state identifier 
oklahomadt$state <- "OK"

# Make Year-Month variable 

oklahomadt$yearmonth <- format(as.Date(oklahomadt$cv_date),"%Y-%m")
oklahomadt$yearmonth <- ymd(oklahomadt$yearmonth, truncated = 1)


# subset

ddok <- oklahomadt %>% select(3,1,25,21,2,20,20,15,4,5,13,14,12,24)

# Missouri

# a. load
missouridt <- read_csv("~/Desktop/portfolio/oklahoma/data/missouri/missouri_v1.csv") %>% 
  distinct()

# --> add state identifier 
missouridt$state <- "MIS"

#Make Year-Month variable
missouridt$yearmonth <- format(as.Date(missouridt$sen_date),"%Y-%m")
missouridt$yearmonth <- ymd(missouridt$yearmonth, truncated = 1)

#subset

ddmis <- missouridt %>% 
  select(1,9,28,24,10,25,11,2,3,5,4,6,27) %>%
  rename(county = 2,
         code = 4, 
         statute = 5, 
         dob = 12)

 # --> elements needed for diff in diff ( Treatment(OK), Control (MIS), Time* at =0, =1, fixed effects covariates, X covariates ( age, race))

# * By the fall of 1995, a decision was made to implement Title 57 § 561, regarding authority to provide incarceration, supervision, 
#and residential treatment at facilities not operated by the Department of Corrections. 
#The Board of Corrections and the Department of Central Services approved 560 medium-security contract beds in December of 1995.(source:OKLAHOMA DEPARTMENT OF CORRECTIONS Citizens’ Academy http://doc.ok.gov )

#merge datasets 

ppdt <- rbind( ddok, ddmis)


#add time dummy 

ppdt$timedummy <- ifelse(ppdt$yearmonth >= "1995-12-01", 1, 0)

xx <- ppdt %>% filter(ppdt$code =="Incarceration" | ppdt$code =="Incarcerated") %>% 
  group_by(DOCNum) %>% 
  filter(yearmonth == min(yearmonth)) %>% 
  mutate(sum_sentence = sum(sentence)) %>% 
  filter(yearmonth >= "1990-01-01" & yearmonth <= "1999-12-01") %>% 
  filter(!sum_sentence < 100)

xx$yearmonth <- ymd(xx$yearmonth)

xx2 <- xx %>% 
  mutate(yeardum = year(yearmonth)) %>% 
  group_by(state, yeardum) %>% 
  summarise(meansentence_gy = mean(sum_sentence))

xx2$yeardum <- ymd(xx2$yeardum, truncated = 2)


ggplot(xx2, aes(x=yeardum, y=meansentence_gy, colour = state)) +
  geom_line() 


