class PollutionRule {
  
  int gatheringPollution;
  int eatingPollution;
  
  public PollutionRule(int gatheringPollution, int eatingPollution) {
    this.gatheringPollution = gatheringPollution;
    this.eatingPollution = eatingPollution;
  }
  
  public void pollute(Square s) {
    //if s is occupied
    if(s.getAgent() != null) {
      Agent agent = s.getAgent();
      
      //pollution is increased by eatingPollution points for every point of metabolism and gatheringPollution points for every point of sugar
      s.setPollution(s.getPollution() + (this.eatingPollution * agent.getMetabolism()) + (this.gatheringPollution * s.getSugar()));
    }
  }
}
