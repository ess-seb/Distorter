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
   distorters.add(new Distorter(idCounter, mouseX, mouseY, -15, this, true, distConsole));
   idCounter++;
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
  
 public int size(){
   return distorters.size();
 }
 
  public Distorter get(int d){
   return distorters.get(d);
 }
  
}

