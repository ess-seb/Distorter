//1.92 save do pojedyńczego pliku
//1.8 warstwy
//1.7 równy priorytet dystorsji, edytowana oś z
//1.6.1 - id nie nadawane z zewnątrz ale same pytają o id container
//  1.6
//    new: - edycja ustawień distorterów
//    fix: - naciśnięcie przycisków na klawiaturze zmienione na zwolnienie przycisków
//
//  1.5
//    mod: - przeniesienie obsługi kolekcji dystorsji do klasy DContainer
//  
//  1.4  
//    new: - fps
//    mod: - przeniesienie distort() do klasy Distorter
//  
//  1.3  
//    new: - wstępny eksport do pliku
//         - dodawanie nowych dystosji i ich kasowanie

import toxi.geom.*;
import controlP5.*;
import processing.dxf.*;
import processing.opengl.*;
import peasy.*;
import proxml.*;

import java.io.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.*;
import javax.swing.filechooser.FileFilter;

PeasyCam cam;

static ControlP5 distConsole;
XMLInOut xmlIO = new XMLInOut(this);
int myColor = color(0,255,175);
int activeLayer = 0;
boolean record = false;
PFont font = createFont("Arial",48);

Vec3D[][] markers = new Vec3D[100][100];
DContainer[] layers = new DContainer[2];

void setup(){
  size(1500, 1000, P3D);
  //ortho();
  //smooth();

  distConsole = new ControlP5(this);
  initLayers(2);


}

void draw(){
//beginCamera();
//camera();
//translate(0, 0, 1000);
//rotateX(-PI/6);
//endCamera();
  
  
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
  distConsole = new ControlP5(this);
  
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
           xmdistorter.addAttribute("x", layers[xl].getAll().get(xd).getPosition().x);
           xmdistorter.addAttribute("y", layers[xl].getAll().get(xd).getPosition().y);
           xmdistorter.addAttribute("z", layers[xl].getAll().get(xd).getPosition().z);
           xmdistorter.addAttribute("forceA", layers[xl].getAll().get(xd).getForceA());
           xmdistorter.addAttribute("forceB", layers[xl].getAll().get(xd).getForceB());
           xmlayer.addChild(xmdistorter);
           
         }
         file.addChild(xmlayer);
       }
       
       String fsName = 	getFile("Save");
       if (fsName != "")
       {
         xmlIO.saveElement(file, fsName);
       }
       else
       {
         println("ERROR: Not valid saving path");
       }
    break;
    case'L':
      try 
      {
         String flName = getFile("Load");
         if (flName != "")
         {
           xmlIO.loadElement(flName);
         }
         else
         {
           println("ERROR: Not valid loading path");
         }
      } 
      catch (Exception e)
      {
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

void xmlEvent(proxml.XMLElement xmlLoaded)
{
  println("LOADING COMPLETE:");
  initLayers(xmlLoaded.countChildren());
  for (int xl=0; xl<xmlLoaded.countChildren(); xl++)
   {
     println("layer " + xl + ": " + xmlLoaded.getChild(xl).countChildren() + " distorters");
     for (int xd=0; xd<xmlLoaded.getChild(xl).countChildren(); xd++)
     {
       float dist_x = Float.parseFloat(xmlLoaded.getChild(xl).getChild(xd).getAttribute("x"));
       float dist_y = Float.parseFloat(xmlLoaded.getChild(xl).getChild(xd).getAttribute("y"));
       float dist_z = Float.parseFloat(xmlLoaded.getChild(xl).getChild(xd).getAttribute("z"));       
       float dist_fA = Float.parseFloat(xmlLoaded.getChild(xl).getChild(xd).getAttribute("forceA"));
       float dist_fB = Float.parseFloat(xmlLoaded.getChild(xl).getChild(xd).getAttribute("forceB"));
       layers[xl].addDistorter(dist_x, dist_y, dist_z, dist_fA, dist_fB);
       //layers[xl].addDistorter();
     }
   }
}

String getFile(String dialogTxt)
{
  String fName = "";
  JFileChooser fc = new JFileChooser();
  //FileFilter filter = new FileFilter();
  //filter.addExtension("dst");
  //filter.setDescription("Distorter saveing files *.DST");
  //fc.setFileFilter(filter);
  int rc = fc.showDialog(null, dialogTxt);
  if (rc == JFileChooser.APPROVE_OPTION)
  {
    File file = fc.getSelectedFile();
    fName = file.getName();
    println("PATH: "+fName);
  }
  return fName;
}
