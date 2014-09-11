class DSlider
{
  public int id;
  public float value;
  public color mainColor;
  public color darkColor;
  public color darkerColor;
  
  public float x;
  public float y;
  public float z;
  
  public float width;
  public float height;
  
  public float rangeLow = 0;
  public float rangeHigh = 700;
  
  private float xt, yt;
  DContainer container;
  
  
  
  DSlider(float x, float y, float z, color col, float val, float maxVal, float minVal)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    mainColor = col;
    value = val;
    rangeHigh = maxVal;
    rangeLow  = minVal;
  }
  
  void drawSlider()
  {
    rectMode(CORNER);
    rect(35, 35, 50, 50);
  }
  
  void Colorate()
  {
    float dHue = hue(mainColor);
    colorMode(HSB, 360, 100, 100);
    
    
    mainColor = color(dHue, 60, 100);
    darkColor = color(dHue, 60, 100);
    darkerColor = color(dHue, 60, 100);
  }
  
}
