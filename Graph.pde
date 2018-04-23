class Graph {

  int x;
  int y;

  int howWide;
  int howTall;

  String xlab;
  String ylab;

  public Graph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    this.x = x;
    this.y = y;

    this.howWide = howWide;
    this.howTall = howTall;

    this.xlab = xlab;
    this.ylab = ylab;
  }

  public void update(SugarGrid g) {
    rectMode(LEFT);
    fill(255);
    
    //white box for entire graph
    rect(x, y, x + this.howWide, y + this.howTall);

    fill(0);
    textSize(14.0);
    
    rectMode(CENTER);
    
    //x-label
    text(xlab, x + this.howWide / 2, y + this.howTall + 15);
    
    //y-label
    pushMatrix();
    translate(x, y);
    
    rotate(-PI/2.0);
    text(ylab, 0 - this.howTall / 2, 0 - 10);
    
    popMatrix();
    
    //x-axis
    stroke(0);
    strokeWeight(2);
    line(x, y + this.howTall, x + this.howWide, y + this.howTall);
    
    //y-axis
    line(x, y, x, y + this.howTall);
  }
}

abstract class LineGraph extends Graph {
  
  int updateCalls;
  
  public LineGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    
    //inherit superclass (Graph)
    super(x, y, howWide, howTall, xlab, ylab);
    
    //set# of update calls to 0
    updateCalls = 0;
  }
  
  //empty bc abstract method
  public abstract int nextPoint(SugarGrid g);
  
  //overrides superclass update
  public void update(SugarGrid g) {
    
    //if the # of update calls is 0, call Graph update()
    
    if (updateCalls == 0) {
      super.update(g);
    }
    
    //otherwise, call nextPoint(g) to get the y-coord of the next point in the line
    else {
      int nextPoint = this.nextPoint(g);
      
      stroke(0);
      strokeWeight(1);
      rect(x + updateCalls, y + howTall - nextPoint, 1, 1);
    
      //if the # of update calls is greater than the width of the graph, set the number of update
      //    calls back to 0, starting over
      if (updateCalls > this.howWide) {
        updateCalls = 0;
      }
    }
    
    updateCalls++;
  }
}

abstract class CDFGraph extends Graph {
  
  int numUpdates;
  int callsPerValue;
  
  public CDFGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
    super(x, y, howWide, howTall, xlab, ylab);
    
    this.callsPerValue = callsPerValue;
    numUpdates = 0;
  }
  
  public abstract void reset(SugarGrid g);
  
  public abstract int nextPoint(SugarGrid g);
  
  public abstract int getTotalCalls(SugarGrid g);
  
  public void update(SugarGrid g) {
    
    numUpdates = 0;
    
    super.update(g);
    this.reset(g);
    
    int numPerCell = howWide / this.getTotalCalls(g);
    
    while (numUpdates < this.getTotalCalls(g)) {
      rect(x + (numUpdates * numPerCell) + numPerCell/2, y + howTall - this.nextPoint(g), numPerCell, 1);
      
      numUpdates++;
    }
  }
}






//IMPLEMENTED GRAPHS
//avg amount of sugar held by agents on the sugarscape
class AverageSugar extends LineGraph {

  int sum;

  public AverageSugar(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> agentList = g.getAgents();
    sum = 0;

    for (int i = 0; i < agentList.size(); i++) {
      Agent currentAgent = agentList.get(i);
      sum += currentAgent.getSugarLevel();
    }

    return sum / agentList.size();
  }
}

//avg metabolism of agents on the sugarscape
class AverageMet extends LineGraph {

  int sum;

  public AverageMet(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> agentList = g.getAgents();
    sum = 0;

    for (int i = 0; i < agentList.size(); i++) {
      Agent currentAgent = agentList.get(i);
      sum += currentAgent.getMetabolism();
    }

    return sum / agentList.size();
  }
}

class WealthCDFGraph extends CDFGraph {

  float sugarSoFar;
  float totalSugar;
  int sum;
  float avg;
  ArrayList<Agent> agentsList;

  public WealthCDFGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
    super(x, y, howWide, howTall, xlab, ylab, callsPerValue);
  }

  public void reset(SugarGrid g) {
    agentsList = g.getAgents();

    QuickSorter qs = new QuickSorter();
    qs.sort(agentsList);

    totalSugar = 0;

    for (int i = 0; i < agentsList.size(); i++) {
      totalSugar += agentsList.get(i).getSugarLevel();
    }

    sugarSoFar = 0;
  }


  public int nextPoint(SugarGrid g) {
    sum = 0;

    if (callsPerValue > agentsList.size() - super.numUpdates * callsPerValue) {
      for (int i = super.numUpdates * callsPerValue; i < agentsList.size(); i++) {
        sum += agentsList.get(i).getSugarLevel();
      }
    } else {
      for (int i = super.numUpdates * callsPerValue; i < super.numUpdates * callsPerValue + callsPerValue; i ++) {
        sum += agentsList.get(i).getSugarLevel();
      }
    }
    avg = sum / callsPerValue;
    sugarSoFar += avg;
    float div = sugarSoFar/totalSugar * 1000;
    return (int) div;
  }

  public int getTotalCalls(SugarGrid g) {

    return agentsList.size() / callsPerValue;
  }
}

class Population extends LineGraph {

  public Population(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> agentList = g.getAgents();
    
    return agentList.size();
  }
}

class AgeGraph extends LineGraph {
  int sum;

  public AgeGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }

  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> agentList = g.getAgents();
    sum = 0;

    for (int i = 0; i < agentList.size(); i++) {
      Agent currentAgent = agentList.get(i);
      sum += currentAgent.getAge();
    }

    return sum / agentList.size();
  }
}

class CultureGraph extends LineGraph {
  int tribeA;
  int tribeB;
  
  public CultureGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }
  
  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> agentList = g.getAgents();
    int tribeA = 0;
    
    for(int i = 0; i < agentList.size(); i++) {
      Agent currentAgent = agentList.get(i);
      
      if(currentAgent.getTribe() == true) {
        tribeA++;
      }
    }
    
    return tribeA;
  }
}
