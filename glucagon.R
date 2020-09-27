library(lavaan)
library(xlsx)
library(semPlot)
library(GGally)
library(tidyverse)
setwd("C:/glucagon_robert/")
glucagon<- read.xlsx('glucagon_cross_legged.xlsx','Sheet 1')

#logtransform and normalize data
dat.glucagon<-log(glucagon[,9:27])
dat.glucagon<-scale(dat.glucagon)
hist(dat.glucagon)
n.glucagon <-cbind(glucagon[,1:8],dat.glucagon)
#visualize correlation matrix
# ----- Define a function for plotting a matrix ----- #
myImagePlot <- function(x, ...){
  min <- min(x)
  max <- max(x)
  yLabels <- rownames(x)
  xLabels <- colnames(x)
  title <-c()
  # check for additional function arguments
  if( length(list(...)) ){
    Lst <- list(...)
    if( !is.null(Lst$zlim) ){
      min <- Lst$zlim[1]
      max <- Lst$zlim[2]
    }
    if( !is.null(Lst$yLabels) ){
      yLabels <- c(Lst$yLabels)
    }
    if( !is.null(Lst$xLabels) ){
      xLabels <- c(Lst$xLabels)
    }
    if( !is.null(Lst$title) ){
      title <- Lst$title
    }
  }
  # check for null values
  if( is.null(xLabels) ){
    xLabels <- c(1:ncol(x))
  }
  if( is.null(yLabels) ){
    yLabels <- c(1:nrow(x))
  }
  
  layout(matrix(data=c(1,2), nrow=1, ncol=2), widths=c(4,1), heights=c(1,1))
  
  # Red and green range from 0 to 1 while Blue ranges from 1 to 0
  ColorRamp <- rgb( seq(0,1,length=256),  # Red
                    seq(0,1,length=256),  # Green
                    seq(1,0,length=256))  # Blue
  ColorLevels <- seq(min, max, length=length(ColorRamp))
  
  # Reverse Y axis
  reverse <- nrow(x) : 1
  yLabels <- yLabels[reverse]
  x <- x[reverse,]
  
  # Data Map
  par(mar = c(3,5,2.5,2))
  image(1:length(xLabels), 1:length(yLabels), t(x), col=ColorRamp, xlab="",
        ylab="", axes=FALSE, zlim=c(min,max))
  if( !is.null(title) ){
    title(main=title)
  }
  axis(BELOW<-1, at=1:length(xLabels), labels=xLabels, cex.axis=0.7)
  axis(LEFT <-2, at=1:length(yLabels), labels=yLabels, las= HORIZONTAL<-1,
       cex.axis=0.7)
  
  # Color Scale
  par(mar = c(3,2.5,2.5,2))
  image(1, ColorLevels,
        matrix(data=ColorLevels, ncol=length(ColorLevels),nrow=1),
        col=ColorRamp,
        xlab="",ylab="",
        xaxt="n")
  
  layout(1)
}
# ----- END plot function ----- #
corrMat <-cor(dat.glucagon,use = "complete.obs")
myImagePlot(corrMat)

#try growth model
model <- '
i =~ 1*INS0 + 1*INS30 + 1*INS60 + 1*INS90 + 1*INS120
s =~ 0*INS0 + 1*INS30 + 2*INS60 + 3*INS90 + 4*INS120
# regressions
i ~ fchglucagon + AGE
s ~ fchglucagon + AGE
GLUK0 ~~ GLUK0
# time-varying covariates
#INS0 ~ c1
#INS30 ~ c2
#INS60 ~ c3
#INS90 ~ c4
#INS120 ~ C5
'
fit <- growth(model, data=n.glucagon)
summary(fit)
semPaths(fit,what='std',layout='tree')
coef(fit)


#try simple autoregression model
model2 <-'
INS =~ INS0 + INS30 + INS60 + INS90 + INS120
BZ =~ BZN0 + BZ30 + BZ60 + BZ90 + BZ120
GLUK =~ GLUK0 + GLUK30 + GLUK120

INS~~BZ
INS~~GLUK
GLUK~~BZ

