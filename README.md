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


Upcoming Features
=================
* Master SPSStoR function
* Descriptives
* Value Labels
* Further arguments for above current features
* Modeling functions
    + t-test
    + analysis of variance
    + regression
    + generalized models
* if else statements
* graphics

Aggregate to R Example
======================




```r
aggregate_to_agg("aggregateExamp.txt", syntax = "data.table")
```

```
##      [,1]                                                                                                                                           
## [1,] "\\#x is the name of your data frame"                                                                                                          
## [2,] "temp <- x[order(gender, marital), list(age_mean=mean(age), age_median=median(age), income_median=median(income)), by = list(gender, marital)]"
```

```r
aggregate_to_agg("aggregateExampNoBreak.txt", syntax = "data.table")
```

```
##      [,1]                                                                                           
## [1,] "\\#x is the name of your data frame"                                                          
## [2,] "temp <- x[, list(age_mean=mean(age), age_median=median(age), income_median=median(income)), ]"
```

```r
aggregate_to_agg("aggregateExampNoBreakNoOutfile.txt", syntax = "data.table")
```

```
##      [,1]                                  
## [1,] "\\#x is the name of your data frame" 
## [2,] "x[, age_mean:=mean(age), ]"          
## [3,] "x[, age_median:=median(age), ]"      
## [4,] "x[, income_median:=median(income), ]"
```

```r
aggregate_to_agg("aggregateExampNoOutfile.txt", syntax = "data.table")
```

```
##      [,1]                                                                                  
## [1,] "\\#x is the name of your data frame"                                                 
## [2,] "x[order(gender, marital), age_mean:=mean(age), by = list(gender, marital)]"          
## [3,] "x[order(gender, marital), age_median:=median(age), by = list(gender, marital)]"      
## [4,] "x[order(gender, marital), income_median:=median(income), by = list(gender, marital)]"
```


Correlation to R Example
=========================

```r
correlations_to_cor("correlationsExamp.txt")
```

```
##      [,1]                                                         
## [1,] "\\#x is the name of your data frame"                        
## [2,] "with(x, cor(cbind(sales, mpg)),use = pairwise.complete.obs)"
```


Crosstab to R Example
======================

```r
crosstabs_to_table("crosstabExamp.txt")
```

```
##       [,1]                                                     
##  [1,] "\\#x is the name of your data frame"                    
##  [2,] "ctab(with(x, table(grade,M_part)), type = c('n','r'))"  
##  [3,] "ctab(with(x, table(race,M_part)), type = c('n','r'))"   
##  [4,] "ctab(with(x, table(lepflag,M_part)), type = c('n','r'))"
##  [5,] "ctab(with(x, table(FRL,M_part)), type = c('n','r'))"    
##  [6,] "ctab(with(x, table(SpEd,M_part)), type = c('n','r'))"   
##  [7,] "ctab(with(x, table(grade,R_part)), type = c('n','r'))"  
##  [8,] "ctab(with(x, table(race,R_part)), type = c('n','r'))"   
##  [9,] "ctab(with(x, table(lepflag,R_part)), type = c('n','r'))"
## [10,] "ctab(with(x, table(FRL,R_part)), type = c('n','r'))"    
## [11,] "ctab(with(x, table(SpEd,R_part)), type = c('n','r'))"
```


Sort Cases to R Example
=======================

```r
sortcases_to_order("sortCasesExamp.txt")
```

```
##      [,1]                                    
## [1,] "\\#x is the name of your data frame"   
## [2,] "x <- x[order(DIVISION, STORE, -AGE), ]"
```

```r
sortcases_to_order("sortCasesExamp2.txt")
```

```
##      [,1]                                 
## [1,] "\\#x is the name of your data frame"
## [2,] "x <- x[order(DIVISION, -STORE), ]"
```

