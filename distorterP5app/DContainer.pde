class DContainer
{
 
 ArrayList<Distorter> distorters = new ArrayList<Distorter>();
 ArrayList<Distorter> selectedD = new ArrayList<Distorter>();



 void run()
 {
    for (int d=0; d<distorters.size(); d++){
        distorters.get(d).run();
    }
 }
 
 void addDistorter()
 {
   distorters.add(new Distorter(500,500,-15, distorters, true));
 }
 
 void removeDistorter()
 {
   for (int d=0; d<distorters.size(); d++)
    {
      if (distorters.get(d).selected) 
            distorters.remove(d);
    }
 }

 void distort(Vec3D[][] markers){
  for (int d=0; d<distorters.size(); d++){
     distorters.get(d).distort(markers);
    }
  } 
  
}

