
	
	import toxi.geom.*;
	import processing.core.*;

import java.util.ArrayList;

class Distorter 
{
	private PApplet p5;
	
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
    //Range sRange;
  
  boolean enabledHUD = false;
  boolean enabledEdit = false;
  boolean enabledDrag = false;
  boolean enabledHMove = true;
  
  private float xt, yt;
  DContainer container;
  
  
  Distorter(float xx, float yy, float zz, DContainer container, PApplet p5)
  {
	this.p5 = p5;
    newColor();
    position = new Vec3D(xx, yy, zz);
    this.container = container; 
    this.id = container.newId();
    
    s1 = new DSlider(position.x+25f, position.y+25f, dColor, forceA, 0f, 5f, p5, this);
    s2 = new DSlider(position.x+25, position.y+37, dColor, forceB, 0f, 2000f, p5, this);
    zSlider = new DSlider(position.x+25, position.y+49, dColor, position.z, 0, 100f, p5, this);
    
    vMulti = p5.random(0,100)/130;
    if (p5.random(-1,1)>=0) target.x=100;
  }
  
  Distorter(float x, float y, float z, float forceA, float forceB, DContainer container, PApplet p5)
  {
	this.p5 = p5;
    newColor();
    position = new Vec3D(x, y, z);
    this.forceA = forceA;
    this.forceB = forceB;
    this.container = container; 
    this.id = container.newId();
    
    s1 = new DSlider(position.x+25f, position.y+25f, dColor, forceA, 0f, 5f, p5, this);
    s2 = new DSlider(position.x+25, position.y+37, dColor, forceB, 0f, 2000f, p5, this);
    zSlider = new DSlider(position.x+25, position.y+49, dColor, position.z, -1000f, 100f, p5, this);
    
    vMulti = p5.random(0,100)/130;
    if (p5.random(-1,1)>=0) target.x=100;
  }
  
  void run()
  {
    if (enabled)
    {
      if (enabledHUD) drawHUD();
      if (enabledEdit)doSelect();
      if (enabledDrag)doDragXY();
      if (enabledHMove)doHMove();
    }
  }
 
 private void doDragXY()
 {
    if (draged)    //    !!! AKTUALIZUJ POZYCJÊ DISTORTERA!!!
    {
      position.x = p5.mouseX;
      position.y = p5.mouseY;  
    }
    
    if (p5.mousePressed && (PApplet.dist(p5.pmouseX, p5.pmouseY, position.x, position.y)<40) && !draged)
    {
      
      
      if (!isOtherinuse() && !inUse)  //    !!! DRAG !!!
      {
        p5.mouseX = (int)position.x;
        p5.mouseY = (int)position.y;
        draged = true;
        inUse = true;
        xt = position.x;
        yt = position.y;
      }
     }
     
    if (!p5.mousePressed && draged)    //    !!! DROP !!!
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
        
        if (draged)      //    !!! AKTUALIZUJ POZYCJÊ KONSOLI!!!
        {
          s1.setPosition(p5.screenX(position.x, position.y, position.z)+25, p5.screenY(position.x, position.y, position.z)+25);
          s2.setPosition(p5.screenX(position.x, position.y, position.z)+25, p5.screenY(position.x, position.y, position.z)+37);
          zSlider.setPosition(p5.screenX(position.x, position.y, position.z)+25, p5.screenY(position.x, position.y, position.z)+49);
        }
    }
    

      if (!p5.mousePressed && draged && (PApplet.dist(position.x, position.y, xt, yt)<4)) 
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
          dif.scaleSelf(forceB/PApplet.pow(distance,forceA));      
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
          dif.scaleSelf(forceB/PApplet.pow(distance,forceA));      
          distortedMarker[i][j] = dif;
        }     
      } 
    }
    return distortedMarker;
  }
  
    
  private void newColor()
  {
    float dHue = p5.random(360);
    p5.colorMode(PConstants.HSB, 360, 100, 100);
    dColor =p5.color(dHue, 60, 100);
  }
    
  void drawHUD()
  {
    if (p5.dist(p5.pmouseX, p5.pmouseY, position.x, position.y)<40)
    {
    	p5.noFill();
    	p5.stroke(dColor);
    	p5.rectMode(p5.CENTER);
    	p5.ellipse(p5.screenX(position.x, position.y, position.z), p5.screenY(position.x, position.y, position.z), 30, 30);
    }
    
    if (p5.dist(p5.pmouseX, p5.pmouseY, position.x, position.y)<(forceB/6))
    {
    	p5.noFill();
    	p5.stroke(75);
    	p5.rectMode(p5.CENTER);
    	p5.ellipse(p5.screenX(position.x, position.y, position.z), p5.screenY(position.x, position.y, position.z), forceB/3+30, forceB/3+30);
    }
    
    if (selected)
    {
    	p5.noFill();
    	p5.stroke(dColor);
    	p5.rectMode(p5.CENTER);
    	p5.ellipse(p5.screenX(position.x, position.y, position.z), p5.screenY(position.x, position.y, position.z), 30, 30);
    	p5.fill(dColor);
    	p5.ellipse(p5.screenX(position.x, position.y, position.z), p5.screenY(position.x, position.y, position.z), 30, 30);
    }
    
  }
  
  boolean isInuse()
  {
	  return inUse;
  }
  
  boolean isOtherinuse()
  {
	  boolean otherInUse = false;
      for (int d=0; d<container.size(); d++)  //    !!! SPRAWD CZY INNY JEST DRAG!!!
      {
        if ((container.get(d).isInuse())) otherInUse = true;       
      }
      return otherInUse;
  }
  
  protected void kill() {

  }
  
}