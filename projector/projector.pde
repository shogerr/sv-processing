// Main application for producing visualizations
import spout.*;
import hypermedia.net.*;

import java.util.*;

public class Scene
{
  int width = 640;
  int height = 480;
}

public class Command
{
  float value = 0;
}

// Create the scene state settings object.
Scene s = new Scene();

Deque<Float> cmds;

// Provide a spout object for sending/recieving.
Spout spout;

// UDP component
UDP udp_client;

void settings()
{
  // Ensure P3D is set
  size(s.width, s.height, P3D);
}

void setup()
{
  cmds = new ArrayDeque<Float>();
  // Initialize udp client.
  udp_client = new UDP(this, 8051);

  // Turn on logging
  //udp_client.log(true);
  udp_client.listen(true);

  // Initialize spout
  spout = new Spout(this);
  String sender_name = "AR visualizations";
  background(255, 100, 100);
}

void draw()
{
  if (!cmds.isEmpty())
  {
    background(cmds.pop()*255, 100, 100);
  }

  // Send the spout texture to memory
  spout.sendTexture();
}

// UDP recieve handler. Name is set automatically.
void receive(byte[] d, String ip, int port)
{
  //Trimming any extra characters
  //d = subset(d, 0, d.length);

  String msg = new String(d);
  JSONObject json = parseJSONObject(msg);

  if (json == null)
  {
    println("JSONObject not parsed.");
  }
  else
  {
    cmds.push(json.getFloat("value"));
  }
}
