

import toxi.geom.*;
import controlP5.*;
import processing.dxf.*;
import processing.opengl.*;
import peasy.*;
import proxml.*;

PeasyCam cam;

static ControlP5 distConsole;
XMLInOut xmlIO = new XMLInOut(this);
int myColor = color(0,255,175);
int activeLayer = 0;
boolean record = false;
PFont font = createFont("Arial",48);

Vec3D[][] markers = new Vec3D[100][100];
//ArrayList<Distorter> distorters = new ArrayList<Distorter>();
DContainer distCollection;
DContainer[] layers = new DContainer[2];
//ListBox mlist;

void setup(){
  size(1500, 1000, P3D);
  //ortho();
  //smooth();

  distConsole = new ControlP5(this);
  initLayers(2);

  
  //distConsole.addListBox("Layers",0,10,100,12);
  //mlist = (ListBox)distConsole.getGroup("Layers");
  //mlist.addItem("Layer 1", 1);
  //mlist.addItem("Layer 2", 3);
  //mlist.addItem("Layer 3", 2);
  //mlist.setHeight(600); 


}

void draw(){
  
  for (DContainer layer: layers)
  {
    layer.distortB(markers);
  }
  
  background(40);
  fps();
  if (record == true) {
    beginRaw(DXF, "d:/output.dxf");
  }
  else distConsole.draw();
  
  drawMarkers();
  if (record == true) {
    endRaw();
    record = false; // Stop recording to the file
  }
  for (DContainer layer: layers)
  {
    layer.run();
  }
}

void drawMarkers(){
  for (int i=1; i<markers.length-1; i++){
    for (int j=1; j<markers.length-1; j++){
      
      fill(200);
      stroke(170,60);
      if (!record) point(markers[i][j].x, markers[i][j].y, markers[i][j].z);
      //line(markers[i][j].x, markers[i][j].y, markers[i+1][j].x, markers[i+1][j].y);
      line(markers[i][j].x, markers[i][j].y, markers[i][j].z, markers[i][j+1].x, markers[i][j+1].y, markers[i][j+1].z);
      //markers[i][j] = new Vec3D(i*8+(width-800)/2, j*8+100, 0);
    }
  }
  init_markers();  
}

void initLayers(int n)
{
  layers = new DContainer[n];
  for (int i=0; i<n; i++)
  {
    layers[i] = new DContainer(distConsole);
  }
  layers[0].setActive(true);
  init_markers();
}

void init_markers(){
  for (int i=0; i<markers.length; i++){
    for (int j=0; j<markers.length; j++){
      markers[i][j] = new Vec3D(i*8+(width-800)/2, j*8+100, 0);
    } 
  }
}

void keyReleased() {
  switch(key){
    
    case 'E':
    case 'e':
      record = true;
    break;
    
    case DELETE:
      layers[activeLayer].removeDistorter();
    break;
    
    case 'C':
    case 'c':
      layers[activeLayer].addDistorter();
    break;
    
    case '1':
      activeLayer = 0;
      layers[0].setActive(true);
      layers[1].setActive(false);
    break;
    
    case '2':
      activeLayer = 1;
      layers[1].setActive(true);
      layers[0].setActive(false);
    break;  
    case 'k':
      cam = new PeasyCam(this, 100);
      cam.setMinimumDistance(50);
      cam.setMaximumDistance(1000);
    break;
    case 'S':
      proxml.XMLElement file = new proxml.XMLElement("root");
      proxml.XMLElement[] xmlLayer = new proxml.XMLElement[layers.length];
      ArrayList<proxml.XMLElement> xmlDistCont = new ArrayList<proxml.XMLElement>();
      
      for (int xl=0; xl<layers.length; xl++)
       {
         proxml.XMLElement xmlayer = new proxml.XMLElement("layer_"+xl);
         xmlayer.addAttribute("id", xl);
         for (int xd=0; xd<layers[xl].getAll().size(); xd++)
         {
           proxml.XMLElement xmdistorter = new proxml.XMLElement("distorter_"+xd);
           xmdistorter.addAttribute("id", xd);
           xmlayer.addChild(xmdistorter);
           
           proxml.XMLElement xmposition = new proxml.XMLElement("position");
           xmposition.addAttribute("x", layers[xl].getAll().get(xd).getPosition().x);
           xmposition.addAttribute("y", layers[xl].getAll().get(xd).getPosition().y);
           xmposition.addAttribute("z", layers[xl].getAll().get(xd).getPosition().z);
           xmdistorter.addChild(xmposition);
           
           proxml.XMLElement xmforces = new proxml.XMLElement("forces");
           xmforces.addAttribute("forceA", layers[xl].getAll().get(xd).getForceA());
           xmforces.addAttribute("forceB", layers[xl].getAll().get(xd).getForceB());
           xmdistorter.addChild(xmforces);
         }
         file.addChild(xmlayer);
       }
       
       xmlIO.saveElement(file, "save.xml");
    break;
    case'L':
      try {
        xmlIO.loadElementFrom("save.xml");
      } catch (Exception e) {
        println("LOADING ERROR");
      }
    break;    
    
    
  }
  
}


void fps()
{
   textFont(font,12);
   fill(200);
   text(int(frameRate),20,60);
}

void xmlEvent(proxml.XMLElement xmlElement){
  
}
