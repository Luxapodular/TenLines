import java.awt.Robot;
import java.awt.AWTException;
import processing.serial.*;

Robot rob;
LineMan a;

void setup() {
  size(400, 400);
  
  //Set up Bot to move mouse
  try {
  rob = new Robot();
  }
  catch (AWTException e) {
    e.printStackTrace();
  }
  
}

void draw() {
  background(255);
}

void keyPressed() {
  //Get x,y of frame to offset changes. 
  int x = frame.getLocation().x;
  int y = frame.getLocation().y;
  rob.mouseMove(x +  width/2, y + height/2);
}

class LineMan {
  float x;
  float y;
  float lineLength;
  float thickness;
  float headX;
  float headY;
  float bottomX;
  float bottomY;
  float distance;
  int index;
  float speed;
  
  LineMan(float x,float y,int index) {
    this.x = x;
    this.y = y;
    this.lineLength = (int)random(height * .05, height * .1);
    this.thickness = (int)random(2, 5);
    this.speed = 20/(this.lineLength + this.thickness);
    this.headX = x; 
    this.headY = y - lineLength/2;
    this.bottomX = x;
    this.bottomY = y + lineLength/2;
    this.update();
  }
  
  void drawMe() {
    strokeWeight(this.thickness);
    line(this.bottomX, this.bottomY, this.headX, this.headY);
  }
  
  void update() {
    this.xSlope = abs(this.x - this.headX);
    this.ySlope = abs(this.y - this.headY);
    this.xToMouse = abs(this.x - mouseX);
    this.yToMouse = abs(this.y - mouseY);
    this.distance = dist(this.x, this.y, mouseX, mouseY);
    
    this.ratio = (float)this.lineLength / (float)this.distance;
    
    this.defProperPos();
    this.move();
    this.headX = this.x;
    this.headY = this.y - lineLength /2;
    this.bottomX = (int)(this.bottomX - this.xChange);
    this.bottomY = (int)(this.bottomY - this.yChange);
  }
  
  void defProperPos() {
    if (this.x - mouseX < 0){
      this.properX = (int)(this.x +this.xToMouse * this.ratio);
    } else {
      this.properX = (int)(this.x-( this.xToMouse * this.ratio));
    }
    if (this.y - mouseY < 0) {
      this.properY = (int)(this.y + this.yToMouse * this.ratio);
    } else {
      this.properY = (int)(this.y -(this.yToMouse * this.ratio));
    }
  }
  
  void move() {
    if (this.x < this.properX) {
      this.xChange = 1;
      this.x += this.xChange;
    } else if (this.x > this.properX) {
      this.xChange = -1;
      this.x += this.xChange;
    }
    
    if (this.y < this.properY) {
      this.yChange = 1;
      this.y += this.yChange;
    } else if (this.y > this.properY) {
      this.yChange = -1;
      this.y += this.yChange;
    }
  }
}  
    
    
    
    
    
    
    
    
  
