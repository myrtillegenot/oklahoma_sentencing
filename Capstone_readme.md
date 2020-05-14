# In Whose Interest : Private Prisons and Sentencing Lengths 

#### Capstone Project by Myrtille Génot, for the MSc in Applied Economics at the University of San Francisco. 



##### Motivation 

***

Profit and prisons have a long history. Although the13th Amendment **abolished involutary servitutude**, a loophole exempted prisoners from such protection.

> **Amendment XII**
>
> Neither slavery nor  involuntary servitude, except as a punishment for crime whereof the  party shall have been duly convicted, shall exist within the United  States, or any place subject to their jurisdiction.

This led to a quick expansion of prison populations, especially in the South, and especially of African-Americans.

**Photo 1** *Juvenile Convicts at work in the fields, Detroit, 1903*

<img align="center" src="/photos/juvenileconvicts.jpg">

Following conviction, most prisoners were sent to prison camps and **leased to private companies as cheap labour**. This was a violent system that led to widespread abuse and death. States disallowed private convict leasing in the 1920s due to complaints of unfair competition from businesses that paid market rates for their labour, and the polemical death of a young Caucasian man, **Martin Talbert**.

**Photo 2** *Martin Talbert*

<img align="left" src="/photos/martintalbert.jpg"  height="300" width="350"/>

**Martin Talbert**, arrested in 1922 for riding a train without a ticket and failing to pay the subsequent 25$ fine, was leased to Putnam Lumber Yard in Dixie County Florida where he was **flogged to death** by prison guard Thomas Higginbotham.

**Talbert’s $25 fine had actually been paid** by his family, which had rushed the money upon hearing of his arrest. However, it was widely known that **Sheriff J. R. Jones touched a ‘$20 head fee for each able bodied man he turned to the lumber company.’** Had he processed the fine, he would have lost Talbert’s head fee.

Disbanding prison camps was difficult as they were protected by the wealthy and well connected. For example, **Knabb Turpentine** in nearby Baker county, described by a contemporary prison supervisor as a **"human slaughter pen"** was owned by **State Senator Knabb** (fourth from the left).

put in conclu // Prize winning work from economists like XX have shown that these sort of institutional outcomes have long shadows.One of his descendents, Todd Knabb is now a the county sheriff at the local county jail.  *source : Baker County Press*

<img align="center" src="/photos/senatorknabb.jpg">

##### Theoretically, this points to a clear issue : when there is financial gain to be made from incarceration, sub-optimal outcomes occur as a result of incentive distortions in the justice system. 

##### *So why are profits back in the prison system?*

Well, just because **convict leasing had been outlawed for private companies,the practice of using inmates as labour didn't stop**. In fact, many states continued to use their inmate populations as a form of cheap labour for themselves. Notably, Southern states re-purposed former plantation land to 'prison farms', some of which are still in existence today.  

Prison farms broached the path to modern prison privatisation through one man : **T. Don Hutto**. 

T. Don Hutto worked as a warden at the Ramsey Prison Farm for African-Americans in Southeastern Texas in the 1960s. Hutto had a 'knack' for running prisons, and for running them cheap. In fact, he was so successful he eventually became the director of Corrections for the state of Arkansas, and then Virginia through the 70s. In 1983, along with two other co-founders, he created the first private prison company : Corrections Corporation of America (since rebranded as CoreCivic, following several lawsuits.)

**Photo 3** *CoreCivic Founders, featuring a snapshot of their political connections*

<img align="center" src="/photos/ccafounders.jpg">



##### Research Question 

***

##### Ideally: 

>  ##### Does the introduction of private prisons lead to distortions in the justice system? Specifically, does the use of private prisons have an effect on criminal justice outcomes?

Given time and data constraints, answering such a broad, sweeping question is beyond the scope of this project. However, I can use econometric methods to answer a narrower, but adjacent, question. 



##### My question:

> ##### Did the introduction of private prisons in Oklahoma have an effect on sentencing lengths?



*Why this question?*

Private prisons are used at both the federal and state level. While detailed sentencing data at the federal level is available through the United States Sentencing Commission, my identification strategy (as detailed below) is not consistent with this data. 

Indeed, my problem is essentially one of *causal inference*. How can I make sure that any changes in sentencing are due to the introduction of private prisons, and not the result of any other miscellaneous factors?

As is the case for many social science questions, it is impossible to use **experimental methods** to answer my research question. In the *ideal scenario*, I could go back in time, duplicate the entire country so I have two identical versions of it and introduce private prisons in one version and not in the other ( in general terms, assign *treatment* to one and not the other). Holding all else equal, I could look at resulting outcome in my **treated** U.S.A versus my **control** U.S.A. and attribute any resulting differences to the use of private prisons. 

