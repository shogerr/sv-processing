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

  public void draw()
  {
    if (!drawn)
    {
      int max = findMax(data);
      for (int i = 0; i < data.length; i++)
      {
        ellipse(i*(s.width)/data.length, s.height - (data[i]*(s.height))/(max), 4.0, 4.0);
      }
    }
    drawn = true;
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
