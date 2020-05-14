# In Whose Interest : Private Prisons and Sentencing Lengths 

#### Capstone Project by Myrtille Génot, for the MSc in Applied Economics at the University of San Francisco. 





#### Motivation 

***



<img align="center" src="/photos/juvenileconvicts.jpg">

 *Juvenile Convicts at work in the fields, Detroit, 1903*

Profit and prisons have a long history. Although the13th Amendment abolished involutary servitutude, a loophole exempted prisoners from such protection.





> **Amendment XII**
>
> Neither slavery nor  involuntary servitude, except as a punishment for crime whereof the  party shall have been duly convicted, shall exist within the United  States, or any place subject to their jurisdiction.





This led to a quick expansion of prison populations, especially in the South, and especially of African-Americans.

Following conviction, most prisoners were sent to prison camps and leased to private companies as cheap labour. This was a violent system that led to widespread abuse and death. States disallowed private convict leasing in the 1920s due to complaints of unfair competition from businesses that paid market rates for their labour, and the polemical death of a young Caucasian man, Martin Talbert.



<img align="left" src="/photos/martintalbert.jpg"  height="300" width="350"/>

Martin Talbert, arrested in 1922 for riding a train without a ticket and failing to pay the subsequent 25$ fine, was leased to Putnam Lumber Yard in Dixie County Florida where he was flogged to death by prison guard Thomas Higginbotham.

Talbert’s $25 fine had actually been paid by his family, which had rushed the money upon hearing of his arrest. However, it was widely known that *Sheriff J. R. Jones touched a ‘$20 head fee for each able bodied man he turned to the lumber company.’* Had he processed the fine, he would have lost Talbert’s head fee.



Disbanding prison camps was difficult as they were protected by the wealthy and well connected. For example, Knabb Turpentine in nearby Baker county, described by a contemporary prison supervisor as a *"human slaughter pen"* was owned by State Senator Knabb (fifth from the left).

<img align="center" src="/photos/senatorknabb.jpg">

**Theoretically, this points to a clear issue : when there is financial gain to be made from incarceration, sub-optimal outcomes occur as a result of incentive distortions in the justice system**

_*So why are profits back in the prison system?*_

**Although convict leasing had been outlawed for private companies,the practice of using inmates as labour didn't stop**. In fact, many states continued to use their inmate populations as a form of cheap labour for themselves. Notably, Southern states re-purposed former plantation land to 'prison farms', some of which are still in existence today.  

Prison farms broached the path to modern prison privatisation through one man : *T. Don Hutto*. 

T. Don Hutto worked as a warden at the Ramsey Prison Farm for African-Americans in Southeastern Texas in the 1960s. Hutto had a 'knack' for running prisons, and for running them cheap. In fact, he was so successful he eventually became the director of Corrections for the state of Arkansas, and then Virginia through the 70s. In 1983, along with two other co-founders, he created the first private prison company : Corrections Corporation of America (since rebranded as CoreCivic, following several lawsuits.)

CoreCivic Founders, featuring a snapshot of their political connections, Tennesee State Senator Lamar Alexander and President D.T.

<img align="center" src="/photos/ccafounders.jpg">





#### Research Question 

***



**Ideally**

**Does the introduction of private prisons lead to distortions in the justice system? Specifically, does the use of private prisons have an effect on criminal justice outcomes?**

Given time and data constraints, answering such a broad, sweeping question is beyond the scope of this project. However, I can use econometric methods to answer a narrower, but adjacent, question. 



**My question**

**Did the introduction of private prisons in Oklahoma have an effect on sentencing lengths?**

Private prisons are used at both the federal and state level. While detailed sentencing data at the federal level is available through the United States Sentencing Commission, my identification strategy (as detailed below) is not consistent with this data. 

**Indeed, my problem is essentially one of *causal inference*.**How can I make sure that any changes in sentencing are due to the introduction of private prisons, and not the result of any other miscellaneous factors?

As is the case for many social science questions, it is impossible to use *experimental methods* to answer my research question. In the *ideal scenario*, I could go back in time, duplicate the entire country so I have two identical versions of it and introduce private prisons in one version and not in the other ( in general terms, assign *treatment* to one and not the other). Holding all else equal, I could look at resulting outcome in my **treated** U.S.A versus my **control** U.S.A. and attribute any resulting differences to the use of private prisons. 

