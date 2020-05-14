# In Whose Interest : Private Prisons and Sentencing Lengths 

#### Capstone Project by Myrtille Génot, as part of graduation requirements for the MSc in Applied Economics at the University of San Francisco. 



###### I. Motivation 

***

Profit and prisons have a long history. Although the13th Amendment **abolished involutary servitutude**, a loophole exempted prisoners from this protection.

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

**Talbert’s $25 fine had actually been paid** by his family, which had rushed the money upon hearing of his arrest. However, it was widely known that **Sheriff J R Jones touched a ‘$20 head fee for each able bodied man he turned to the lumber company.’** Had he processed the fine, he would have lost Talbert’s head fee.

Disbanding prison camps was difficult as they were protected by the wealthy and well connected. For example, **Knabb Turpentine** in nearby Baker county, described by a contemporary prison supervisor as a **"human slaughter pen"** was owned by **State Senator Knabb** (fourth to the left below).

One of his descendents, Todd Knabb is now a the county sheriff at the local county jail.  *source : Baker County Press*

<img align="center" src="/photos/senatorknabb.jpg">

##### Theoretically, this points to a clear issue : when there is financial gain to be made from incarceration, sub-optimal outcomes occur as a result of incentive distortions in the justice system. 

##### *So why are profits back in the prison system?*

Well, just because **convict leasing had been outlawed for private companies,the practice of using inmates as labour didn't stop**. In fact, many states continued to use their inmate populations as a form of cheap labour for themselves. Notably, Southern states re-purposed former plantation land to 'prison farms', some of which are still in existence today.  

Prison farms broached the path to modern prison privatisation through one man : **T. Don Hutto**. 

T. Don Hutto worked as a warden at the Ramsey Prison Farm for African-Americans in Southeastern Texas in the 1960s. Hutto had a 'knack' for running prisons, and for running them cheap. In fact, he was so successful he eventually became the director of Corrections for the state of Arkansas, and then Virginia through the 70s. In 1983, along with two other co-founders, he created the first private prison company : Corrections Corporation of America (since rebranded as CoreCivic, following several lawsuits.)

**Photo 3** *CoreCivic Founders, featuring a snapshot of their political connections*

<img align="center" src="/photos/ccafounders.jpg">



###### II. Research Question 

***

##### Ideally: 

>  ##### Does the introduction of private prisons lead to distortions in the justice system? Specifically, does the use of private prisons have an effect on criminal justice outcomes?

Given time and data constraints, answering this broad based question is beyond the scope of this project. However, I can use econometric methods to answer a narrower, but adjacent, question. 



##### My question:

> ##### Did the introduction of private prisons in Oklahoma have an effect on sentencing lengths?



*Why this question?*

Private prisons are used at both the federal and state level. While detailed sentencing data at the federal level is available through the United States Sentencing Commission, my identification strategy (as detailed below) is not consistent with this data. 

Indeed, my problem is essentially one of *causal inference*. How can I make sure that any changes in sentencing are due to the introduction of private prisons, and not the result of any other miscellaneous factors?

As is the case for many social science questions, it is impossible to use **experimental methods** to answer my research question. In the *ideal scenario*, I could go back in time, duplicate the entire country so I have two identical versions of it and introduce private prisons in one version and not in the other ( in general terms, assign *treatment* to one and not the other). Holding all else equal, I could look at resulting outcomes in my **treated** U.S.A versus my **control** U.S.A. and attribute any resulting differences to the use of private prisons. 

Obviously, in the real world, having access to this **counterfactual** world is impossible. 

Luckily, the impossibility of time travel and alternate dimension creation does not stop the zealous social scientist. Using **quasi-experimental** methods, it is possible to come to useful insights into these complex questions. 



###### III. Methodology 

***



To isolate the effects of the introduction of private prisons, I will be using a **Differences-in-Differences approach**. This identification strategy is the most popular in Econometrics, due to its intuitive conceptual nature and relatively straightforward implementation. However, it is important to note that there are a whole host of issues to be aware of when using this framework, which will be discussed later in this analysis. 



* **What is a Differences-in-Differences framework?**

  A differences-in-differences (hitherto, **DiD**) approach needs :

  > (**1**)  *a natural experiment*. Natural experiments are events that occured in real life, that affect an outcome of interest and thus mimic assignment to treatment. We can conveniently use these natural experiments for our econometric analysis (for example, the passage of a specific state law). 

  As well as,

  > (**2**)  *the existence of two groups*, one Treated (**T**)  (as a reulst of the event from our natural experiment) and one that is a Control group (**C**).  So, using the passage of a law, we could look at two states and compare the differences in the outcome of interest in the state with the law and the one without. 

  and finally;

  > (3) *two time periods*, one before our event (**Time = 0**) and one after (**Time =1**) for both groups. 

  When looking at this, one can see how it ressembles the ideal experiment described above. We have two groups, one treated and one untreated, and measurements of our outcome of interest at different time points. 

  Neatly : 

  X | Time | Time

  _ _ _ | _ _ _ | _ _ _

  Treated | yq |uu

  Control | dd| dd

  

  Putting (**1**) and (**2**) together, we have the first difference from our DiD : the difference in outcomes for 2 groups, one treated as a result of the event from our natural experiment and the one that wasn't.

  

  However, this obviously would not be sufficient to derive any causal insights from the effect of our treatment. Indeed, just looking at this difference, we can hardly confidently say that whatever difference we find is a result of the passage of that specific law. To bolster our confidence, we also look need a third component: 

  

  















