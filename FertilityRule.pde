class FertilityRule {
  
  private Integer[] childbearingX; //ages between which childbearing begins for X sex
  private Integer[] childbearingY; //ages between which childbearing begins for Y sex
  private Integer[] climactericX; //ages between which childbearing ends for X sex
  private Integer[] climactericY; //ages between which childbearing ends for Y sex
  Map<Agent, Integer> agentChildbearing;
  Map<Agent, Integer> agentClimacteric;
  Map<Agent, Integer> agentSugar;
  
  /* Initializes a new FertilityRule with the specified ages 
   * for the start of the fertile and infertile periods for 
   * agents of each sex. For example, the map {'X' -> [12,15], 
   * 'Y' ->[12,15]} might be used to indicate that the start of 
   * the childbearing period is between 12 and 15 years (inclusive) 
   * for both sexes.
   */
  public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character, Integer[]> climactericOnset) {
    this.childbearingX = childbearingOnset.get(X);
    this.childbearingY = childbearingOnset.get(Y);
    this.climactericX = climactericOnset.get(X);
    this.climactericY = climactericOnset.get(Y);
  }
  
  /* 
   * see replaceThisOne() in ReplacementRule class
   *
   *Determines whether Agent a is fertile, 
   * according to the rules listed below:
   * 
   * If a is null or dead, then remove all
   * records of it from any storage it may
   * be present in, and return false.
   * 
   * Otherwise, if this is the first time a was 
   * passed to this function:
   *    Generate a random number for the onset of 
   *    childbearing age (c) and the age of the start 
   *    of a's climacteric (o), based on the fields of 
   *    this class. Remember: use inclusive ranges!
   *
   *    Store those generated numbers in a way that is 
   *    associated with a for later retrieval.
   *
   *    Store the current sugar level of a for retrieval as well.
   *
   * Regardless of whether this is the first time, return true only if:
   *    c <= a.getAge() < o, using the values of c and o that were stored 
   *    for this agent earlier.
   *
   *    a currently has at least as much sugar as it did the first time 
   *    we passed it to this function.
   */
  public boolean isFertile(Agent a) {
    LinkedList<Agent> agents = new LinkedList<Agent>();
    int c = 0;
    int o = 0;
    
    //if a is null or dead
    if(a == null || a.isAlive() == false) {
      if(agents.contains(a)) {
        agents.remove(a);
      }
      a = null;
      return false;
    }
    
    //if this is the first time a was passed to the function
    if(agents.contains(a) == false) {
      //generate a random chidbearing age c
      Random randC = new Random();
      Random randO = new Random();
      
      //for sex X
      if(a.getSex() == X) {
        //random childbearing age c
        c = randC.nextInt((childbearingX[1] - childbearingX[0] + 1) + childbearingX[0]);
        agentChildbearing.put(a, c);
        //random climacteric age o
        o = randO.nextInt((climactericX[1] - climactericX[0] + 1) + climactericX[0]);
        agentClimacteric.put(a, o);
        
        agentSugar.put(a, a.getSugarLevel());
      }
      
      //for sex Y
      if(a.getSex() == Y) {
        //random childbearing age c
        c = randC.nextInt((childbearingY[1] - childbearingY[0] + 1) + childbearingY[0]);
        agentChildbearing.put(a, c);
        //random climacteric age o
        o = randO.nextInt((climactericY[1] - climactericY[0] + 1) + climactericY[0]);
        agentClimacteric.put(a, o);
        
        agentSugar.put(a, a.getSugarLevel());
      }
    }
    
    //if agent is of childbearing age and has enough sugar
    if((c <= a.getAge() && a.getAge() < o) && (a.getSugarLevel() >= agentSugar.get(a))) {
      return true;
    }
    
    else {
     return false; 
    }
  }
  
  /* Determines whether the two passed agents can form a breeding pair 
   * or not. local is the radius 1 vision around agent a. Returns true 
   * only if:
   * 
   * a is fertile.
   * b is fertile.
   * a and b are of different sexes.
   * b is on one of the Squares in local.
   * At least one of the Squares in local is empty.
   */
  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local) {
    int empty = 0;
    
    //check for empty squares in local
    for(Square s : local) {
      if(s.getAgent() == null) {
        empty++;
      }
    }
    
    if((isFertile(a) == true) && (isFertile(b) == true) && (a.getSex() != b.getSex()) && (local.contains(b) == true) && (empty > 0)) {
      return true;
    }
    
    else {
     return false; 
    }
  }
  
  /* Creates and places a new Agent that is the offspring of a and b, 
   * according to the process below. The local visions of each agent are 
   * provided.
   *
   * If a cannot breed with b and b cannot breed with a, then return null.
   *
   * Otherwise:
   *    Pick one of the parents' metabolisms, uniformly at random.
   *
   *    Pick one of the parents' visions, uniformly at random.
   *
   *    Take the MovementRule from Agent a.
   *
   *    Pick a sex uniformly at random.
   *
   *    Create a new agent (the child) using the parameters computed in 
   *    the previous 4 steps, and 0 initial sugar.
   *
   *    Have each of the parents (a and b) gift half their initial sugar 
   *    amounts to the child.
   *
   *    Pick a random square from aLocal or bLocal that does not have 
   *    an Agent on it, and place the child on that square.
   *
   *    Return the child.
   */
  public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal) {
    Agent c = null;
    
    //if a cannot breed with b and b cannot breed with a
    if((canBreed(a, b, aLocal) == false) && (canBreed(b, a, bLocal) == false)) {
      return null;
    }
    
    else {
      //find and store empty squares
      int emptya = 0;
      int emptyb = 0;
      LinkedList<Square> asquares = new LinkedList<Square>();
      LinkedList<Square> bsquares = new LinkedList<Square>();
      
      for(Square s : aLocal) {
        if(s.getAgent() == null) {
          emptya++;
          asquares.add(s);
        }
      }
      
      for(Square s : bLocal) {
        if(s.getAgent() == null) {
          emptyb++;
          bsquares.add(s);
        }
      }
      
      //start making the child agent
      LinkedList<Integer> metabolisms = new LinkedList<Integer>();
      LinkedList<Integer> visions = new LinkedList<Integer>();
      int newMet = 0;
      int newVis = 0;
      MovementRule mr = null;
      Character newSex = null;
      
      metabolisms.add(a.getMetabolism());
      metabolisms.add(b.getMetabolism());
      visions.add(a.getVision());
      visions.add(b.getVision());
      
      //get a random metabolism
      Random randmet = new Random();
      int metnum = randmet.nextInt(metabolisms.size() - 1);
      
      if(metnum == 0) {
        newMet = a.getMetabolism();
      }
      
      if(metnum == 1) {
        newMet = b.getMetabolism();
      }
      
      //get a random vision
      Random randvis = new Random();
      int visnum = randvis.nextInt(visions.size() - 1);
      
      if(visnum == 0) {
        newVis = a.getVision();
      }
      
      if(visnum == 1) {
        newVis = b.getVision();
      }
      
      //get a's movement rule
      mr = a.getMovementRule();
      
      //get a random sex
      Random random = new Random();
      int index = random.nextInt(2);
    
      if(index == 0) {
        newSex = X;
      }
      else {
        newSex = Y;
      }
      
      //make a new agent
      c = new Agent(newMet, newVis, 0, mr, newSex);
      
      //gift half of each parent's sugar
      int gift = (a.getSugarLevel()/2) + (b.getSugarLevel()/2);
      
      a.sugarLevel -= a.sugarLevel/2;
      b.sugarLevel -= b.sugarLevel/2;
      c.sugarLevel += gift;
      
      //nurture c before placing
      c.nurture(a, b);
      
      //~start finding place~
      //pick a random square to place c
      Random rands = new Random();
      
      //if you have to choose from a's vision
      if(emptya > 0 && emptyb == 0) {
        int squareina = rands.nextInt(asquares.size() - 1);
        asquares.get(squareina).setAgent(c);
      }
      
      //if you have to choose from b's vision
      else if(emptya == 0 && emptyb > 0) {
        int squareinb = rands.nextInt(bsquares.size() - 1);
        bsquares.get(squareinb).setAgent(c);
      }
      
      //if they both have eligible squares
      else if(emptya > 0 && emptyb > 0) {
        //get a random number between 0 (inc) and 2 (exc)
        Random choice = new Random();
        int aorb = choice.nextInt(2);
        
        //if 0, choose from a's pool
        if(aorb == 0) {
          int squareina = random.nextInt(asquares.size() - 1);
          asquares.get(squareina).setAgent(c);
        }
        
        //if 1, choose from b's pool
        else if(aorb == 1) {
          int squareinb = random.nextInt(bsquares.size() - 1);
          bsquares.get(squareinb).setAgent(c);
        }
      }
    }
    return c;
  }
}
