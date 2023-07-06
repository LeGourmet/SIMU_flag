import peasy.*;
import java.util.Collections;

final float   DELTA_TIME          = 0.1;
final PVector GRAVITY             = new PVector(0.,9.81,0.);
final PVector WIND                = new PVector(10.,5.,5.);

final String  FLAG_TEXTURE        = "FrenchFlag.jpg";
final int     FLAG_SIZE_X         = 100;
final int     FLAG_SIZE_Y         = 50;
final int     FLAG_POINT_DENSITY  = 8;
final float   FLAG_K              = 20.;
final float   FLAG_C              = 0.5;
final float   FLAG_MAX_STRETCHING = 1.35f;
final float   FLAG_MIN_STRETCHING = 0.1f;
final float   FLAG_MASS           = 1500;

PeasyCam camera;
Flag flag;

void setup(){
  size(900,600,P3D);
  camera = new PeasyCam(this,1000);
  
  flag = new Flag(FLAG_SIZE_X, FLAG_SIZE_Y, FLAG_MASS);   

  noStroke();
  fill(255); 
}

void draw(){  
  background(30);
  lights();

  flag.display();
  flag.computeForces(DELTA_TIME);
  flag.updatePositions(DELTA_TIME);  
  flag.constrain();
}

void keyPressed(){
  switch(key){
    case 'r' : flag.reset(); break;
    case 'p' : println("frameRate: "+frameRate); 
  }
}
