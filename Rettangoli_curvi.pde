import com.hamoid.*; // Libreria VideoExport
VideoExport video; // Oggetto per registrazione
boolean recording = false;


// Setup iniziale della finestra
void setup() {
  size(1920, 1080); // Dimensione della finestra
  background(255);  // Sfondo bianco
  noStroke();       // Niente contorni sui rettangoli
  noLoop();         // Disegno una volta sola, redraw solo con mousePressed()
  video = new VideoExport(this, "output.mp4");
}

// Funzione principale che disegna la griglia di rettangoli curvi
void draw() {
  int n_ret = 5;    // Numero di rettangoli per gruppo
  
  // Array dei colori, uno per ogni rettangolo del gruppo
  color[] colors = new color[n_ret];
  for (int i=0; i<colors.length; i++) {
    colors[i] = color(random(255), random(255), random(255));
  }
  
  // Dimensioni e posizione iniziale dei rettangoli
  float rectH  = int(random(250, 800));        // Altezza del rettangolo
  float rectW  = int(random(180, 800));        // Larghezza del rettangolo
  float startX = int(random(-rectW/2 + 1, 0)); // Offset X iniziale
  float startY = int(random(-rectH/2 + 1, 0)); // Offset Y iniziale
  float warp   = int(random(50,71));           // Intensità della curvatura
  
  float cx = startX; // Coordinata X corrente
  float cy = startY; // Coordinata Y corrente
    
  // Numero di colonne e righe necessarie per riempire la finestra
  int   cols   = ceil((width + startX + rectW/2) / rectW);
  int   rows   = ceil((height + startY + rectH/2) / rectH);
  
  // Stampa informazioni sul layout nella console
  println("Base tela: " + width);
  println("Altezza tela: " + height);
  println("Base rettangolo: " + rectW);
  println("Altezza rettangolo: " + rectH);
  println("StartX: " + startX);
  println("StartY: " + startY);
  println("Colonne: " + cols);
  println("Righe: " + rows);
  println("------------------------------------");
  
  
  // Ciclo principale per disegnare la griglia
  for (int k = 0; k<=rows; k++){
    for(int i = 0; i<=cols; i++){
      // Alterna la direzione dei gruppi di rettangoli (pari/dispari)
      if((i+k)%2 == 0){
        drawCurvedRectGroup(cx, cy, rectW, rectH, warp, true, colors);
      }else{
        drawCurvedRectGroup(cx, cy, rectW, rectH, warp, false,colors);
      }
      cx += rectW;  // Passa alla colonna successiva
    }
    cy += rectH; // Passa alla riga successiva
    cx = startX; // Resetta la coordinata x
  }
  // Se il video è attivo, salva il frame
  if (recording) {
    video.saveFrame();
  }
}

// Funzione per disegnare un gruppo di rettangoli curvi
void drawCurvedRectGroup(float   cx, 
                         float   cy,
                         float   rectW,
                         float   rectH,
                         float   warp,
                         boolean even,
                         color   colors[])
{
  // Se il gruppo è "pari", disegna i rettangoli con i colori normali
  if (even){
    for (int i = 0; i<colors.length; i++){
      drawCurvedRect(cx, cy, rectW, rectH, warp, colors[i]);
      rectW = rectW * 0.60;  // Riduce larghezza per il rettangolo successivo
      rectH = rectH * 0.60;  // Riduce altezza per il rettangolo successivo
      warp  = warp * 0.50;   // Riduce curvatura
    }
  // Se il gruppo è "pari", disegna i rettangoli con i colori invertiti  
  }else{
    for (int i = 0; i<colors.length; i++){
      drawCurvedRect(cx, cy, rectW, rectH, warp, colors[colors.length-(i+1)]);
      rectW = rectW * 0.70;
      rectH = rectH * 0.70;
      warp  = warp * 0.70;
    }
  }
}

// Disegna un singolo rettangolo curvo partendo dalla coordinata centrale
void drawCurvedRect(float cx, 
                    float cy,
                    float rectW,
                    float rectH,
                    float warp,
                    color c)
{
  // Coordinate dei vertici
  float x1 = cx - rectW/2, y1 = cy - rectH/2; // Punto alto a sx
  float x2 = cx + rectW/2, y2 = y1;           // Punto alto a dx
  float x3 = x2, y3 = cy + rectH/2;           // Punto basso a dx
  float x4 = x1, y4 = y3;                     // Punto basso a sx

  // Punti di controllo per le curve dei lati
  float xc1 = x1 + rectW/4,   yc1 = y1 - warp;
  float xc2 = x1 + rectW*3/4, yc2 = y1 + warp;
  float xc3 = x2 + warp,      yc3 = y2 + rectH/4;
  float xc4 = x2 - warp,      yc4 = y2 + rectH*3/4;
  float xc5 = xc2,            yc5 = y3 + warp;
  float xc6 = xc1,            yc6 = y3 - warp;
  float xc7 = x1 - warp,      yc7 = yc4;
  float xc8 = x1 + warp,      yc8 = yc3;

  fill(c);
  beginShape();
    vertex(x1, y1);
    bezierVertex(xc1, yc1, xc2, yc2, x2, y2); // lato superiore
    bezierVertex(xc3, yc3, xc4, yc4, x3, y3); // lato destro
    bezierVertex(xc5, yc5, xc6, yc6, x4, y4); // lato inferiore
    bezierVertex(xc7, yc7, xc8, yc8, x1, y1); // lato sinistro
  endShape(CLOSE);
}

// Richiama tutto al click del mouse
void mousePressed() {
  redraw();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    if (!recording) {
      video.startMovie();
      recording = true;
      println("Registrazione iniziata!");
    } else {
      video.endMovie();
      recording = false;
      println("Registrazione fermata e salvata!");
    }
  }
}
