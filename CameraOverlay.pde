import processing.video.*;

import oscP5.*;
import netP5.*;

boolean testMode = true;


//dragons past here

int camStatus; // 1=Ship is alive. 2=Ship is dead 3=Static.
Capture cam;
PImage testImage;
PImage noiseImage;
OscP5 oscP5;
int locX = 1024;
int locY = 0;
PFont fOSD = createFont("Terminal", 72, false);
color cOSD = color(47, 237, 19);
int damageTimer = -1000;

void setup() {
  camStatus = 1; //Initial assumed gamestate.
  size(1024, 768);
  noiseImage = loadImage("noise.png");
  if (testMode) {
    testImage = loadImage("testcam.png");
    locX = 0;
    locY = 0;
  } 
  else {
    cam = new Capture(this, "name=Video Camera           ,size=640x480,fps=30"); //What.
    cam.start();
  }
  oscP5 = new OscP5(this, 12010);
  frame.setLocation(locX, locY);
}

void hide() {
  frame.setLocation(locX, locY);
  frame.setAlwaysOnTop(false);
  frame.hide();
  println("hide");
}

void show() {
  frame.setLocation(locX, locY);
  frame.setAlwaysOnTop(true);
  frame.show();
  println("show");
}

void damage() {
  damageTimer = millis();
}


void draw() {

  switch(camStatus) {
  case 1: //Game running
    background(0);
    if (testMode) {
      image(testImage, 0, 0, width, height);
    } 
    else {
      if (cam.available()) {
        cam.read();
      }
      image(cam, 0, 0, width, height);
      if ( damageTimer + 1000 > millis()) {
        if (random(10) > 3) {
          image(noiseImage, 0, 0, width, height);
        }
      }
    }
    break;
  case 2: //Game dead
    break;
  case 3: //Static.
    loadPixels();
    for (int i = 0; i < pixels.length; i++ ) {
      float rand = random(255);
      color c = color(rand);
      pixels[i] = c;
    }
    updatePixels();
    textFont(fOSD);
    fill(cOSD);
    textAlign(CENTER, CENTER);
    text("DOWNLINK LOST", width/2, height/2);
    break;
  }
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/system/webcam/show")) {
    show();
  } 
  else if (msg.checkAddrPattern("/system/webcam/hide")) {
    hide();
  }   
  else if (msg.checkAddrPattern("/game/reset")) {
    camStatus = 1;
  }   
  else if (msg.checkAddrPattern("/scene/youaredead")) {
    //camStatus = 2 //Added hook for ship death, in case of future shens.
  }
  else if (msg.checkAddrPattern("/system/webcam/downLinkLost")) {
    camStatus = 3;
  }  
  else if (msg.checkAddrPattern("/ship/damage")) {
    damage();
  }
}

