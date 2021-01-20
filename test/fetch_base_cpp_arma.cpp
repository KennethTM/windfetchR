// add RcppArmadillo to package description file
  
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;

// [[Rcpp::export]]
arma::mat fetch_base_cpp_arma(NumericMatrix x, double res) {
  
    double accumulator = 0;
    int rows = x.nrow();
    int cols = x.ncol();

    arma::mat out(rows, cols);

    for(int j = 0; j < cols; j++){
      
      for(int i = 0; i < rows; i++){  

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

