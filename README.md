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
## [1] "library(foreign)"                                                                            
## [2] "x <- read.spss('/data/hubtemp.sav', to.data.frame = TRUE)"                                   
## [3] "x <- x[order(DIVISION, STORE, -AGE), ]"                                                      
## [4] "library(SPSStoR)"                                                                            
## [5] "with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, sd, min, max))"
```



Aggregate to R Example
-----------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/aggregateExamp.txt")
```

```
##      [,1]                                                                                                                                           
## [1,] "library(data.table)"                                                                                                                          
## [2,] "temp <- x[order(gender, marital), list(age_mean=mean(age), age_median=median(age), income_median=median(income)), by = list(gender, marital)]"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/aggregateExampNoBreak.txt")
```

```
##      [,1]                                                                                           
## [1,] "library(data.table)"                                                                          
## [2,] "temp <- x[, list(age_mean=mean(age), age_median=median(age), income_median=median(income)), ]"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/aggregateExampNoBreakNoOutfile.txt")
```

```
##      [,1]                                  
## [1,] "library(data.table)"                 
## [2,] "x[, age_mean:=mean(age), ]"          
## [3,] "x[, age_median:=median(age), ]"      
## [4,] "x[, income_median:=median(income), ]"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/aggregateExampNoOutfile.txt")
```

```
##      [,1]                                                                                  
## [1,] "library(data.table)"                                                                 
## [2,] "x[order(gender, marital), age_mean:=mean(age), by = list(gender, marital)]"          
## [3,] "x[order(gender, marital), age_median:=median(age), by = list(gender, marital)]"      
## [4,] "x[order(gender, marital), income_median:=median(income), by = list(gender, marital)]"
```


Correlation to R Example
-------------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/correlationsExamp.txt")
```

```
##      [,1]                                                         
## [1,] "with(x, cor(cbind(sales, mpg)),use = pairwise.complete.obs)"
```


Crosstab to R Example
----------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/crosstabExamp.txt")
```

```
##       [,1]                                                     
##  [1,] "ctab(with(x, table(grade,M_part)), type = c('n','r'))"  
##  [2,] "ctab(with(x, table(race,M_part)), type = c('n','r'))"   
##  [3,] "ctab(with(x, table(lepflag,M_part)), type = c('n','r'))"
##  [4,] "ctab(with(x, table(FRL,M_part)), type = c('n','r'))"    
##  [5,] "ctab(with(x, table(SpEd,M_part)), type = c('n','r'))"   
##  [6,] "ctab(with(x, table(grade,R_part)), type = c('n','r'))"  
##  [7,] "ctab(with(x, table(race,R_part)), type = c('n','r'))"   
##  [8,] "ctab(with(x, table(lepflag,R_part)), type = c('n','r'))"
##  [9,] "ctab(with(x, table(FRL,R_part)), type = c('n','r'))"    
## [10,] "ctab(with(x, table(SpEd,R_part)), type = c('n','r'))"
```


Sort Cases to R Example
-----------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/sortCasesExamp.txt")
```

```
##      [,1]                                    
## [1,] "x <- x[order(DIVISION, STORE, -AGE), ]"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/sortCasesExamp2.txt")
```

```
##      [,1]                               
## [1,] "x <- x[order(DIVISION, -STORE), ]"
```


Descriptives to R Example
-------------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/descriptivesExamp.txt")
```

```
##      [,1]                                                                                          
## [1,] "library(SPSStoR)"                                                                            
## [2,] "with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, sd, min, max))"
```

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/descriptivesExampAll.txt")
```

```
##      [,1]                                                                                                                                       
## [1,] "library(SPSStoR)"                                                                                                                         
## [2,] "library(e1071)"                                                                                                                           
## [3,] "with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, semean, sd, var, kurtosis, skewness, range, min, max, sum))"
```


One Sample T-test Example
--------------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/ttestOneSampExamp.txt")
```

```
##      [,1]                                               
## [1,] "with(x, t.test(brake, mu = 322, conf.level = .90)"
```


