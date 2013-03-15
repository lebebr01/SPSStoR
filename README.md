SPSS to R
=================
  
A set of functions that takes *SPSS* syntax as input and outputs *R* commands 
to do the same analysis or data management tasks.

Current Features
===============
* Aggregate
* Correlations
* Crosstab
* Sort Cases
* Descriptives
* One sample t-test
* Independent sample t-test
* Get for sav files
* Master SPSStoR function
* graphics


Upcoming Features
=================
* More Get commands to read in csv, txt, etc.
* Dataset commands
* Value Labels
* Further arguments for descriptives
* Modeling functions
    + t-test (two sample with cut score and paired)
    + analysis of variance
    + regression
    + generalized models
* if else statements
* Examine

Installing Function
===================

```r
library(devtools)
install_github("SPSStoR", username = "lebebr01")
library(SPSStoR)
```


Examples
=========
Multiple commands
------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/getDescExamp.txt")
```

```
## [1] "# x is the name of your data frame"                                                          
## [2] "library(foreign)"                                                                            
## [3] "x <- read.spss('/data/hubtemp.sav', to.data.frame = TRUE)"                                   
## [4] "x <- x[order(DIVISION, STORE, -AGE), ]"                                                      
## [5] "library(SPSStoR)"                                                                            
## [6] "with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, sd, min, max))"
```



Aggregate to R Example
-----------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/aggregateExamp.txt")
```

```
## [1] "# x is the name of your data frame"                                                                                                           
## [2] "library(data.table)"                                                                                                                          
## [3] "temp <- x[order(gender, marital), list(age_mean=mean(age), age_median=median(age), income_median=median(income)), by = list(gender, marital)]"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/aggregateExampNoBreak.txt")
```

```
## [1] "# x is the name of your data frame"                                                           
## [2] "library(data.table)"                                                                          
## [3] "temp <- x[, list(age_mean=mean(age), age_median=median(age), income_median=median(income)), ]"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/aggregateExampNoBreakNoOutfile.txt")
```

```
## [1] "# x is the name of your data frame"  
## [2] "library(data.table)"                 
## [3] "x[, age_mean:=mean(age), ]"          
## [4] "x[, age_median:=median(age), ]"      
## [5] "x[, income_median:=median(income), ]"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/aggregateExampNoOutfile.txt")
```

```
## [1] "# x is the name of your data frame"                                                  
## [2] "library(data.table)"                                                                 
## [3] "x[order(gender, marital), age_mean:=mean(age), by = list(gender, marital)]"          
## [4] "x[order(gender, marital), age_median:=median(age), by = list(gender, marital)]"      
## [5] "x[order(gender, marital), income_median:=median(income), by = list(gender, marital)]"
```


Correlation to R Example
-------------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/correlationsExamp.txt")
```

```
## [1] "# x is the name of your data frame"                         
## [2] "with(x, cor(cbind(sales, mpg)),use = pairwise.complete.obs)"
```


Crosstab to R Example
----------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/crosstabExamp.txt")
```

```
##  [1] "# x is the name of your data frame"                     
##  [2] "ctab(with(x, table(grade,M_part)), type = c('n','r'))"  
##  [3] "ctab(with(x, table(race,M_part)), type = c('n','r'))"   
##  [4] "ctab(with(x, table(lepflag,M_part)), type = c('n','r'))"
##  [5] "ctab(with(x, table(FRL,M_part)), type = c('n','r'))"    
##  [6] "ctab(with(x, table(SpEd,M_part)), type = c('n','r'))"   
##  [7] "ctab(with(x, table(grade,R_part)), type = c('n','r'))"  
##  [8] "ctab(with(x, table(race,R_part)), type = c('n','r'))"   
##  [9] "ctab(with(x, table(lepflag,R_part)), type = c('n','r'))"
## [10] "ctab(with(x, table(FRL,R_part)), type = c('n','r'))"    
## [11] "ctab(with(x, table(SpEd,R_part)), type = c('n','r'))"
```


Sort Cases to R Example
-----------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/sortCasesExamp.txt")
```

```
## [1] "# x is the name of your data frame"    
## [2] "x <- x[order(DIVISION, STORE, -AGE), ]"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/sortCasesExamp2.txt")
```

```
## [1] "# x is the name of your data frame"
## [2] "x <- x[order(DIVISION, -STORE), ]"
```


Descriptives to R Example
-------------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/descriptivesExamp.txt")
```

