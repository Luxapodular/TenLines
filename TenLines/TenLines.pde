import java.awt.Robot;
import java.awt.AWTException;
import processing.serial.*;

Robot rob;

boolean alerted;
ArrayList<LineMan> lineList;
ArrayList<Position> atkPosList;
ArrayList<Position> restPosList;

void setup() {
  size(400, 400);
  
  //Set up Bot to move mouse
  try {
  rob = new Robot();
  }
  catch (AWTException e) {
    e.printStackTrace();
  }
  createLines();
  createRestPositions();
  alerted = false;
}

void draw() {
  background(255);
  updateAtkPositions();
  updateRestPositions();
  updateLines();
  drawLines();
}

void keyPressed() {
  //Get x,y of frame to offset changes. 
  int x = frame.getLocation().x;
  int y = frame.getLocation().y;
  rob.mouseMove(x +  width/2, y + height/2);
}

void createLines() {
  lineList = new ArrayList<LineMan>();
  for (int i = 0; i < 10; i++) {
    float x = random(width*.1, width*.9);
    float y = random(height * .1, height * .9);
    lineList.add(new LineMan(x,y,i));
  }
}

void updateAtkPositions() { 
  atkPosList = new ArrayList<Position>();
  float radius = width * .07;
  for (int i = 0; i < 10; i++) {
    float theta = i * (6.28 / 10 );
    atkPosList.add(new Position(r * cos(theta), r * sin(theta)));
  }
}

void createRestPositions() {
  restPosList = new ArrayList<Position>();
  for (int i = 0; i < 10; i++) {
    float x = random(width * .1, width * .9);
    float y = random(height * .1, height * .9);
    restPosList.add(Position(x,y));
  }
}

void updateRestPositions() {
  for (int i = 0; i < 0; i++) {
    if (random(10) < 1.2) {
      restPosList.get(i) = new Position(random(width*.1, width*.9),
                                        random(height*.1,width*.9));
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
  if (count = 10) {
    alerted = true;
  } else {
    alerted = false;
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
  
  LineMan(float x,float y,int index) {
    this.x = x;
    this.y = y;
    this.lineLength = (int)random(height * .05, height * .1);
    this.thickness = (int)random(2, 5);
    this.speed = 20/(this.lineLength + this.thickness); //Fatter lines move slower. 
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
    if (alerted) {
      this.attacking = true;
    } else {
     this.attacking = false;
    } 
    this.definePos();
    this.move();
  }
  
  void definePos() {
    this.atkPos = atkPosList.get(this.index);
    this.restPos = restPosList.get(this.index);  
  }
  
  void move() {
    if (this.attacking) {
      float distance = dist(this.x, this.y, this.atkPos.x, this.atkPos.y);
      this.x += this.speed*(-((this.x - this.atkPos.x)/distance));
      this.y += this.speed*(-((this.y - this.atkPos.y)/distance));
    } else {
      float distance = dist(this.x, this.y, this.resPos.x, this.restPos.y);
      this.x += this.speed*(-((this.x - this.restPos.x)/distance));
      this.y += this.speed*(-((this.y - this.restPos.y)/distance));
    }
    this.headX = x; 
    this.headY = y - lineLength/2;
    this.bottomX = x;
    this.bottomY = y + lineLength/2;
  }
    
}

class Position {
  int x;
  int y;
  
  Position(int x, int y) {
    this.x = x;
    this.y = y;
  }
}
  
    
    
    
    
    
    
    
    
  
