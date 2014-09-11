class Distorter
{
  public Vec3D position;
  public color dColor;
  public float forceA = 1.5;
  public float forceB = 600;
  public boolean draged = false;
  public boolean selected = false;
  
  private float xt, yt;
  ArrayList<Distorter> distorters;
  
  
  Distorter(float xx, float yy, float zz, ArrayList<Distorter> dists, boolean draged)
    {
      rndColor();
      position = new Vec3D(xx, yy, zz);
      distorters = dists; 
      this.draged = draged;
    }
    
  void run()
  {
    positionBox();
    if (draged)
    {
      position.x = mouseX;
      position.y = mouseY;
    }
    
    if (mousePressed && dist(mouseX, mouseY, position.x, position.y)<40 && !draged)
    {
      boolean otherDraged = false;
      for (int d=0; d<distorters.size(); d++)
      {
        if ((distorters.get(d) != this)&&(distorters.get(d).draged)) otherDraged = true;       
      }
      if (!otherDraged)
      {
        draged = true;
        xt = position.x;
        yt = position.y;
      }
     }
    
    if (!mousePressed && draged)
    {
      draged = false;
      if (dist(position.x, position.y, xt, yt)<4) 
        {
          selected = !selected;
          position.x = xt;
          position.y = yt;
        }
      if (selected)
      for (int d=0; d<distorters.size(); d++)
      {
        if (distorters.get(d) != this) distorters.get(d).selected = false;
      }
    }
    
  }
  
 void distort(Vec3D[][] markers)
  {
    Vec3D dif;
    float distance;
    for (int i=1; i<markers.length-1; i++){
      for (int j=0; j<markers.length-1; j++){
        if (true)  // wyjątek np. dla i!=50
        {
          dif = markers[i][j].sub(position);
          distance = dif.magnitude();
          //dif.normalize();
          dif.scaleSelf(forceB/pow(distance,forceA));
          markers[i][j].addSelf(dif);
        }     
      } 
    }
  }
  
    
  void rndColor()
  {
    colorMode(HSB, 360, 100, 100);
    dColor = color(random(360), 60, 100);
  }
    
  void positionBox()
  {
    if (dist(mouseX, mouseY, position.x, position.y)<40)
    {
      fill(0,0);
      stroke(dColor);
      rectMode(CENTER);
      ellipse(position.x, position.y, 30, 30);
    }
    
    if (selected)
    {
      fill(0,0);
      stroke(dColor);
      rectMode(CENTER);
      //ellipse(position.x, position.y, 30, 30);
      line(position.x-100, position.y, position.z, position.x+100, position.y, position.z);
      line(position.x, position.y-100, position.z, position.x, position.y+100, position.z);
      line(position.x, position.y, position.z-100, position.x, position.y, position.z+100);
    }
  }
  
  
}
