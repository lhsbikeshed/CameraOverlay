import processing.video.*;

import oscP5.*;
import netP5.*;

boolean testMode = true;
boolean gameStatus;
Capture cam;
PImage testImage;
OscP5 oscP5;


void setup() {
  size(1024, 768);
  if (testMode) {
    testImage = loadImage("testcam.png");
  } 
  else {
    cam = new Capture(this, 640, 480, "SMI Grabber Device", 30);
    cam.start();
  }

  oscP5 = new OscP5(this, 12010);
}

void hide() {
  frame.setAlwaysOnTop(false);
  frame.hide();
}

void show() {
  frame.setAlwaysOnTop(true);
  frame.show();
}


void draw() {
  if (gameStatus) {
    background(0);
    if (testMode) {
      image(testImage, 0, 0, width, height);
    } 
    else {
      if (cam.available()) {
        cam.read();
      }
      image(cam, 0, 0, width, height);
    }
  } 
  else {
    show();
    loadPixels();
    //This may need slowing down. It's a bit trippy.
    for (int i = 0; i < pixels.length; i++ ) {
      float rand = random(255);
      color c = color(rand);
      pixels[i] = c;
    }
    updatePixels();
  }
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/system/externalCam/show")) {
    if (gameStatus) show();
  } 
  else if (msg.checkAddrPattern("/system/externalCam/hide")) {
    if (gameStatus) hide();
  }   
  else if (msg.checkAddrPattern("/the/game/has/been/reset")) { //Find the actual OSC format for this..
    gameStatus = true;
  }   
  else if (msg.checkAddrPattern("/the/goddamn/ship/blew/up")) { //And this...
    gameStatus = false;
  }
}

