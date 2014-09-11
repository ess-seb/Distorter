class MContainer
{
  Vec3D[][] grid;
  float hspace;
  float vspace;
  int gwidth;
  int gheight;
  
  MContainer(int w, int h, float hs, float vs)
  {
    grid = new Vec3D[w][h];
    hspace = hs;
    vspace = vs;
    gwidth = w;
    gheight = h;
    init_markers();
  }
  
  void drawHStripes()
  {
    for (int i=1; i<grid.length-1; i++){
      for (int j=1; j<grid[0].length-1; j++){
          fill(200);
          stroke(170,60);
          if (!record) point(grid[i][j].x, grid[i][j].y, grid[i][j].z);
          line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[i][j+1].x, grid[i][j+1].y, grid[i][j+1].z);
      }
    }
    init_markers();  
  }
  
  void drawVStripes()
  {
    for (int i=1; i<grid.length-1; i++){
      for (int j=1; j<grid[0].length-1; j++){
          fill(200);
          stroke(170,60);
          if (!record) point(grid[i][j].x, grid[i][j].y, grid[i][j].z);
          line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[i+1][j].x, grid[i+1][j].y, grid[i+1][j].z);
      }
    }
    init_markers();  
  }
  
  void drawGrid()
  {
    for (int i=1; i<grid.length-1; i++){
      for (int j=1; j<grid[0].length-1; j++){
          fill(200);
          stroke(170,60);
          if (!record) point(grid[i][j].x, grid[i][j].y, grid[i][j].z);
          line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[i][j+1].x, grid[i][j+1].y, grid[i][j+1].z);
      }
    }
    init_markers();  
  }
  
  void drawNoise1()
  {
    for (int i=1; i<grid.length-1; i++){
      for (int j=1; j<grid[0].length-1; j++){
          fill(255);
          stroke(255,100);
          if (!record) point(grid[i][j].x, grid[i][j].y, grid[i][j].z);
          line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[i+1][j].x, grid[i+1][j].y, grid[i+1][j].z);
          line(grid[i][j].x, grid[i][j].y, grid[i][j].z, grid[1][j+1].x, grid[i][j+1].y, grid[i][j+1].z);
      }
    }
    init_markers();  
  }
  
  
  
  void init_markers(){
    for (int i=0; i<grid.length; i++){
      for (int j=0; j<grid.length; j++){
        grid[i][j] = new Vec3D(i*8+700/2, j*8+100, 0);
      } 
    }
  }
  
  Vec3D[][] getGrid()
  {
    return grid;
  }
 
}
