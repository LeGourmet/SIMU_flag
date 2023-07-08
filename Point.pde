public class Point{
  // ----------------------------------------------------- ATTRIBUTS -----------------------------------------------------
  public PVector pos;
  public PVector pos_old;
  public PVector forces;
  public float   mass;
  
  public boolean blocked;
  public color   col;
  
  // ---------------------------------------------------- CONSTRUCTOR ----------------------------------------------------
  public Point(float x, float y, float z, color col, float mass){
    this.pos = new PVector(x,y,z);
    this.pos_old = pos.copy();
    this.forces = new PVector(0.,0.,0.);
    this.mass = mass;
    
    this.blocked = false;
    this.col = col;
  }
  
  // ----------------------------------------------------- FONCTIONS -----------------------------------------------------
  public PVector getVelocity(float dt){ return PVector.sub(pos,pos_old).div(dt); }
  
  public void toVertex(){ fill(col); vertex(pos.x,pos.y,pos.z); }
  public void applyForce(PVector force){ if(!blocked) forces.add(force); }
  public void move(PVector vec){ if(!blocked) pos.add(vec); }
  
  public void update(float dt){
    if(blocked) return;
    
    PVector a = new PVector(0.,0.,0.).add(PVector.div(forces,mass));
    PVector vel = getVelocity(dt).add(PVector.mult(a,dt));
    PVector pos_next = new PVector(0.,0.,0.).add(pos).add(PVector.mult(vel,dt));
    
    pos_old.set(pos);
    pos.set(pos_next);
    
    forces.set(0.,0.,0.);
  }
}
