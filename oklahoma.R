# Author: Myrtille Genot
# Code : Thesis Code with OK_DOC data
# Date: 18/04/2020



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

#load data 
library("readr")
sentence <- read_fwf(
  file="~/Desktop/portfolio/oklahoma/data/sentence.dat",
  fwf_widths(c(11, 40, 40, 9, 40, 10, 10))) %>% 
  rename( DOCNum =1, 
          statute =2, 
          court =3,
          cv_date =4, 
          crfnum =5,
          inc_years =6,
          prob_years =7)


profile <- read_fwf(
  file="~/Desktop/portfolio/oklahoma/data/profile.dat",
  fwf_widths(c(11,30,30,30,5,9,40,9,1,40,40,2,2,4,40,10))) %>% 
  rename( DOCNum =1, 
          lastname =2, 
          firstname =3,
          middlename =4, 
          suffix =5,
          last_move =6,
          facility =7,
          dob =8,
          sex=9,
          race=10,
          hair=11,
          height_ft=12,
          height_in=13,
          weight=14,
          eye=15,
          status=16)

# Merge 1
raw_dat <- merge(sentence, profile, by="DOCNum") %>% 
  select(1,8,9,3,13,22,4,6,7,2,14,15,16)

# Add offence 

offence <- read_fwf(
  file="~/Desktop/portfolio/oklahoma/data/offence.dat",
  fwf_widths(c(38,40,1))) %>% 
  rename( statute =1, 
          desc =2, 
          violent =3)

alias <- read_fwf(
  file="~/Desktop/portfolio/oklahoma/data/alias.dat",
  fwf_widths(c(11,30,30,30,5))) %>% 
  rename( DOCNum =1, 
          lastname =2, 
          firstname =3,
          suffix=4)

# Merge 2
rawdat2 <- merge(raw_dat, offence, by="statute")

# Look at variable formats
sapply(rawdat2, class)




               # Clean each column :




# (1) Statute :

# Oklahoma law - county court judges must follow the sentencing guidelines stipulated. 
rawdat2$statute <- paste("§",rawdat2$statute,sep = "") 

# (2) DOCNum :

# ID for each prisoner 

# (3) Last Name :

rawdat2$lastname <- str_to_title(rawdat2$lastname)

# (4) First Name :

rawdat2$firstname <- str_to_title(rawdat2$firstname)

# (5) Court :

rawdat2$court <- str_to_title(as.character(rawdat2$court))

# Get county extract
rawdat2$county <- str_extract(rawdat2$court , ".*Court") %>% 
  str_replace_all("Court","") %>% 
  trimws()

# Define level for each court
rawdat2$court_state <- ifelse(grepl("Jurisdiction",rawdat2$court), "Out_of_state", "In_state")
rawdat2$court_state <- ifelse(grepl("District Office",rawdat2$court), "In_state", rawdat2$court_state )
rawdat2$court_state <- ifelse(grepl("United States Jurisdiction", rawdat2$court), "Federal", rawdat2$court_state)

# Scrape County List for population : US Census, 2019
scrape_county <- as.data.frame(read_html("https://www.oklahoma-demographics.com/counties_by_population") %>% 
                                 html_table()) %>% 
  slice(-78L) %>% 
  select(-1) %>% 
  rename(county=1, population=2)


# Get same format for county (upper, trimws)
scrape_county$county <- trimws(scrape_county$county)

# Scrape District levels for County Courts
scrape_district <- read_html("https://ballotpedia.org/Oklahoma_District_Courts", as.data.frame=T) %>% 
  html_table(fill=T) %>% 
  .[[2]] %>% 
  slice(-1L,-2L) %>% 
  select(1,2) %>% 
  rename( district=1, county=2)

# Spread rows --> note: wish I could have used separate_rows() here
district <- scrape_district %>% 
  mutate(county = strsplit(as.character(county),",| and")) %>% 
  unnest(county)

# Apply matching format (upper, trimws)
district$county <- paste(district$county,"County") %>% trimws()

# County, District, Population
county_district <- merge(scrape_county, district, by="county")

# Merge into main dataset

rawdat3 <- merge(rawdat2, county_district, by="county", all.x=T)

# (6) Facility :

#only correct as per the last conviction & if currently still serving time, not their first. 
rawdat3$facility <- str_to_title(rawdat3$facility)

# (7) Status :

unique(rawdat3$status)

# (8) Conviction Date : --> NOT CORRECT / use a regex based function to extract the three pieces and make a new date format
rawdat3$cv_date <- parse_date_time2(rawdat3$cv_date, "%d-%B-%y", cutoff_2000 =20L)


