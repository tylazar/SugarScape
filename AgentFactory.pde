import java.util.Random;

class AgentFactory {
  private int minMetabolism;
  private int maxMetabolism;
  private int minVision;
  private int maxVision;
  private int minInitialSugar;
  private int maxInitialSugar;
  MovementRule m;
  
  public AgentFactory(int minMetabolism, int maxMetabolism, int minVision, int maxVision, int minInitialSugar, int maxInitialSugar, MovementRule m) {
    this.minMetabolism = minMetabolism;
    this.maxMetabolism = maxMetabolism;
    this.minVision = minVision;
    this.maxVision = maxVision;
    this.minInitialSugar = minInitialSugar;
    this.maxInitialSugar = maxInitialSugar;
  }
  
  public Agent makeAgent() {
    //generate random values
    Random rand = new Random();
    int metabolism = rand.nextInt((this.maxMetabolism - this.minMetabolism + 1) + this.minMetabolism);
    int vision = rand.nextInt((this.maxVision - this.minVision + 1) + this.minVision);
    int sugarLevel = rand.nextInt((this.maxInitialSugar - this.minInitialSugar + 1) + this.minInitialSugar);
    
    //create agent with random values
    Agent a = new Agent(metabolism, vision, sugarLevel, m);
    return a;
  }
}