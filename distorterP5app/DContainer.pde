public class DContainer
{
 

 private int idCounter = 0;
 private boolean active = false;
 ArrayList<Distorter> distorters = new ArrayList<Distorter>();

DContainer()
{
  setActive(false);
  
  //MultiListButton b;
  //b = mlist.add("level1",1);
  //b.add("level11",11).setLabel("level1 item1");
}

 public void run()
 {
    for (int d=0; d<distorters.size(); d++){
        distorters.get(d).run();
    }
 }
 
 void addDistorter()
 {
   distorters.add(new Distorter(mouseX, mouseY, -15, this));
 }
 
 void addDistorter(float xx, float yy, float zz, float forceA, float forceB)
 {
   distorters.add(new Distorter(xx, yy, zz, forceA, forceB, this));
 }
 
 void removeDistorter()
 {
   for (int d=0; d<distorters.size(); d++)
    {
      if (distorters.get(d).selected) {
            distorters.get(d).kill();
            distorters.remove(d);
      }
    }
 }

 void distort(Vec3D[][] markers){
  for (int d=0; d<distorters.size(); d++){
     distorters.get(d).distort(markers);
    }
  }
 
 void distortB(Vec3D[][] markers){  
   
   ArrayList<Vec3D[][]> distortedMarkers = new ArrayList<Vec3D[][]>();
   for (int d=0; d<distorters.size(); d++){
      distortedMarkers.add(distorters.get(d).distortB(markers));
    }
   for (Vec3D[][] distortedMarker: distortedMarkers)
   {
     for (int i=0; i<distortedMarker.length; i++) {
       for (int j=0; j<distortedMarker[i].length; j++){
         markers[i][j].addSelf(distortedMarker[i][j]);
       }
     }
   }
  }  
  
 public int size() {
   return distorters.size();
 }
 
 public ArrayList<Distorter> getAll() {
   return distorters;
 }
 
  public Distorter get(int d) {
   return distorters.get(d);
 }
 
 public int newId() {
   return idCounter++;
 }
 
 public void setActive(boolean act){
   if (act) {
     active = act;
     for (Distorter disto: distorters) {
       disto.setEnabled(true);
     }
   }
   else
   {
     for (Distorter disto: distorters) {
       disto.setEnabled(false);
     }
   }
 }
  
}