# (9) Sentence Incarceration 
rawdat3$sentence <- as.numeric(rawdat3$inc_years) * 365
rawdat3$code <- ifelse(rawdat3$sentence %in% c(0, NA), "Probation", "Incarceration")

rawdat3$code <- ifelse(rawdat3$sentence %in% c(3649635), "Death", rawdat3$code)

rawdat3$code <- ifelse(rawdat3$sentence %in% c(3244120), "Life w/o Parole", rawdat3$code)

rawdat3$code <- ifelse(rawdat3$sentence %in% c(2838605), "Life", rawdat3$code)

# (10) Sentence Probation

rawdat3$probation <- as.numeric(rawdat3$prob_years) * 365
rawdat3$code <- ifelse(rawdat3$probation %in% c(0, NA) & rawdat3$sentence %in% c(0, NA), "Suspended", rawdat3$code)


# (11) DOB :

rawdat3$dob <- parse_date_time2(rawdat3$dob, "%d-%B-%y", cutoff_2000 =05L)

# (12) Sex : 

unique(rawdat3$sex)

# (13) Race : M - Mexican and N - Negro?

unique(rawdat3$race)
rawdat3$race <- str_to_title(rawdat3$race)

n <- rawdat3 %>% group_by(race) %>% count()
n <- rawdat3 %>% group_by(sex) %>% count()

# (14) OFFENCE DESC :

rawdat3$desc <- str_to_title(rawdat3$desc)

#make broader categories -- data on statutes available at Justia website. 

rawdat3$agg_desc <- "Other"
rawdat3$agg_desc <- ifelse(grepl("§21", rawdat3$statute), "Criminal", rawdat3$agg_desc )
rawdat3$agg_desc <- ifelse(grepl("§63", rawdat3$statute), "Drugs", rawdat3$agg_desc )
rawdat3$agg_desc <- ifelse(grepl("§47", rawdat3$statute), "Motor-Vehicle", rawdat3$agg_desc )
rawdat3$agg_desc <- ifelse(grepl("§68", rawdat3$statute), "Embezzlement", rawdat3$agg_desc )
rawdat3$agg_desc <- ifelse(grepl("§30", rawdat3$statute), "Hunting", rawdat3$agg_desc )

unique(rawdat3$agg_desc)
                # Start exploring

#make relevant subset
explore <- rawdat3 %>% 
  select(DOCNum, status, firstname, lastname, cv_date, court, code, statute, agg_desc, sentence, probation, desc, violent, county, district, court_state, population, sex, race, dob) %>% 
  mutate_at(vars(cv_date), funs(year, month, day)) %>% 
  distinct()

explore$year <- lubridate::ymd(explore$year, truncated = 2L)


topcrime_year <- explore %>%
  filter(1969 < year) %>% 
  group_by(year) %>% 
  count(statute,desc) %>% 
  mutate(tot_offence = sum(n), perc = (n/tot_offence)*100) %>% 
  slice(which.max(n))

library('ggrepel')
library('ggtext')



# Plot 1 : Leave this for now 

# Fix colours, legend, add key for size of circle, increase distance for title, 
# blod axis ticks, bold title, clean axis lines and annotate 2020

