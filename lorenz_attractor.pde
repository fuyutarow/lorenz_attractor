float SCALE = 10;
int flag;
float start;
int SPEED = 1;

// meta parameter
int N = 100000;
double LOOP_PER_POINT = 30;
double DT = 0.001;
int COLOR_SCALE = N/30;

// parameter
double sigma;
double rho;
double bata;

// solutions
double[] orbitX = new double[N];
double[] orbitY = new double[N];
double[] orbitZ = new double[N];

void setup() {
  size(1920, 1080, P3D);
  frameRate(60);
  colorMode(HSB, COLOR_SCALE, 100, 100);
  background(0);
  noFill();
  strokeWeight(2);

  flag=0;
  computeLorenz();
}

void draw() {
  background(0);

  // print data
  text(("sigma==\t"+sigma), 100, 100);
  text(("rho==\t"+rho), 100, 140);
  text(("bata==\t"+bata), 100, 180);
  text(("N==\t"+N), 100, 220);

  text(("x==\t"+(float)orbitX[frameCount*SPEED%(int)(N/LOOP_PER_POINT)]), width-150, 100);
  text(("y==\t"+(float)orbitY[frameCount*SPEED%(int)(N/LOOP_PER_POINT)]), width-150, 140);
  text(("z==\t"+(float)orbitZ[frameCount*SPEED%(int)(N/LOOP_PER_POINT)]), width-150, 180);

  // handle
  translate(width/2, height/2);
  rotateX(mouseX / 200.0);
  rotateY(mouseY / 100.0);

  // coodination box
  stroke(COLOR_SCALE, 0, 30);
  box(500);

  // for orbit
  for (int i = 0; i < N; i++) {
    stroke(i%COLOR_SCALE, 100, 100);
    point((float)orbitX[i]*SCALE, (float)orbitY[i]*SCALE, (float)orbitZ[i]*SCALE);
  }

 // for ball
  translate(
    (float)orbitX[frameCount*SPEED%(int)(N/LOOP_PER_POINT)]*SCALE,
    (float)orbitY[frameCount*SPEED%(int)(N/LOOP_PER_POINT)]*SCALE,
    (float)orbitZ[frameCount*SPEED%(int)(N/LOOP_PER_POINT)]*SCALE
    );
  stroke(70, 10, 100);
  sphere(10);
}

// smooth moment
void keyPressed() {
  if ( key==' ') {
    N = 100000;
    LOOP_PER_POINT = 30;
    DT = 0.001;
    COLOR_SCALE = N/30;
    colorMode(HSB, COLOR_SCALE, 100, 100);
    SPEED = 1;
    orbitX = new double[N];
    orbitY = new double[N];
    orbitZ = new double[N];

    computeLorenz();
  }
}

// smooth orbit
void mouseClicked() {
  if (mouseButton==RIGHT) {
    N = 300000;
    LOOP_PER_POINT = 30;
    DT = 0.0001;
    COLOR_SCALE = N/30;
    colorMode(HSB, COLOR_SCALE, 100, 100);
    SPEED = 10;
    orbitX = new double[N];
    orbitY = new double[N];
    orbitZ = new double[N];

    computeLorenz();
  }
}



double fx(double x, double y, double z) {
  return sigma*(y-x);
}
double fy(double x, double y, double z) {
  return x*(rho-z)-y;
}
double fz(double x, double y, double z) {
  return x*y-bata*z;
}

void computeLorenz() {
  double x, y, z;
  double k1x, k1y, k1z;
  double k2x, k2y, k2z;
  double k3x, k3y, k3z;
  double k4x, k4y, k4z;

  int plotIndex = 0;

  sigma = 10;
  rho = random(13, 30);//28;
  bata = 8/3;

  x = random(-100, 100);
  y = random(-100, 100);
  z = random(-100, 100);
  for (int i = 0; i < N; i++) {
    k1x = fx( x, y, z );
    k1y = fy( x, y, z );
    k1z = fz( x, y, z );

    k2x = fx( x+k1x*DT*0.5, y+k1y*DT*0.5, z+k1z*DT*0.5 );
    k2y = fy( x+k1x*DT*0.5, y+k1y*DT*0.5, z+k1z*DT*0.5 );
    k2z = fz( x+k1x*DT*0.5, y+k1y*DT*0.5, z+k1z*DT*0.5 );

    k3x = fx( x+k2x*DT*0.5, y+k2y*DT*0.5, z+k2z*DT*0.5 );
    k3y = fy( x+k2x*DT*0.5, y+k2y*DT*0.5, z+k2z*DT*0.5 );
    k3z = fz( x+k2x*DT*0.5, y+k2y*DT*0.5, z+k2z*DT*0.5 );

    k4x = fx( x+k3x*DT, y+k3y*DT, z+k3z*DT );
    k4y = fy( x+k3x*DT, y+k3y*DT, z+k3z*DT );
    k4z = fz( x+k3x*DT, y+k3y*DT, z+k3z*DT );

    x += (k1x + 2.0*k2x + 2.0*k3x + k4x)*DT/6.0;
    y += (k1y + 2.0*k2y + 2.0*k3y + k4y)*DT/6.0;
    z += (k1z + 2.0*k2z + 2.0*k3z + k4z)*DT/6.0;

    if ( i%LOOP_PER_POINT == 0 ) {
      orbitX[plotIndex] = x;
      orbitY[plotIndex] = y;
      orbitZ[plotIndex] = z;
      plotIndex++;
    }
  }
}
