

	
import processing.core.*;	import processing.core.XML;

	import processing.dxf.*;
	import processing.opengl.*;
	
	import java.io.*;
	import javax.swing.*;	
import java.util.ArrayList;
	
	


public class Commander extends PApplet {

	//1.12 przeniesienie projektu do eclipse, fix b³¹d gdy grid mia³ ró¿ne boki, przepisanie save/load na natywn¹ obs³ugê xml z p5 - rezygnacja z niedzia³aj¹cej pod eclipse proxml, przepisanie suwaków na w³asne - rezygnacja z controlP5, dopisanie inUse — gdy coœ jest przesuwane inne nie reagujê¹
	//1.11 marker container, zaczêty DSlider
	//1.10 load do pojedyñczego pliku
	//1.9.2 save do pojedyñczego pliku
	//1.8 warstwy
	//1.7 równy priorytet dystorsji, edytowana oœ z
	//1.6.1 - id nie nadawane z zewn¹trz ale same pytaj¹ o id container
	//  1.6
//	    new: - edycja ustawieñ distorterów
//	    fix: - naciœniêcie przycisków na klawiaturze zmienione na zwolnienie przycisków
	//
	//  1.5
//	    mod: - przeniesienie obs³ugi kolekcji dystorsji do klasy DContainer
	//  
	//  1.4  
//	    new: - fps
//	    mod: - przeniesienie distort() do klasy Distorter
	//  
	//  1.3  
//	    new: - wstêpny eksport do pliku
//	         - dodawanie nowych dystosji i ich kasowanie


	

	int myColor = color(0,255,175);
	int activeLayer = 0;
	boolean record = false;
	boolean wait = false;
	PFont font = createFont("Arial", 48);

	//MContainer marker = new MContainer(100, 700, 4, 1, this); //for printing
	MContainer marker = new MContainer(70, 100, 5, 5, this); //for animation
	DContainer[] layers = new DContainer[2];
	
	PApplet p5 = this;

	DSlider mySlider;
	
	static public void main(String args[]) {
		PApplet.main(new String[] { "--present","Commander"});
	}
	
	
	
	public void setup(){
	  size(1280, 800, P3D);
	  //fs = new fullscreen.SoftFullScreen(p5);
	  //fs = new FullScreen(p5); 
	  //fs.enter();
	  //ortho(-width/2, width/2, -height/2, height/2, -1000, 1000);
	  
	  noSmooth();

	  initLayers(1);
	  for (int e=0; e<40; e++)
	  {
		//  layers[0].addDistorter(random(200, 1000), random(70, 400), 10, random(8, 30)/30, random(1800));
	  }

	}

	public void draw(){
		 
	//beginCamera();
	//camera();
	//translate(0, 0, 1000);
	//rotateX(-PI/6);
	//endCamera();
		//layers[0].addDistorter(random(200, 1000), random(200, 400), 10, random(10, 30)/10, random(1800));
	  
		p5.scale(0.5f);
	//translate(0,0);
	 if (!wait)
	  {
		  for (DContainer layer: layers)
		  {
		    layer.distortB(marker.getGrid());
		  }
	  
		  background(60);
		  if (record) {
			  marker.recording = true;
		    beginRaw(DXF, selectOutput()+".dxf");
		  }
		  
		  //marker.drawGrid();
		  //marker.drawNoise1();
		  marker.drawHStripes();
		  
		  
		  if (record == true) {
			  marker.recording = false;
		    endRaw();
		    record = false; // Stop recording to the file
		  }
		  for (DContainer layer: layers)
		  {
		    layer.run();
		  }
	  }
	 //System.out.println(wait);
	 wait = false;
	 
	 fps();
	  
	}



	void initLayers(int n)
	{
	  
	  layers = new DContainer[n];
	  for (int i=0; i<n; i++)
	  {
	    layers[i] = new DContainer(this);
	  }
	  layers[0].setActive(true);
	}



