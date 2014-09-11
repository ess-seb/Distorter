//1.4 - przeniesienie distort() do klasy Distorter, fps
//1.3 - wstępny eksport do pliku, dodawanie nowych dystosji i ich kasowanie

import toxi.geom.*;
import controlP5.*;
import processing.dxf.*;
import processing.opengl.*;


ControlP5 distConsole;
int myColor = color(0,255,175);
float ForceA = 1.5;
float ForceB = 600;
boolean record = false;
PFont font = createFont("Arial",48);

Vec3D[][] markers = new Vec3D[100][100];
ArrayList<Distorter> distorters = new ArrayList<Distorter>();


void setup(){
  size(1500, 1000, P3D);
  //smooth();

  distConsole = new ControlP5(this);
  // add horizontal sliders
  distConsole.addSlider("ForceA",0,5,1.5,100,950,200,20);
  distConsole.addSlider("ForceB",0,2000,600,400,950,200,20);
  //distorters.add(new Distorter(500,500,-22, distorters, true));
  init_markers();
}

void draw(){
  
  //init_markers();
  distort();
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
  
  for (int d=0; d<distorters.size(); d++){
    distorters.get(d).run();
  }
  
}

void drawMarkers(){
  for (int i=0; i<markers.length-1; i++){
    for (int j=0; j<markers.length-1; j++){
      
      fill(170);
      stroke(170,50);
      if (!record) point(markers[i][j].x, markers[i][j].y,0);
      //ellipse(markers[i][j].x, markers[i][j].y, 2, 2);
      line(markers[i][j].x, markers[i][j].y, markers[i+1][j].x, markers[i+1][j].y);
      markers[i][j] = new Vec3D(i*8+(width-800)/2, j*8+100, 0);
    } 
  }  
}

void distort(){
  for (int d=0; d<distorters.size(); d++){
    distorters.get(d).distort(markers);
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
    for (int d=0; d<distorters.size(); d++)
    {
      if (distorters.get(d).selected) 
            distorters.remove(d);
    }
  }
  if (key == 'C' || key == 'c') { 
    distorters.add(new Distorter(500,500,-15, distorters, true));
  }
}

void fps()
{
   textFont(font,12);
   fill(200);
   text(int(frameRate),20,60);
}
