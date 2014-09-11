//1.5 - przeniesienie obsługi kolekcji dystorsji do klasy DContainer
//1.4 - przeniesienie distort() do klasy Distorter, fps
//1.3 - wstępny eksport do pliku, dodawanie nowych dystosji i ich kasowanie

import toxi.geom.*;
import controlP5.*;
import processing.dxf.*;
import processing.opengl.*;


ControlP5 distConsole;
int myColor = color(0,255,175);
boolean record = false;
PFont font = createFont("Arial",48);

Vec3D[][] markers = new Vec3D[100][100];
//ArrayList<Distorter> distorters = new ArrayList<Distorter>();
DContainer distCollection = new DContainer();

void setup(){
  size(1500, 1000, P3D);
  //ortho();
  //smooth();

  distConsole = new ControlP5(this);
  distConsole.addSlider("ForceA",0,5,1.5,100,950,200,20);
  distConsole.addSlider("ForceB",0,2000,600,400,950,200,20);
  init_markers();
}

void draw(){
  
  distCollection.distort(markers);
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
  
  distCollection.run();
}

void drawMarkers(){
  for (int i=1; i<markers.length-1; i++){
    for (int j=1; j<markers.length-1; j++){
      
      fill(170);
      stroke(170,50);
      if (!record) point(markers[i][j].x, markers[i][j].y,0);
      //ellipse(markers[i][j].x, markers[i][j].y, 2, 2);
      //line(markers[i][j].x, markers[i][j].y, markers[i+1][j].x, markers[i+1][j].y);
      line(markers[i][j].x, markers[i][j].y, markers[i][j+1].x, markers[i][j+1].y);
      markers[i][j] = new Vec3D(i*8+(width-800)/2, j*8+100, 0);
    }
  }  
}

void init_markers(){
  for (int i=0; i<markers.length; i++){
    for (int j=0; j<markers.length; j++){
      markers[i][j] = new Vec3D(i*8+(width-800)/2, j*8+100, 0);
    } 
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') {
    record = true;
  }
  if (key == DELETE) { 
    distCollection.removeDistorter();
  }
  if (key == 'C' || key == 'c') { 
    distCollection.addDistorter();
  }
}

public void controlEvent(ControlEvent theEvent) {
  switch(theEvent.controller().id()) {
    case(1): // numberboxA
    //myColorRect = (int)(theEvent.controller().value());
    break;
    case(2):  // numberboxB
    //myColorBackground = (int)(theEvent.controller().value());
    break;  
  }
}

void fps()
{
   textFont(font,12);
   fill(200);
   text(int(frameRate),20,60);
}