#autoregression
INS ~ BZ + GLUK
BZ ~ INS + GLUK
GLUK ~ INS + BZ
'
fit2 <- sem(model2, data=n.glucagon)
summary(fit2)
semPaths(fit2,what='std',layout='tree2')
coef(fit2)


#CLPM INS ~ BZ autoregression
model3 <-'
corr0 =~ BZN0 
corr30 =~ BZ30
corr60=~ BZ60 
corr90=~ BZ90 
corr120 =~ BZ120 

#LATENT VARIABLE DEFINITION
LINS0 =~ INS0
LINS30 =~ INS30
LINS60 =~ INS60
LINS90 =~ INS90
LINS120 =~ INS120

#LATENT FACTORS COVARIANCES @0	
corr30 ~~ 0*corr0
corr60 ~~ 0*corr0
corr90 ~~ 0*corr0
corr120 ~~ 0*corr0

LINS30 ~~ 0*LINS0
LINS60 ~~ 0*LINS0
LINS90 ~~ 0*LINS0
LINS120 ~~ 0*LINS0

#LAGGED EFFECTS	
LINS30 ~ v1*LINS0	
LINS60 ~ v1*LINS30
LINS90 ~ v1*LINS60
LINS120 ~ v1*LINS90

corr30 ~ v2*corr0
corr60 ~ v2*corr30
corr90 ~ v2*corr60
corr120 ~ v2*corr90

LINS30 ~ v3*corr0
LINS60 ~ v3*corr30
LINS90 ~ v3*corr60
LINS120 ~ v3*corr90

corr30 ~ v4*LINS0
corr60 ~ v4*LINS30
corr90 ~ v4*LINS60
corr120 ~ v4*LINS90

# CORRELATIONS	
LINS0 ~~ v5*corr0	
LINS30 ~~ v6*corr30
LINS60 ~~ v6*corr60
LINS90 ~~ v6*corr90
LINS120 ~~ v6*corr120
'
fit3 <- sem(model3, data=n.glucagon,missing='ml')
summary(fit3)
semPaths(fit3,what='std',layout='tree2')
coef(fit3)


#RICLPM model INS ~ BZ unconstrained
model4 <-'
#LATENT VARIABLE DEFINITION
LBZ0 =~ 1*BZN0 
LBZ30 =~ 1*BZ30 
LBZ60 =~ 1*BZ60
LBZ90 =~ 1*BZ90
LBZ120 =~ 1*BZ120 

LINS0 =~ 1*INS0
LINS30 =~ 1*INS30
LINS60 =~ 1*INS60
LINS90 =~ 1*INS90
LINS120 =~ 1*INS120

#Latent mean Structure with intercepts
kappa =~ 1*BZN0 + 1*BZ30 + 1*BZ60 + 1*BZ90 + 1*BZ120
omega =~ 1*INS0 + 1*INS30 + 1*INS60 + 1*INS90 + 1*INS120

#intercepts
#mu: group mean per wave covariants 
BZN0 ~ mu1*1
BZ30 ~ mu2*1
BZ60 ~ mu3*1
BZ90 ~ mu4*1
BZ120 ~ mu5*1

#pi: group mean per wave insulin
INS0 ~ pi1*1
INS30 ~ pi2*1
INS60 ~ pi3*1
INS90 ~ pi4*1
INS120 ~ pi5*1

#kappa: random intercepts for covariants
#omega: random intercepts for Inuslin
kappa ~~ kappa #variance
omega ~~ omega #variance
kappa ~~ omega #covariance

#LATENT FACTORS COVARIANCES @0	
LBZ30 ~~ 0*LBZ0
LBZ60 ~~ 0*LBZ0
LBZ90 ~~ 0*LBZ0
LBZ120 ~~ 0*LBZ0

LINS30 ~~ 0*LINS0
LINS60 ~~ 0*LINS0
LINS90 ~~ 0*LINS0
LINS120 ~~ 0*LINS0

