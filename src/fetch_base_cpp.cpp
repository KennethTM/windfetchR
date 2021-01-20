#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix fetch_base_cpp(NumericMatrix x, double res) {
  
    double accumulator = 0;

    NumericMatrix out(x.nrow(), x.ncol());

    for(int j = 0; j < x.ncol(); j++){
      
      for(int i = 0; i < x.nrow(); i++){  

        if(x(i, j) == 1){
          
          accumulator += res;
          
        }else{
          
          accumulator = 0;
          
        }

        out(i, j) = accumulator;
        
      }
      
    }

    return out;
    
}

