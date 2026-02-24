class Particle {
   PVector pos;
   Type type;
   
   Particle(int index, PVector pos, ArrayList<Type> list) {
      this.pos = pos;
      this.type = list.get(index);
   }
   
   void display() {
      PVector newPos = man.translateCoords(pos.x, pos.y);
      float newRadius = type.typeRadius * zoom;
      
      noStroke();
      
      fill(type.c);
      
      if (useRect) {
         rect(newPos.x - newRadius / 2, newPos.y - newRadius / 2, newRadius, newRadius);
      }

      if (!useRect) {
         ellipse(newPos.x, newPos.y, newRadius, newRadius);
      }
   }
   
   void update(ArrayList<Particle> particles) {
      PVector increase = new PVector();
      
      if (mouse.inMouse(this)) {
         increase.set(mouse.setPos());
      } else if (gui.running) {
         for (Particle forcing : particles) {
            if (this != forcing) {
               increase.add(this.applyForce(forcing));
            }
         }
         increase.mult(viscosity);
         increase.limit(maxSpeed);
      }
      
      this.pos.add(increase);
      this.wrapParticles();
   }
   
   PVector applyForce(Particle other) {
      PVector wrappedPos = getShortestDistance(other.pos);
      
      float distance = PVector.dist(this.pos, wrappedPos);
      
      float ratio;
      if (distance == 0) {
         ratio = 0;
      } else {
         ratio = (this.forceEq(other) / distance);
      }
      
      PVector increase = new PVector(ratio * (this.pos.x - wrappedPos.x), ratio * (this.pos.y - wrappedPos.y));
      return increase;
   }
   
   float forceEq(Particle other) {
      PVector wrappedPos = getShortestDistance(other.pos);
      float a = this.type.attraction[other.type.index];
      float r = this.type.repelDist[other.type.index];
      float m = this.type.middle[other.type.index];
      float d = PVector.dist(this.pos, wrappedPos);
      
      if (0 <= d && d <= 2 * r) {
         return abs((2 * a / (4 * r * r)) * pow(d - 2 * r, 2));
      } else if (2 * r <= d && d < m + 2 * r) {
         return a / m * d - 2 * r * a / m;
      } else if (m + 2 * r <= d && d <= 2 * m + 2 * r) {
         return -a / m * d + 2 * m * a / m + 2 * r * a / m;
      }
      
      return 0;
   }
   
   void wrapParticles() {
      if (pos.x > width) {
         pos.x -= width;
      } else if (pos.x < 0) {
         pos.x += width;
      }
      if (pos.y > height) {
         pos.y -= height;
      } else if (pos.y < 0) {
         pos.y += height;
      }
   }
   
   PVector getShortestDistance(PVector otherPos) {
      float dx = otherPos.x - this.pos.x;
      float dy = otherPos.y - this.pos.y;
      
      if (dx > width / 2)
      dx -= width;
      if (dx < -width / 2)
      dx += width;
      if (dy > height / 2)
      dy -= height;
      if (dy < -height / 2)
      dy += height;
      
      return new PVector(this.pos.x + dx, this.pos.y + dy);
   }
}
