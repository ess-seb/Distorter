class Distorter
{
  public int id;
  public Vec3D position;
  public color dColor;
  CColor cdColor;
  public float forceA = 1.5;
  public float forceB = 600;
  public boolean draged = false;
  public boolean selected = false;
  Slider s1;
  Slider s2;
  
  private float xt, yt;
  DContainer container;
  ControlP5 distConsole;
  
  
  Distorter(int id, float xx, float yy, float zz, DContainer container, boolean draged, ControlP5 distConsole)
    {
      rndColor();
      position = new Vec3D(xx, yy, zz);
      this.container = container; 
      this.draged = draged;
      this.distConsole = distConsole;
      this.id = id;
    }
    
  void run()
  {
    drawHUD();
    if (selected)
    {
        if ((s1.value()!=forceA)||(s2.value()!=forceB))
        {
          forceA=s1.value();
          forceB=s2.value();
        }
    }
    
    if (draged)
    {
      position.x = pmouseX;
      position.y = pmouseY;
     
     
      if (selected)
      {
        s1.setPosition(position.x+25, position.y+25);
        s2.setPosition(position.x+25, position.y+37);
        

      }
    }
    
    if (mousePressed && dist(pmouseX, pmouseY, position.x, position.y)<40 && !draged)
    {
      boolean otherDraged = false;
      for (int d=0; d<container.size(); d++)
      {
        if ((container.get(d) != this)&&(container.get(d).draged)) otherDraged = true;       
      }
      if (!otherDraged)
      {
        mouseX = (int)position.x;
        mouseY = (int)position.y;
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
          if (!selected)
          {
          
            s1 = distConsole.addSlider("#"+id+"A", 0, 5, forceA ,(int)position.x+25, (int)position.y+25, 200, 8);
            s1.setColor(cdColor);
            s1.setLabelVisible(false);
            
            s2 = distConsole.addSlider("#"+id+"B", 0, 2000, forceB ,(int)position.x+25, (int)position.y+37, 200, 8);
            s2.setColor(cdColor);
            s2.setLabelVisible(false);
            
            selected = true;
          }
          else
          {
            selected = false;
            s1=null;
            distConsole.remove("#"+id+"A");
            s1=null;
            distConsole.remove("#"+id+"B");
            
          }
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
    float dHue = random(360);
    colorMode(HSB, 360, 100, 100);
    dColor = color(dHue, 60, 100);
    
    cdColor = new CColor();
    cdColor.setForeground(color(dHue, 60, 80));
    cdColor.setBackground(color(dHue, 60, 50));
    cdColor.setActive(color(dHue, 60, 100));
  }
    
  void drawHUD()
  {
    if (dist(pmouseX, pmouseY, position.x, position.y)<40)
    {
      noFill();
      stroke(dColor);
      rectMode(CENTER);
      ellipse(screenX(position.x, position.y, position.z), screenY(position.x, position.y, position.z), forceB/20, forceB/20);
    }
    
    if (dist(pmouseX, pmouseY, position.x, position.y)<(forceB/6))
    {
      noFill();
      stroke(75);
      rectMode(CENTER);
      ellipse(screenX(position.x, position.y, position.z), screenY(position.x, position.y, position.z), forceB/3, forceB/3);
    }
    
    if (selected)
    {
      noFill();
      stroke(dColor);
      rectMode(CENTER);
      ellipse(screenX(position.x, position.y, position.z), screenY(position.x, position.y, position.z), 30, 30);
      fill(dColor);
      ellipse(screenX(position.x, position.y, position.z), screenY(position.x, position.y, position.z), 30, 30);
      //line(position.x-100, position.y, position.z, position.x+100, position.y, position.z);
      //line(position.x, position.y-100, position.z, position.x, position.y+100, position.z);
      //line(position.x, position.y, position.z-100, position.x, position.y, position.z+100);
    }
    
  }
  
protected void kill() {
            s1=null;
            distConsole.remove("#"+id+"A");
            s1=null;
            distConsole.remove("#"+id+"B");
}
  
}
