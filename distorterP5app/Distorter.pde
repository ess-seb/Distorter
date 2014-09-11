class Distorter
{
  public int id;
  public Vec3D position;
  public color dColor;
  CColor cdColor;
  public float forceA = 1.5;
  public float forceB = 600;
    //public float rangeLow = 0;
    //public float rangeHigh = 700;
  
  private boolean draged = false;
  private boolean selected = false;
  private boolean enabled = true;
  Slider s1;
  Slider s2;
  Slider zSlider;
    //Range sRange;
  
  boolean enabledHUD = true;
  boolean enabledEdit = true;
  boolean enabledDrag = true;
  
  private float xt, yt;
  DContainer container;
  ControlP5 distConsole = null;
  
  
  Distorter(float xx, float yy, float zz, DContainer container)
  {
    newColor();
    position = new Vec3D(xx, yy, zz);
    this.container = container; 
    this.id = container.newId();
  }
  
  Distorter(float xx, float yy, float zz, DContainer container, ControlP5 distConsole)
  {
    newColor();
    position = new Vec3D(xx, yy, zz);
    this.container = container; 
    this.distConsole = distConsole;
    this.id = container.newId();
  }
    
  void run()
  {
    if (enabled)
    {
      if (enabledHUD) drawHUD();
      if (enabledEdit)doSelect();
      if (enabledDrag)doDragXY();
    }
  }
 
 private void doDragXY()
 {
    if (draged)    //    !!! AKTUALIZUJ POZYCJĘ DISTORTERA!!!
    {
      position.x = pmouseX;
      position.y = pmouseY;  
    }
    
    if (mousePressed && (dist(pmouseX, pmouseY, position.x, position.y)<40) && !draged)
    {
      boolean otherDraged = false;
      for (int d=0; d<container.size(); d++)  //    !!! SPRAWDŹ CZY INNY JEST DRAG!!!
      {
        if ((container.get(d) != this)&&(container.get(d).draged)) otherDraged = true;       
      }
      
      if (!otherDraged)  //    !!! DRAG !!!
      {
        mouseX = (int)position.x;
        mouseY = (int)position.y;
        draged = true;
        xt = position.x;
        yt = position.y;
      }
     }
     
    if (!mousePressed && draged)    //    !!! DROP !!!
    {
      draged = false;
    }
 }
 
 public Vec3D getPosition()
 {return position;}
 
  public float getForceA()
 {return forceA;}
 
  public float getForceB()
 {return forceB;}
  
 private void doSelect()
  {
    if (selected)
    {
        if ((s1.value()!=forceA)||(s2.value()!=forceB)||(zSlider.value()!=position.z))     //    !!! AKTUALIZUJ WARTOŚCI !!!
        {
          forceA=s1.value();
          forceB=s2.value();
          position.z=zSlider.value();
            //rangeLow=sRange.arrayValue()[0];
            //rangeHigh=sRange.arrayValue()[1];
        }
        
        if (draged)      //    !!! AKTUALIZUJ POZYCJĘ KONSOLI!!!
        {
          s1.setPosition(position.x+25, position.y+25);
          s2.setPosition(position.x+25, position.y+37);
          zSlider.setPosition(position.x+25, position.y+45);
            //sRange.setPosition(position.x+25, position.y+45);
        }
    }
    

      if (!mousePressed && draged && (dist(position.x, position.y, xt, yt)<4)) 
        {
          if (!selected)  //    !!! SELECT !!!
          {
          
            s1 = distConsole.addSlider("#"+id+"A", 0, 5, forceA ,(int)position.x+25, (int)position.y+25, 200, 8);
            s1.setColor(cdColor);
            s1.setLabelVisible(false);
            
            s2 = distConsole.addSlider("#"+id+"B", 0, 2000, forceB ,(int)position.x+25, (int)position.y+37, 200, 8);
            s2.setColor(cdColor);
            s2.setLabelVisible(false);
            
            zSlider = distConsole.addSlider("#"+id+"Z", -100, 100, position.z ,(int)position.x+25, (int)position.y+49, 200, 8);
            zSlider.setColor(cdColor);
            zSlider.setLabelVisible(false);
            
              //sRange = distConsole.addRange("#"+id+"R", 0.0, 1000.0, (int)position.x+25, (int)position.y+49, 200, 8);
              //sRange.setColor(cdColor);
              //sRange.setLowValue(rangeLow);
              //sRange.setHighValue(rangeHigh);
              //sRange.setLabelVisible(false);
            
            selected = true;
          }
          else          //    !!! UNSELECT !!!
          {
            unSelect();
          }
        }
    
  } 
  
 public void unSelect()           //    !!! UNSELECT !!!
 {
   if (selected)
   {
            selected = false;
            s1=null;
            distConsole.remove("#"+id+"A");
            s1=null;
            distConsole.remove("#"+id+"B");
            zSlider=null;
            distConsole.remove("#"+id+"Z");
            //sRange=null;
            //distConsole.remove("#"+id+"R"); 
   }
 }
 
 public void setEnabled(boolean ena)           //    !!! set ENABLED !!!
 {
   if(ena)
   {
     enabled = true;
   }
   else
   {
     unSelect();
     enabled = false;
   }
 }
  
 public void distort(Vec3D[][] markers)
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
  
  public Vec3D[][] distortB(Vec3D[][] markers)
  {
    Vec3D dif;
    float distance;
    Vec3D[][] distortedMarker = new Vec3D[markers.length][markers[0].length];
    
    for (int i=0; i<markers.length; i++){
      for (int j=0; j<markers.length; j++){
        if (true)  // wyjątek np. dla i!=50
        {
          dif = markers[i][j].sub(position);
          distance = dif.magnitude();
          dif.normalize();
          dif.scaleSelf(forceB/pow(distance,forceA));      
          distortedMarker[i][j] = dif;
        }     
      } 
    }
    return distortedMarker;
  }
  
    
  void newColor()
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
              zSlider=null;
              distConsole.remove("#"+id+"Z");
  }
  
}