#LAGGED EFFECTS	
#effects to be the same across both lags.
LINS120 ~ alpha5*LINS90 + beta5*LBZ90
LINS90 ~ alpha4*LINS60 + beta4*LBZ60
LINS60 ~ alpha3*LINS30 + beta3*LBZ30
LINS30 ~ alpha2*LINS0 + beta2*LBZ0

BZ120 ~ gamma5*LINS90 + delta5*LBZ90
BZ90 ~ gamma4*LINS60 + delta5*LBZ60
BZ60 ~ gamma3*LINS30 + delta3*LBZ30
BZ30 ~ gamma2*LINS0 + delta2*LBZ0

#variance
LINS0 ~~ LINS0
LINS30 ~~ u2*LINS30
LINS60 ~~ u3*LINS60
LINS90 ~~ u4*LINS90
LINS120 ~~ u5*LINS120
#variance
LBZ0 ~~ LBZ0
LBZ30 ~~ v2*LBZ30
LBZ60 ~~ v3*LBZ60
LBZ90 ~~ v4*LBZ90
LBZ120 ~~ v5*LBZ120

# LBZELATIONS	
LINS0 ~~ b0*LBZ0	
LINS30 ~~ b2*LBZ30
LINS60 ~~ b3*LBZ60
LINS90 ~~ b4*LBZ90
LINS120 ~~ b5*LBZ120
'
fit4 <- lavaan(model4, data=n.glucagon,missing='ml',
            int.ov.free = F,
            int.lv.free = F,
            auto.fix.first = F,
            auto.fix.single = F,
            auto.cov.lv.x = F,
            auto.cov.y = F,
            auto.var = F)
summary(fit4,standardized = T)
Estimates<-parameterEstimates(fit4,standardized=T)
print(Estimates[nchar(Estimates[,"label"])==2,"std.all"])
print(Estimates[nchar(Estimates[,"label"])==2,"pvalue"])
semPaths(fit4,what='std',layout='tree2')
coef(fit4)


#CLPM model
model5 <-'
#LATENT VARIABLE DEFINITION
LBZ0 =~ 1*BZN0 
LBZ30 =~ 1*BZ30 
LBZ60 =~ 1*BZ60
LBZ90 =~ 1*BZ90
LBZ120 =~ 1*BZ120 

LINS0 =~ 1*INS0
LINS30 =~ 1*INS30
LINS60 =~ 1*INS60
LINS90 =~ 1*INS90
LINS120 =~ 1*INS120

#Latent mean Structure with intercepts
kappa =~ 1*BZN0 + 1*BZ30 + 1*BZ60 + 1*BZ90 + 1*BZ120
omega =~ 1*INS0 + 1*INS30 + 1*INS60 + 1*INS90 + 1*INS120

#intercepts
#mu: group mean per wave covariants 
BZN0 ~ mu1*1
BZ30 ~ mu2*1
BZ60 ~ mu3*1
BZ90 ~ mu4*1
BZ120 ~ mu5*1

#pi: group mean per wave insulin
INS0 ~ pi1*1
INS30 ~ pi2*1
INS60 ~ pi3*1
INS90 ~ pi4*1
INS120 ~ pi5*1

#kappa: random intercepts for covariants
#omega: random intercepts for Inuslin
kappa ~~ 0*kappa #variance
omega ~~ 0*omega #variance
kappa ~~ 0*omega #covariance

#LATENT FACTORS COVARIANCES @0	
LBZ30 ~~ 0*LBZ0
LBZ60 ~~ 0*LBZ0
LBZ90 ~~ 0*LBZ0
LBZ120 ~~ 0*LBZ0

LINS30 ~~ 0*LINS0
LINS60 ~~ 0*LINS0
LINS90 ~~ 0*LINS0
LINS120 ~~ 0*LINS0

#LAGGED EFFECTS	
#effects to be the same across both lags.
LINS120 ~ alpha5*LINS90 + beta5*LBZ90
LINS90 ~ alpha4*LINS60 + beta4*LBZ60
LINS60 ~ alpha3*LINS30 + beta3*LBZ30
LINS30 ~ alpha2*LINS0 + beta2*LBZ0

