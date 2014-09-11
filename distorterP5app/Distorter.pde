class Distorter
{
  public Vec3D position;
  public color dColor;
  public float forceA = 1.5;
  public float forceB = 600;
  public boolean draged = false;
  public boolean selected = false;
  
  private float xt, yt;
  Distorter[] distorters;
  
  
  Distorter(float xx, float yy, float zz, Distorter[] dists)
    {
      rndColor();
      position = new Vec3D(xx, yy, zz);
      distorters = dists; 
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
      for (int d=0; d<distorters.length; d++)
      {
        if ((distorters[d] != this)&&(distorters[d].draged)) otherDraged = true;       
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
      for (int d=0; d<distorters.length; d++)
      {
        if (distorters[d] != this) distorters[d].selected = false;
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
      rect(position.x, position.y, 30, 30);
    }
    
    if (selected)
    {
      fill(dColor);
      stroke(dColor);
      rectMode(CENTER);
      rect(position.x, position.y, 30, 30);
    }
  }
  
  
}