Obviously, in the real world, having access to this **counterfactual** world is impossible. 

Luckily, the impossibility of time travel and alternate dimension creation does not stop the zealous social scientist. Using **quasi-experimental** methods, it is possible to come to useful insights into these complex questions. 



##### III. Methodology

***



To isolate the effects of the introduction of private prisons, I will be using a **Differences-in-Differences approach**. This identification strategy is the most popular in Econometrics, due to its intuitive conceptual nature and relatively straightforward implementation. However, it is important to note that there are a whole host of issues to be aware of when using this framework, which will be discussed later in this analysis. 



* **What is a Differences-in-Differences framework?**

  A differences-in-differences (hitherto, **DiD**) approach needs :

  > (**1**)  *a natural experiment*. Natural experiments are events that occured in real life, that affect an outcome of interest (known as our **Y** variable) and thus mimic assignment to treatment. We can conveniently use these natural experiments for our econometric analysis (for example, the passage of a specific state law). 

  As well as,

  > (**2**)  *the existence of two groups*, one Treated (**T**)  (as a reulst of the event from our natural experiment) and one that is a Control group (**C**).  So, using the passage of a law, we could look at two states and compare the differences in the outcome of interest in the state with the law and the one without. 

  and finally;

  > (3) *two time periods*, one before our event (**Time = 0**) and one after (**Time =1**) for both groups. 

  When looking at this, one can see how it ressembles the ideal experiment described above. We have two groups, one treated and one untreated, and measures of the (average of the) outcome of interest **(Y)** at different time points. 

  It is common to illustrate this in a table : 

  

  |                       | Time = 0                               | Time = 1                                    | Difference                                            |
  | --------------------- | -------------------------------------- | ------------------------------------------- | ----------------------------------------------------- |
  | **Treated Group (1)** | E(Y\|G = T, T=0)                       | E(Y\|G = T, T=1)                            | **Diff 1** : change in outcome for  group T over time |
  | **Control Group (0)** | E(Y\|G = C, T=0)                       | E(Y\|G = C, T=1)                            | **Diff 2** : change in outcome for  group C over time |
  |                       | Baseline diff in **T** vs **C** groups | Post-treatment diff in **T** vs **C** group |                                                       |

  

  Our estimate of the impact of the treatment ( in ~technical~ terms the Average Treatment Effect on the Treated - the **ATT**) is thus the difference between **Diff 1** and **Diff 2**, or:

  

  

  

  This can be calculated using the simple mean differences above, but of course, a more precise way to calculate this impact is through **regression**, which permits us to control for other variables which we think may affect our estimate ( as well as conduct hypothesis testing, which in this case will be difficult. More on this below).

  The simplest specification is thus: 

  
  $$
  Y = \mathbf{B}_0 + \mathbf{B}_1  T + \mathbf{B}_2 G +  \mathbf{B}_3 T \times\ G +  \mathbf{B}_4 X + \mathbf{e}
  $$
  

  where T is a dummy variable = 1 post-treatment, and G is a dummy = 1 for treated group. The interaction term T x G indicates treated years for the treated and X are the relevant covariates.

  

  Now that the basics are out of the way, how exactly will I be using this framework to answer my research question?

  

  <img align="center" src="/photos/lawchange.jpg">

  

  In November of 1995,  the state of Oklahoma enacted Title 57 § 561, "regarding authority to provide incarceration, supervision, and residential treatment at facilities not operated by the Department of Corrections". This is my natural experiment. 

  In the following year, Oklahoma began to contract private prisons beds for several hundred convicted felons. However, the neighbouring state, Missouri, did not. These are my treatment and control groups. 

  > To recap : I will be using the enactment of Oklahoma Title 57 as 'treatment' for my two groups, Oklahoma and Missouri. My two time periods are 1995 and 1996. Although the law got passed in 1995, the first beds were not contracted until very late in the year, so essentially, through 1996. I posit that the introduction of private prisons in Oklahoma will have an effect on my outcome variable of choice: sentencing lengths.

  

  ##### IV. Theory 

  ***

  

  Why **sentencing lengths**?

  To understand why I chose this, I will walk through my reasoning and summarise the relevant academic literature. 

  

  When one is arrested, they are put in jail awaiting trial. In trial, the jury decides if they are guilty or innocent. Once the jury has decided guilt, the judge sentences. **Sentencing decisions are, in large part, up to the discretion of the judge**. At the federal level, there exists sentencing guidelines which set suggested minimum and maximum sentences per crimetype, to decrease variance in punishment level for the same crime across courts. At the state level, there also exists similar guidelines. However,  these are not set in stone. The judge gets the final say, and can override these guidelines if they see fit to do so. Once sentenced, inmates are sent to a holding facility, where DOC officials decide what prison they will be sent to based on various attributes (severity of crime, gang affiliation etc. )

  

  To maximise societal outcome, it would be best for judges to sentence each inmate at the lowest possible point that they believe will lead to improved outcomes  (either through ~~reform~~, or simply distancing that inmate from society). This is a tough exercise : judges must weight the benefits versus cost of incarceration time for each inmate. **Picking a length closest to what they believe is a fair sentence is efficient** as it means that no inmate is held for a longer period than they need to be, (thereby minimising the life loss of being behind bars) as well as the literal cost of incarcerating them which is publicly paid for. Given this, state prisons are merely means to an end as they arguably hold no contesting incentives to this process*(except small towns whose economic livelihood depend on state prisons).

  

  However, private prisons are for-profit institutions. They wish to maximise income, which can only be done by keeping incarceration levels high. One of the ways to keep incarceration levels high is by sentencing more people, aggregate. Another, less straightforward **way to keep prison propulations high, is by  sentencing people to longer terms**. Indeed, research indicates that if sentencing lengths were to decrease by a month, it would lead to a reduction in incarceration of up to 50,000 inmates. 

  It is also arguable that, as a profit-maximising firm, private prisons would prefer to hold one same inmate for longer than cycle new ones in and out. Indeed, there are high costs associated with transferring inmates into a facility, as this requires extensive staffing attention. However, as has been analyzed in both academic and popular news, private prisons main cost-cutting comes from suppressing prison staff. Thus, **private prisons stand to gain the most from the same inmate being convicted for a longer amount of time.**

  

  The posited links between private prisons and increased sentencing lengths are thus as follow:

  

  1. **The private prison industry influences judges decisions through the use of lobbying and/or campaign contributions [read:corruption].**

     ***

     Is this channel possible? Well, there is evidence to say that private prisons do not shy from using bribes as a means of filling up their beds. Other methods would include lobbying, or other political pressure. 

     

  *or*, 

  

  2. **As a result of judges internalising minimized stress on the penal system and adjusting sentences accordingly.**

     ***

     Is this channel possible? Given current mass incarceration levels, financial costs associated with incarcerationare enormous and have been stretching correctional systems thin. In fact, some states are considering making the cost of incarceration known to the judge as they make sentencing decisions. In theory, private prisons are mandated to run at a lower price point than state prisons. Judges may take these lower costs into consideration, and punish more extensively as the marginal cost of doing so is lessened. However, determining whether or not private prisons **actually** costs less than state facilities is a formidable accounting exercise, and so far, there is no good evidence to say that they do. That being said, it is possible that once judges are aware that prisons *beds* are available, they do not punish as fastidiously as when they are aware there are facilities to house the inmate in front of them (in fact, most state prisons suffer from severe over-crowding and operate at over 100% capacity). So potential mechanisms here are both from (alleged) lesser costs to the state, or increased physical detention capacities. 

  

  Economic literature on this topic is scarce. In fact, the amount of  papers which discuss private prisons using empirical techniques can be counted on one hand, and have all been published within the last few years. This notwithstanding, the literature seems to come to a concensus that the introduction of private prisons does indeed lead to distorted outcomes. 

  

  <img align="center" src="/photos/literature.jpg">

  

  These studies show that there is some credence in saying that judge decision making is not uniquely a  factor of justice, and that private prisons do have some perverse effect in the criminal justice system. To circle back to our analysis: 

  

  ##### V. Data 

  ***

  

  Data for both states are made publicly available on their respective Department of Correction websites. 

  Oklahoma data can be found in fixed-width format [here](http://doc.ok.gov/odoc-public-inmate-data), and Missouri data (also in fwf) [here](https://doc.mo.gov/media-center/sunshine-law). 

  

  Both datasets are at a granular level, with rich information concerning sentencing decisions for all inmates spanning several decades. Data was cleaned through the scripts folder, available in this repo, and was complemented using some light web-scraping for any relevant information they did not have (such as population data per county etc.)

  It is important to note that both datasets suffer from light inconsistencies (especially Oklahoman data), which should not affect this subsequent analysis, but it cannot be ruled out entirely. 

  

  The first thing I wanted to do was understand my data : 

  

  

  

  

  

  

  

  

  

  

  

  

  

  

  

  















