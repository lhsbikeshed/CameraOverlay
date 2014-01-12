import processing.video.*;

import oscP5.*;
import netP5.*;

boolean testMode = true;

Capture cam;
PImage testImage;
OscP5 oscP5;


void setup(){
  size(1024,768);
  if(testMode){
    testImage = loadImage("testcam.png");
  } else {
    cam = new Capture(this, 640, 480, "SMI Grabber Device", 30);
    cam.start();
  }
  
  oscP5 = new OscP5(this, 12010);
}

void hide(){
  frame.setAlwaysOnTop(false);
  frame.hide();
  
}

void show(){
   frame.setAlwaysOnTop(true);
  frame.show();
}


void draw(){
  background(0);
  if(testMode){
    image(testImage, 0, 0, width, height);
  } else {
    if(cam.available()){
      cam.read();
    }
    image(cam,0,0,width,height);
  }
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/system/externalCam/show")){
    show();
  } else if(msg.checkAddrPattern("/system/externalCam/hide")){
    hide();
  }  
  
}



  