	public void keyReleased() {
	  switch(key){
	    
	    case 'E':
	    case 'e':
	      record = true;
	      wait = false;
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
	    case 'S':
	    	String fsName = selectOutput();
	      XML file = new XML(p5, fsName);
	      
	      for (int xl=0; xl<layers.length; xl++)
	       {
	         XML xmlayer = new XML("layer_"+xl);
	         xmlayer.setInt("id", xl);
	         for (int xd=0; xd<layers[xl].getAll().size(); xd++)
	         {
	           XML xmdistorter = new XML("distorter_"+xd);
	           xmdistorter.setInt("id", xd);
	           xmdistorter.setFloat("x", layers[xl].getAll().get(xd).getPosition().x);
	           xmdistorter.setFloat("y", layers[xl].getAll().get(xd).getPosition().y);
	           xmdistorter.setFloat("z", layers[xl].getAll().get(xd).getPosition().z);
	           xmdistorter.setFloat("forceA", layers[xl].getAll().get(xd).getForceA());
	           xmdistorter.setFloat("forceB", layers[xl].getAll().get(xd).getForceB());
	           //xmlayer.addChild(xmdistorter);
	         }
	         //file.addChild(xmlayer);  -- nie dzia³a w p2.0alfa

	       }
	       
	       
	       //println("PATH: "+fsName);
	       if (fsName != "")
	       {
	        // file.save(fsName); -- nie dzia³a w p2.0alfa
	       }
	       else
	       {
	         println("ERROR: Not valid saving path");
	       }
	    break;
	    case'L':
	         String flName = selectInput();
	         
	         println("LOADING COMPLETE:");
	         XML xmlLoaded = new XML(p5, flName);
	   	  initLayers(xmlLoaded.getChildCount());
	   	  for (int xl=0; xl<xmlLoaded.getChildCount(); xl++)
	   	   {
	   	     println("layer " + xl + ": " + xmlLoaded.getChild(xl).getChildCount() + " distorters");
	   	     for (int xd=0; xd<xmlLoaded.getChild(xl).getChildCount(); xd++)
	   	     {
	   	       float dist_x = xmlLoaded.getChild(xl).getChild(xd).getFloat("x");
	   	       float dist_y = xmlLoaded.getChild(xl).getChild(xd).getFloat("y");
	   	       float dist_z = xmlLoaded.getChild(xl).getChild(xd).getFloat("z");       
	   	       float dist_fA = xmlLoaded.getChild(xl).getChild(xd).getFloat("forceA");
	   	       float dist_fB = xmlLoaded.getChild(xl).getChild(xd).getFloat("forceB");
	   	       
	   	       layers[xl].addDistorter(dist_x, dist_y, dist_z, dist_fA, dist_fB);
	   	       //layers[xl].addDistorter();
	   	     }
	   	   }
	     
	    break;
	    case'R':
	         
	   	 initLayers(1);
		  for (int e=0; e<40; e++)
		  {
			  layers[0].addDistorter(random(200, 1000), random(70, 400), 10, random(8, 30)/30, random(1800));
		  }		
	     wait = false;
	    break;
	    case'T':
	         
		   	 initLayers(1);
			  for (int e=0; e<45; e++)
			  {
				  layers[0].addDistorter(random(200, 1000), random(200, 400), -12, random(10, 30)/10, random(1800));
			  }
		     wait = false;
		break;
	    case'Y':
	         
		   	 initLayers(1);
			  for (int e=0; e<20; e++)
			  {
				  layers[0].addDistorter(random(200, 1000), random(200, 400), -12, random(10, 30)/18, random(1500));
			  }
		     wait = false;
		break;
	    
	    
	  }
	  
	}


	void fps()
	{
	   textFont(font,12);
	   fill(200);
	   text((int) (frameRate),20,60);
	}

	void xmlEvent(proxml.XMLElement xmlLoaded)
	{
	  
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
	
	
}
