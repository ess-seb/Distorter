import toxi.geom.*;
import controlP5.*;

ControlP5 controlP5;
int myColor = color(0,255,175);
float powSlide = 1.5;
float scaSlide = 600;

Vec3D[][] markers = new Vec3D[100][100];
public Vec3D distorter = new Vec3D(500,500,-22);

void setup(){
  size(1500, 1000, P3D);
  smooth();
  controlP5 = new ControlP5(this);
  // add horizontal sliders
  controlP5.addSlider("powSlide",0,5,1.5,100,950,200,20);
  controlP5.addSlider("scaSlide",0,2000,600,400,950,200,20);
}

void draw(){
  distorter.x = mouseX;
  distorter.y = mouseY;
   init_markers();
 distort();
  background(40);
  controlP5.draw();
  drawMarkers();
  
}

void drawMarkers(){
  for (int i=0; i<markers.length-1; i++){
    for (int j=0; j<markers.length-1; j++){
      fill(170);
      stroke(170,50);
      point(markers[i][j].x, markers[i][j].y);
      //ellipse(markers[i][j].x, markers[i][j].y, 2, 2);
      line(markers[i][j].x, markers[i][j].y, markers[i+1][j].x, markers[i+1][j].y);
    } 
  }  
}

void distort(){
  Vec3D dif;
  float distance;
  for (int i=1; i<markers.length-1; i++){
    for (int j=0; j<markers.length-1; j++){
      if (true)  // wyjątek np. dla i!=50
      {
        dif = markers[i][j].sub(distorter);
        distance = dif.magnitude();
        //dif.normalize();
        dif.scaleSelf(scaSlide/pow(distance,powSlide));
        markers[i][j].addSelf(dif);
      }
      
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