Indpendent Sample T-test Example
----------------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/ttestTwoSampValExamp.txt")
```

```
##      [,1]                                                                             
## [1,] "library(car)"                                                                   
## [2,] "leveneTest(dollars ~ insert, data = x)"                                         
## [3,] "t.test(dollars ~ insert, data = x, mu = 0, conf.level = .95, var.equal = TRUE)" 
## [4,] "t.test(dollars ~ insert, data = x, mu = 0, conf.level = .95, var.equal = FALSE)"
```


Get Command Example
-------------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/getExamp.txt")
```

```
##      [,1]                                                       
## [1,] "library(foreign)"                                         
## [2,] "x <- read.spss('/data/hubtemp.sav', to.data.frame = TRUE)"
```


Graphics
----------------

```r
spss_to_r("C:/Users/e520062/Dropbox/SPSStoR/SPSSsyntax/graphExamps.txt")
```

```
##  [1] "library(ggplot2)"                                                                                                                                                                                  
##  [2] "p <- ggplot(x, aes(x = PF)) + geom_histogram(aes(y = ..density..), stat = 'bin')+ stat_function(geom='line', fun = dnorm, arg = list(mean = mean(PF), sd = sd(PF)))+ labs(title = 'Points Scored')"
##  [3] "p"                                                                                                                                                                                                 
##  [4] "library(ggplot2)"                                                                                                                                                                                  
##  [5] "p <- ggplot(x, aes(x = PF)) + geom_histogram()+ labs(title = 'Points Scored')"                                                                                                                     
##  [6] "p"                                                                                                                                                                                                 
##  [7] "library(ggplot2)"                                                                                                                                                                                  
##  [8] "p <- ggplot(x, aes(ymax = max(PF), ymin = min(PF), y = mean(PF), x = W.L)) + geom_pointrange()"                                                                                                    
##  [9] "p"                                                                                                                                                                                                 
## [10] "library(ggplot2)"                                                                                                                                                                                  
## [11] "p <- ggplot(x, aes(ymax = max(PF), ymin = min(PF), x = W.L)) + geom_ribbon()"                                                                                                                      
## [12] "p"                                                                                                                                                                                                 
## [13] "library(ggplot2); library(GGally)"                                                                                                                                                                 
## [14] "ggpairs(x[, c('PF', 'PA')])"                                                                                                                                                                       
## [15] "library(ggplot2)"                                                                                                                                                                                  
## [16] "p <- ggplot(x, aes(y = ..count.., x = PF)) + geom_bar(position = 'dodge')+ labs(title = 'Points Scored by WinLoss')"                                                                               
## [17] "p"                                                                                                                                                                                                 
## [18] "library(ggplot2)"                                                                                                                                                                                  
## [19] "p <- ggplot(x, aes(y = ..count.., x = PF, fill = W.L)) + geom_bar(position = 'dodge')"                                                                                                             
## [20] "p"                                                                                                                                                                                                 
## [21] "library(ggplot2)"                                                                                                                                                                                  
## [22] "p <- ggplot(x, aes(y = mean(PF), x = W.L)) + geom_line()"                                                                                                                                          
## [23] "p"                                                                                                                                                                                                 
## [24] "library(ggplot2)"                                                                                                                                                                                  
## [25] "p <- ggplot(x, aes(y = PA, x = PF)) + geom_point()+ labs(title = 'Points Scored by Points Against')"                                                                                               
## [26] "p"                                                                                                                                                                                                 
## [27] "library(ggplot2)"                                                                                                                                                                                  
## [28] "p <- ggplot(x, aes(y = PF, x = W.L)) + geom_errorbar()"                                                                                                                                            
## [29] "p"                                                                                                                                                                                                 
## [30] "library(ggplot2)"                                                                                                                                                                                  
## [31] "p <- ggplot(x, aes(y = mean(PF), x = W.L)) + geom_area()"                                                                                                                                          
## [32] "p"
```



