import com.google.gson.annotations.*;
import com.google.gson.*;
import com.google.gson.internal.*;
import com.google.gson.internal.bind.*;
import com.google.gson.internal.bind.util.*;
import com.google.gson.reflect.*;
import com.google.gson.stream.*;

// Main application for producing visualizations
import spout.*;
import hypermedia.net.*;

import java.util.*;
import java.lang.*;

public class Scene
{
  int width = 640;
  int height = 480;
  Visualization viz;
}

public class Command
{
  float value = 0;
  String name;
}

// Create the scene state settings object.
Scene s = new Scene();

Deque<Command> cmds;

// Provide a spout object for sending/recieving.
Spout spout;

// UDP component
UDP udp_client;

// JSON parser
Gson gson = new Gson();

float r=255, g=255, b = 255;

void settings()
{
  // Ensure P3D is set
  size(s.width, s.height, P3D);
}

void setup()
{
  // Setup our program
  // Deque of commands in
  cmds = new ArrayDeque<Command>();

  ArrayList<Float> d = noiseLine(0.0, .05, 1, s.width);
  println(d);
  int[] e = new int[d.size()];
  for (int i = 0; i < d.size(); i++)
  {
    e[i] = int(s.height*d.get(i));
  }

  s.viz = new ScatterPlot(e);

  //// Setup our network
  // Initialize udp client.
  udp_client = new UDP(this, 8051);

  // Turn on logging
  //udp_client.log(true);

  udp_client.listen(true);

  // Initialize spout
  spout = new Spout(this);
  String sender_name = "AR visualizations";

  // Set initial background color
  background(r, g, b);
}

void draw()
{
  if (!cmds.isEmpty())
  {
    Command cmd = cmds.pop();
    switch (cmd.name.toLowerCase())
    {
      case "slider1":
        r = 255*cmd.value;
        break;
      case "slider2":
        b = 255*cmd.value;
        break;
    }

    s.viz.drawn = false;
  }

  //((ScatterPlot) s.viz).drawLine();
  //s.viz.drawn = false;
  //((ScatterPlot) s.viz).drawPoints();
  checkerBoard();
  // Send the spout texture to memory
  spout.sendTexture();
}

// UDP recieve handler. Name is set automatically.
void receive(byte[] d, String ip, int port)
{
  String msg = new String(d);
  JSONObject json = parseJSONObject(msg);

  if (json == null)
  {
    println("JSONObject not parsed.");
  }
  else
  {
    Command m = gson.fromJson(msg, Command.class);
    println(m.value);
    println(m.name);
    cmds.push(m);
  }
}
