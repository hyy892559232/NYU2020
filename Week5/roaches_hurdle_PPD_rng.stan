functions {
  matrix roaches_hurdle_PPD_rng(int S, vector log_roach1, vector treatment,
                                vector senior, vector offset) {
    int N = rows(log_roach1);
    matrix[S, N] PPD;
    for (s in 1:S) {
      // hurdle parameters
      real gamma = normal_rng(0, 2);
      real lambda[3] = normal_rng([0,0,0], 1);
      
      // negative binomial parameters
      real alpha = normal_rng(0, 5);
      real beta[3] = normal_rng([0,0,0], 2);
      real phi = exponential_rng(1);
      
      for (n in 1:N) {
        real log_odds = gamma + lambda[1] * (log_roach1[n] == 0) 
                      + lambda[2] * treatment[n] + lambda[3] * senior[n];
        int hurdle = bernoulli_logit_rng(log_odds); // same as bernoulli_rng(inv_logit(log_odds));
        if (hurdle == 1) {
          real eta = alpha + offset[n] + beta[1] * log_roach1[n] 
                   + beta[2] * treatment[n] + beta[3] * senior[n];
          int y_ = neg_binomial_2_log_rng(eta, phi); // may be zero
          while(y_ == 0) y_ = neg_binomial_2_log_rng(eta, phi);
          PPD[s, n] = y_;
        } else PPD[s, n] = 0;
      }
    }
    return PPD;
  }
}


/*
// my version
functions {
  matrix roaches_PPD_rng(int S, vector log_roach1, vector treatment,
                         vector senior, vector offset) {
    int N = rows(log_roach1);
    
    vector[N] log_roach1_ = log_roach1 - mean(log_roach1);
    vector[N] treatment_ = treatment - mean(treatment);
    vector[N] senior_ = senior - mean(senior);
    vector[N] offset_ = offset - mean(offset); // mean centered
    matrix[S, N] PPD;
    
    for (s in 1:S) {
      // prior for negbinomial
      real alpha = normal_rng(mean(log_roach1), 3);
      real beta[3] = normal_rng([0,0,0], 2);
      real phi = exponential_rng(1);

        
        // Prior for bernoulli
        real betab[3] = normal_rng([0,0,0],1);
        real intercept = normal_rng(0,1);
        
        
        for (n in 1:N){
  
        real log_odds = intercept + betab[1]*treatment[n] +betab[2]*senior[n] +betab[3]* (log_roach1[n]==0);
        int zero_or_not_ =  bernoulli_logit_rng(log_odds);

          if (zero_or_not_ ==0) {
            PPD[s, n] =0;
          } else{
        real eta = alpha + offset + beta[1] * log_roach1[n] + 
        beta[2] * treatment[n] + beta[3] * senior[n];
         int  ppd_=neg_binomial_2_log_rng(eta,phi);
            while(ppd_== 0) ppd_=neg_binomial_2_log_rng(eta,phi);
            
            PPD[s, n] =ppd_;
          }
    }
    }
    return PPD;
    
  }
}

*/
