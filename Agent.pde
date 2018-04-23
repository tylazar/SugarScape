class Agent {
  private int metabolism;
  private int vision;
  private int sugarLevel;
  private MovementRule movementRule;
  private int age;
  private Character sex;
  private boolean[] culture;

  /* Sets the set of the agent, along with the other passed variables. 
   * If sex is something other than 'X' or 'Y', the program should 
   * throw an assertion error.
   */
   public Agent(int metabolism, int vision, int initialSugar, MovementRule mr, char sex) {
     this.metabolism = metabolism;
     this.vision = vision;
     this.sugarLevel = initialSugar;
     this.movementRule = mr;
     
     if(sex == 'X' || sex == 'Y') {
       this.sex = sex;
     }
     else {
       throw new AssertionError("Assertion Error: Invalid entry for field 'sex'");
     }
     
     culture = new boolean[11];
     
     for(int i = 0; i < culture.length; i++) {
       Random picker = new Random();
       int torf = picker.nextInt(2);
       
       if(torf == 0) {
         culture[i] = true;
       }
       else if(torf == 1) {
         culture[i] = false;
       }
     }
   }
  
  /* initializes a new Agent with the specified values for its 
   *  metabolism, vision, stored sugar, and movement rule.
   * 
   * Modify the existing constructor for the Agent class, so that 
   * it assigns the sex of the Agent to 'X' or 'Y' uniformly at random.
   *
   */
  public Agent(int met, int v, int iS, MovementRule m) {
    metabolism = met;
    vision = v;
    sugarLevel = iS;
    movementRule = m;
    age = 0;
    
    Character[] sexes = {X, Y};
    Random random = new Random();
    int index = random.nextInt(sexes.length);
    
    if(sexes[index] == 0) {
      this.sex = X;
    }
    else {
      this.sex = Y;
    }
    
    culture = new boolean[11];
     
     for(int i = 0; i < culture.length; i++) {
       Random picker = new Random();
       int torf = picker.nextInt(2);
       
       if(torf == 0) {
         culture[i] = true;
       }
       else if(torf == 1) {
         culture[i] = false;
       }
     }
  }
  
  /* returns the sex of the agent ('X' or 'Y').
   */
  public char getSex() {
    return this.sex;
  }

  /* returns the amount of food the agent needs to eat each turn to survive.
   */
  public int getMetabolism() {
    return metabolism;
  } 

  /* returns the agent's vision radius.
   */
  public int getVision() {
    return vision;
  } 

  /* returns the amount of stored sugar the agent has right now.
   */
  public int getSugarLevel() {
    return sugarLevel;
  } 

  /* returns the Agent's movement rule.
   */
  public MovementRule getMovementRule() {
    return movementRule;
  } 
  
  /* returns the Agent's age.
   */
  public int getAge() {
    return age;
  }
  
  public void setAge(int howOld) {
    if(howOld >= 0) {
      this.age = howOld;
    }
    
    else {
      assert(1 == 0);
    }
  }

  /* Moves the agent from source to destination. If the 
   * destination is already occupied, the program should 
   * crash with an assertion error instead, unless the destination 
   * is the same as the source.
   */
  public void move(Square source, Square destination) {
    if (destination.getAgent() != null) {
      assert(1 == 0);
    }
    else {
      source.setAgent(null);
      destination.setAgent(this);
    }
  }

  /* Reduces the agent's stored sugar level by its metabolic rate, 
   * to a minimum value of 0.
   */
  public void step() {
    if (this.getSugarLevel() > 0) {
      sugarLevel= sugarLevel - metabolism;
      age++;
    }
  } 

  /* returns true if the agent's stored sugar level is greater than 0, 
   * false otherwise. 
   */
  public boolean isAlive() {
    if (this.getSugarLevel() > 0) {
      return true;
    }
    else {
    return false;
    }
  } 

  /* The agent eats all the sugar at Square s. The agents sugar level is 
   * increased by that amount, and the amount of sugar on the square is 
   * set to 0.
   */
  public void eat(Square s) {
    sugarLevel = sugarLevel + s.getSugar();
    s.setSugar(0);
  } 
  
  public void display(int x, int y, int scale) {
    fill(0);
    ellipse(x * scale, y * scale, 3*scale/4, 3*scale/4);
    
    keyPressed();
    
    //standard display
    if(key == ' ') {
      fill(0);
      ellipse(x * scale, y * scale, 3*scale/4, 3*scale/4);
    }
    
    //display by tribe
    else if(key == 'c' || key == 'C') {
      if(this.getTribe() == true) {
        fill(255, 118, 118);
        ellipse(x * scale, y * scale, 3*scale/4, 3*scale/4);
      }

      else {
        fill(118, 178, 255);
        ellipse(x * scale, y * scale, 3*scale/4, 3*scale/4);
      }
    }
  }
  
  /* Provided that this agent has at least amount sugar, transfers 
   * that amount from this agent to the other agent. If there's not 
   * enough sugar, then throw an AssertionError.
   */
  public void gift(Agent other, int amount) {
    if(this.sugarLevel >= amount) {
      this.sugarLevel -= amount;
      other.sugarLevel += amount;
    }
    else {
      throw new AssertionError("Assertion Error: Agent does not have enough sugar");
    }
  }
  
  /* picks a random number between 1 and 11. If other's culture does 
   * not match this Agent's culture in the selected cultural attribute, 
   * then mutate other's culture to match the culture of this agent. Your 
   * Agent should (silently) chant "One of us, one of us. Gooba-gobble, 
   * gooba-gobble" while doing this.
   */
  public void influence(Agent other) {
    //random number from 1-11
    Random random = new Random();
    int attribute = 1 + random.nextInt(11);
    
    //if cultures are different, modify other's culture
    if(other.culture[attribute] != this.culture[attribute]) {
      other.culture[attribute] = this.culture[attribute];
    }
  }
  
  /* For each of the 11 dimensions of culture, set this Agent's value for 
   * that dimension to be one of the two parent values, selected uniformly 
   * at random. Important: do not simply take all the cultural values of 
   * one parent. Pick a different parent for each cultural dimension 
   * separately.
   */
  public void nurture(Agent parent1, Agent parent2) {
    //loop for each culture attribute
    for(int i = 0; i < culture.length; i++) {
      //get a random choice
      Random randn = new Random();
      int nurturer = randn.nextInt(2);
      
      //pick parent1 to nurture
      if(nurturer == 0) {
        this.culture[i] = parent1.culture[i];
      }
      
      //pick parent2 to nurture
      else if(nurturer == 1) {
        this.culture[i] = parent2.culture[i];
      }
    }
  }
  
  /* Returns true only if this Agent's culture contains more true values 
   * than false values. Otherwise returns false.
   */
  public boolean getTribe() {
    int trues = 0;
    int falses = 0;
    
    for(Boolean b : culture) {
      if(b == true) {
        trues++;
      }
      
      else if(b == false) {
        falses++;
      }
    }
    
    if(trues > falses) {
      return true;
    }
    
    else {
      return false;
    }
  }
}