Obviously, in the real world, having access to this *counterfactual* world is impossible. 

**Luckily, the impossibility of time travel and alternate dimension creation does not stop the zealous social scientist. Using *quasi-experimental* methods, it is possible to come to useful insights into these complex questions** 





#### III. Methodology 

***





**To isolate the effects of the introduction of private prisons, I will be using a Differences-in-Differences approach**. This identification strategy is the most popular in Econometrics, due to its intuitive conceptual nature and relatively straightforward implementation. However, it is important to note that there are a whole host of issues to be aware of when using this framework, which will be discussed later in this analysis. 



**What is a Differences-in-Differences framework?**



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



Our estimate of the impact of the treatment ( in technical terms the Average Treatment Effect on the Treated - the **ATT**) is thus the difference between **Diff 1** and **Diff 2**, or:



<img align="center" src="/photos/meansdid.jpg" height="50" width="650">





This can be calculated using the simple mean differences above, but of course, a more precise way to calculate this impact is through *regression*, which permits us to control for other variables which we think may affect our estimate ( as well as conduct hypothesis testing, which in this case will be difficult. More on this below).

The simplest specification is thus: 



<img align="center" src="/photos/regdid.jpg" height="50" width="650">



where T is a dummy variable = 1 post-treatment, and G is a dummy = 1 for treated group. The interaction term T x G indicates treated years for the treated and X are the relevant covariates.



**Now that the basics are out of the way, how exactly will I be using this framework to answer my research question?**

***







<img align="center" src="/photos/lawchange.jpg">





In November of 1995,  the state of Oklahoma enacted Title 57 § 561, "regarding authority to provide incarceration, supervision, and residential treatment at facilities not operated by the Department of Corrections". This is my natural experiment. 

In the following year, Oklahoma began to contract private prisons beds for several hundred convicted felons. However, the neighbouring state, Missouri, did not. These are my treatment and control groups. 



**To recap** : 

*I will be using the enactment of Oklahoma Title 57 as 'treatment' for my two groups, Oklahoma and Missouri. My two time periods are 1995 and 1996. Although the law got passed in 1995, the first beds were not contracted until very late in the year, so essentially, through 1996. I posit that the introduction of private prisons in Oklahoma will have an effect on my outcome variable of choice: sentencing lengths*.





#### IV. Theory 

***





**Why sentencing lengths**?

To understand why I chose this, I will walk through my reasoning and summarise the relevant academic literature. 



**Sentencing decisions are, in large part, up to the discretion of the judge**. At the federal level, there exists sentencing guidelines which set suggested minimum and maximum sentences per crimetype, to decrease variance in punishment level for the same crime across courts. At the state level, there also exists similar guidelines. However,  these are not set in stone. The judge gets the final say, and can override these guidelines if they see fit to do so. Once sentenced, inmates are sent to a holding facility, where DOC officials decide what prison they will be sent to based on various attributes (severity of crime, gang affiliation etc. )



 **Picking a length shortest length possible given what judges believe is fair sentence is efficient** as it means that no inmate is held for a longer period than they need to be. Indeed, to maximise societal outcome, inmates should be sentenced at the lowest possible point that will lead to desirable outcomes ( through ~~reform~~, or distancing that inmate from society). This is a tough exercise : judges must weight the benefits versus cost of incarceration time for each inmate. Given this, state prisons are merely means to an end as they theoretically hold no contesting incentives to this process.



**However, private prisons are for-profit institutions**. They wish to maximise income, which can only be done by keeping incarceration levels high. One of the ways to keep incarceration levels high is by sentencing more people, aggregate. Another, less straightforward way to keep prison propulations high, is by  sentencing people to longer terms. Indeed, research indicates that if sentencing lengths were to decrease by a month, it would lead to a reduction in incarceration of up to 50,000 inmates. 

It is also arguable that, as a profit-maximising firm, private prisons would prefer to hold one same inmate for longer than cycle new ones in and out. Indeed, there are high costs associated with transferring inmates into a facility, as this requires extensive staffing attention. However, as has been analyzed in both academic and popular news, private prisons main cost-cutting comes from suppressing prison staff. Thus, **private prisons stand to gain the most from the same inmate being convicted for a longer amount of time.**



The posited links between private prisons and increased sentencing lengths are thus as follow:



