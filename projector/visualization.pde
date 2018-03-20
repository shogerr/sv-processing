public class Visualization
{
  Boolean drawn = false;
  private int[] data;
  
  public void setData(int[] d)
  {
    println("setting data");
    data = d;
  }
  
  public void draw()
  {
    if (!drawn)
    {
      text("No Viz", 0, (float)s.height/2+3);
    }
    drawn = true;
  }
}

public class ScatterPlot extends Visualization
{
  public ScatterPlot()
  {
  }
  public ScatterPlot(int[] d)
  {
    data = d;
  }

  
  public void drawLine()
  {
    if (!drawn)
    {
      //clear();
      int max = findMax(data);
      
      
      color(255, 255, 255);
      noFill();
      beginShape();
      for (int i = 0; i < data.length; i++)
      {
        vertex(map(i, 0, data.length, 20, s.width-20),
                map(data[i], 0, max, 20, s.height-20));
      }
      endShape(CLOSE);
    }
    drawn = true;
  }

  public void drawPoints()
  {
    if (drawn) return;
    clear();
    println("drawing plot");
    println(data);
    int max = findMax(data);
    for (int i = 0; i < data.length; i++)
    {
      ellipse(map(i, 0, data.length, 20, s.width-20),
              map(data[i], 0, max, 20, s.height-20), 2, 2);
    }
    drawn = true;

  }

  public void draw()
  {
    drawLine();
  }
}

void checkerBoard() {
  for (int i = 0; i < s.width; i += 50)
  {
    for (int j = 0; j < s.height; j += 50)
    {
      if ((i+j)%20 == 0)
      {
        fill(150,0,0);
      }
      else
      {
        fill(100,0,0);
      }
      rect(i, j, 50, 50);
    }
  }
}

int findMax(int[] d)
{
  int m = d[0];
  for (int i = 0; i < d.length; i++)
  {
    if (d[i] > m)
    {
      m = d[i];
    }
  }
  return m;
}
/*
void heatMap(float c) {  // Generate the heat map
  float[][] heat_array;
  pushStyle(); 
  // Set drawing mode to HSB instead of RGB
  colorMode(HSB, 1, 1, 1);
  loadPixels();
  int p = 0;
  for (int h = 0; h < height; h++) {
    for (int w = 0; w < width; w++) {
      // Get the heat map value 
      float value = heat_array[w][h];
      // Constrain value to acceptable range.
      value = constrain(value, 25, 30);
      // Map the value to the hue
      // 0.2 blue
      // 1.0 red
      value = map(value, 25, 30, 0.2, c*1.0);
      pixels[p++] = color(value, 0.9, 1);
    }
  }
  updatePixels();
  spout.sendTexture();
  popStyle(); 
}
*/