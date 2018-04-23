class SocialNetworkNode {
  
  Agent a;
  Boolean painted;
  
  public SocialNetworkNode(Agent a) {
    this.a = a;
    this.painted = false;
  }
  
  public boolean painted() {
    if(this.painted == true) {
      return true;
    }
    else {
      return false;
    }
  }
  
  public void paint() {
    this.painted = true;
  }
  
  public void unpaint() {
    this.painted = false;
  }
  
  public Agent getAgent() {
    return this.a;
  }
}