1. **The private prison industry influences judges decisions through the use of lobbying and/or campaign contributions [read:corruption].**

   Is this channel possible? Well, there is evidence to say that private prisons do not shy from using bribes as a means of filling up their beds. Other methods would include lobbying, or other political pressure. 

   

*or*, 



2. **As a result of judges internalising minimized stress on the penal system and adjusting sentences accordingly.**

   Is this channel possible? Given current mass incarceration levels, financial costs associated with incarcerationare enormous and have been stretching correctional systems thin. In fact, some states are considering making the cost of incarceration known to the judge as they make sentencing decisions. In theory, private prisons are mandated to run at a lower price point than state prisons. Judges may take these lower costs into consideration, and punish more extensively as the marginal cost of doing so is lessened. However, determining whether or not private prisons **actually** costs less than state facilities is a formidable accounting exercise, and so far, there is no good evidence to say that they do. That being said, it is possible that once judges are aware that prisons *beds* are available, they do not punish as fastidiously as when they are aware there are facilities to house the inmate in front of them (in fact, most state prisons suffer from severe over-crowding and operate at over 100% capacity). So potential mechanisms here are both from (alleged) lesser costs to the state, or increased physical detention capacities. 



Economic literature on this topic is scarce. In fact, the amount of  papers which discuss private prisons using empirical techniques can be counted on one hand, and have all been published within the last few years. This notwithstanding, the literature seems to come to a concensus that the introduction of private prisons does indeed lead to distorted outcomes. 



* [Mukherjee, 2017](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2523238) : Finds evidence that those inmates serve an additional 60 to 90 days of their sentences as compared to the average inmate. The author posits that this is due to conduct violations being used more heavily in private institutions, thereby curtailing early release on good behaviour.

