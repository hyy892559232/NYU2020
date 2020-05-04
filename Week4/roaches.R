library(rstanarm)
roaches <- roaches[roaches$roach1 > 0, ]; str(roaches)

roaches$log_roach1 <- log(roaches$roach1)
roaches2_ <- t(replicate(100, {
  alpha_ <- rnorm(1, mean = log(42), sd = 3)
  beta_lag <- rnorm(1, mean = 1, sd = 1)
  beta_trt <- rnorm(1, mean = 0, sd = 0.5)
  beta_snr <- rnorm(1, mean = 0, sd = 0.5)
  
  eta_ <- with(roaches, alpha_ + log(exposure2) - mean(log(exposure2)) + 
                 beta_lag * (log_roach1 - mean(log_roach1)) + 
                 beta_trt * (treatment - mean(treatment)) + 
                 beta_snr * (senior - mean(senior)))
  mu_ <- exp(eta_) # too big!
  roaches_ <- rpois(n = length(mu_), mu_)
  roaches_
}))






##my version
library(rstanarm)

roaches <- roaches[roaches$roach1 > 0, ]
summary(roaches)
S=200
roaches_<-replicate(S,{
  alpha_<-rnorm(1,mean=log(42),3)
  beta1_<-rnorm(1,0,1)
  beta2_<-rnorm(1,0,0.5)
  beta3_<-rnorm(1,0,0.5)
  eta_<-alpha_+beta1_*log(roaches$roach1)+beta2_*roaches$senior+beta3_*roaches$treatment+log(roaches$exposure2)
  mu_<-exp(eta_)
  roaches_<-rpois(length(mu_),mu_)
  roaches_
})









