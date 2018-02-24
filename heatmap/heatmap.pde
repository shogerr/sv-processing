import java.util.*;
import java.lang.*;

import com.google.gson.annotations.*;
import com.google.gson.*;
import com.google.gson.internal.*;
import com.google.gson.internal.bind.*;
import com.google.gson.internal.bind.util.*;
import com.google.gson.reflect.*;
import com.google.gson.stream.*;

import spout.*;
import processing.opengl.*;
import hypermedia.net.*;

Spout spout;
float[][] heat_array;
int[] values;

public class Command
{
  float value = 0;
  String name;
}

Deque<Command> cmds;

// UDP component
UDP udp_client;

// JSON parser
Gson gson = new Gson();

void setup() {
  size(400, 400, OPENGL);
  //// Setup our network
  // Initialize udp client.
  udp_client = new UDP(this, 8051);
  // Turn on logging
  //udp_client.log(true);
  udp_client.listen(true); 
  
  cmds = new ArrayDeque<Command>();
  
  spout = new Spout(this);
  spout.createSender("Spout from Processing");
  heat_array = new float[width][height];
  makeArray();
  applyColor(1.0);
  
}

// Fill array with Perlin noise (smooth random) values
void makeArray() {
  for (int h = 0; h < height; h++) {
    for (int w = 0; w < width; w++) {
      // Range is 24.8 - 30.8
      heat_array[w][h] = 24.8 + 6.0 * noise(h * 0.02, w * 0.04);
    }
  }
}
 
void applyColor(float c) {  // Generate the heat map
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

void draw()
{
  if (!cmds.isEmpty())
  {
    Command cmd = cmds.pop();
    switch (cmd.name.toLowerCase())
    {
      case "slider1":
        applyColor(cmd.value);
    }
  }
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