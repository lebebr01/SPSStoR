## SPSS to R
=================
  
A set of functions that takes *SPSS* syntax as input and outputs *R* commands 
to do the same analysis or data management tasks.

## Current Features
===============
* Read in Data
    * Get for sav files
* Data Manipulation
    * Sort Cases
* Descriptives
    * Aggregate
    * Correlations
    * Crosstab
    * Descriptives
    * Frequencies
    * Graphics    
* Models
    * One sample t-test
    * Independent sample t-test




## Upcoming Features
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

## Installing Function
===================

```r
library(devtools)
install_github("SPSStoR", username = "lebebr01")
library(SPSStoR)
```

## Examples
=========
### Multiple commands
------------------

```r
# Multiple commands in one
spss_to_r(system.file("SPSSsyntax", "getDescExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## library(foreign)
## x <- read.spss('/data/hubtemp.sav', to.data.frame = TRUE)
## x <- x[order(DIVISION, STORE, -AGE), ]
## library(SPSStoR)
## with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, sd, min, max))
```


### Aggregate Example
-----------------------

```r
  spss_to_r(system.file("SPSSsyntax", "aggregateExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## library(data.table)
## x <- data.table(x)
## temp <- x[order(gender, marital), list(age_mean=mean(age), age_median=median(age), income_median=median(income)), by = list(gender, marital)]
## temp <- x[, list(age_mean=mean(age), age_median=median(age), income_median=median(income)), ]
## x[, age_mean:=mean(age), ]
## x[, age_median:=median(age), ]
## x[, income_median:=median(income), ]
## x[order(gender, marital), age_mean:=mean(age), by = list(gender, marital)]
## x[order(gender, marital), age_median:=median(age), by = list(gender, marital)]
## x[order(gender, marital), income_median:=median(income), by = list(gender, marital)]
```

### Correlation Example
-------------------------

```r
  spss_to_r(system.file("SPSSsyntax", "correlationsExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## with(x, cor(cbind(sales, mpg)),use = pairwise.complete.obs)
```

### Crosstab Example
----------------------

```r
  spss_to_r(system.file("SPSSsyntax", "crosstabExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## library(catspec)
## ctab(with(x, table(grade,M_part)), type = c('n','r'))
## ctab(with(x, table(race,M_part)), type = c('n','r'))
## ctab(with(x, table(lepflag,M_part)), type = c('n','r'))
## ctab(with(x, table(FRL,M_part)), type = c('n','r'))
## ctab(with(x, table(SpEd,M_part)), type = c('n','r'))
## ctab(with(x, table(grade,R_part)), type = c('n','r'))
## ctab(with(x, table(race,R_part)), type = c('n','r'))
## ctab(with(x, table(lepflag,R_part)), type = c('n','r'))
## ctab(with(x, table(FRL,R_part)), type = c('n','r'))
## ctab(with(x, table(SpEd,R_part)), type = c('n','r'))
```

### Sort Cases Example
-----------------------

```r
  spss_to_r(system.file("SPSSsyntax", "sortCasesExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## x <- x[order(DIVISION, STORE, -AGE), ]
## x <- x[order(DIVISION, -STORE), ]
```

### Descriptives Example
-------------------------

```r
  spss_to_r(system.file("SPSSsyntax", "descriptivesExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## library(SPSStoR)
## with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, sd, min, max))
## library(e1071)
## with(x, descmat(x = list(longmon, tollmon, equipmon, cardmon, wiremon), mean, semean, sd, var, kurtosis, skewness, range, min, max, sum))
```

### t-test Examples
--------------------------

```r
# t-test one-sample
  spss_to_r(system.file("SPSSsyntax", "ttestOneSampExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## with(x, t.test(brake, mu = 322, conf.level = .90)
```

```r
# Independent t-test example
  spss_to_r(system.file("SPSSsyntax", "ttestTwoSampValExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## library(car)
## leveneTest(dollars ~ insert, data = x)
## t.test(dollars ~ insert, data = x, mu = 0, conf.level = .95, var.equal = TRUE)
## t.test(dollars ~ insert, data = x, mu = 0, conf.level = .95, var.equal = FALSE)
```

### Get Command Example
-------------------

```r
  spss_to_r(system.file("SPSSsyntax", "getExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## library(foreign)
## x <- read.spss('/data/hubtemp.sav', to.data.frame = TRUE)
```

### Graphics
----------------

```r
  spss_to_r(system.file("SPSSsyntax", "graphExamps.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## library(ggplot2)
## p <- ggplot(x, aes(x = PF)) + geom_histogram(aes(y = ..density..), stat = 'bin')+ stat_function(geom='line', fun = dnorm, arg = list(mean = mean(PF), sd = sd(PF)))+ labs(title = 'Points Scored')
## p
## p <- ggplot(x, aes(x = PF)) + geom_histogram()+ labs(title = 'Points Scored')
## p
## p <- ggplot(x, aes(ymax = max(PF), ymin = min(PF), y = mean(PF), x = W.L)) + geom_pointrange()
## p
## p <- ggplot(x, aes(ymax = max(PF), ymin = min(PF), x = W.L)) + geom_ribbon()
## p
## library(GGally)
## ggpairs(x[, c('PF', 'PA')])
## p <- ggplot(x, aes(y = ..count.., x = PF)) + geom_bar(position = 'dodge')+ labs(title = 'Points Scored by WinLoss')
## p
## p <- ggplot(x, aes(y = ..count.., x = PF, fill = W.L)) + geom_bar(position = 'dodge')
## p
## p <- ggplot(x, aes(y = mean(PF), x = W.L)) + geom_line()
## p
## p <- ggplot(x, aes(y = PA, x = PF)) + geom_point()+ labs(title = 'Points Scored by Points Against')
## p
## p <- ggplot(x, aes(y = PF, x = W.L)) + geom_errorbar()
## p
## p <- ggplot(x, aes(y = mean(PF), x = W.L)) + geom_area()
## p
```

### Frequencies
---------------

```r
  spss_to_r(system.file("SPSSsyntax", "frequenciesExamp.txt", package = "SPSStoR"))
```

```
## # x is the name of your data frame
## with(x, table(is.na(dept)))
## with(x, table(is.na(race)))
## with(x, table(dept))
## with(x, table(race))
## ggplot(x, aes(x = factor(1), fill = dept)) + geom_bar() + coord_polar(theta = 'y')
## ggplot(x, aes(x = factor(1), fill = race)) + geom_bar() + coord_polar(theta = 'y')
## with(x, table(is.na(sale)))
## library(SPSStoR)
## library(e1071)
## with(x, descmat(x = list(sale), sd, min, max, mean, median, skewness, kurtosis))
## quantile(x, probs = seq(0, 1, 1/4), type = 6)
## quantile(x, probs = seq(0, 1, 1/5), type = 6)
## quantile(x, probs = c(10, 25, 33.3, 66.7, 75), type = 6)
## ggplot(x, aes(x = factor(1), fill = sale)) + geom_histogram()
```



