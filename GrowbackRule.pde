interface GrowthRule {
  public void growBack(Square s);
}

class GrowbackRule implements GrowthRule {
  /* Initializes a new GrowbackRule with the specified growth rate.
  *
  */
  
  int r;
  
  public GrowbackRule(int rate) {
    r = rate;
  }
  /* Increases the sugar in Square s by the growth rate, 
  *  up to the maximum value that can be stored in s. 
  *  Note: you should use only public methods of the Square class. 
  *  The Autograder will provide its own Square class, 
  *  which may not have the private methods or variable names you expect.
  */
  public void growBack(Square s) {
      s.setSugar(s.getSugar() + r);
  }
}

class SeasonalGrowbackRule implements GrowthRule {
  
  int alpha;
  int beta;
  int gamma;
  int equator;
  int numSquares;
  boolean northSummer;
  
  public SeasonalGrowbackRule(int alpha, int beta, int gamma, int equator, int numSquares) {
    this.alpha = alpha;
    this.beta = beta;
    this.gamma = gamma;
    this.equator = equator;
    this.numSquares = numSquares;
    this.northSummer = true;
  }
  
  public void growBack(Square s) {
    int calls = 0;
    
    //s is at or above the equator and it's northSummer OR
    //s is below the equator and it's southSummer
    if(((s.getY() <= this.equator) && this.northSummer == true) || ((s.getY() > this.equator) && this.northSummer == false)) { 
      //increase the sugar level by alpha to a max of the max sugar level on that square
      if(s.getSugar() < s.getMaxSugar()) {
        s.setSugar(s.getSugar() + alpha);
        calls++;
      }
    }
    
    //s is at or above the equator and it's southSummer OR
    //s is below the equator and it's northSummer
    if(((s.getY() <= this.equator) && this.northSummer == false) || (s.getY() > this.equator) && this.northSummer == true) {
      //increase the sugar level by beta to a max of the max sugar level on that square
      if(s.getSugar() < s.getMaxSugar()) {
        s.setSugar(s.getSugar() + beta);
        calls++;
      }
    }
    
    //if the rule has been called gamma*numSquares times since the last change of seasons
    if(calls == gamma * numSquares) {
      
      //if it's northSummer, change it to southSummer
      if(this.northSummer == true) {
        this.northSummer = false;
        //reset calls
        calls = 0;
      }
      
      //if it's southSummer, change it to northSummer
      if(this.northSummer == false) {
        this.northSummer = true;
        //reset calls
        calls = 0;
      }
    }
  }
  
  public boolean isNorthSummer() {
    
    //return true iff it's northSummer
    if(this.northSummer == true) {
      return true;
    }
    
    else {
      return false;
    }
  }
}
