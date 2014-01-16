import processing.video.*;

import oscP5.*;
import netP5.*;

boolean testMode = true;
boolean gameStatus = true;
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
  size(1024, 768);
  noiseImage = loadImage("noise.png");
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
  frame.setLocation(locX, locY);
  frame.setAlwaysOnTop(false);
  frame.hide();
}

void show() {
  frame.setLocation(locX, locY);
  frame.setAlwaysOnTop(true);
  frame.show();
}

void damage() {
  damageTimer = millis();
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
      if ( damageTimer + 1000 > millis()) {
        if (random(10) > 3) {
          image(noiseImage, 0, 0, width, height);
        }
      }
    }
  } 
  else {
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
  }
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/system/externalCam/show")) {
    if (gameStatus) show();
  } 
  else if (msg.checkAddrPattern("/system/externalCam/hide")) {
    if (gameStatus) hide();
  }   
  else if (msg.checkAddrPattern("/game/reset")) {
    gameStatus = true;
  }   
  else if (msg.checkAddrPattern("/scene/youaredead")) {
    gameStatus = false;
    show();
  }  
  else if (msg.checkAddrPattern("/ship/damage")) {
    damage();
  }
}

