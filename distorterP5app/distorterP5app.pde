import toxi.geom.*;

Vec3D[][] markers = new Vec3D[100][100];
public Vec3D distorter = new Vec3D(500,500,-22);

void setup(){
  size(1000, 1000, P3D);
  background(0);
  smooth();
  
  init_markers();
  
  distort();
  drawMarkers();
}

void draw(){
  distorter.x = mouseX;
  distorter.y = mouseY;
   init_markers();
 distort();
  background(0);
  drawMarkers();
  
}

void drawMarkers(){
  for (int i=0; i<markers.length-1; i++){
    for (int j=0; j<markers.length-1; j++){
      fill(255);
      stroke(150);
      //point(markers[i][j].x, markers[i][j].y);
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
      dif = markers[i][j].sub(distorter);
      distance = dif.magnitude();
      //dif.normalize();
      dif.scaleSelf(500/pow(distance,1.5));
      markers[i][j].addSelf(dif);
      
    } 
  }
}

void init_markers(){
  for (int i=0; i<markers.length; i++){
    for (int j=0; j<markers.length; j++){
      markers[i][j] = new Vec3D(i*8+100, j*8+100, 0);
    } 
  }
}
