# Oklahoma Capstone Project
Data/scripts &amp; snippets of analysis for thesis project. 

* *This contains the scripts as well as introductory insights to my final capstone project  as part of the curriculum for the Masters in Applied Economics at the University of San Francisco.* *

* *This section goes over my introduction. To go straight to the data cleaning script, please open Oklahoma.R above. The script is heavily annotated and designed to be shared with non-R users (Stata), so made to be as simple as possible* *

## In Whose Interest : Private Prisons & Sentencing Lengths

Prisons are ill-defined. Are they meant to rehabilitate? Are they meant to punish? Can both these purposes co-exist? These important questions have often been swept under the rug in favour of 'protecting the public' from criminals. This mindset has some serious negative externalities. The first, and most obvious, is economic. Housing, feeding, clothing, supervising and disciplining any human being is an onerous activity. The second is the cost of the thousands of lives which are siphoned into this system. By all accounts, the prison system disproportionately punishes African-Americans. This is not an artefact of differing rates of criminality, but is indeed by design. Undeniably, the American prison system is a direct legacy of slavery. 

  These two concerns crystallize in a specific segment of the correctional landscape : the private prison corporation. 
  
  The history of profit in American prisons is a long and complex one (Jewkes, 2007). These institutions continue to play an important role in modern times, making up roughly 23% of all state and federal institutions (Kirchoff, 2010). Despite this, they have received considerably little empirical scholarship. This is surprising. Being for-profit institutions, private prisons financially benefit from high incarceration rates. On the other hand, wider social utility is maximised when incarceration is as low as possible, as every marginal inmate incurs a non-trivial cost on the public purse. This introduces contesting incentives into the prison system.
  
  This essay aims to examine these differing incentives through the specific lens of sentencing lenghts. Although sentencing lengths are often not served in their entirety, they play a critical role in keeping prison population high. Indeed, research indicates that decreasing sentencing by a month would lead to a reduction of incarceration by up to 50,000 inmates (Kirchoff, 2010). To do so, Department of Corrections (henceforth : DOC) data from both Oklahoma - whose prison systems heavily depends on private prisons - and Missouri, a neighbouring state which does not, will be used. Both are publicly available, at [http://doc.ok.gov/odoc-public-inmate-data] and [https://doc.mo.gov/media-center/sunshine-law#datafile]. 
  
  Stated explicitly, this research aims to see if the introduction of private prisons led to an increase in average time sentenced per inmate. A "difference-in-difference" regression - a popular causal inference method in econometric research - will be used to do so. Given correct specification (notably, the parallel trends assumption, careful adjustments of standard errors and domain knowledge regarding treatment), results from the regression can be used to estimate the effect of private prisons on sentencing in Oklahoma. 
  
   
 * *Below I quickly outline my data gathering and cleaning process* *
  
### Data Cleaning

  The Oklahoma data is uploaded as a series of fixed-width files. These were opened given their stipulated lengths. Four datasets were provided :one with personal information for each inmate ( as per their DOCNum), one with the associated sentencing details for each DOCNum, as well as a list of Oklahoma statutes needed to understand the nature of their crimes and aliases for each inmate. Overall, the data was rich in details but sadly suffered from some grave inconsistencies (some inmates sentenced before the date of birth etc.) 
  
  As I am still in the process of finalising the analysis for my project, here I show only the outputs from two graphs made from the Oklahoma data. These were made to better understand the evolution of offences and inmates in Oklahoma, and strenghten domain knowledge for the subsequent statistical analysis. 
  
  I made this first figure to try and capture several insights from the data at once. In one plot, I could see the geenral trend for incarceration, across genders and specified by type of offence. 
 
**Figure 1**

```
plot1 <- ggplot(data = topcrime_year, aes(x=year, y=n, size=perc, fill=clean_desc)) +
  geom_point(alpha=0.35, shape =21, color ="grey40") + 
  
  # scales
  
  guides(fill = guide_legend(override.aes = list(size = 4))) +
  scale_size(range = c(.1, 15), limits = c(5,25), labels =c("5%", "10%","15%","20%","25%")) +
  scale_fill_manual(values= wes_palette(name = "Darjeeling1"), aesthetics = "fill") +
  scale_x_date(expand = c(0, 0), limits=c(min1,max1), date_labels="%Y", date_breaks  ="7 years") +
  scale_y_continuous(expand = c(0, 0), limits = c(20, 13000), breaks = c(20, seq(2000, 13000, 1000)), labels = c(20, seq(2000, 13000, 1000))) +
  
  #allow roomm 
  
  coord_cartesian(clip = "off") +
  
  #titles
  
  labs(y = 'Count of offence',
       title = 'Top Offences in Oklahoma', 
       subtitle = 'Count of offence, by incidence rate in that year\n\n', 
       caption = 'Data from the Oklahoma Department of Corrections. \nDownload : April 2020') +
       
   # custom theme 
   
  theme(text = element_text(family = 'Source Sans Pro'),
  
        #plot text
        
        plot.title = element_text(margin = margin(t = 20), face="bold", vjust = 2, family = 'Roboto Black'),
        plot.subtitle = element_text(size = 9,face="bold", family ="Source Sans Pro"),
        plot.caption = element_text(margin = margin(t = 15), hjust = 0, size =8),
        
        #axis
        
        axis.title.y = element_text(size = 9,family ="Roboto Black", angle =90, vjust = 5),
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
        plot.margin = unit(c(1,1,1,1), "cm"))
```

![png](/graphs/plot_2.png)


  I wanted to further explore the types of offences committed. To do this, I counted total offence numbers grouped by year and type. I retained the top offence, and tried to represent it in a way that would show * *how* popular an offence was across years, and within year. As such, this graph is colour coded by crime type and area coded by % of offence it accounts for that year. 
  

**Figure 2**
 
 
This led me to thinking about which crimes were the most popular per year. I thus created this graph, which looks at what offence was the most 'popular' per year, and the percentage it played relative to total offence for that year. 

```
plot2 <- ggplot(gender_crime, aes(fill=agg_desc, y=bar, x=year)) + 
  geom_bar(position="stack", stat="identity", alpha =0.9) +
  
  # scale
  
  scale_fill_manual(values= wes_palette(name = "Zissou1"), aesthetics = "fill") +
  scale_x_date(expand =c(0,0), limits = c(min, max), date_labels="%Y", date_breaks  ="2 years") +
  scale_y_continuous(limits = c(-12000, 45000), 
                     breaks = c(-12000, -9000, -6000, -3000, seq(0,45000, 3000)),
                     labels = c(12000, 9000, 6000, 3000, seq(0,45000, 3000))) +
                     
  #titles
  
  labs(title = "Gendered Yearly Offences",
       subtitle ="Yearly evolution of male vs. female offences.\n\n\n",
       y= "Offence Counts",
       x= "",
       caption = 'Data from the Oklahoma Department of Corrections.\nDownload : April 2020') +
       
   #annotate 
   
   
  annotate("text", y = -11500, x = as.Date("1973-03-01"), label = "Women", family="Roboto Black", size = 3) +
  annotate("text", y = 45000, x = as.Date("1972-08-01"), label = "Men", family="Roboto Black", size = 3) +
  
  #custom theme
  #font
  
  theme(text = element_text(family = 'Source Sans Pro'),
  
        #plot text
        
        plot.title = element_text(margin = margin(t = 20), face="bold", vjust = 2, family = 'Roboto Black'),
        plot.subtitle = element_text(size = 9, family ="Source Sans Pro"),
        plot.caption = element_text(margin = margin(t = 15), hjust = 0, size =9),
        
        #axis
        
        axis.title.y = element_text(angle = 0 , size = 7, margin = margin(t = 0, r = -20 , b = 0, l = 0), 
        family ="Roboto Black"),
        axis.text.y = element_text(face="bold", size = 8),
        axis.text.x = element_text(size =5, angle = 90), axis.line.x = element_line(colour = "grey40", size = 0.3), 
        axis.ticks = element_blank(),
        
        #legend
        
        legend.title = element_blank(), legend.text = element_text(size = 6),
        legend.key.size = unit(.4, 'cm'), legend.position = "bottom", 
        legend.background = element_rect(fill=alpha(0.4)),
        
        #panels
        
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey50", size = 0.1),
        panel.grid.major.y = element_blank())+
        
        
  geom_hline(yintercept = 0, colour="white", size =0.5)
```
![png](/graphs/plot_1.png)

 Two things emerged from this graph. 

1. The origin of the explosion in US penal population is still contested. A widely circulated narrative is this began due to increasignly harsh crackdowns on drug offences during the 'War on Drugs' era. Several prominent intellectuals have championed this idea, most prominently Angela Davis in her book " Are prisons obsolete?". However, others have proposed that this is not the case. Notably, the book "Locked In: The True Causes of Mass Incarceration and How to Achieve Real Reform" by Fordham University criminal justice expert John Pfaff suggests that mass increases in penal population were due to an increase in violent offences. *Want to add : look at offence per inmate & see if corr between violent offence and drug offence*

2. Although offence counts increased dramatically over the years, the ratio held of top offence:all offence stayed * *relatively* constant. This seems to suggest that the diversity of crime has remained more or less the same over the years. This to me perhaps suggests that -behaviourally- crime has stayed the same, but what people are being arrested for over time changes. *Need to think more about this*


### Econometric Analysis

Due to some data difficulties, this section is being reworked. Results added shortly (latest May 7th.)