BZ120 ~ gamma5*LINS90 + delta5*LBZ90
BZ90 ~ gamma4*LINS60 + delta5*LBZ60
BZ60 ~ gamma3*LINS30 + delta3*LBZ30
BZ30 ~ gamma2*LINS0 + delta2*LBZ0

#variance
LINS0 ~~ LINS0
LINS30 ~~ u2*LINS30
LINS60 ~~ u3*LINS60
LINS90 ~~ u4*LINS90
LINS120 ~~ u5*LINS120

#variance
LBZ0 ~~ LBZ0
LBZ30 ~~ v2*LBZ30
LBZ60 ~~ v3*LBZ60
LBZ90 ~~ v4*LBZ90
LBZ120 ~~ v5*LBZ120

# LBZELATIONS	
LINS0 ~~ LBZ0	
LINS30 ~~ LBZ30
LINS60 ~~ LBZ60
LINS90 ~~ LBZ90
LINS120 ~~ LBZ120
'
fit5 <- lavaan(model5, data=n.glucagon,missing='ml',
               int.ov.free = F,
               int.lv.free = F,
               auto.fix.first = F,
               auto.fix.single = F,
               auto.cov.lv.x = F,
               auto.cov.y = F,
               auto.var = F)
summary(fit5,standardized = T)
semPaths(fit5,what='std',layout='tree')
coef(fit5)


#RICLPM model AR structure
model6 <-'
#LATENT VARIABLE DEFINITION
LBZ0 =~ 1*BZN0 
LBZ30 =~ 1*BZ30 
LBZ60 =~ 1*BZ60
LBZ90 =~ 1*BZ90
LBZ120 =~ 1*BZ120 

LINS0 =~ 1*INS0
LINS30 =~ 1*INS30
LINS60 =~ 1*INS60
LINS90 =~ 1*INS90
LINS120 =~ 1*INS120

#Latent mean Structure with intercepts
kappa =~ 1*BZN0 + 1*BZ30 + 1*BZ60 + 1*BZ90 + 1*BZ120
omega =~ 1*INS0 + 1*INS30 + 1*INS60 + 1*INS90 + 1*INS120

#intercepts
#mu: group mean per wave covariants 
BZN0 ~ mu1*1
BZ30 ~ mu2*1
BZ60 ~ mu3*1
BZ90 ~ mu4*1
BZ120 ~ mu5*1

#pi: group mean per wave insulin
INS0 ~ pi1*1
INS30 ~ pi2*1
INS60 ~ pi3*1
INS90 ~ pi4*1
INS120 ~ pi5*1

#kappa: random intercepts for covariants
#omega: random intercepts for Inuslin
kappa ~~ kappa #variance
omega ~~ omega #variance
kappa ~~ omega #covariance

#LATENT FACTORS COVARIANCES @0	
LBZ30 ~~ 0*LBZ0
LBZ60 ~~ 0*LBZ0
LBZ90 ~~ 0*LBZ0
LBZ120 ~~ 0*LBZ0

LINS30 ~~ 0*LINS0
LINS60 ~~ 0*LINS0
LINS90 ~~ 0*LINS0
LINS120 ~~ 0*LINS0

#LAGGED EFFECTS	
#effects to be the same across both lags.
LINS120 ~ alpha*LINS90 + beta*LBZ90
LINS90 ~ alpha*LINS60 + beta*LBZ60
LINS60 ~ alpha*LINS30 + beta*LBZ30
LINS30 ~ alpha*LINS0 + beta*LBZ0

BZ120 ~ gamma*LINS90 + delta*LBZ90
BZ90 ~ gamma*LINS60 + delta*LBZ60
BZ60 ~ gamma*LINS30 + delta*LBZ30
BZ30 ~ gamma*LINS0 + delta*LBZ0

#variance
LINS0 ~~ LINS0
LINS30 ~~ u*LINS30
LINS60 ~~ u*LINS60
LINS90 ~~ u*LINS90
LINS120 ~~ u*LINS120

#variance
LBZ0 ~~ LBZ0
LBZ30 ~~ v*LBZ30
LBZ60 ~~ v*LBZ60
LBZ90 ~~ v*LBZ90
LBZ120 ~~ v*LBZ120

