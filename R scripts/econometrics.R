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
library('readr')





# 1. load datasets. Datasets are cleaned, and have as columns :

# Sentence Date (Year-Mon), Time Sentenced, Court, County, Crime Desc, Race, Age. (*add judge) --> every obvs. is the first sentence for each inmate in dataset. 
# I.E : if you were convicted for the first time in 1995, and then again in 1998 on a new charge after initial release, only your 1996 is in the dataset. 

# Oklahoma

# a. load 
oklahomadt <- read_csv("~/Desktop/portfolio/oklahoma/data/oklahoma/oklahoma_v1.csv") %>% 
  distinct()

# --> add state identifier 
oklahomadt$state <- "OK"

# Make Year-Month variable 

oklahomadt$yearmonth <- format(as.Date(oklahomadt$cv_date),"%Y-%m")
oklahomadt$yearmonth <- ymd(oklahomadt$yearmonth, truncated = 1)


# subset : Keep only observations that are in state. 

ddok <- oklahomadt %>% select(3,1,25,21,2,20,20,15,4,5,13,14,12,24) %>% filter(oklahomadt$court_state == "In_state")

# Missouri

# a. load
missouridt <- read_csv("~/Desktop/portfolio/oklahoma/data/missouri/missouri_cl.csv") %>% 
  distinct()

# --> add state identifier 
missouridt$state <- "MIS"

#Make Year-Month variable
missouridt$yearmonth <- format(as.Date(missouridt$sen_date),"%Y-%m")
missouridt$yearmonth <- ymd(missouridt$yearmonth, truncated = 1)


#subset

ddmis <- missouridt %>% 
  select(3,2,29,25,11, "sentence",12,4,5,6,7,8,28) %>%
  rename(county = 2,
         code = 4, 
         statute = 5, 
         dob = 12)



## Look at both of my datasets 

NA_mis <- ddmis %>% 
  map_df(~sum(is.na(.))) %>% 
  gather() %>% 
  rename( Column = 1,
          NAs = 2)

NA_ok <- ddok %>% 
  map_df(~sum(is.na(.))) %>% 
  gather() %>% 
  rename( Column = 1,
          NAs = 2)

 # --> elements needed for diff in diff ( Treatment(OK), Control (MIS), Time* at =0, =1, fixed effects covariates, X covariates ( age, race))

# * By the fall of 1995, a decision was made to implement Title 57 § 561, regarding authority to provide incarceration, supervision, 
#and residential treatment at facilities not operated by the Department of Corrections. 
#The Board of Corrections and the Department of Central Services approved 560 medium-security contract beds in December of 1995.(source:OKLAHOMA DEPARTMENT OF CORRECTIONS Citizens’ Academy http://doc.ok.gov )

#merge datasets 

ok_mis_dt <- rbind(ddok, ddmis)


#add time dummy 

ok_mis_dt$timedummy <- ifelse(ok_mis_dt $yearmonth >= "1995-12-01", 1, 0)


## A
#Clean Race Descriptions

unique(ok_mis_dt$race)


ok_mis_dt$race <- ifelse(grepl("Alaskan Native", ok_mis_dt$race), "Native American", ok_mis_dt$race)
ok_mis_dt$race <- ifelse(grepl("Nat Am/Alaskan", ok_mis_dt$race), "Native American", ok_mis_dt$race)
ok_mis_dt$race <- ifelse(grepl("Pacific Islander", ok_mis_dt$race), "Asian/Pacific Islander", ok_mis_dt$race)
ok_mis_dt$race <- ifelse(grepl("Asian", ok_mis_dt$race), "Asian/Pacific Islander", ok_mis_dt$race)
ok_mis_dt$race <- ifelse(grepl("M", ok_mis_dt$race), "Unknown", ok_mis_dt$race)
ok_mis_dt$race <- ifelse(grepl("N", ok_mis_dt$race), "Unknown", ok_mis_dt$race)
ok_mis_dt$race <- ifelse(grepl("Other", ok_mis_dt$race), "Unknown", ok_mis_dt$race)

