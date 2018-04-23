class Square {
  /* Fields
   *   where the square is
   *    - x and y coordinates (on the grid, right? not on the screen)
   *   how much sugar is on the square right now 
   *   the maximum amount of sugar that the square can hold
   *     (should the max amount be forced to be the same for every square, or
   *      should we rely on the object that calls the constructor to enforce that?)
   *   whether the square is currently occupied, and who is occupying it
   *    - this should be an Agent reference, null for unoccupied
   */
  private int x;
  private int y;
  private int sugarLevel;
  private int maxSugarLevel;
  private Agent agent;
  private int pollution;

  /* Constructor
   *   initializes a new Square with the specified initial and maximum sugar levels, 
   *   and the specified x and y coordinates. The square should be unoccupied.
   */
  public Square(int sLevel, int maxSLevel, int xi, int yi) {
    sugarLevel = sLevel;
    maxSugarLevel = maxSLevel;
    x = xi;
    y = yi;
    this.pollution = 0;
  }

  /* Returns the current level of sugar
   */
  public int getSugar() {
    return sugarLevel;
  }

  /* returns the maximum amount of sugar that can be stored here.
   *
   */
  public int getMaxSugar() {
    return maxSugarLevel;
  }

  /* returns the x coordinate of the Square
   *  (on the grid, right?)
   *
   */
  public int getX() {
    return x;
  }

  /* returns the y coordinate of the Square
   *  (on the grid, right?)
   *
   */
  public int getY() {
    return y;
  }

  /* Sets the sugar level to the specified value. 
   *  If the value is negative, sets the sugar level to 0 instead. 
   *  If the value is larger than the maximum amount of sugar that can be stored here, 
   *  sets the sugar level to the maximum value instead.
   *
   */
  public void setSugar(int howMuch) {
    if (howMuch < 0) {
      sugarLevel = 0;
    }
    else if (howMuch > maxSugarLevel) {
      sugarLevel = maxSugarLevel;
    }
    else {
      sugarLevel = howMuch;
    }
  }

  /* Sets the maximum sugar level to the specified value. 
   *  If the specified value is less than 0, sets the maximum sugar level to 0 instead. 
   *  Adjusts the current sugar level to ensure it is no larger than the updated maximum.
   *
   */
  public void setMaxSugar(int howMuch) {
    if (howMuch < 0) {
      maxSugarLevel = 0;
    }
    else {
      maxSugarLevel = howMuch;
    }
    this.setSugar(sugarLevel);
  }

  /* Returns the Agent object that currently occupies this Square, if any. 
   *  Returns null if no Agent is present. 
   *  You may make an empty Agent class to ensure your code compiles, and 
   *  to facilitate tests of your code. 
   *  The test system will provide its own Agent class.
   *
   */
  public Agent getAgent() {
    return this.agent;
  }

  /* Sets the Agent currently occupying this Square to the specified Agent a. 
   *  If this Square is not empty, then:
   *     unless the current agent is the same as the specified Agent or 
   *     the specified Agent is null, this should produce an error instead 
   *     (use assert(false)).
   *
   */
  public void setAgent(Agent a) {
    if (this.getAgent() == null || this.getAgent() == a || a == null) {
      this.agent = a;
    }
  }

  /* Draws a Square. 
   *  Not tested visually by the autograder. 
   *
   *  The Square should be drawn as a size*size square 
   *  at position (size*xOffset, size*yOffset). 
   *
   *  The square should have a while border 4 pixels wide. 
   *  The square should be colored as a function of its Sugar Levels. 
   *  An example color scheme is to use shades of yellow: 
   *    (255, 255, 255 - sugarLevel/6.0*255)
   *
   */
  public void display(int size) {
    rectMode(CENTER);
    strokeWeight(4);
    stroke(255);
    fill(255, 255, 255 - sugarLevel / 6.0 * 255);
    rect(x * size, y * size, size, size);
    if(this.agent != null) {
      this.agent.display(x, y, size);
    }
  }
  
  public int getPollution() {
    return this.pollution;
  }
  
  public void setPollution(int level) {
    this.pollution = level;
  }
}
