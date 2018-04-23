import java.util.LinkedList;

SugarGrid myGrid = new SugarGrid(50, 40, 20, new SeasonalGrowbackRule(1, 3, 5, 100, 10));
AgentFactory af = new AgentFactory(1, 4, 1, 4, 25, 75, new SugarSeekingMovementRule());

void setup() {
  
  size(1000, 800);
  
  myGrid.addSugarBlob(40, 10, 3, 8);
  myGrid.addSugarBlob(10, 30, 2, 8);
  
  for(int i = 0; i < 100; i++) {
    Agent a = af.makeAgent();
    myGrid.addAgentAtRandom(a);
  }
  
  myGrid.display();
  
  frameRate(10);
}

void draw() {
  myGrid.update();
  
  background(255);
  
  myGrid.display(); 
}