# CORRELATIONS	
LINS0 ~~ LBZ0	
LINS30 ~~ b*LBZ30
LINS60 ~~ b*LBZ60
LINS90 ~~ b*LBZ90
LINS120 ~~ b*LBZ120
'
fit6 <- lavaan(model6, data=n.glucagon,missing='ml',
               int.ov.free = F,
               int.lv.free = F,
               auto.fix.first = F,
               auto.fix.single = F,
               auto.cov.lv.x = F,
               auto.cov.y = F,
               auto.var = F)
summary(fit6,standardized = T)
semPaths(fit6,what='std',layout='tree')
coef(fit6)

#compare un, non-RI & AR models
anova(fit4,fit5,fit6)#unconstrained model has the best fit
#plot correlations between latent variables
#plot prediction
predict(fit4) %>%
  as.data.frame %>%
  select(-kappa, -omega) %>%
  ggpairs(lower = list(continuous = wrap(ggally_smooth, alpha = .5))) + 
  theme_classic()
#plot raw
dat.glucagon %>% 
  as.data.frame %>%
  ggpairs(lower = list(continuous = wrap(ggally_smooth, alpha = .5))) + 
  theme_classic()


#RICLPM glucagon
model7 <-'
#LATENT VARIABLE DEFINITION
LGLUK0 =~ 1*GLUK0 
LGLUK30 =~ 1*GLUK30 
LGLUK120 =~ 1*GLUK120 

LINS0 =~ 1*INS0
LINS30 =~ 1*INS30
LINS120 =~ 1*INS120

#Latent mean Structure with intercepts
kappa =~ 1*GLUK0 + 1*GLUK30 + 1*GLUK120
omega =~ 1*INS0 + 1*INS30 + 1*INS120

#intercepts
#mu: group mean per wave covariants 
GLUK0 ~ mu1*1
GLUK30 ~ mu2*1
GLUK120 ~ mu5*1

#pi: group mean per wave insulin
INS0 ~ pi1*1
INS30 ~ pi2*1
INS120 ~ pi5*1

#kappa: random intercepts for covariants
#omega: random intercepts for Inuslin
kappa ~~ kappa #variance
omega ~~ omega #variance
kappa ~~ omega #covariance

#LATENT FACTORS COVARIANCES @0	
LGLUK30 ~~ 0*LGLUK0
LGLUK120 ~~ 0*LGLUK0

LINS30 ~~ 0*LINS0
LINS120 ~~ 0*LINS0

#LAGGED EFFECTS	
#effects to be the same across both lags.
LINS120 ~ alpha3*LINS30 + beta3*LGLUK30
LINS30 ~ alpha2*LINS0 + beta2*LGLUK0

GLUK120 ~ gamma3*LINS30 + delta3*LGLUK30
GLUK30 ~ gamma2*LINS0 + delta2*LGLUK0

#variance
LINS0 ~~ LINS0
LINS30 ~~ u2*LINS30
LINS120 ~~ u5*LINS120
#variance
LGLUK0 ~~ LGLUK0
LGLUK30 ~~ v2*LGLUK30
LGLUK120 ~~ v5*LGLUK120

# CORRELATIONS	
LINS0 ~~ b0*LGLUK0	
LINS30 ~~ b2*LGLUK30
LINS120 ~~ b5*LGLUK120
'
fit7 <- lavaan(model7, data=n.glucagon,missing='ml',
               int.ov.free = F,
               int.lv.free = F,
               auto.fix.first = F,
               auto.fix.single = F,
               auto.cov.lv.x = F,
               auto.cov.y = F,
               auto.var = F)
summary(fit7,standardized = T)
Estimates<-parameterEstimates(fit7,standardized=T)
print(Estimates[nchar(Estimates[,"label"])==2,"std.all"])
print(Estimates[nchar(Estimates[,"label"])==2,"pvalue"])
coef(fit7)


#RICLPM model INS ~ INS + BZ + GLUK + FFAMI
model8 <-'
#LATENT VARIABLE DEFINITION
LBZ0 =~ 1*BZN0 
LBZ30 =~ 1*BZ30 
LBZ60 =~ 1*BZ60
LBZ90 =~ 1*BZ90
LBZ120 =~ 1*BZ120 

