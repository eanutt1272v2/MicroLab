// Main File

int initialParticlesNum = 3000;
float viscosity = 0.85;
float maxSpeed = 500;
float worldScale = 0.5;

boolean useInitialParticles = true;
boolean useInstant = true;
boolean useRect = false;
boolean useEvolveRules = false;

boolean isDesktop;
int trueScreenWidth;
int trueScreenHeight;

float zoom = 1;
float zoomRate = 1.05;
float offsetX = 0;
float offsetY = 0;
float originX;
float originY;

Manager man;
Mouse mouse;
GUI gui;

PImage lightAppIcon;
PImage darkAppIcon;
boolean useLightAppIcon = true;

void settings() {
   osCheck();
   
   if (isDesktop) {
      trueScreenWidth  = displayWidth;
      trueScreenHeight = displayHeight;
      fullScreen();
   } else {
      trueScreenWidth  = screenWidth;
      trueScreenHeight = screenHeight;
      size(screenWidth, screenHeight);
   }
}

void setup() {
   setAppIcon();
   size(screenWidth, screenHeight, P2D);
   man = new Manager();
   gui = new GUI(man);
   mouse = new Mouse();
   man.randomTypes();
}

void draw() {
   frameRate(60);
   man.update();
   mouse.update();
   gui.update();
}

void mouseWheel(MouseEvent event) {
   float e = event.getCount();
   zoom = (e > 0) ? zoom/zoomRate : zoom*zoomRate;
}

void setAppIcon() {
   lightAppIcon = loadImage("lightAppIcon.png");
   darkAppIcon  = loadImage("darkAppIcon.png");
   
   if (isDesktop) {
      if (useLightAppIcon && lightAppIcon != null) {
         surface.setIcon(lightAppIcon);
      } 
      else if (!useLightAppIcon && darkAppIcon != null) {
         surface.setIcon(darkAppIcon);
      } 
      else {
         println("Error: Icon image not found for selected theme.");
      }
   } else {
      initialParticlesNum = 500;
   }
}

String getOS() {
   try {
      return System.getProperty("os.name");
   } catch (Exception e) {
      return null;
   }
}

void osCheck() {
   String os = getOS();
   if (os != null) {
      isDesktop = true;
   } else {
      isDesktop = false;
   }
}

void mouseDragged() {
   if (!mouse.selected && !gui.selected && gui.selected != 0) {
      gui.mouseDragged();
   }
}