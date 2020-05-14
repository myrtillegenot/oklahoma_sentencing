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



## D. DATA ANALYSIS 



# Incarceration only (no life, probation etc)

incarceration <- ok_mis_dt %>% 
  filter(year >= "1950-01-01" & year <= "2019-01-01") %>% 
  filter(code=="Incarceration")

# Average Number offence per inmate

uniqueinmates <- incarceration %>% 
  group_by(state) %>% 
  count(Distinct_Inmates = n_distinct(DOCNum)) %>% 
  mutate( Average_Num_Offence = n/Distinct_Inmates) %>% 
  rename( Total_Inmates = n,
          State = state)


library("formattable")
formattable(uniqueinmates,
            align =c("l","c","c","c","c", "c", "c", "c", "r"),
            list(`Column` = formatter(
              "span", style = ~ style(color = "grey",font.weight = "bold")))) 
  
# Most common charges for incarceration in Missouri and Oklahoma : Repeat offenders included. 

mis_common_incarceration <- incarceration %>% 
  filter(state == "MIS") %>% 
  group_by(year) %>% 
  count(statute,desc) %>% 
  mutate(tot_offence = sum(n), perc = (n/tot_offence)*100) %>% 
  slice(which.max(n))

ok_common_incarceration <- incarceration %>% 
  filter(state == "OK") %>% 
  group_by(year) %>% 
  count(statute,desc) %>% 
  mutate(tot_offence = sum(n), perc = (n/tot_offence)*100) %>% 
  slice(which.max(n))

# Most common charges for incarceration in Missouri and Oklahoma : Repeat offenders NOT included (1st time offenders only)

mis_1st_charges <- incarceration %>% 
  group_by(DOCNum, state) %>% 
  filter(yearmonth == min(yearmonth)) %>% 
  filter(state =="MIS") %>% 
  group_by(year) %>% 
  count(statute,desc) %>% 
  mutate(tot_offence = sum(n), perc = (n/tot_offence)*100) %>% 
  slice(which.max(n))
  
ok_1st_charges <- incarceration %>% 
  group_by(DOCNum, state) %>% 
  filter(yearmonth == min(yearmonth)) %>% 
  filter(state =="OK") %>% 
  group_by(year) %>% 
  count(statute,desc) %>% 
  mutate(tot_offence = sum(n), perc = (n/tot_offence)*100) %>% 
  slice(which.max(n))


#Look at most common charges across states : Not just incarceration. 

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

#Unique inmate count : incarcerated
prison_uniqueinmates <- incarceration %>% 
  group_by(state, year) %>% 
  summarise(n_distinct(DOCNum)) %>% 
  rename(inmate =3) %>% 
  mutate(cumulative_inmates = cumsum(inmate))

#Graph 1 :
#Inmate growth : non-cumulative (amount of new inmates every year)
inmate_count <- ggplot(prison_uniqueinmates , aes( x= year, y=inmate, colour=state)) +
  geom_line() +
  labs(y = 'Count of inmates',
       title = 'Count of inmates through DOC systems', 
       subtitle = 'Non-cumulative\n\n',
       caption = 'Data from the Missouri Department of Corrections. \nDownload : April 2020') +
  theme(text = element_text(family = 'Source Sans Pro'),
        #plot text
        plot.title = element_text(margin = margin(t = 20), face="bold", vjust = 2, family = 'Roboto Black'),
        plot.subtitle = element_text(size = 9,face="bold", family ="Source Sans Pro"),
        plot.caption = element_text(margin = margin(t = 15), hjust = 0, size =8),
        #asix
        axis.title.y = element_text(size = 9,family ="Roboto Black", angle = 0, margin = margin(t = 0, r = -20 , b = 0, l = 0),),
        axis.title.x = element_blank(),
        axis.text.y = element_text(face="bold", size = 8, angle = 0),
        axis.text.x = element_text(size =5),
        axis.line.x = element_blank(), axis.ticks.x = element_blank(),
        axis.line.y = element_line(colour="grey40", size = 0.3), axis.ticks.y = element_blank(),
        #legend
        legend.title = element_blank(), legend.text = element_text(size = 7),
        legend.key = element_blank(), legend.position = "bottom", legend.box="vertical", 
        legend.background = element_rect(colour ="white", fill=alpha(0.8)),
        #panels
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey50", size = 0.1),
        panel.grid.major.x = element_blank(),
        plot.margin = unit(c(0,1,0,1), "cm"))