LGLUK0 =~ 1*GLUK0
LGLUK30 =~ 1*GLUK30
LGLUK120 =~ 1*GLUK120

LFF0 =~ 1*FFAMI0
LFF30 =~ 1*FFAMI30
LFF60 =~ 1*FFAMI60
LFF90 =~ 1*FFAMI90
LFF120 =~ 1*FFAMI120

LINS0 =~ 1*INS0
LINS30 =~ 1*INS30
LINS60 =~ 1*INS60
LINS90 =~ 1*INS90
LINS120 =~ 1*INS120

#Latent mean Structure with intercepts
kappa =~ 1*BZN0 + 1*BZ30 + 1*BZ60 + 1*BZ90 + 1*BZ120
omega =~ 1*INS0 + 1*INS30 + 1*INS60 + 1*INS90 + 1*INS120
lambda =~ 1*GLUK0 + 1*GLUK30 + 1*GLUK120
iota =~ 1*FFAMI0 + 1*FFAMI30 + 1*FFAMI60 + 1*FFAMI90 + 1*FFAMI120

#intercepts
#mu: group mean per wave covariants 
BZN0 ~ mu1*1
BZ30 ~ mu2*1
BZ60 ~ mu3*1
BZ90 ~ mu4*1
BZ120 ~ mu5*1

#pi: group mean per wave insulin
INS0 ~ pi1*1
INS30 ~ pi2*1
INS60 ~ pi3*1
INS90 ~ pi4*1
INS120 ~ pi5*1

#zeta: group mean per wave glucagon
GLUK0 ~ zeta1*1
GLUK30 ~ zeta2*1
GLUK120 ~ zeta5*1

#eta: group mean per wave FFAMI
FFAMI0 ~ eta1*1
FFAMI30 ~ eta2*1
FFAMI60 ~ eta3*1
FFAMI90 ~ eta4*1
FFAMI120 ~ eta5*1

#kappa: random intercepts for covariants
#omega: random intercepts for Inuslin
#kappa ~~ kappa #variance
#omega ~~ omega #variance
#lambda ~~ lambda
#iota ~~ iota
kappa ~~ omega #covariance
kappa ~~ lambda
kappa ~~ iota
omega ~~ lambda
omega ~~ iota
lambda ~~ iota

#LATENT FACTORS COVARIANCES @0	
LBZ30 ~~ 0*LBZ0
LBZ60 ~~ 0*LBZ0
LBZ90 ~~ 0*LBZ0
LBZ120 ~~ 0*LBZ0

LINS30 ~~ 0*LINS0
LINS60 ~~ 0*LINS0
LINS90 ~~ 0*LINS0
LINS120 ~~ 0*LINS0

LGLUK30 ~~ 0*LGLUK0
LGLUK120 ~~ 0*LGLUK0

LFF30 ~~ 0*LFF0
LFF60 ~~ 0*LFF0
LFF90 ~~ 0*LFF0
LFF120 ~~ 0*LFF0

#LAGGED EFFECTS	
#effects to be the same across both lags.
LINS120 ~ alpha5*LINS90 + beta5*LBZ90 + delta5*LFF90
LINS90 ~ alpha4*LINS60 + beta4*LBZ60 + delta4*LFF60
LINS60 ~ alpha3*LINS30 + beta3*LBZ30 + gamma3*LGLUK30 + delta3*LFF30 
LINS30 ~ alpha2*LINS0 + beta2*LBZ0 + gamma2*LGLUK0 + delta2*LFF0

#variance
LINS0 ~~ LINS0
LINS30 ~~ u2*LINS30
LINS60 ~~ u3*LINS60
LINS90 ~~ u4*LINS90
LINS120 ~~ u5*LINS120

#variance
LBZ0 ~~ LBZ0
LBZ30 ~~ v2*LBZ30
LBZ60 ~~ v3*LBZ60
LBZ90 ~~ v4*LBZ90
LBZ120 ~~ v5*LBZ120

