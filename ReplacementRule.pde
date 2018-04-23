import java.util.LinkedList;
import java.util.Random;

class ReplacementRule {
  
  int minAge;
  int maxAge;
  AgentFactory fac;
  HashMap<Agent, Integer> maxAgents;
  
  public ReplacementRule(int minAge, int maxAge, AgentFactory fac) {
    this.minAge = minAge;
    this.maxAge = maxAge;
    this.fac = fac;
  }
  
  public boolean replaceThisOne(Agent a) {
    LinkedList<Integer> lifespans = new LinkedList<Integer>();
    LinkedList<Agent> agents = new LinkedList<Agent>();
    
    Random rand = new Random();
    int lifespan = rand.nextInt((maxAge - minAge + 1) + minAge);
    
    if(a == null) {
      return false;
    }
    
    if(a.isAlive() == false) {
      agents.add(a);
      return true;
    }
    
    if(agents.contains(a) == false) {
      lifespans.add(lifespan);
      agents.add(a);
    }
    
    if(a.getAge() > lifespan) {
      a.setAge(maxAge + 1);
      return true;
    }
    
    else {
      return false;
    }
  }
  
  public Agent replace(Agent a, List<Agent> others) {
    Agent replacement = fac.makeAgent();
    return replacement;
  }
}
