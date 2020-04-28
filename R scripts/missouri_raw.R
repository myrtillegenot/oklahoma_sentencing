# Author: Myrtille Genot
# Code : Thesis Code with MIS_DOC data
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
library('ggrepel')
library('ggtext')
library('gridExtra')
library('grid')
library('ggplot2')
library('lattice')
library('cowplot')
library('wesanderson')


#downloaded date from website : https://doc.mo.gov/media-center/sunshine-law#datafile
# colnames :view-source:https://doc.mo.gov/sites/doc/files/2018-01/sunshine_layout.xml

#main dataset
missouri <- read_fwf(
   file="~/Desktop/portfolio/oklahoma/data/missouri.dat",
   fwf_widths(c(8,18,12,12,3,30,30,8,8,1,20,4,4,4,8,74,1,2,8,8,8,4,2,2,8,3,4,2,2)))

missouri <- missouri %>% 
  rename(DOCNum =1, 
          lastname =2, 
          firstname =3, 
          middlename =4, 
          suffix =5,
          race = 6,
          sex = 7,
          DOB =8,
          facility =9,
          flag =10, 
          cause =11,
          county_offence =12,
          county_sentenced =13,
          NCIC =14,
          statecharge =15,
          desc =16,
          complete_flag = 17,
          con_sec =18,
          sen_date = 19,
          maxrelease = 20,
          minrelease =21,
          senlen =22,
          senlen_mo =23,
          senlen_day =24,
          sen_pro =25,
          prob_type =26,
          problen = 27,
          problen_mo=28,
          problen_day  =29)
             
colnames(missouri)
sapply(missouri, class)



                # CLEAN COLUMNS: 

# (1) DOCNUM: 

#--> fine as character

# (2) Last Name :

#fine as char 
missouri$lastname <- str_to_title(missouri$lastname)


# (3) First Name :

#fine as char 
missouri$firstname <- str_to_title(missouri$firstname)

# (4) Middle Name : 

# fine as char

# (5) Suffix: 

# fine as char

# (6) Race: 

# fine as char

#(7) Sex:

# fine as char

#(8) DOB : 

library(lubridate)
missouri$DOB <- ymd(missouri$DOB)

# (9) facility:

#This is the DOC place name for the offender assigned location.
unique(missouri$facility)

# (10) flag :

#This indicates F for Field or I for Institution
unique(missouri$flag)

# (11) cause : 

#This is the cause/docket number assigned by the Circuit Court. 
#This number identifies the proceedings from which this offender was received, and it is obtained from sentence and judgement paperwork.  
#This field may be blank for interstate compact offenders. 
#Enter the number including dashes and letters as it appears on the sentence and judgement. 
#(Also known as the Docket Number (P&amp;P), Police Report Number for Deferred Prosecution, or Court Case Number (AI))
unique(missouri$cause)

# (12) County_Offence : 

#This is the county in which the offense occured.
#It is the same as the sentencing county unless there has been a change of venue. 
#If it is the same the second entry is unnecessay. 
#The system will default to the sentencing county.
unique(missouri$county_offence)

# (13) County_sen :

#This is the county of the court of record as shown on the court papers.
unique(missouri$county_sentenced)

# (14) NCIC : 

#This is the NCIC code for this offense as found in the National Crime Information Center's Code Manual referenced in the Missouri Charge Code Manual.


# (15) Charge : 

#This will contain the 8-digit code associated with this offense from court papers or the Missouri Charge Code Manual. Felony class may be used to insure the correct match. 
#Positions 1 through 5 are the major category code. Positions 6 and 7 contain the NCIC/State Modifier range. These positions of the MO Code match the last two digits of the NCIC code for the charge. 
#The eighth position may be 0 for Not Applicable, 1 for Attempt, 2 for Accessory or 3 for Conspiracy.

# (16) Desc : 

# Description of crime 
missouri$desc <- str_to_title(missouri$desc)



# (17) Complete Flag: 

#This is the flag which will be set to Y = yes when a sentence is completed

# (18) Con_sec :

#This indicates whether this sentence is being served concurrent/consecutive to another sentence.  
#This relationship of sentences is derived from the sentence and judgement papers. 
#The allowed values are: ' ' - Single Sentence or Primary Sentence, 'CC' - Concurrent, 'CS' - Consecutive

# (19) Sen_date : 

missouri$sen_date <- ymd(missouri$sen_date)

# (20) Max Release : 

#This is the date (YYYYMMDD) of the maximum release/expiration day of this sentence.
#For a life sentence, 99999999 is used. 
#For an indeterminate or interstate sentence, 88888888 is used. 
#For field supervision records of a court-ordered assessment or investigation, 66666666 is used.

# a. 
#Make a variable that stores the category of incarceration : Life, Inc., Prob. added later
missouri$cat_inc <- ifelse(grepl("99999999", missouri$maxrelease), "LIFE", "Incarcerated")
missouri$cat_inc <- ifelse(grepl("88888888", missouri$maxrelease), "Indeterminate", missouri$cat_inc)
missouri$cat_inc <- ifelse(grepl("66666666", missouri$maxrelease), "Investigation", missouri$cat_inc)

# b.
#Now turn to dates 
missouri$maxrelease <- ymd(missouri$maxrelease)

# (21) Min Release:

#This is the date (YYYYMMDD) calculated as the offender's minimum release date on this active sentence.
#For a life sentence, 99999999 is used.  For an indeterminate or interstate sentence, 88888888 is used. 
#For field supervision records of a court-ordered assessment or investigation, 66666666 is used.
missouri$minrelease <- ymd(missouri$minrelease)

# (22) Sentence Length:

#This is the number of whole years for the length of prison sentence fixed by the court in the sentence and judgement papers. 
#Life sentences are entered a 9999. Interstate Compact offenders may have indefinite sentence lengths and should be entered as 8888 for institutional offenders.  
#Interstate Compact Parolees under field supervision may have the actual sentence length entered.  
#For field supervision records of a court-ordered assessment or investigation, this field is not required.
missouri$senlen <- as.numeric(missouri$senlen)

# (23) Sentence Months :

#This is the number of months less than one year for the length of prison sentence fixed by the court in the sentence and judgement papers.
missouri$senlen_mo <- as.numeric(missouri$senlen_mo)

# (24) Sentence Days :

#This is the number of days less than one month for the length of prison sentence fixed by the court in the sentence and judgement papers.
missouri$senlen_day <- as.numeric(missouri$senlen_day)

# (25) Probation Date:

#This is the date (YYYYMMDD) of sentencing derived from the sentence and judgement papers. If the offender has not been sentenced, this is the date of court action
missouri$sen_pro <- ymd(missouri$sen_pro)

# (26) Probation Type : 

#This indicates the type of probation, interstate or other court supervision
unique(missouri$prob_type)

# (27) Probation Length: 

missouri$problen <- as.numeric(missouri$problen)

# (28) Probation Days Months:

missouri$problen_mo <- as.numeric(missouri$problen_mo)

# (29) Probation Days Days:

missouri$problen_day <- as.numeric(missouri$problen_day)


# 30 (State)

missouri$treat <- 0

