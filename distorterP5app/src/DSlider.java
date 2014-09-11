

	import java.util.ArrayList;

import processing.core.*;

class DSlider
{
  private PApplet p5;
	
  public int id;
  private int mainColor;
  private int darkColor;
  private int darkerColor;
  
  public float x;
  public float y;
  
  private float width = 200;
  private float height = 8;
  
  private float pos;
  private float barWidth;
  
  private float valueP;
  private float value;
  
  private float rangeLow;
  private float rangeHigh;
  
  
  private boolean draged = false;
  private Distorter parentDist;
  

  
  
  
  DSlider(float x, float y, int col, float val, float minVal, float maxVal, PApplet p5, Distorter d)
  {
	this.p5 = p5;
    this.x = x;
    this.y = y;
    mainColor = col;
    value = val;
    rangeHigh = maxVal;
    rangeLow  = minVal;
   
    this.parentDist = d;
    
    pos = ((value-rangeLow)*width)/(rangeHigh-rangeLow);
    colorate();
    updateValues();
  }
  
  
  public void display()
  {
	p5.rectMode(PConstants.CORNER);
	p5.noStroke();
	if (isMouseOver() || draged)
	{
		p5.fill(darkColor);
	    p5.rect(x, y, width, height);
	    p5.fill(mainColor);
	    p5.rect(x, y, barWidth, height);
	}
	else
	{
		p5.fill(darkerColor);
	    p5.rect(x, y, width, height);
	    p5.fill(darkColor);
	    p5.rect(x, y, barWidth, height);
	}
    
    
    
    if (draged )
    {
    	if (pos >= x && pos <= x+width) pos = p5.mouseX;
    	if (pos < x) pos = x;
    	if (pos > x+width) pos = x+width;
    	updateValues();
    }
    
    if (p5.mousePressed && isMouseOver() && !draged && !parentDist.isOtherinuse())
    {
    	parentDist.inUse = true;
    	draged = true;
    }
     
    if (!p5.mousePressed && draged)    //    !!! DROP !!!
    {
    	parentDist.inUse = false;
      draged = false;
    }
  }
  
  
  
  private void colorate()
  {
    float dHue = p5.hue(mainColor);
    p5.colorMode(PConstants.HSB, 360, 100, 100);
    
    
    mainColor = p5.color(dHue, 60, 100);
    darkColor = p5.color(dHue, 60, 80);
    darkerColor = p5.color(dHue, 60, 50);
  }
  
  private void updateValues()
  {
	  valueP = (pos-x)/width;
	  value = (rangeHigh-rangeLow)*valueP+rangeLow;
	  barWidth = pos-x;
	  //
  }
  
  public boolean isMouseOver()
  {
	  if (p5.mouseY>=y && p5.mouseY<=(y+height) && p5.mouseX>=x && p5.mouseX<=(x+width)) return true;
	  else return false;
  }
  
  public float getValue()
  {
	  return value;
  }
  
  
  
  public void setPosition (float x, float y)
  {
	  this.x = x;
	  this.y = y;
  }
  
  boolean isInuse()
  {
	  return draged; 
  }
}