```
## [1] "# x is the name of your data frame"                                                          
## [2] "library(SPSStoR)"                                                                            
## [3] "with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, sd, min, max))"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/descriptivesExampAll.txt")
```

```
## [1] "# x is the name of your data frame"                                                                                                       
## [2] "library(SPSStoR)"                                                                                                                         
## [3] "library(e1071)"                                                                                                                           
## [4] "with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, semean, sd, var, kurtosis, skewness, range, min, max, sum))"
```


One Sample T-test Example
--------------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/ttestOneSampExamp.txt")
```

```
## [1] "# x is the name of your data frame"               
## [2] "with(x, t.test(brake, mu = 322, conf.level = .90)"
```


Indpendent Sample T-test Example
----------------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/ttestTwoSampValExamp.txt")
```

```
## [1] "# x is the name of your data frame"                                             
## [2] "library(car)"                                                                   
## [3] "leveneTest(dollars ~ insert, data = x)"                                         
## [4] "t.test(dollars ~ insert, data = x, mu = 0, conf.level = .95, var.equal = TRUE)" 
## [5] "t.test(dollars ~ insert, data = x, mu = 0, conf.level = .95, var.equal = FALSE)"
```


Get Command Example
-------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/getExamp.txt")
```

```
## [1] "# x is the name of your data frame"                       
## [2] "library(foreign)"                                         
## [3] "x <- read.spss('/data/hubtemp.sav', to.data.frame = TRUE)"
```


Graphics
----------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/graphExamps.txt")
```

```
##  [1] "# x is the name of your data frame"                                                                                                                                                                
##  [2] "library(ggplot2)"                                                                                                                                                                                  
##  [3] "p <- ggplot(x, aes(x = PF)) + geom_histogram(aes(y = ..density..), stat = 'bin')+ stat_function(geom='line', fun = dnorm, arg = list(mean = mean(PF), sd = sd(PF)))+ labs(title = 'Points Scored')"
##  [4] "p"                                                                                                                                                                                                 
##  [5] "library(ggplot2)"                                                                                                                                                                                  
##  [6] "p <- ggplot(x, aes(x = PF)) + geom_histogram()+ labs(title = 'Points Scored')"                                                                                                                     
##  [7] "p"                                                                                                                                                                                                 
##  [8] "library(ggplot2)"                                                                                                                                                                                  
##  [9] "p <- ggplot(x, aes(ymax = max(PF), ymin = min(PF), y = mean(PF), x = W.L)) + geom_pointrange()"                                                                                                    
## [10] "p"                                                                                                                                                                                                 
## [11] "library(ggplot2)"                                                                                                                                                                                  
## [12] "p <- ggplot(x, aes(ymax = max(PF), ymin = min(PF), x = W.L)) + geom_ribbon()"                                                                                                                      
## [13] "p"                                                                                                                                                                                                 
## [14] "library(ggplot2); library(GGally)"                                                                                                                                                                 
## [15] "ggpairs(x[, c('PF', 'PA')])"                                                                                                                                                                       
## [16] "library(ggplot2)"                                                                                                                                                                                  
## [17] "p <- ggplot(x, aes(y = ..count.., x = PF)) + geom_bar(position = 'dodge')+ labs(title = 'Points Scored by WinLoss')"                                                                               
## [18] "p"                                                                                                                                                                                                 
## [19] "library(ggplot2)"                                                                                                                                                                                  
## [20] "p <- ggplot(x, aes(y = ..count.., x = PF, fill = W.L)) + geom_bar(position = 'dodge')"                                                                                                             
## [21] "p"                                                                                                                                                                                                 
## [22] "library(ggplot2)"                                                                                                                                                                                  
## [23] "p <- ggplot(x, aes(y = mean(PF), x = W.L)) + geom_line()"                                                                                                                                          
## [24] "p"                                                                                                                                                                                                 
## [25] "library(ggplot2)"                                                                                                                                                                                  
## [26] "p <- ggplot(x, aes(y = PA, x = PF)) + geom_point()+ labs(title = 'Points Scored by Points Against')"                                                                                               
## [27] "p"                                                                                                                                                                                                 
## [28] "library(ggplot2)"                                                                                                                                                                                  
## [29] "p <- ggplot(x, aes(y = PF, x = W.L)) + geom_errorbar()"                                                                                                                                            
## [30] "p"                                                                                                                                                                                                 
## [31] "library(ggplot2)"                                                                                                                                                                                  
## [32] "p <- ggplot(x, aes(y = mean(PF), x = W.L)) + geom_area()"                                                                                                                                          
## [33] "p"
```



