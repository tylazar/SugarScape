import java.lang.Math;
import java.util.LinkedList;
import java.util.Random;

class SugarGrid {

  private int w;
  private int h;
  private int sideLength;
  private GrowthRule gRule;
  private Square[][] gridArray;
  private ArrayList<Agent> agents;

  public SugarGrid(int w0, int h0, int sideL, SeasonalGrowbackRule g) {
    w = w0;
    h = h0;
    sideLength = sideL;
    gRule = g;
    gridArray = new Square[w][h];
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        gridArray[i][j] = new Square(0, 0, i, j);
      }
    }
    agents = new ArrayList<Agent>();
  }

  /* Accessor methods for the named variables.
   *
   */
  public int getWidth() {
    return this.w;
  }

  public int getHeight() {
    return this.h;
  }

  public int getSquareSize() {
    return sideLength; //stubbed
  }

  /* returns respectively the initial or maximum sugar at the Square 
   *  in row i, column j of the grid.
   *
   */
  public int getSugarAt(int i, int j) {
    return this.gridArray[i][j].getSugar();
  }

  public int getMaxSugarAt(int i, int j) {
    return this.gridArray[i][j].getMaxSugar();
  }

  public ArrayList<Agent> getAgents() {
      for(int i = 0; i < w; i++) {
        for(int j = 0; j < h; j++) {
          if(this.getAgentAt(i, j) != null) {
            Agent a = this.getAgentAt(i, j);
            agents.add(a);
          }
        }
      }
      return agents;
    }
    
  /* returns the Agent occupying the square at position (i,j) in the grid, 
   *  or null if no agent is present there.
   *
   */

  public Agent getAgentAt(int i, int j) {
    return this.gridArray[i][j].getAgent();
  }

  /* places Agent a at Square(x,y), provided that the square is empty. 
   *  If the square is not empty, the program should crash with an assertion failure.
   *
   */
  public void placeAgent(Agent a, int x, int y) {
    if (this.gridArray[x][y].getAgent() == null || this.gridArray[x][y].getAgent() == a || a == null) {
      this.gridArray[x][y].setAgent(a);
    } else {
      assert(1==0);
    }
  }

  /* A method that computes the Euclidian distance between two squares on the grid 
   *  at (x1,y1) and (x2,y2). 
   *  Points are indexed from (0,0) up to (width-1, height-1) for the grid. 
   *  The formula for Euclidean distance is normally sqrt( (x2-x1)2 + (y2-y1)2 ) However...
   *  
   *  As in the book, the grid is a torus. 
   *  This means that an Agent that moves off the top of the grid ends up at the bottom 
   *  (and vice versa), and 
   *  an Agent that moves off the left hand side of the grid ends up on the right hand 
   *  side (and vice versa). 
   *
   *  You should return the minimum euclidian distance between the two points. 
   *  For example, euclidianDistance((1,1), (19,19)) on a 20x20 grid would be 
   *  sqrt(2*2 + 2*2) = sqrt(8) ~ 3, and not sqrt(18*18 + 18*18) = sqrt(648) ~ 25. 
   *
   *  The built-in Java method Math.sqrt() may be useful.
   *
   */

  public double euclidianDistance(Square s1, Square s2) {
    int s1X = s1.getX();
    int s1Y = s1.getY();
    int s2X = s2.getX();
    int s2Y = s2.getY();
    int ingridX = abs(s1X-s2X);
    int ingridY = abs(s1Y-s2Y);
    int outgridX = abs(  min(abs(s1X-0), abs(w-s1X)) + min(abs(s2X-0), abs(w-s2X))  );
    int outgridY = abs(  min(abs(s1Y-0), abs(h-s1Y)) + min(abs(s2Y-0), abs(h-s2Y))  );
    //println(s1X, s1Y, s2X, s2Y);
    //println( ingridX, ingridY, outgridX, outgridY);
    //println(w);
    //println(h);
    int finalX = min(outgridX, ingridX);
    int finalY = min(outgridY, ingridY);
    return Math.sqrt(finalX*finalX + finalY*finalY);
  }

  /* Creates a circular blob of sugar on the gird. 
   *  The center of the blob is at position (x,y), and 
   *  that Square is updated to store a maximum of max sugar or 
   *  its current maximum value, whichever is greater. 
   *
   *  Then, every square within euclidian distance of radius is updated 
   *  to store a maximum of (max-1) sugar, or its current maximum value, 
   *  whichever is greater. 
   *
   *  Then, every square within euclidian distance of 2*radius is updated 
   *  to store a maximum of (max-2) sugar, or its current maximum value, 
   *  whichever is greater. 
   *
   *  This process continues until every square has been updated. 
   *  Any Square that has a new maximum value 
   *  should also have its Sugar level set to this maximum.
   *
   */
  public void addSugarBlob(int x, int y, int radius, int max) {
    int increment = max;
    while (increment > 0) {
      for (int i = 0; i < w; i++) {
        for (int j = 0; j < h; j++) {
          double euDist = euclidianDistance(this.gridArray[i][j], this.gridArray[x][y]);
          if (euDist < radius * increment) {
            int sug = max - increment;
            gridArray[i][j].setMaxSugar(sug);
            gridArray[i][j].setSugar(sug);
          }
        }
      }
      increment--;
    }
  }



  /* Returns a linked list containing radius squares in each cardinal direction, 
   *  centered on (x,y). 
   *
   *  For example, generateVision(5,5,2) should return the squares 
   *   (5,5), (4,5), (3,5), (6,5), (7,5), (5,4), (5,3), (5,6), and (5,7). 
   *
   *  Your program may do whatever it likes if (x,y) is not a point on the grid, 
   *  or radius is negative. 
   *
   *  When radius is 0, it should return a list containing only (x,y). 
   *
   */
  public LinkedList<Square> generateVision(int x, int y, int radius) {
    LinkedList<Square> l = new LinkedList();
    if (radius == 0) {
      l.add(this.gridArray[x][y]);
    } else {
      for (int i = 0; i < w; i++) {
        for (int j = 0; j < h; j++) {
          int euDist = (int) euclidianDistance(this.gridArray[i][j], this.gridArray[x][y]);
          if (euDist <= radius) {
            l.add(this.gridArray[i][j]);
          }
        }
      }
    }
    return l;
  }

  public void update() {
    //LinkedList<Agent> processedAgents = new LinkedList<Agent>();
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        Agent current = this.getAgentAt(i, j);
        //apply growbackrule to square, possibly increasing its sugarlevel
        Square currentSquare = gridArray[i][j];
        gRule.growBack(currentSquare);
        //2 -- if square is not occupied, bypass conditional
        if (current != null) {
          //3.1 -- generate vision
          LinkedList<Square> vision = this.generateVision(i, j, current.getVision());
          //3.2 apply movement rule
          MovementRule mr = new SugarSeekingMovementRule();
          Square movementResult = mr.move(vision, this, this.gridArray[w/2][h/2]);
          //3.3 move agent to preferred square if square is not occupied
          if (movementResult.getAgent() == null) {
            current.move(this.gridArray[i][j], movementResult);
          }
          //3.4 agent consumes stored sugar based on metabolic rate
          current.step();
          //3.5 if agent is dead, mark current square unoccupied
          if (current.isAlive() == false) {
            this.gridArray[i][j].setAgent(null);
          }
          //3.6 if agent is alive, it eats all the sugar on the current square
          if (current.isAlive() == true) {
            current.eat(this.gridArray[i][j]);
          }
        }
      }
    }
  }

  void display() {
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        this.gridArray[i][j].display(sideLength);
      }
    }
  }
  
  public void addAgentAtRandom(Agent a) {
    //make two random numbers
    Random rand = new Random();
    int irand = rand.nextInt(w + 0);
    int jrand = rand.nextInt(h + 0);
    
    if(this.gridArray[irand][jrand] == null) {
      this.gridArray[irand][jrand].setAgent(a);
    }
    
    else {
      int irand2 = rand.nextInt(w + 0);
      int jrand2 = rand.nextInt(h + 0);
      this.gridArray[irand2][jrand2].setAgent(a);
    }
  }
  
  public void killAgent(Agent a) {
    a.sugarLevel = 0;
  }
}
