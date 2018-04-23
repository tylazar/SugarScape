abstract class CDFGraph extends Graph {
  int calls;
  int numUpdates;
  int numPerCell;
  
  public CDFGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue) {
    super(x, y, howWide, howTall, xlab, ylab);
    this.calls = callsPerValue;
    numUpdates = 0;
  }
  
  public abstract void reset(SugarGrid g);
  
  public abstract int nextPoint(SugarGrid g);
  
  public abstract int getTotalCalls(SugarGrid g);
  
  public void update(SugarGrid g) {
    numUpdates = 0;
    super.update(g);
    reset(g);
    numPerCell = w/getTotalCalls(g);
    
    while(numUpdates < getTotalCalls(g)) {
      rect(numUpdates, nextPoint(g), numPerCell, 1);
      numUpdates++;
    }
  }
}
