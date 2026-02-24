class Manager {
   ArrayList<Type> types = new ArrayList<Type>();
   ArrayList<Particle> particles = new ArrayList<Particle>();
   
   void display() {
      background(0);
      
      for (Particle particle : particles) {
         particle.display();
      }
      
      renderBounds();
   }
   
   void update() {
      setOrigin();
      
      for (Particle p : particles) {
         p.wrapParticles();
         p.update(particles);
      }
      
      display();
      
      initialParticles();
      
      if (useEvolveRules) { 
         evolveRules();
      }
   }
   
   void addParticle(int type, float x, float y) {
      PVector newPos = reverseTranslateCoords(x, y);
      particles.add(new Particle(type, new PVector(newPos.x, newPos.y), types));
   }
   
   void addType(color c, float typeRadius, float[] attraction, float[] middle, float[] repelDist) {
      types.add(new Type(c, typeRadius, attraction, middle, repelDist, types));
   }
   
   void randomParticles(int num, float rad) {
      for (int i = 0; i < num; i++) {
         float u = 1;
         float x = random(-u, u);
         float y = random(-sqrt(1 - x * x), sqrt(1 - x * x));
         addParticle((int) random(0, types.size()), width / 2 + x * rad, height / 2 + y * rad);
      }
   }
   
   void randomTypes() {
      gui.selected = null;
      int len = (int) random(3, 16);
      for (int i = 0; i < len; i++) {
         float[] a = makeArray(-3 * worldScale, 3 * worldScale, len);
         
         float[] m = makeArray(15 * worldScale, 80 * worldScale, len);
         
         float[] r = makeArray(2 * worldScale, random(25 * worldScale, 64 * worldScale), len);
         
         float t = random(3, 4) * worldScale * 2;
         
         float desaturation = 100;
         
         float red = random(desaturation, 255);
         
         float green = random(desaturation, 255);
         
         float blue = random(desaturation, 255);
         
         color c = color(red, green, blue);
         
         man.addType(c, t, a, m, r);
      }
   }
   
   void newRules() {
      int len = types.size();
      
      for (Type type : types) {
         float[] a = makeArray(-3 * worldScale, 3 * worldScale, len);
         
         float[] m = makeArray(15 * worldScale, 80 * worldScale, len);
         
         float[] r = makeArray(2 * worldScale, random(25 * worldScale, 64 * worldScale), len);
         
         type.attraction = a;
         
         type.middle = m;
         
         type.repelDist = r; 
      }
   }
   
   void evolveRules() {
      int len = types.size();
      
      for (Type type : types) {
         float delta = random(0.1, 1.75) * 0.1;
         
         float[] a = evolveArray(-3 * worldScale, 3 * worldScale, type.attraction, -delta * worldScale, delta * worldScale, len);
         
         float[] m = evolveArray(15 * worldScale, 80 * worldScale, type.middle, -delta * worldScale, delta * worldScale, len);
         
         float[] r = evolveArray(2 * worldScale, 64 * worldScale, type.repelDist, -delta * worldScale, delta * worldScale, len);
         
         type.attraction = a;
         
         type.middle = m;
         
         type.repelDist = r; 
      }
   }
   
   float[] makeArray(float lower, float upper, int len) {
      float[] outputArray = new float[len];
      
      for (int i = 0; i < len; i++) {
         outputArray[i] = random(lower, upper);
      }
      
      return outputArray;
   }
   
   float[] evolveArray(float min, float max, float[] inputArray, float lower, float upper, int len) {
      float[] outputArray = inputArray;
      
      for (int i = 0; i < len; i++) {
         outputArray[i] += random(lower, upper);
      }
      
      return constrain(outputArray, min, max);
   }
   
   void initialParticles() {
      float generateRadius = (PI - 3) * initialParticlesNum * worldScale * random(3, 8);
      if (useInitialParticles && man.particles.size() < initialParticlesNum) {
         if (useInstant) {
            man.randomParticles(initialParticlesNum, generateRadius * zoom);
         }
         if (!useInstant) {
            man.randomParticles(1, generateRadius * zoom);
         }
      }
      if (!useInitialParticles && man.particles.size() >= initialParticlesNum) {
         useInitialParticles = false;
      }
   }
   
   void setOrigin() {
      originX = width / 2 + offsetX;
      originY = height / 2 + offsetY;
   }
   
   void renderBounds() {
      PVector topLeft = translateCoords(0, 0);
      noFill();
      stroke(gui.guiStroke);
      strokeWeight(gui.guiStrokeWeight);
      rect(topLeft.x, topLeft.y, width * zoom, height * zoom);
      ellipse(width / 2, height / 2, 15, 15);
   }
   
   PVector translateCoords(float x, float y) {
      float tx = ((x - originX) * zoom) + originX - offsetX;
      float ty = ((y - originY) * zoom) + originY - offsetY;
      return new PVector(tx, ty);
   }
   
   PVector reverseTranslateCoords(float x, float y) {
      float wx = ((x + offsetX - originX) / zoom) + originX;
      float wy = ((y + offsetY - originY) / zoom) + originY;
      return new PVector(wx, wy);
   }
}