#No Hispanic for Missouri?
race_count <- ok_mis_dt %>% 
  group_by(race, state) %>% 
  count()


## B
#Try to get the same type of crimes across both states : this will be messy for now 

## Violent crimes are : Murder, Manslaughter, Rape, Robbery, Agg.Assault.
## Drugs : Controlled Substance, Distribution, Dangerous Drugs.
## Non-Violent : Everything Else. 

# For Missouri (http://www.mshp.dps.missouri.gov/MSHPWeb/PatrolDivisions/CRID/documents/1979ChargeCodeManualHistoricalChargeCodeManual-1stoneproduced.pdf)
#--> Murder is code 10, Rape code 11, Manslaughter 09, Robbery 12, Assault 13

# For Oklahoma, descriptions are cleaner, try to use regex based methods to follow Missouri


ok_mis_dt$crimetype <- "Non-Violent"

# Missouri Violent Crimes
ok_mis_dt$crimetype <- ifelse(grepl("^10",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype)
ok_mis_dt$crimetype <- ifelse(grepl("^11",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype)
ok_mis_dt$crimetype <- ifelse(grepl("^09",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype)
ok_mis_dt$crimetype <- ifelse(grepl("^12",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype)
ok_mis_dt$crimetype <- ifelse(grepl("^13",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype)


#Oklahoma Violent Crimes

ok_mis_dt$crimetype <- ifelse(grepl("^.21-701",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype) #Murder
ok_mis_dt$crimetype <- ifelse(grepl("^.21-712",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype) #Rape
ok_mis_dt$crimetype <- ifelse(grepl("^.21-801",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype) #Robbery
ok_mis_dt$crimetype <- ifelse(grepl("^.21-799",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype) #Robbery
ok_mis_dt$crimetype <- ifelse(grepl("^.21-791",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype) #Robbery
ok_mis_dt$crimetype <- ifelse(grepl("^.21-797",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype) #Robbery
ok_mis_dt$crimetype <- ifelse(grepl("^.21-800",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype) #Robbery
ok_mis_dt$crimetype <- ifelse(grepl("^.21-798",ok_mis_dt$statute), "Violent", ok_mis_dt$crimetype) #Robbery


# Missouri Drugs
ok_mis_dt$crimetype <- ifelse(grepl("^32",ok_mis_dt$statute), "Drugs", ok_mis_dt$crimetype)


# Oklahoma Drugs -- Title 63
ok_mis_dt$crimetype <- ifelse(grepl("^.63",ok_mis_dt$statute), "Drugs", ok_mis_dt$crimetype)




## C .

#Clean Race Descriptions

unique(ok_mis_dt$sex)

ok_mis_dt$sex <- ifelse(grepl("M", ok_mis_dt$sex), "Male", ok_mis_dt$sex)
ok_mis_dt$sex <- ifelse(grepl("F", ok_mis_dt$sex), "Female", ok_mis_dt$sex)



## Year 

ok_mis_dt$yeardum <- year(ok_mis_dt$yearmonth)
ok_mis_dt$year <- ymd(ok_mis_dt$yeardum, truncated = 2)

# --> Get this thing as neat as possible. 


NA_ok_mis_dt <- ok_mis_dt %>% 
  map_df(~sum(is.na(.))) %>% 
  gather() %>% 
  rename( Column = 1,
          NAs = 2)


#Look at most common charges across states

missouricharges <- ok_mis_dt %>% 
  filter(state == "MIS") %>% 
  group_by(year) %>% 
  count(statute,desc) %>% 
  mutate(tot_offence = sum(n), perc = (n/tot_offence)*100) %>% 
  slice(which.max(n))

oklahomacharges <- ok_mis_dt %>% 
  filter(state == "OK") %>% 
  group_by(year) %>% 
  count(statute,desc) %>% 
  mutate(tot_offence = sum(n), perc = (n/tot_offence)*100) %>% 
  slice(which.max(n))

# Look at unique IDs per state 

#Unique inmate count per year
uniqueinmates <- ok_mis_dt %>% 
  filter(year >= "1950-01-01" & year <= "2019-01-01") %>% 
  group_by(state, year) %>% 
  summarise(n_distinct(DOCNum)) %>% 
  rename(inmate =3) %>% 
  mutate(cumulative_inmates = cumsum(inmate))

#Unique inmate count
uniqueinmates_count <- ok_mis_dt %>% 
  filter(year >= "1950-01-01" & year <= "2019-01-01") %>% 
  group_by(state) %>% 
  summarise(n_distinct(DOCNum)) 


# Average Number offence per inmate
incarceration_uniqueinmates <- ok_mis_dt %>% 
  filter(year >= "1950-01-01" & year <= "2019-01-01") %>% 
  filter(code =="Incarceration") %>% 
  group_by(state) %>% 
  count(count = n_distinct(DOCNum)) %>% 
  mutate( av_offence = n/count)

#Inmate growth : non-cumulative (amount of new inmates every year)
ggplot(uniqueinmates, aes( x= year, y=inmate, colour=state)) +
  geom_line()

#Inmate growth : cumulative

ggplot(uniqueinmates, aes( x= year, y=cumulative_inmates, colour=state)) +
  geom_line()



# Take first occurence of person dealing with correctional system as a whole ( alternative, first time they went to jail / would have to control for having previous probation).

did_data <- ok_mis_dt %>% 
  # year and date stuff
  filter(yearmonth >= "1990-01-01" & yearmonth <= "1999-12-01") %>% 
  mutate(yeardum = year(yearmonth)) %>% 
  mutate(year= ymd(yeardum, truncated = 2)) %>% 
  # group by DOCNum and state
  group_by(DOCNum, state) %>% 
  filter(yearmonth == min(yearmonth)) %>% 
  filter(code =="Incarceration" | code =="Incarcerated") %>% 
  distinct()
  



#How much data is missing 

NA_diddata <- did_data %>% 
   map_df(~sum(is.na(.))) %>% 
  gather() %>% 
   rename( Column = 1,
          NAs = 2)

# Clean table for NA values 

formattable(NA_diddata,
            align =c("l","c","c","c","c", "c", "c", "c", "r"),
            list(`Column` = formatter(
              "span", style = ~ style(color = "grey",font.weight = "bold")))) 



# Get an idea of the spread of sentences in each state

num_inmate_year <- did_data %>% 
  group_by(year, state) %>% 
  count(n_distinct(DOCNum)) %>% 
  rename(Distinct_DOC =3) %>% 
  select(1,2,3)

# A little bit misleading bc it has ot be weighted by population and other types of inmates
ggplot(num_inmate_year, aes( x= year, y = Distinct_DOC, color= state)) +
         geom_line()


# Sentence lenght 

# Look at sentence range : took the log here which is much better -- looks approx normal for Mis, Ok has a fat right tail tho and no left tail . 

ggplot (did_data, aes(x= year, y = log(sentence))) +
  geom_jitter(alpha=0.1) +
  facet_wrap(~ state)

ggplot (did_data, aes(x= year, y = sentence)) +
  geom_jitter(alpha=0.1) +
  facet_wrap(~ state)



#There are some stratified sentences in the Oklahoma data which makes sense. Maybe a minimum sentence or type of crime

# Look at summed sentence range : number of counts they have (control for?)

offence_count <- did_data %>% 
  group_by(DOCNum, state,year) %>% 
  count()

sum_sentences <- did_data %>% 
  group_by(DOCNum, state,year) %>% 
  summarise(sum_sentence = sum(sentence)) %>% 
  filter(sum_sentence > 0) %>% 
  distinct()

did_sumsentence <- merge(offence_count, sum_sentences, by="DOCNum") %>%
  mutate(log_sentence = log(sum_sentence)) %>% 
  select(1,2,3,4,7,8) %>% 
  rename( state =2,
          year =3)

did_sumsentence$timedummy <- ifelse(did_sumsentence$year < "1996-01-01", 0, 1)

#Histogram 
hist1996 <- did_sumsentence %>% 
  filter( year == "1995-01-01") 

ggplot(hist1996, aes(x= log_sentence)) +
  geom_histogram() +
  facet_wrap(~state)

# Plot using logged sentece sums
ggplot (did_sumsentence, aes(x= year, y = log_sentence)) +
  geom_jitter(alpha=0.1) +
  facet_wrap(~ state)

#Calculate group means

did_means <- did_sumsentence %>% 
  group_by(state,timedummy) %>% 
  summarise(mean_sumsentences = mean(sum_sentence))


# Means Before and After Treatment : USE THIS GRAPH FOR DID 

ggplot(did_sumsentence, aes(x = state, y = sum_sentence)) +
  stat_summary(geom = "pointrange", size = 1, color = "red",
               fun.data = "mean_se", fun.args = list(mult = 1.96)) +
  facet_wrap(~timedummy)



































# Scrap code


  #First occurance
  group_by(DOCNum, state) %>% 
  filter(yearmonth == min(yearmonth)) %>% 
  #Create month dummy to get yearly dates 
  mutate(yeardum = year(yearmonth)) %>% 
  mutate(year= ymd(yeardum, truncated = 2)) %>% 
  #Maybe use this to look at het treatment effects later
  filter(code =="Incarceration" | code =="Incarcerated") %>% 
  #Use time range I want
  filter(year >= "1990-01-01" & year <= "1999-01-01") %>% 
  #Make correct groups 
  group_by(DOCNum, state, year) %>% 
  mutate(sentence_sum = sum(sentence)) 










# Core Civic Share Prices

corecivic <- read_csv("~/Desktop/portfolio/oklahoma/data/corecivic.csv")
corecivic$Date <- ymd(corecivic$Date)
  
  

ggplot(corecivic, aes(y=Close, x=Date)) +
  geom_line() +
  scale_x_date(expand =c(0,0), date_labels="%Y", date_breaks  ="5 years")






















# Visual 1 : Count of incarceration per year 

count_incarceration <- ok_mis_dt  %>% 
  filter(ppdt$code =="Incarceration" | ppdt$code =="Incarcerated") %>% 
  mutate(yeardum = year(yearmonth)) %>% 
  mutate(year= ymd(yeardum, truncated = 2)) %>% 
  group_by(year, state) %>% 
  summarise(Unique_Elements = sum(n_distinct(DOCNum))) %>% 
  select(year, state, Unique_Elements) %>% 
  filter(year >= "1990-01-01" & year <= "1999-01-01")

ggplot(count_incarceration, aes(x=year, y=Unique_Elements, colour = state)) +
  geom_line() 


# Visual 2 : Count of people dealing with correctional per year 

count_corrections <- ok_mis_dt  %>% 
  mutate(yeardum = year(yearmonth)) %>% 
  mutate(year= ymd(yeardum, truncated = 2)) %>% 
  group_by(year, state) %>% 
  summarise(Unique_Elements = sum(n_distinct(DOCNum))) %>% 
  select(year, state, Unique_Elements) %>% 
  filter(year >= "1990-01-01" & year <= "1999-01-01")

ggplot(count_corrections, aes(x=year, y=Unique_Elements, colour = state)) +
  geom_line() 


# Visual 3 : Average sentence delivered per year, for first offences per DOCNum (excluding life sentences)


# Step 1 - 
average_sentence <- ok_mis_dt  %>% 
  
#Keep only first record of conviction
  group_by(DOCNum, state) %>% 
  filter(yearmonth == min(yearmonth)) %>% 
  mutate(effective_life = ifelse(sentence > 29200 & code == "Incarceration" | code == "Incarcerated" , "life", "notlife"))

DOCNum_effectivelifers <- average_sentence %>% 
  filter(effective_life == "life") %>% 
  select(DOCNum) %>% 
  distinct()

DOC_lifers <- DOCNum_effectivelifers$DOCNum


average_sentence_nl <- average_sentence 
average_sentence_nl$yeardum <- year(average_sentence_nl$yearmonth)
average_sentence_nl$year <- ymd(average_sentence_nl$yeardum, truncated = 2)


# Median sentences
med_sentences <- average_sentence_nl %>% 
  filter(!is.na(sentence), sentence >0) %>% 
  group_by(DOCNum, yearmonth, state) %>% 
  mutate(sentence_sum = sum(sentence)) %>% 
  filter(!DOCNum %in% DOC_lifers) %>% 
  group_by(year,state) %>% 
  summarise(av_sentence_year = median(sentence_sum)) %>% 
  filter(year >= "1990-01-01" & year <= "1999-01-01")


# Mean sentences
mean_sentences <- average_sentence_nl %>% 
  filter(!is.na(sentence), sentence >0) %>% 
  group_by(DOCNum, yearmonth, state) %>% 
  mutate(sentence_sum = sum(sentence)) %>% 
  filter(!DOCNum %in% DOC_lifers) %>% 
  group_by(year,state) %>% 
  summarise(av_sentence_year = mean(sentence_sum)) %>% 
  filter(year >= "1990-01-01" & year <= "1999-01-01")


ggplot(sum_sentences, aes(x=year, y=av_sentence_year, colour = state)) +
  geom_line() 


# Look at distribution of summed sentences

sentence_distribution <- average_sentence_nl %>% 
  filter(!is.na(sentence), sentence >0) %>% 
  group_by(DOCNum, yearmonth, state) %>% 
  mutate(sentence_sum = sum(sentence)) %>% 
  filter(!DOCNum %in% DOC_lifers) %>% 
  group_by(year, state) %>% 
  mutate(max_sum = max(sentence_sum),
         max_sum_years = max(sentence_sum)/365,
         min_sum = min(sentence_sum),
         min_sum_years = min(sentence_sum)/365) %>% 
  select(year, state, max_sum, min_sum,max_sum_years,min_sum_years) %>% 
  arrange(year) %>% 
  filter(year >= "1990-01-01" & year <= "1999-01-01") %>% 
  distinct()

# Mean sentences -- mean sentences without extreme skew

filtered_sentences <- average_sentence_nl %>% 
  filter(!is.na(sentence), sentence >0) %>% 
  group_by(DOCNum, yearmonth, state) %>% 
  mutate(sentence_sum = sum(sentence)) %>% 
  filter(!DOCNum %in% DOC_lifers) %>%
  filter(!sentence_sum > 219000) %>% 
  group_by(year, state) %>% 
  summarise(av_sentence_year = mean(sentence_sum)) %>% 
  filter(year >= "1990-01-01" & year <= "1999-01-01") 


ggplot(filtered_sentences, aes(x=year, y=av_sentence_year, colour = state)) +
  geom_line() 


# Median sentences -- median sentences without extreme skew

filtered_sentences_median <- average_sentence_nl %>% 
  filter(!is.na(sentence), sentence >0) %>% 
  group_by(DOCNum, yearmonth, state) %>% 
  mutate(sentence_sum = sum(sentence)) %>% 
  filter(!DOCNum %in% DOC_lifers) %>%
  filter(!sentence_sum > 219000) %>% 
  group_by(year, state) %>% 
  summarise(av_sentence_year = median(sentence_sum)) %>% 
  filter(year >= "1990-01-01" & year <= "1999-01-01") 


ggplot(filtered_sentences_median, aes(x=year, y=av_sentence_year, colour = state)) +
  geom_line() 


## Econometrics 

## Equation 





