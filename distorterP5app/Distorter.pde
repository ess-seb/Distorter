class Distorter 
{
  
  public int id;
  public Vec3D position;
  private float vMulti;
  public Vec3D target= new Vec3D(1200, 0, 0);
  public Vec3D acc = new Vec3D(0, 0, 0);
  public Vec3D velo = new Vec3D(0, 0, 0);
  public float veloMulti;
  
  
  public int dColor;
  public float forceA = 1.5f;
  public float forceB = 600;
    //public float rangeLow = 0;
    //public float rangeHigh = 700;
  
  private boolean draged = false;
  public boolean selected = false;
  private boolean enabled = true;
  
  boolean inUse = false;
  
  DSlider s1;
  DSlider s2;
  DSlider zSlider;
  
  boolean enabledHUD = true;
  boolean enabledEdit = true;
  boolean enabledDrag = true;
  boolean enabledHMove = true;
  
  private float xt, yt;
  DContainer container;
  
  
  Distorter(float xx, float yy, float zz, DContainer container) {
    newColor();
    position = new Vec3D(xx, yy, zz);
    this.container = container; 
    this.id = container.newId();
    
    s1 = new DSlider(position.x+25f, position.y+25f, dColor, forceA, 0f, 5f, this);
    s2 = new DSlider(position.x+25, position.y+37, dColor, forceB, 0f, 2000f, this);
    zSlider = new DSlider(position.x+25, position.y+49, dColor, position.z, 0, 100f, this);
    
    vMulti = random(0,100)/130;
    if (random(-1,1)>=0) target.x=100;
  }
  
  Distorter(float x, float y, float z, float forceA, float forceB, DContainer container) {
    newColor();
    position = new Vec3D(x, y, z);
    this.forceA = forceA;
    this.forceB = forceB;
    this.container = container; 
    this.id = container.newId();
    
    s1 = new DSlider(position.x+25f, position.y+25f, dColor, forceA, 0f, 5f, this);
    s2 = new DSlider(position.x+25, position.y+37, dColor, forceB, 0f, 2000f, this);
    zSlider = new DSlider(position.x+25, position.y+49, dColor, position.z, -1000f, 100f, this);
    
    vMulti = random(0,100)/130;
    if (random(-1,1)>=0) target.x=100;
  }
  
  void run() {
    if (enabled) {
      if (enabledHUD) drawHUD();
      if (enabledEdit) doSelect();
      if (enabledDrag) doDragXY();
      if (enabledHMove) doHMove();
    }
  }
 
 private void doDragXY()
 {
    if (draged) {
      position.x = mouseX;
      position.y = mouseY;  
    }
    
    if (mousePressed && (dist(pmouseX, pmouseY, position.x, position.y)<40) && !draged) {
      
      if (!isOtherinuse() && !inUse)  //    !!! DRAG !!!
      {
        mouseX = (int)position.x;
        mouseY = (int)position.y;
        draged = true;
        inUse = true;
        xt = position.x;
        yt = position.y;
      }
     }
     
    if (!mousePressed && draged)    //    !!! DROP !!!
    {
      inUse = false;
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
      s1.display();
      s2.display();
      zSlider.display();
      
        if ((s1.getValue()!=forceA)||(s2.getValue()!=forceB)||(zSlider.getValue()!=position.z))     //    !!! AKTUALIZUJ WARTOŒCI !!!
        {
          forceA=s1.getValue();
          forceB=s2.getValue();
          position.z=zSlider.getValue();
        }
        
        if (draged)      //    !!! AKTUALIZUJ POZYCJĘ KONSOLI!!!
        {
          s1.setPosition(screenX(position.x, position.y, position.z)+25, screenY(position.x, position.y, position.z)+25);
          s2.setPosition(screenX(position.x, position.y, position.z)+25, screenY(position.x, position.y, position.z)+37);
          zSlider.setPosition(screenX(position.x, position.y, position.z)+25, screenY(position.x, position.y, position.z)+49);
        }
    }
    

      if (!mousePressed && draged && (dist(position.x, position.y, xt, yt)<4)) 
        {
          if (!selected)  //    !!! SELECT !!!
          {
            selected = true;
          }
          else          //    !!! UNSELECT !!!
          {
            unSelect();
          }
        }
    
  } 
 
 private void doHMove()
 { 
   if (position.x>800) target.x = 100;
   else if (position.x<50) target.x = 1200;
   acc.x = (target.x - position.x)/2000;
   acc.limit(2);
   velo.addSelf(acc);
   velo.limit(10);
   velo.x = velo.x*(vMulti);
   position.addSelf(velo);
   //System.out.println(acc.x + " " + velo.x + " " + position.x + " " + target.x);
 }
  
 public void unSelect()           //    !!! UNSELECT !!!
 {
   if (selected)
   {
            selected = false;
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
      for (int j=0; j<markers[0].length-1; j++){
        if (true)  // wyj¹tek np. dla i!=50
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
      for (int j=0; j<markers[0].length; j++){
        if (true)  // wyj¹tek np. dla i!=50
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
  
    
  private void newColor()
  {
    float dHue = random(360);
    colorMode(PConstants.HSB, 360, 100, 100);
    dColor = color(dHue, 60, 100);
  }
    
  void drawHUD()
  {
    if (dist(pmouseX, pmouseY, position.x, position.y)<40)
    {
      noFill();
      stroke(dColor);
      rectMode(CENTER);
      ellipse(screenX(position.x, position.y, position.z), screenY(position.x, position.y, position.z), 30, 30);
    }
    
    if (dist(pmouseX, pmouseY, position.x, position.y)<(forceB/6))
    {
      noFill();
      stroke(75);
      rectMode(CENTER);
      ellipse(screenX(position.x, position.y, position.z), screenY(position.x, position.y, position.z), forceB/3+30, forceB/3+30);
    }
    
    if (selected)
    {
      noFill();
      stroke(dColor);
      rectMode(CENTER);
      ellipse(screenX(position.x, position.y, position.z), screenY(position.x, position.y, position.z), 30, 30);
      fill(dColor);
      ellipse(screenX(position.x, position.y, position.z), screenY(position.x, position.y, position.z), 30, 30);
    }
    
  }
  
  boolean isInuse()
  {
    return inUse;
  }
  
  boolean isOtherinuse()
  {
    boolean otherInUse = false;
      for (int d=0; d<container.size(); d++)  //    !!! SPRAWDź CZY INNY JEST DRAG!!!
      {
        if ((container.get(d).isInuse())) otherInUse = true;       
      }
      return otherInUse;
  }
  
  protected void kill() {

  }
  
}