inmate_count

ggsave(inmate_count, file ='~/Desktop/portfolio/oklahoma/scripts/graphs/inmatecount.png', width=6, height=6)


## SENTENCES

# Using just incarcerated inmates, create average sentence per year 

average_year_sentence <- incarceration %>% 
  filter(!is.na(sentence), !sentence<0) %>% 
  filter(year >= "1990-01-01" & year <= "1999-01-01") %>% 
  mutate(sentence_inyears = sentence / 365.25) %>% 
  filter(!sentence_inyears > 80) %>% 
  group_by(state, year) %>% 
  mutate(average_sentence = mean(sentence_inyears))

parallel <- ggplot(average_year_sentence, aes( x= year, y=average_sentence, colour = state)) +
  geom_line() +
  geom_vline(xintercept = as.numeric(as.Date("1996-01-01")), colour = "grey", linetype='dashed') +
  scale_colour_manual(values=c("#4b878b", "#d01c01")) +
  labs(y = 'Average Sentence',
       title = 'Parallel Trends : Average Sentences (in years)', 
       subtitle = 'Not quite there\n\n',
       caption = 'Data from the Missouri and Oklahoma Department of Corrections. \nDownload : April 2020') +
  annotate("text", y = 7.2 , x = as.Date("1996-09-01"), label = "Title 57", family="Source Sans Pro", size = 3) +
  theme(text = element_text(family = 'Source Sans Pro'),
        #plot text
        plot.title = element_text(margin = margin(t = 20), face="bold", vjust = 2, family = 'Roboto Black'),
        plot.subtitle = element_text(size = 9,face="bold", family ="Source Sans Pro"),
        plot.caption = element_text(margin = margin(t = 15), hjust = 0, size =8),
        #asix
        axis.title.y = element_text(size = 9,family ="Roboto Black", angle = 90),
        axis.title.x = element_blank(),
        axis.text.y = element_text(face="bold", size = 8, angle = 0),
        axis.text.x = element_text(size =5),
        axis.line.x = element_blank(), axis.ticks.x = element_blank(),
        axis.line.y = element_line(colour="grey40", size = 0.3), axis.ticks.y = element_blank(),
        #legend
        legend.title = element_blank(), legend.text = element_text(size = 7),
        legend.key = element_blank(), legend.position = "bottom", legend.box="vertical", 
        legend.background = element_rect(colour ="white", fill=alpha(0.8)),
        #panels
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey50", size = 0.1),
        panel.grid.major.x = element_blank(),
        plot.margin = unit(c(0,1,0,1), "cm"))

ggsave(parallel, file ='~/Desktop/portfolio/oklahoma/scripts/graphs/parallel.png', width=6, height=6)

# Histogram for logged average sentence in specific year to show semi normal distribution 

hist1995 <- average_year_sentence %>% 
  mutate(log_sentence = log(sentence_inyears))

labels <- c(MIS = "Missouri", OK = "Oklahoma")

histograms <- ggplot(hist1995, aes(x= log_sentence, fill= state, colour =state)) +
  geom_histogram(position="identity", alpha=0.5) +
  facet_wrap(. ~state, labeller=labeller(state = labels)) +
  scale_x_continuous(limits = c(0.0, 5.0), 
                     breaks = c(seq(0,5, 2.5))) +
  scale_colour_manual(values=c("#4b878b", "#d01c01")) +
  scale_fill_manual(values=c("#4b878b", "#d01c01")) +
  labs(y = 'Count',
       x = "Log Sentence in Years",
       title = 'Histogram : Logged Sentence (in years)', 
       subtitle = 'For Missouri and Oklahoma\n\n',
       caption = 'Data from the Missouri and Oklahoma Department of Corrections. \nDownload : April 2020') +
  theme(text = element_text(family = 'Source Sans Pro'),
        #plot text
        plot.title = element_text(margin = margin(t = 20), face="bold", vjust = 2, family = 'Roboto Black'),
        plot.subtitle = element_text(size = 9,face="bold", family ="Source Sans Pro"),
        plot.caption = element_text(margin = margin(t = 15), hjust = 0, size =8),
        #asix
        axis.title.y = element_text(size = 9,family ="Roboto Black", angle = 90),
        axis.title.x = element_text(size = 9,family ="Roboto Black", angle = 0),
        axis.text.y = element_text(face="bold", size = 8, angle = 0),
        axis.text.x = element_text(face="bold", size = 8, angle = 0),
        #legend
        legend.position = "none",
        #panels
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey50", size = 0.1),
        panel.grid.major.x = element_blank(),
        plot.margin = unit(c(0,1,0,1), "cm"),
        #strip for label facets
        strip.background =element_rect(fill = NA),
        strip.text = element_text(size = 9,family ="Roboto Black", angle = 0))

