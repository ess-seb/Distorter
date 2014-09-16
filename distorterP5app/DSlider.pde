class DSlider
{
  
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
  

  
  
  
  DSlider(float x, float y, int col, float val, float minVal, float maxVal, Distorter d)
  {

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
    rectMode(PConstants.CORNER);
    noStroke();
  if (isMouseOver() || draged)
  {
    fill(darkColor);
    rect(x, y, width, height);
    fill(mainColor);
    rect(x, y, barWidth, height);
  }
  else
  {
    fill(darkerColor);
    rect(x, y, width, height);
    fill(darkColor);
    rect(x, y, barWidth, height);
  }
    
    
    
    if (draged )
    {
      if (pos >= x && pos <= x+width) pos = mouseX;
      if (pos < x) pos = x;
      if (pos > x+width) pos = x+width;
      updateValues();
    }
    
    if (mousePressed && isMouseOver() && !draged && !parentDist.isOtherinuse())
    {
      parentDist.inUse = true;
      draged = true;
    }
     
    if (!mousePressed && draged) {   //    !!! DROP !!!
      parentDist.inUse = false;
      draged = false;
    }
  }
  
  
  
  private void colorate() {
    float dHue = hue(mainColor);
    colorMode(PConstants.HSB, 360, 100, 100);
    
    
    mainColor = color(dHue, 60, 100);
    darkColor = color(dHue, 60, 80);
    darkerColor = color(dHue, 60, 50);
  }
  
  private void updateValues() {
    valueP = (pos-x)/width;
    value = (rangeHigh-rangeLow)*valueP+rangeLow;
    barWidth = pos-x;
  }
  
  public boolean isMouseOver() {
    if (mouseY>=y && mouseY<=(y+height) && mouseX>=x && mouseX<=(x+width)) return true;
    else return false;
  }
  
  public float getValue() {
    return value;
  }
  
  
  
  public void setPosition (float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  boolean isInuse() {
    return draged; 
  }
}