* [Dippel and Poyker, 2020](https://www.nber.org/papers/w25715) : Compare prisoner outcomes across state borders. Using county level data, they compare changes in sentencing across county-pairs which straddle a border following changes in a state’s private prison capacity. They find that a doubling of private prisons capacity raises sentence lengths by 1.3%.

* [Eren and Mocan, 2015](https://pubs.aeaweb.org/doi/pdf/10.1257/app.20160390): Find marked increases in sentencing lengths in the week following an unexpected loss from the judge’s alma matter football team. (Heterogenous effects : this disproportionastely affects black youth). 



These studies show that there is credence in saying that judge decision making is not uniquely a  factor of justice, and that private prisons do have some perverse effect in the criminal justice system. To circle back to our analysis: 





#### V. Data

***





Data for both states are made publicly available on their respective Department of Correction websites. 

Oklahoma data can be found in fixed-width format [here](http://doc.ok.gov/odoc-public-inmate-data), and Missouri data (also in fwf) [here](https://doc.mo.gov/media-center/sunshine-law). 



Both datasets are richly detailed, with information concerning sentencing decisions for all inmates spanning several decades. Data was cleaned through the scripts folder, available in this repo, and was complemented using some light web-scraping for any relevant information they did not have (such as population data per county etc.)

> It is important to note that both datasets suffer from some inconsistencies (especially Oklahoman data). Of particular concern is the lack of granularity of sentence information for Oklahoma. While the Missouri data sentence can be calculated with great detail using time differences between Start and End Dates for each row, Oklahoman data only has a global value, in year, for each sentence. This leads to what looks like censoring of the data, where several granular sentences are absored within a bigger category (so, for example, if you were really sentenced for 18 months and and 14 days, the sentence I have is collapsed to 1 year). This can be seen when looking at ranges of the sentencing data, where Oklahoma has some distinct 'layering' occurring (also seen on graph 4 below). On the other hand, this could simply be due to minimum sentences for prison time. This requires further thought, or possibly specifying a Tobit model which would be feasible in a DiD context.



The understand my data more,  I created some quick visualisations: 



<img align="center" src="/photos/inmatecount.jpg">

This count uses incarceration sentences only : so excludes life sentences, death sentences, probation etc. 



*I am also working on some deeper visualisations*, to really get familiar with the data. 



#### VI. Econometrics

***



**Subsetting the right dataset for analysis was made through a series of difficult decisions.** Should I keep all observations? Only those sentencd to an incarceration term? Every record of an inmate's appearance? Just their first? Sum sentences across inmates and court appearances? Use just the individual sentence? Given abudance of data, should I extend my time periods? Should I be taking log values?

This process was not clear-cut.  For the regressions below, I used only the first instance of being sentenced to incarceration (to avoid bias from repeat offenders), did not sum sentences but did log them, and collapsed pre and post treatment periods from 1994 to 1998, with 1996 as my cutoff. I did this because the bulk of contracting occured some months after the title was enacted, so restricting my data to only the year following introduction may not fully reflect the effect of private prisons on the system. 



**Before running the regressions, it is important to look at whether the assumptions for DiD hold.** According to Hansen (2020) :

* *Outcome equation equals the specified linear regression model which is additively separable in observables, individual effects and time effects and controls for trends and interactions.* Here, the very simple specification described above will be used. 

* *Policy is exogenous to independent variable:* Sentencing lengths are related to aggregate levels of prison populations, which spurred the enactment of the title. So, in that way, the policy is not exactly exogenous. However, in the graph below, it is shown that average sentence was not particularly growing in the time period preceeding the policy. 

* *No other relevant unincluded factors are coincident with the policy:* There is almost no way that this assumption holds across all DiD, and especially in this one. That being said, I undertook a quick investigation of both state and federal law. There were some laws passed which may affect my independent variable. Notably, Oklahoma passed a truth-in-sentencing law that set minimum times to be spent incarcerated when sentenced in the mid 1990s, and a federal grant was passed which provided some states ( including Oklahoma) with financial assistance for their correctional costs. 

  

* *Parallel trends assumption holds.* 

<img align="center" src="/photos/parallel.jpg">



Well, not really. But there is the possibility of matching which may help with this at a later stage.  

That being said, in this visualisation, there seems to be some evidence that average sentence lenght did increase following the introduction of private prisons. Sentences have been logged, and in the second figure you can see the potential censoring discussed above. 

<img align="center" src="/photos/statsum.jpg">



<img align="center" src="/photos/histogram_logsentences.jpg">



** Restricted model**



<table>
 <thead>
  <tr>
   <th style="text-align:left;"> names </th>
   <th style="text-align:left;"> model1 </th>
   <th style="text-align:left;"> model2 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (1) </td>
   <td style="text-align:left;"> (2) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:left;"> 7.56 *** </td>
   <td style="text-align:left;"> 7.33 *** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.004) </td>
   <td style="text-align:left;"> (0.056) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> statedummy </td>
   <td style="text-align:left;"> -0.208 *** </td>
   <td style="text-align:left;"> -0.082 *** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.007) </td>
   <td style="text-align:left;"> (0.007) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> timedummy </td>
   <td style="text-align:left;"> -0.0167 </td>
   <td style="text-align:left;"> -0.0178 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.0107) </td>
   <td style="text-align:left;"> (0.0101) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Interaction </td>
   <td style="text-align:left;"> 0.006 </td>
   <td style="text-align:left;"> 0.010 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.015) </td>
   <td style="text-align:left;"> (0.014=) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sexMale </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 0.19 *** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.008) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sexUnknown </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> -0.159 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.136) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> raceBlack </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.055) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> raceHispanic </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 0.0257 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.058) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> raceUnknown </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> -0.068 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.057) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> raceWhite </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> -0.048 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.055) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> crimetypeNon-Violent </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> -0.100 *** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.006) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> crimetypeViolent </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 0.657 *** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> (0.010) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> N </td>
   <td style="text-align:left;"> 64073 </td>
   <td style="text-align:left;"> 63841 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:left;"> 0.0173 </td>
   <td style="text-align:left;"> 0.1209 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> logLik </td>
   <td style="text-align:left;"> -75150.2605489357 </td>
   <td style="text-align:left;"> -71319.5316201152 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AIC </td>
   <td style="text-align:left;"> 150310.521097871 </td>
   <td style="text-align:left;"> 142665.06324023 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> *** p &lt; 0.001;  ** p &lt; 0.01;  * p &lt; 0.05. </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
  </tr>
</tbody>
</table>





As has been abudantly discussed in the econometrics world, the standard errors on these estimates are completely unreliable. Given the fact I have state-level variation, and only two states, other methods to correct for this are also not ideal (pesky asymptotic requirements).

However, I have in good faith included wild cluster bootstrap values here: 







#### Conclusion

***



This project is still at its inception. From both econometric and research perspectives, a lot more work remains to be done. However, these initial directional results point to a small effect, of about 1% increase in sentencing lengths as a result of the introduction of private prisons.







































