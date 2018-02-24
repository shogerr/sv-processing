public class Visualization
{
  Boolean drawn = false;

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
  private int[] data;

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
      int max = findMax(data);
      beginShape();
      for (int i = 0; i < data.length; i++)
      {
        vertex(map(i, 0, data.length, 20, s.width-20),
                map(data[i], 0, max, 20, s.height-20));
      }
      endShape();
    }
    drawn = true;
  }

  public void drawPoints()
  {
    if (drawn) return;

    int max = findMax(data);
    for (int i = 0; i < data.length; i++)
    {
      point(map(i, 0, data.length, 20, s.width-20),
              map(data[i], 0, max, 20, s.height-20));
    }

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