ggsave(histograms, file ='~/Desktop/portfolio/oklahoma/scripts/graphs/histogram.png', width=6, height=6)

#Mean box plots
average_year_sentence$timedummy <- ifelse(average_year_sentence$year < "1996-01-01", 0, 1)

statsum <- ggplot(average_year_sentence , aes(x = state, y = sentence_inyears)) +
  stat_summary(geom = "pointrange", size = 1, color = "#e2c240",
               fun.data = "mean_se", fun.args = list(mult = 1.96)) +
  facet_wrap(~timedummy) +
  labs(y = 'Sentence in years',
       x = "State",
       title = 'Average Sentence : Before and After Treatment', 
       subtitle = 'For Missouri and Oklahoma (1990-1999)\n\n',
       caption = 'Data from the Missouri and Oklahoma Department of Corrections. \nDownload : April 2020') +
  theme(text = element_text(family = 'Source Sans Pro'),
        #plot text
        plot.title = element_text(margin = margin(t = 20), face="bold", vjust = 2, family = 'Roboto Black'),
        plot.subtitle = element_text(size = 9,face="bold", family ="Source Sans Pro"),
        plot.caption = element_text(margin = margin(t = 15), hjust = 0, size =8),
        #asix
        axis.title.y = element_text(size = 9,family ="Roboto Black", angle = 90),
        axis.title.x = element_text(size = 9,family ="Roboto Black", angle = 0),
        axis.text.y = element_text(face="bold", size = 8, angle = 0),
        axis.text.x = element_text(face="bold", size = 8, angle = 0),
        #legend
        legend.position = "none",
        #panels
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey50", size = 0.1),
        plot.margin = unit(c(0,1,0,1), "cm"),
        #strip for label facets
        strip.background =element_rect(fill = NA),
        strip.text = element_text(size = 9,family ="Roboto Black", angle = 0))

ggsave(statsum, file ='~/Desktop/portfolio/oklahoma/scripts/graphs/statsum.png', width=6, height=6)



# Tobit for censored data




#No covariates, regular errors for now. 


clean_data <- incarceration %>% 
  group_by(DOCNum, state) %>% 
  filter(yearmonth == min(yearmonth))

clean_data2 <- clean_data %>% 
  filter(!is.na(sentence), sentence > 0) %>% 
  mutate(logsentence = log(sentence),
         statedummy = ifelse(state =="OK",1,0),
         timedummy = ifelse(year == "1996-01-01",1,0)) %>% 
  filter(year >= "1994-01-01" & year <= "1998-01-01")


clean_data2$interaction <- clean_data2$statedummy * clean_data2$timedummy
model_small <- lm(logsentence ~ statedummy + timedummy + interaction,
                  data = clean_data2)


model_big <- lm(logsentence ~ statedummy + timedummy + interaction + sex + race + crimetype,
                data = clean_data2)

library(broom)
tidy(model_small)
tidy(model_big)

library(pixiedust)
library(kableExtra)
library(huxtable)

reg <- huxreg(model_small, model_big, number_format = 2) %>% 
  kable()

reg

#Wild Cluster 

# have to manually make the interaction variable 
library(clusterSEs)
clean_data2$interaction <- clean_data2$statedummy * clean_data2$timedummy
model_wildcluster1 <- glm(logsentence ~ statedummy + timedummy + interaction,
                          data = clean_data2)

wildcluster <- cluster.wild.glm(model_wildcluster1, dat = clean_data2,cluster = ~state, boot.reps = 1000,report = TRUE, prog.bar = TRUE, seed = 2516)













#Appendix

# Look at sentence range : took the log here which is much better -- looks approx normal for Mis, Ok has a fat right tail tho and no left tail . 

ggplot (did_data, aes(x= year, y = log(sentence))) +
  geom_jitter(alpha=0.1) +
  facet_wrap(~ state)

ggplot(incarceration, aes(x= year, y = log(sentence))) +
  geom_jitter(alpha=0.1) +
  facet_wrap(~ state)


ggplot (did_data, aes(x= year, y = sentence)) +
  geom_jitter(alpha=0.1) +
  facet_wrap(~ state)























































