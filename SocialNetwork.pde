import java.lang.Math;
import java.util.Arrays;
import java.util.List;

/*
A7Q2:
 (   ) Program output: stderr:
 Could not parse -1 for --display
 Okay, we build a Social Network Node, how about building an entire social network?
 I'm going to make a sugar grid.
 If I pass an empty grid to your constructor, does it crash?
 (   ) Program exited normally
 (-10) Error: expected program output:Success!
 */

class SocialNetwork {

  SugarGrid g;
  private LinkedList<SocialNetworkNode>[] adj;
  private SocialNetworkNode[] agentNode;

  private int w;
  private int h;

  public SocialNetwork(SugarGrid g) {

    this.g = g;
    w = g.getWidth();
    h = g.getHeight();

    //adjacency list
    adj = new LinkedList[w * h];
    agentNode = new SocialNetworkNode[w * h];

    //for each item in adj array
    for (int i = 0; i < (w * h); i++) {
      //add a linkedlist of socialnetworknodes
      if (g.getAgentAt(i % w, i / w) != null) {
        agentNode[i] = new SocialNetworkNode(g.getAgentAt(i % w, i / w));
        adj[i] = new LinkedList<SocialNetworkNode>();
      }
    }

    //for each item in adj array
    for (int j = 0; j < (w * h); j++) {

      //if current agent exist
      if (adj[j] != null) {
        //generate its vision
        LinkedList<Square> vision = g.generateVision(j % w, j / w, agentNode[j].getAgent().getVision());
        adj[j].add(agentNode[j]);

        //for each square in current agent's vision
        for (int i = 0; i < vision.size(); i++) {

          //if agent in vision in square exists
          if (vision.get(i).getAgent() != null) {
            for (int k = 0; k < agentNode.length; k++) {
              if (agentNode[k] != null) {
                if (agentNode[k].getAgent().equals(vision.get(i).getAgent()) && agentNode[k].getAgent() != agentNode[j].getAgent()) {
                  adj[j].add(agentNode[k]);
                }
              }
            }
          }
        }
      }
    }
  }


  //Returns true if agent x is adjacent to agent y in this SocialNetwork.
  //If either x or y is not present in the social network, should return null.
  public boolean adjacent(SocialNetworkNode x, SocialNetworkNode y) {
    int indexX = 0;

    //if x or y is not present in network
    if (x.getAgent() == null || y.getAgent() == null) {
      return false;
    }

    //for each i in agentNode
    for (int i = 0; i < (w * h); i++) {
      //if x isn't null and x is one of the agent nodes
      if (x.getAgent() != null && x == agentNode[i]) {
        //set index to appropriate i value
        indexX = i;
      }
    }

    //otherwise,
    //if y is in x's vision
    if (adj[indexX].contains(y)) {
      return true;
    }

    return false;
  }

  //Returns a list (either ArrayList or LinkedList) containing all the nodes that x is adjacent to.
  //Returns null if x is not in the social network.
  public List<SocialNetworkNode> seenBy(SocialNetworkNode x) {
    int indexX = -1;
    for (int i = 0; i < (w * h); i++) {
      if (agentNode[i] != null && x.getAgent() == agentNode[i].getAgent() && x.getAgent() != null) {
        indexX = i;
      }
    }
    //if y isn't null
    if (indexX != -1) {
      return adj[indexX];
    }
    return null;
  }

  //Returns a list (either ArrayList or LinkedList) containing all the nodes that are adjacent to y.
  //Returns null if y is not in the social network.
  public List<SocialNetworkNode> sees(SocialNetworkNode y) {
    //list to keep track of what nodes x is seen by
    ArrayList<SocialNetworkNode> l = new ArrayList<SocialNetworkNode>();
    int indexY = -1;
    if (y != null) {
      for (int i = 0; i < (w * h); i++) {
        if (agentNode[i] != null && y.getAgent() == agentNode[i].getAgent()) {
          indexY = i;
        }
      }
    }
    //if x isn't null
    if (indexY != -1) {
      //for each element in adj
      for (int i = 0; i < (w * h); i++) {
        //if the linkedlist in the ith position contains x
        if (adj[i] != null && adj[i].contains(y) && agentNode[i] != null) {
          //add the node to the list
          l.add(agentNode[i]);
        }
      }
    }
    return l;
  }

  //Sets every node in the network to unpainted.
  public void resetPaint() {
    //for each element in adj
    for (int i = 0; i < (w * h); i++) {
      //if the linkedlist in the ith position doesn't equal null
      if (adj[i] != null) {
        //for each element in adj
        for (SocialNetworkNode snn : adj[i]) {
          //unpaint
          snn.unpaint();
        }
      }
    }
  }

  //Returns the node containing the passed agent. 
  //Returns null if that agent is not represented in this graph.
  public SocialNetworkNode getNode(Agent a) {
    //for each element in agentNode
    for (int i = 0; i < (w * h); i++) {
      //if the agent in agentNode[i] equals a
      if (agentNode[i] != null && agentNode[i].getAgent() == a) {
        //return the node itself
        return agentNode[i];
      }
    }
    //else
    return null;
  }

  //Returns true if there exists any path through the social network that connects x to y. 
  //A path should start with node x, proceed through any node x can see, and then any node 
  //    that agent can see, and so on, until it reaches node y.
  public boolean pathExists(Agent x, Agent y) {
    //nodes of x and y
    SocialNetworkNode xNode = this.getNode(x);
    SocialNetworkNode yNode = this.getNode(y);

    //if both nodes are not null
    if (xNode != null && yNode != null) {

      //paint x for sure
      xNode.paint();

      //if agentNode contains xNode and the size of it's linkedlist in adj is greater than 0
      if (Arrays.asList(agentNode).contains(xNode) && adj[Arrays.asList(agentNode).indexOf(xNode)].size() > 1) {

        xNode.paint();

        //variable to hold index
        int index = Arrays.asList(agentNode).indexOf(xNode);

        //for each element in linkedlist of xNode
        for (int i = 0; i < adj[index].size(); i++) {

          //if the ith element is not painted and it equals the yNode
          if (adj[index].get(i).painted == false && adj[index].get(i) == yNode) {
            return true;
          } else if (adj[index].get(i).painted == false) {
            //paint the element
            adj[index].get(i).paint();
            //recursively call pathExists
            this.pathExists(adj[index].get(i).getAgent(), y);
          }
        }
      }
    }
    return false;
  }

  //Returns the shortest path through the social network from node x to node y. 
  //If more than one path is the shortest, returns any of the shortest ones. 
  //If there is no path from x to y, returns null. You may find it useful to add some 
  //    additional information to the SocialNetworkNode class, like a reference to the 
  //    first node that added it to the search.
  public List<Agent> bacon (Agent x, Agent y) {
    if (this.pathExists(x, y)) {
      SocialNetworkNode xNode = this.getNode(x);
      SocialNetworkNode yNode = this.getNode(x);

      xNode.paint();

      int indexX = Arrays.asList(agentNode).indexOf(xNode);

      for (SocialNetworkNode neighbor : adj[indexX]) {
        if (neighbor.painted() == false) {
          bacon(neighbor.getAgent(), y);
        }
      }
    }
    LinkedList<Agent> empty = new LinkedList<Agent>();
    return empty;
  }
  
  public void connect(List<SocialNetworkNode> ssns) {
    for(SocialNetworkNode s : ssns) {
      for(SocialNetworkNode x : ssns) {
        if(ssns.adjacent(s, x) == true) {
          line(s, s, x, x);
        }
      }
    }
  }
}
