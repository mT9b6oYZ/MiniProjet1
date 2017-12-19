PFont police;
PImage img = null;
int nbPixels;
boolean blacknwhite = false;
float[][] blurmatrice = { {1/9f,1/9f,1/9f},
                        {1/9f,1/9f,1/9f},
                        {1/9f,1/9f,1/9f}};

void setup(){
  police=loadFont("LiberationMono-24.vlw");
  img = loadImage("Roche-Jagu.jpg");
  nbPixels=img.width*img.height;
  size(800, 690);
  background(255);
  image(img,0,0);
}

void draw() {
  menu();
 /* loadPixels();
  for (int x = 0; x < img.width; x++)
    for (int y = 0; y < img.height; y++) {
      color hsv = rgbtohsv(img.pixels[y * img.width + x]);
      color hs = (hsv >> 8) << 8;
      hsv = (int) ((mouseX / 800d) * (hsv - hs) + hs);
      pixels[y * img.width + x] = hsvtorgb(hsv);
    }
  updatePixels(); */
}


void menu() {
  fill(0);
  textFont(police,24);
  text("i : Inversion des couleurs",10,img.height+20 );
  text("r : Recharger l'image",10,img.height+40 );
  text("v : Inversion Verticale",10,img.height+60 );
  text("h : Inversion Horizontale",10,img.height+80 );
  text("n : Noir et Blanc",420,img.height+20 );
  text("f : Flou",420, img.height+40 );
}

void inversionVideo() {
  loadPixels();
  for (int i=0;i<nbPixels;i++) {
    pixels[i]=color(255-red(pixels[i]), 255-green(pixels[i]), 255-blue(pixels[i]));
  }
  updatePixels();
}


void retournementVertical() {
  loadPixels();  
  int[][] localtab = new int[img.width][img.height];
  for (int i = 0; i < localtab.length; i++)
    for (int j = 0; j < localtab[i].length; j++)
      localtab[i][j] = pixels[j * img.width + (img.width - i - 1)];
  for (int i = 0; i < localtab.length; i++)
    for (int j = 0; j < localtab[i].length; j++)
      pixels[j * localtab.length + i] = localtab[i][j];
  updatePixels();

  } 

void retournementHorizontal() {
  loadPixels();  
  int[][] localtab = new int[img.width][img.height];
  for (int i = 0; i < localtab.length; i++)
    for (int j = 0; j < localtab[i].length; j++)
      localtab[i][j] = pixels[(img.height - j - 1) * img.width + i];
  for (int i = 0; i < localtab.length; i++)
    for (int j = 0; j < localtab[i].length; j++)
      pixels[j * localtab.length + i] = localtab[i][j];
  updatePixels();
}

void blacknwhite() {
  if (blacknwhite) {
    image(img, 0, 0);
    blacknwhite = false;
  } else {
    loadPixels();
    for (int i=0;i<nbPixels;i++) {
      pixels[i]=color((red(pixels[i]) + green(pixels[i]) +blue(pixels[i]))/3);
    }
    updatePixels();
    blacknwhite = true;
  }
}

void blur(){
  loadPixels();
  int tailleMatrice = 3;
  for (int x = 0; x < img.width; x++) {
     for (int y = 0; y < img.height; y++) {
        color c = convolution(x, y, blurmatrice, tailleMatrice, img);
        int posPixels = x + y*img.width;
        pixels[posPixels] = c;
     }
  }
      
  updatePixels();    
}

color rgbtohsv(color rgb) {
  int r = (int) red(rgb);
  int g = (int) green(rgb);
  int b = (int) blue(rgb);
  int vmax = 0;
  int vmin = 256;
  int max = -1;
  int min = -1;
  if (r > vmax) {max = 0; vmax = r;}
  if (r < vmin) {min = 0; vmin = r;}
  if (g > vmax) {max = 1; vmax = g;}
  if (g < vmin) {min = 1; vmin = g;}
  if (b > vmax) {max = 2; vmax = b;}
  if (b < vmin) {min = 2; vmin = b;}
  int h = 0;
  if (max == min) h = 0;
  else if (max == 0) h = floor(256f * (g - b) / (6 * (vmax - vmin)));
  else if (max == 1) h = floor(256f * ((b - r) / (6 * (vmax - vmin)) + 1 / 3f));
  else if (max == 2) h = floor(256f * ((r - g) / (6 * (vmax - vmin)) + 2 / 3f));
  int s = 0;
  if (vmax == 0) s = 0;
  else s = 256 - vmin / vmax * 256;
  int  v = vmax;
  return color(h, s, v);
}

color hsvtorgb(color hsv) {
  int h = (int) red(hsv);
  int s = (int) green(hsv);
  int v = (int) blue(hsv);
  int hi = floor(6 * h / 255f) % 6;
  float f = 6 * h / 255f - hi;
  int l = (int) (v * (1f - s / 255f));
  int m = (int) (v * (1f - f * s / 255f));
  int n = (int) (v * (1f - (1f - f) * s / 255f));
  switch (hi) {
  case 0:
    return color(v, n, l);
  case 1:
    return color(m, v, l);
  case 2:
    return color(l, v, n);
  case 3:
    return color(l, m, v);
  case 4:
    return color(n, l, v);
  default:
    return color(v, l, m);
  }
}
color convolution(int x, int y, float[][] matrice, int tailleMatrice, PImage img) 
{
  float r = 0.0;
  float g = 0.0;
  float b = 0.0;
  int matMilieu = tailleMatrice / 2;
  for (int i=0; i<tailleMatrice; i++) {
    for (int j=0; j<tailleMatrice; j++) {
      int xpos = x + i - matMilieu; // On soustrait matMilieu pour éviter un déplacement des pixels
      int ypos = y + j - matMilieu;
      int pos = xpos + ypos * img.width;
      // On s'assure de ne pas être sorti de l'image
      pos = constrain(pos, 0, img.pixels.length-1);
      // Calcul de la convolution
      r += (red(img.pixels[pos]) * matrice[i][j]);
      g += (green(img.pixels[pos]) * matrice[i][j]);
      b += (blue(img.pixels[pos]) * matrice[i][j]);
    }
  }
  // On s'assure que le RGB des pixels soit bien entre 0 et 255
  r = constrain(r, 0, 255);
  g = constrain(g, 0, 255);
  b = constrain(b, 0, 255);
  // On renvoie la couleur résultante
  return color(r, g, b);
}

void keyPressed()
{
  if (key=='i') inversionVideo();
  if (key=='v') retournementVertical();
  if (key=='h') retournementHorizontal();
  if (key=='r') {
    image(img, 0, 0);
    blacknwhite = false;
  }
  if (key=='n') blacknwhite();
  if (key=='f') blur();
}
