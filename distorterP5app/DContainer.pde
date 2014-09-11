class DContainer
{
 
 ArrayList<Distorter> distorters = new ArrayList<Distorter>();
 ArrayList<Distorter> selectedD = new ArrayList<Distorter>();
 ControlP5 distConsole;
 private int idCounter = 0;

DContainer(ControlP5 distConsole)
{
  this.distConsole = distConsole;
}

 void run()
 {
    for (int d=0; d<distorters.size(); d++){
        distorters.get(d).run();
    }
 }
 
 void addDistorter()
 {
   distorters.add(new Distorter(mouseX, mouseY, -15, this, distConsole));

 }
 
 void removeDistorter()
 {
   for (int d=0; d<distorters.size(); d++)
    {
      if (distorters.get(d).selected) 
            distorters.get(d).kill();
            distorters.remove(d);
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
     for (int i=0; i<distortedMarker.length; i++){
       for (int j=0; j<distortedMarker[i].length; j++){
         markers[i][j].addSelf(distortedMarker[i][j]);
       }
     }
   }
  }  
  
 public int size(){
   return distorters.size();
 }
 
  public Distorter get(int d){
   return distorters.get(d);
 }
 
 public int newId(){
   return idCounter++;
 }
  
}

