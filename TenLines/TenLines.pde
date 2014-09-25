import java.awt.Robot;
import java.awt.AWTException;
import processing.serial.*;

Robot rob;

boolean alerted;
ArrayList<LineMan> lineList;
ArrayList<Position> atkPosList;
ArrayList<Position> restPosList;
int lastUpdate;

void setup() {
  size(400,400);
  
  //Set up Bot to move mouse
  try {
  rob = new Robot();
  }
  catch (AWTException e) {
    e.printStackTrace();
  }
  updateAtkPositions();
  createRestPositions();
  createLines();
  alerted = false;
  lastUpdate = 0;
}

void draw() {
  background(255);
  updatePositions();
  updateLines();
  drawLines();
}

void keyPressed() {
  //Get x,y of frame to offset changes. 
  int x = frame.getLocation().x;
  int y = frame.getLocation().y;
  rob.mouseMove(x +  width/2, y + height/2);
}

void updatePositions() {
  updateAtkPositions();
  if ((millis() - lastUpdate)/1000.0 >= 1.5) {
    lastUpdate = millis();
    updateRestPositions();
  }
}
void createLines() {
  lineList = new ArrayList<LineMan>();
  for (int i = 0; i < 10; i++) {
    float x = random(width*.1, width*.9);
    float y = random(height * .1, height * .9);
    print(i);
    lineList.add(new LineMan(x,y,i));
  }
}

void updateAtkPositions() { 
  atkPosList = new ArrayList<Position>();
  float r = width * .07; // radius around mouse
  for (int i = 0; i < 10; i++) {
    float theta = i * (6.28 / 10 );
    atkPosList.add(new Position(mouseX + (r * cos(theta)), mouseY + (r * sin(theta)) ) );
// This Code shows the attack positions
    strokeWeight(5);
    point(mouseX + r * cos(theta),mouseY +  r * sin(theta));
  }
}

void createRestPositions() {
  restPosList = new ArrayList<Position>();
  for (int i = 0; i < 10; i++) {
    float x = random(width * .1, width * .9);
    float y = random(height * .1, height * .9);
    restPosList.add(new Position(x,y));
  }
  
}

void updateRestPositions() {
  for (int i = 0; i < 10; i++) {
    if (random(10) < 2) {
      restPosList.get(i).x = random(width*.1, width*.9);
      restPosList.get(i).y = random(height*.1,width*.9);
    }
  }
}

void updateLines() {
  int count = 0;
  for (int i = 0; i < 10; i++) { 
    lineList.get(i).update();
    if (lineList.get(i).alerted){
      count += 1;
    }

  }
  if (count == 10) {
    alerted = true;
  } else {
    alerted = false;
  }
}

void drawLines() {
  for (int i = 0; i < 10; i++) {
    lineList.get(i).drawMe();
  }
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
  Position atkPos;
  Position restPos;
  boolean attacking;
  boolean alerted;
  boolean inPlace;
  float yChange;
  float sinCurve;
  
  LineMan(float x,float y,int index) {
    this.x = x;
    this.y = y;
    this.lineLength = (int)random(height * .05, height * .1);
    this.thickness = (int)random(2, 5);
    this.speed = max(width/4, height/4)/(this.lineLength * this.thickness); //Fatter lines move slower. 
    this.headX = x; 
    this.headY = y - lineLength/2;
    this.bottomX = x;
    this.bottomY = y + lineLength/2;
    this.alerted = false;
    this.update();
    this.index = index;
    this.sinCurve = random(0, 6.28);
  }
  
  void drawMe() {
    strokeWeight(this.thickness);
    line(this.bottomX, this.bottomY, this.headX, this.headY);
  }
  
  void update() {
    if (alerted) {
      this.attacking = true;
    } else {
      this.attacking = false;
    } 
    this.sinCurve += .1;
    this.sinCurve = this.sinCurve % 6.28;
    int coEff;
    if (this.alerted) {
      coEff = 1; //Slow
    } else if ((this.attacking) && (!this.inPlace)){
      coEff = 10; //Fast
    } else if ((this.attacking) && (this.inPlace)) {
      coEff = 2; //Sort of Slow
    } else {
      coEff = 5; //No one on screen
    }
    
    // CoEff... offset by height of window... sin wave
    this.yChange = coEff * (height / (float)400) * sin(this.sinCurve); 
    this.definePos();
    this.move();
  }
  
  void definePos() {
    this.atkPos = atkPosList.get(this.index);
    this.restPos = restPosList.get(this.index); 
    if (this.attacking) {
      if ((abs(this.x - this.atkPos.x) <= width*.02) &&
          (abs(this.y - this.atkPos.y) <= height*.02)) {
        this.inPlace = true;
      } else {
        this.inPlace = false;
      }
    } else {
      if ((abs(this.x - this.restPos.x) <= width * .02) &&
          (abs(this.y - this.restPos.y) <= height * .02)){
        this.inPlace = true;
          } else {
        this.inPlace = false;
          }
    }
  }
  
  void move() {
    if ((this.attacking) && (!this.inPlace)){
      float distance = dist(this.x, this.y, this.atkPos.x, this.atkPos.y);
      this.x += this.speed*(-((this.x - this.atkPos.x)/distance));
      this.y += this.speed*(-((this.y - this.atkPos.y)/distance));
    } else if ((!this.attacking) && (!this.inPlace)){
      float distance = dist(this.x, this.y, this.restPos.x, this.restPos.y);
      this.x += this.speed*(-((this.x - this.restPos.x)/distance));
      this.y += this.speed*(-((this.y - this.restPos.y)/distance));
    }
    this.headX = this.x; 
    this.headY = (this.y - lineLength/2) + this.yChange;
    this.bottomX = this.x;
    this.bottomY = this.y + lineLength/2 + this.yChange;
  }
    
}

class Position {
  float x;
  float y;
  
  Position(float x, float y) {
    this.x = x;
    this.y = y;
  }
}
  
    
    
    
    
    
    
    
    
  
