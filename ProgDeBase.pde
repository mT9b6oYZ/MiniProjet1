PFont police;
PImage img = null;
int nbPixels;
boolean blacknwhite = false;
int[][] blurmatrice = { {1,1,1},
                        {1,1,1},
                        {1,1,1}};

void setup(){
  police=loadFont("LiberationMono-24.vlw");
  img = loadImage("Roche-Jagu.jpg");
  nbPixels=img.width*img.height;
  size(800, 690);
  background(255);
  image(img,0,0);
}

void draw()
{
menu();
}


void menu() {
fill(0);
textFont(police,24);
  text("i : Inversion des couleurs",10,img.height+20 );
  text("r : Recharger l'image",10,img.height+40 );
  text("v : Inversion Verticale",10,img.height+60 );
  text("h : Inversion Horizontale",10,img.height+80 );
  text("n : Noir et Blanc",420,img.height+20 );
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
  int[][] tab = new int[img.width][img.height];
  for (int i = 0; i < tab.length; i++)
    for (int j = 0; j < tab[i].length; j++)
      println(i+" x "+j);
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
  if (key=='b') blur();
}