public class Flag{
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  public int sizeX;
  public int sizeY;
  public float mass;
  
  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public Point[][] points;
  public ArrayList<Spring> springs;
  
  public Flag(int sizeX, int sizeY, float mass){
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.mass = mass;
    
    reset();
  }
  
  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public void reset(){
    this.points = new Point[sizeX][sizeY];
    this.springs = new ArrayList<>();
    
    final float massPoints = mass/float(sizeX*sizeY);
    PImage img = loadImage(FLAG_TEXTURE);
    img.resize(sizeX,sizeY);
    
    // construct grid
    for(int i=0; i<points.length ;i++)
      for(int j=0; j<points[0].length ;j++)
        points[i][j] = new Point(FLAG_POINT_DENSITY*(i-0.5*sizeX),FLAG_POINT_DENSITY*(j-0.5*sizeY), 0., img.pixels[j*sizeX+i], massPoints);
       
    // construct springs
    for(int i=0; i<points.length ;i++)
      for(int j=0; j<points[i].length ;j++){
        if(i<points.length-1)                         springs.add(new Spring(points[i][j],points[i+1][j]));
        if(j<points[i].length-1)                      springs.add(new Spring(points[i][j],points[i][j+1]));
        if(i<points.length-1 && j<points[i].length-1) springs.add(new Spring(points[i][j],points[i+1][j+1]));
        if(i>0 && j<points[i].length-1)               springs.add(new Spring(points[i][j],points[i-1][j+1]));
      }
    
    // blocked points
    for(int i=0; i<points.length/10. ;i++)
      for(int j=0; j<points[i].length/20. ;j++){
        points[i][j].blocked = true; 
        points[i][points[i].length-j-1].blocked = true;
      }
  }
  
  public void display(){
    beginShape(TRIANGLES);    
    for(int i=0; i<points.length-1 ;i++)
      for(int j=0; j<points[i].length-1 ;j++){
        points[i  ][j  ].toVertex();
        points[i+1][j  ].toVertex();
        points[i+1][j+1].toVertex();
        
        points[i  ][j  ].toVertex();
        points[i+1][j+1].toVertex();
        points[i  ][j+1].toVertex();
      }
    endShape(CLOSE);
  }
 
  public void computeForces(float dt){ 
    PVector wind = new PVector(WIND.x*random(-0.1,1),WIND.y*random(-1.,0.1),WIND.z*random(-0.5,0.5));
    for(int i=0; i<points.length ;i++)
      for(int j=0; j<points[i].length ;j++){
        points[i][j].applyForce(PVector.mult(GRAVITY,points[i][j].mass)); 
        points[i][j].applyForce(PVector.mult(wind,1.));
        points[i][j].applyForce(PVector.mult(points[i][j].getVelocity(dt),-0.01));
    }
    springs.forEach(sp -> sp.computeForces(dt));
  }
  
  public void updatePositions(float dt){
    for(int i=0; i<points.length ;i++)
      for(int j=0; j<points[i].length ;j++)
        points[i][j].update(dt);
  }
  
  public void constrain(){
    for(int i=0; i<10 ;i++){
      Collections.shuffle(springs);
      for(Spring sp : springs) sp.constrain();   
    }
  }
  
}