ggplot(data = topcrime_year, aes(x=year, y=n, size=perc, color=desc)) +
  geom_point(alpha=0.2) + 
  guides(size = FALSE) +
  scale_size(range = c(.1, 23))  + 
  scale_fill_manual(values= wes_palette(name = "BottleRocket1"), aesthetics = "colour") +
  coord_cartesian(clip = "off") +
  scale_y_continuous(expand = c(0, 0), limits = c(20, 12000), breaks = c(25, seq(2000, 12000, 1000)), labels = c(25, seq(2000, 12000, 1000))) +
  labs(y = 'Count of offence',
       title = 'Top Offences in Oklahoma', 
       subtitle = 'Count of offence, by incidence rate in that year', 
       caption = 'Data from the Oklahoma Department of Corrections. \nDownload : April 2020') +
  theme(text = element_text(family = 'Source Sans Pro'),
        plot.title = element_text(margin = margin(t = 15),face="bold"),
        plot.subtitle = element_text(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.margin = unit(c(1,1,1,1),"cm"), 
        legend.position = "bottom",
        legend.key = element_blank(),
        legend.title = element_blank(),
        legend.background = element_rect(fill=alpha(0.4)),
        axis.line.x = element_blank(), axis.ticks.x = element_blank(),
        axis.line.y = element_line(colour="grey40", size = 0.3), axis.ticks.y = element_blank(),
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey50", size = 0.1),
        panel.grid.major.x = element_blank(),
        panel.border=element_blank(), 
        axis.line = element_line())

ggplot(data = topcrime_year, aes(x=year, y=n, size=perc, color=desc)) +
  geom_point(alpha=0.2) + 
  guides(size = FALSE) +
  scale_size(range = c(.1, 23))  + 
  scale_fill_manual(values= wes_palette(name = "BottleRocket1"), aesthetics = "colour") +
  coord_cartesian(clip = "off") +
  scale_x_date(expand =c(0,0), limits = c(min, max), date_labels="%Y", date_breaks = "5 years")+
  scale_y_continuous(expand = c(0, 0), limits = c(20, 12000), breaks = c(25, seq(2000, 12000, 1000)), labels = c(25, seq(2000, 12000, 1000))) +
  labs(y = 'Count of offence',
       title = 'Top Offences in Oklahoma', 
       subtitle = 'Count of offence, by incidence rate in that year', 
       caption = 'Data from the Oklahoma Department of Corrections. \nDownload : April 2020') +
  theme(text = element_text(family = 'Source Sans Pro'),
        #plot text
        plot.title = element_text(margin = margin(t = 20), face="bold", vjust = 2, family = 'Roboto Black'),
        plot.subtitle = element_text(size = 9,face="bold", family ="Source Sans Pro"),
        plot.caption = element_text(margin = margin(t = 15), hjust = 0),
        #asix
        axis.title.y = element_text(size = 9,family ="Roboto Black"),
        axis.title.x = element_text(size = 9,family ="Roboto Black"),
        axis.text.y = element_text(face="bold", size = 8),
        axis.text.x = element_text(size =5, angle = 90), axis.line.x = element_line(colour = "grey40", size = 0.3), 
        axis.ticks = element_blank(),
        #legend
        legend.title = element_blank(), legend.text = element_text(size = 6),
        legend.key.size = unit(.6, 'cm'), legend.position = "bottom", 
        legend.background = element_rect(colour ="white", fill=alpha(0.4)),
        #panels
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey50", size = 0.1),
        panel.grid.major.x = element_blank())

  
# Plot 2: Offence Count per year, men vs. women

gender_crime <- explore %>% 
  group_by(year, sex, agg_desc) %>% 
  count() %>% 
  group_by(sex,year) %>% 
  mutate( tot_off = sum(n)) %>% 
  mutate( bar = ifelse(sex == "F", -1*n, n)) 

min <- as.Date("1970-01-01")
max <- as.Date("2020-01-01")

ggplot(gender_crime, aes(fill=agg_desc, y=bar, x=year)) + 
  geom_bar(position="stack", stat="identity", alpha =0.9) +
  scale_fill_manual(values= wes_palette(name = "Zissou1"), aesthetics = "fill") +
  scale_x_date(expand =c(0,0), limits = c(min, max), date_labels="%Y", date_breaks  ="2 years") +
  scale_y_continuous(limits = c(-12000, 45000), 
                     breaks = c(-12000, -9000, -6000, -3000, seq(0,45000, 3000)),
                     labels = c(12000, 9000, 6000, 3000, seq(0,45000, 3000))) +
  labs(title = "Gendered Yearly Offences",
       subtitle ="Yearly evolution of male vs. female offences.\nLetsnfr\n\n",
       y= "Offence Counts",
       x= "",
       caption = 'Data from the Oklahoma Department of Corrections.\nDownload : April 2020') +
  annotate("text", y = -11500, x = as.Date("1973-06-01"), label = "Women", family="Roboto Black", size = 3) +
  annotate("text", y = 45000, x = as.Date("1972-08-01"), label = "Men", family="Roboto Black", size = 3) +
  theme(text = element_text(family = 'Source Sans Pro'),
        #plot text
        plot.title = element_text(margin = margin(t = 20), face="bold", vjust = 2, family = 'Roboto Black'),
        plot.subtitle = element_text(size = 9,face="bold", family ="Source Sans Pro"),
        plot.caption = element_text(margin = margin(t = 15), hjust = 0),
        #asix
        axis.title.y = element_text(angle = 0 , size = 7, margin = margin(t = 0, r = -15 , b = 0, l = 0), family ="Roboto Black"),
        axis.text.y = element_text(face="bold", size = 8),
        axis.text.x = element_text(size =5, angle = 90), axis.line.x = element_line(colour = "grey40", size = 0.3), 
        axis.ticks = element_blank(),
        #legend
        legend.title = element_blank(), legend.text = element_text(size = 6),
        legend.key.size = unit(.4, 'cm'), legend.position = "right", 
        legend.background = element_rect(fill=alpha(0.4)),
        #panels
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey50", size = 0.1),
        panel.grid.major.y = element_blank())+
  geom_hline(yintercept = 0, colour="white", size =0.5)






 