#variance
LGLUK0 ~~ LGLUK0
LGLUK30 ~~ w2*LGLUK30
LGLUK120 ~~ w5*LGLUK120

#variance
LFF0 ~~ LFF0
LFF30 ~~ x2*LFF30
LFF60 ~~ x3*LFF60
LFF90 ~~ x4*LFF90
LFF120 ~~ x5*LFF120

# CORRELATIONS	
LINS0 ~~ a0*LBZ0	
LINS30 ~~ a2*LBZ30
LINS60 ~~ a3*LBZ60
LINS90 ~~ a4*LBZ90
LINS120 ~~ a5*LBZ120

LINS0 ~~ b0*LGLUK0	
LINS30 ~~ b2*LGLUK30
LINS120 ~~ b5*LGLUK120

LINS0 ~~ c0*LFF0	
LINS30 ~~ c2*LFF30
LINS60 ~~ c3*LFF60
LINS90 ~~ c4*LFF90
LINS120 ~~ c5*LFF120
'
fit8 <- lavaan(model8, data=n.glucagon,missing='ml',
               int.ov.free = F,
               int.lv.free = F,
               auto.fix.first = F,
               auto.fix.single = F,
               auto.cov.lv.x = F,
               auto.cov.y = F,
               auto.var = F)
lavInspect(fit8, "cov.lv")
summary(fit8,standardized = T)
Estimates<-parameterEstimates(fit8,standardized=T)
print(Estimates[nchar(Estimates[,"label"])==2,"std.all"])
print(Estimates[nchar(Estimates[,"label"])==2,"pvalue"])
coef(fit8)
#plot prediction
predict(fit8) %>%
  as.data.frame %>%
  select(-kappa, -omega) %>%
  ggpairs(lower = list(continuous = wrap(ggally_smooth, alpha = .5))) + 
  theme_classic()


#RICLPM model unconstrained
#INS ~ INS + BZ + GLUK + FFAMI
#GLUK ~ INS + BZ + GLUK + FFAMI
model9 <-'
#LATENT VARIABLE DEFINITION
LBZ0 =~ 1*BZN0 
LBZ30 =~ 1*BZ30 
LBZ60 =~ 1*BZ60
LBZ90 =~ 1*BZ90
LBZ120 =~ 1*BZ120 

LGLUK0 =~ 1*GLUK0
LGLUK30 =~ 1*GLUK30
LGLUK120 =~ 1*GLUK120

LFF0 =~ 1*FFAMI0
LFF30 =~ 1*FFAMI30
LFF60 =~ 1*FFAMI60
LFF90 =~ 1*FFAMI90
LFF120 =~ 1*FFAMI120

LINS0 =~ 1*INS0
LINS30 =~ 1*INS30
LINS60 =~ 1*INS60
LINS90 =~ 1*INS90
LINS120 =~ 1*INS120

#Latent mean Structure with intercepts
kappa =~ 1*BZN0 + 1*BZ30 + 1*BZ60 + 1*BZ90 + 1*BZ120
omega =~ 1*INS0 + 1*INS30 + 1*INS60 + 1*INS90 + 1*INS120
lambda =~ 1*GLUK0 + 1*GLUK30 + 1*GLUK120
iota =~ 1*FFAMI0 + 1*FFAMI30 + 1*FFAMI60 + 1*FFAMI90 + 1*FFAMI120

#intercepts
#mu: group mean per wave covariants 
BZN0 ~ mu1*1
BZ30 ~ mu2*1
BZ60 ~ mu3*1
BZ90 ~ mu4*1
BZ120 ~ mu5*1

#pi: group mean per wave insulin
INS0 ~ pi1*1
INS30 ~ pi2*1
INS60 ~ pi3*1
INS90 ~ pi4*1
INS120 ~ pi5*1

#zeta: group mean per wave glucagon
GLUK0 ~ zeta1*1
GLUK30 ~ zeta2*1
GLUK120 ~ zeta5*1

#eta: group mean per wave FFAMI
FFAMI0 ~ eta1*1
FFAMI30 ~ eta2*1
FFAMI60 ~ eta3*1
FFAMI90 ~ eta4*1
FFAMI120 ~ eta5*1

