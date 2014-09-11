
	
	
	import toxi.geom.*;
	import processing.core.*;
import java.util.ArrayList;
import java.io.*;
import javax.swing.*;

class MContainer 
{
	private PApplet p5;
	
  Vec3D[][] grid;
  float hspace;
  float vspace;
  int gwidth;
  int gheight;
  boolean recording = false;
  
  MContainer(int w, int h, float hs, float vs, PApplet p5)
  {
	this.p5 = p5;
    grid = new Vec3D[w][h];
    hspace = hs;
    vspace = vs;
    gwidth = w;
    gheight = h;
    init_markersWTC();
  }
  
  void drawHStripes()
  {
	  p5.stroke(200, 90);
	  p5.strokeWeight(1);
    for (int i=1; i<grid.length-1; i++){
      for (int j=1; j<grid[0].length-1; j++){
    	  
          if (!recording) p5.point(grid[i][j].x, grid[i][j].y, grid[i][j].z);
  
          p5.line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[i][j+1].x, grid[i][j+1].y, grid[i][j+1].z);
      }
    }
    init_markersWTC();  
  }
  
  void drawVStripes()
  {

	p5.noFill();
	p5.stroke(170, 70);
    for (int i=1; i<grid.length-1; i++){
    	p5.beginShape();
      for (int j=1; j<grid[0].length-1; j++){
    	  
          if (!recording) p5.point(grid[i][j].x, grid[i][j].y, grid[i][j].z);
          p5.vertex(grid[i][j].x, grid[i][j].y, grid[i][j].z);
          p5.vertex(grid[i+1][j].x, grid[i+1][j].y, grid[i+1][j].z);
          
      }
      p5.endShape();
    }
    init_markersWTC();  
  }
  
  void drawGrid()
  {
    for (int i=1; i<grid.length-1; i++){
      for (int j=1; j<grid[0].length-1; j++){
    	  p5.fill(200);
    	  p5.stroke(170,60);
          if (!recording) p5.point(grid[i][j].x, grid[i][j].y, grid[i][j].z);
          p5.line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[i][j+1].x, grid[i][j+1].y, grid[i][j+1].z);
      }
    }
    init_markersWTC();  
  }
   
  void drawNoise1()
  {
    for (int i=1; i<grid.length-1; i++){
      for (int j=1; j<grid[0].length-1; j++){
    	  p5.fill(255);
    	  p5.stroke(255,100);
          if (!recording) p5.point(grid[i][j].x, grid[i][j].y, grid[i][j].z);
          p5.line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[i+1][j].x, grid[i+1][j].y, grid[i+1][j].z);
          p5.line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[1][j+1].x, grid[i][j+1].y, grid[i][j+1].z);
      }
    }
    init_markersWTC();  
  }
  
  
  
  void init_markers(){
    for (int i=0; i<grid.length; i++){
      for (int j=0; j<grid[0].length; j++){
        grid[i][j] = new Vec3D(i*2+350, j*2+100, 0);
      } 
    }
  }
  
  void init_markersWTC(){
	    for (int i=0; i<grid.length/2; i++){
	      for (int j=0; j<grid[0].length; j++){
	        grid[i][j] = new Vec3D(i*hspace+350, j*vspace+150, 0);
	        grid[i+grid.length/2][j] = new Vec3D(i*hspace+750, j*vspace+150, 0);
	      }  
	    }
	    
   }
  
  Vec3D[][] getGrid()
  {
    return grid;
  }
 
}