import java.util.*;

interface MovementRule {
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle);
}

class SugarSeekingMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
   *
   */
  public SugarSeekingMovementRule() {
  }

  /* For now, returns the Square containing the most sugar. 
   *  In case of a tie, use the Square that is closest to the middle according 
   *  to g.euclidianDistance(). 
   *  Squares should be considered in a random order (use Collections.shuffle()). 
   */
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    int mostSugar = 0;
    Square mostSugarSquare = g.gridArray[0][0];
    Square current = null;
    Collections.shuffle(neighbourhood);
    for (int i = 0; i < neighbourhood.size(); i++) {
      current = neighbourhood.get(i);
      if (current.getSugar() > mostSugar) {
        mostSugarSquare = current;
        mostSugar = mostSugarSquare.getSugar();
      }
      else if (current.getSugar() == mostSugar) {
        double mostSugarDist = g.euclidianDistance(mostSugarSquare, middle);
        double currentSugarDist = g.euclidianDistance(current, middle);
        if (mostSugarDist > currentSugarDist) {
          mostSugarSquare = current;
        }
      }
    }
   
    return mostSugarSquare; // stubbed
  }
}

class PollutionMovementRule implements MovementRule {
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    
    int pollutionRatio = 1;
    Square highestRatioSquare = g.gridArray[0][0];
    Square current = null;
    
    Collections.shuffle(neighbourhood);
    
    for(int i = 0; i < neighbourhood.size(); i++) {
      current = neighbourhood.get(i);
      
      //if square has no pollution
      if(current.getPollution() == 0) {
        highestRatioSquare = current;
        pollutionRatio = highestRatioSquare.getSugar();
      }
      
      //if the ratio is greater
      else if(current.getSugar()/current.getPollution() > pollutionRatio) {
        highestRatioSquare = current;
        pollutionRatio = highestRatioSquare.getSugar()/highestRatioSquare.getPollution();
      }
      
      //if two squares have equal ratio
      else if(current.getSugar()/current.getPollution() == pollutionRatio) {
        double highestRatioDist = g.euclidianDistance(highestRatioSquare, middle);
        double currentRatioDist = g.euclidianDistance(current, middle);
        
        //move if the distance is smaller
        if(highestRatioDist > currentRatioDist) {
          highestRatioSquare = current;
        }
      }
    }
   
    return highestRatioSquare; // stubbed
  }
}

class CombatMovementRule extends SugarSeekingMovementRule {
  
  private int alpha;
  private LinkedList<Square> neighbourhood;
  private SugarGrid g;
  
  /* Initializes a new CombatMovementRule with the specified value 
   * of alpha.
   */
  public CombatMovementRule(int alpha) {
    this.alpha = alpha;
  }
  
  /* Moves the Agent according to the Combat Rule definition on page 
   * 83 of the textbook. This is quite complex, and it may be useful 
   * to write helper functions for several of them:
   *
   * Remove from neighbourhood any Square containing an Agent of the 
   * same tribe as the Agent on the middle Square.
   */
   public void removeTribe() {
     int middle = neighbourhood.size()/2;
     Agent middleAgent = neighbourhood.get(middle).getAgent();
     boolean tribe = middleAgent.getTribe(); 
     
     for(Square s : neighbourhood) {
       if(s.getAgent() != null && s.getAgent() != middleAgent && s.getAgent().getTribe() == tribe) {
         neighbourhood.remove(s);
       }
     }
   }
   
  /*
   * Remove from neighbourhood any Square containing an Agent that has 
   * at least as much sugar as the agent on the middle square.
   */
   public void removeSugar() {
     int middle = neighbourhood.size()/2;
     Agent middleAgent = neighbourhood.get(middle).getAgent();
     
     for(Square s : neighbourhood) {
       if(s.getAgent() != null && s.getAgent().getSugarLevel() >= middleAgent.getSugarLevel()) {
         neighbourhood.remove(s);
       }
     }
   }
   
  /*
   * For each remaining Square in neighbourhood that contains an Agent, 
   * get the vision that the Agent on middle would have if it moved to 
   * that Square. If the vision contains any Agent with more sugar than 
   * the Agent on middle, and the opposite tribe, then remove the Square 
   * in question from neighbourhood.
   */
   public void findEnemies() {
     int middle = neighbourhood.size()/2;
     Agent middleAgent = neighbourhood.get(middle).getAgent();
     
     for(Square s : neighbourhood) {
       if(s.getAgent() != null) {
         LinkedList<Square> vision = g.generateVision(s.getX(), s.getY(), middleAgent.getVision());
         
         for(Square q : vision) {
           if(q.getAgent() != null && q.getAgent().getSugarLevel() > middleAgent.getSugarLevel() && q.getAgent().getTribe() != middleAgent.getTribe()) {
             neighbourhood.remove(s);
           }
         }
       }
     }
   }
   
  /*
   * Replace each Square in neighbourhood that still has an Agent with a 
   * new Square that has the same x and y coordinates, but a Sugar and 
   * MaximumSugar level that are increased by the minimum of alpha and 
   * the sugar level of the occupying agent.
   */
   public Agent replace() {
     Agent a = null;
     for(Square s : neighbourhood) {
       a = s.getAgent();
       if(a != null) {
         Square newSquare = new Square(s.getSugar() + alpha + a.getSugarLevel(), s.getMaxSugar() + alpha + a.getSugarLevel(), s.getX(), s.getY());
         newSquare.setAgent(a);
         neighbourhood.remove(s);
         neighbourhood.add(newSquare);
       }
     }
     return a;
   }
   
  /*
   * Call the superclass movement method on what's left of neighbourhood, 
   * and, if necessary, determine which original square corresponded to a 
   * replacement square (if that's what was returned). The original and 
   * replacement squares will have the same x and y coordinates. Store the 
   * result (which must be one of the original squares in neighbourhood) 
   * in target.
   *
   * If target is not occupied, just return target.
   *
   * Otherwise, store the occupying agent as casualty.
   *
   * Remove casualty from its Square.
   *
   * Increase the wealth of this agent by the minimum of casualty's 
   * sugarlevel  and alpha
   *
   * Call the SugarGrid's killAgent() method on casualty.
   *
   * Return target.
   */
   
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    this.removeTribe();
    this.removeSugar();
    this.findEnemies();
    Agent a = this.replace();
    Square target = super.move(neighbourhood, g, middle);
    
    if(target.getAgent() == null) {
      return target;
    }
    
    else {
      Agent casualty = target.getAgent();
      target.setAgent(null);
      a.sugarLevel += casualty.sugarLevel + alpha;
      g.killAgent(casualty);
    }
    
    return target;
  }
}
