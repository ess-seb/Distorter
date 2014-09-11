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

MContainer marker = new MContainer(100, 100, 8, 8);
DContainer[] layers = new DContainer[2];

void setup(){
  size(1920, 1200, P3D);
  //ortho(-width/2, width/2, -height/2, height/2, -1000, 1000);
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
    layer.distortB(marker.getGrid());
  }
  
  background(40);
  fps();
  if (record) {
    beginRaw(DXF, "d:/output.dxf");
  }
  
  //marker.drawGrid();
  //marker.drawNoise1();
  marker.drawVStripes();
  
  if(!record) distConsole.draw();
  
  if (record == true) {
    endRaw();
    record = false; // Stop recording to the file
  }
  for (DContainer layer: layers)
  {
    layer.run();
  }
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