#kappa: random intercepts for covariants
#omega: random intercepts for Inuslin
#kappa ~~ kappa #variance
#omega ~~ omega #variance
#lambda ~~ lambda
#iota ~~ iota
#kappa ~~ omega #covariance
#kappa ~~ lambda
#kappa ~~ iota
#omega ~~ lambda
#omega ~~ iota
#lambda ~~ iota

#LATENT FACTORS COVARIANCES @0	
LBZ30 ~~ 0*LBZ0
LBZ60 ~~ 0*LBZ0
LBZ90 ~~ 0*LBZ0
LBZ120 ~~ 0*LBZ0

LINS30 ~~ 0*LINS0
LINS60 ~~ 0*LINS0
LINS90 ~~ 0*LINS0
LINS120 ~~ 0*LINS0

LGLUK30 ~~ 0*LGLUK0
LGLUK120 ~~ 0*LGLUK0

LFF30 ~~ 0*LFF0
LFF60 ~~ 0*LFF0
LFF90 ~~ 0*LFF0
LFF120 ~~ 0*LFF0

#LAGGED EFFECTS	
#effects to be the same across both lags.
LINS120 ~ alpha5*LINS90 + beta5*LBZ90 + delta5*LFF90
LINS90 ~ alpha4*LINS60 + beta4*LBZ60 + delta4*LFF60
LINS60 ~ alpha3*LINS30 + beta3*LBZ30 + gamma3*LGLUK30 + delta3*LFF30 
LINS30 ~ alpha2*LINS0 + beta2*LBZ0 + gamma2*LGLUK0 + delta2*LFF0

LGLUK120 ~ agluk5*LINS90 + bgluk5*LBZ90 + dgluk5*LFF90
LGLUK30 ~ agluk2*LINS0 + bgluk2*LBZ0 + ggluk2*LGLUK0 + dgluk2*LFF0

#variance
LINS0 ~~ LINS0
LINS30 ~~ u2*LINS30
LINS60 ~~ u3*LINS60
LINS90 ~~ u4*LINS90
LINS120 ~~ u5*LINS120
#variance
LBZ0 ~~ LBZ0
LBZ30 ~~ v2*LBZ30
LBZ60 ~~ v3*LBZ60
LBZ90 ~~ v4*LBZ90
LBZ120 ~~ v5*LBZ120
#variance
LGLUK0 ~~ LGLUK0
LGLUK30 ~~ w2*LGLUK30
LGLUK120 ~~ w5*LGLUK120
#variance
LFF0 ~~ LFF0
LFF30 ~~ x2*LFF30
LFF60 ~~ x3*LFF60
LFF90 ~~ x4*LFF90
LFF120 ~~ x5*LFF120

# CORRELATIONS	
LINS0 ~~ a0*LBZ0	
LINS30 ~~ a2*LBZ30
LINS60 ~~ a3*LBZ60
LINS90 ~~ a4*LBZ90
LINS120 ~~ a5*LBZ120

LINS0 ~~ b0*LGLUK0	
LINS30 ~~ b2*LGLUK30
LINS120 ~~ b5*LGLUK120

LINS0 ~~ c0*LFF0	
LINS30 ~~ c2*LFF30
LINS60 ~~ c3*LFF60
LINS90 ~~ c4*LFF90
LINS120 ~~ c5*LFF120
'
fit9 <- lavaan(model9, data=n.glucagon,missing='ml',
               int.ov.free = F,
               int.lv.free = F,
               auto.fix.first = F,
               auto.fix.single = F,
               auto.cov.lv.x = F,
               auto.cov.y = F,
               auto.var = F)
lavMatrix <-lavInspect(fit9, "cov.lv")
myImagePlot(lavMatrix)
summary(fit9,standardized = T)
Estimates<-parameterEstimates(fit9,standardized=T)
print(Estimates[nchar(Estimates[,"label"])==2,"std.all"])
print(Estimates[nchar(Estimates[,"label"])==2,"pvalue"])
coef(fit9)



