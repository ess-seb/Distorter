

import toxi.geom.*;
import controlP5.*;
import processing.dxf.*;
import processing.opengl.*;


static ControlP5 distConsole;
int myColor = color(0,255,175);
boolean record = false;
PFont font = createFont("Arial",48);

Vec3D[][] markers = new Vec3D[100][100];
//ArrayList<Distorter> distorters = new ArrayList<Distorter>();
DContainer distCollection;

void setup(){
  size(1500, 1000, OPENGL);
  //ortho();
  //smooth();

  distConsole = new ControlP5(this);
  distCollection = new DContainer(distConsole);
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

void keyReleased() {
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


void fps()
{
   textFont(font,12);
   fill(200);
   text(int(frameRate),20,60);
}

