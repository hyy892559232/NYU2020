
library(rstanarm)
library(brms)
library(haven)
unzip("100.00019026_supp.zip")
oregon <- as_factor(read_dta(file.path("19026_supp", "Data", "individual_voting_data.dta")))


s=100
vote_<-replicate(s,{
        alpha=rnorm(0,2)
        beta1=alpha_a+beta1_a*oregon$zip_hh_inc_list
        beta2=rnorm(1,0,1)
        alpha_a=rnorm(1,0,1)
        beta1_a=rnorm(1,0,1)
        error=rlogis(1)
        log_odds=alpha+beta1*oregon$age+beta2*oregon$zip_hh_inc_list+error
        log_odds}
        
  
)