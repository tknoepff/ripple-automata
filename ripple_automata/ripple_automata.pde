// import sound for use of sound file.
import processing.sound.*;

// a macro 2-dimensional array that holds an instrument category and corresponding its notes.
SoundFile[][] instruments;

// each of these arrays store a random note for each instrument.
SoundFile[] bass;
SoundFile[] bassoon;
SoundFile[] cellos;
SoundFile[] clarinet;
SoundFile[] flute;
SoundFile[] oboe;
SoundFile[] violas;
SoundFile[] violins;

// the background noiose for the ocean depths.
SoundFile water_noise;

// this is an arbitrzy length for the t
int arbitrary_length = 50;

// the number of instrumentts being used.
int num_instruments = 8;

// list of all the instrument names.
String[] instrument_names = {"bass","violas", "oboe", "bassoon", "flute", "violins", "cellos", "clarinet"};

// the numebr of random notes for each instrument.
int num_bass = 16;
int num_bassoon = 12;
int num_cellos = 16;
int num_clarinet = 8;
int num_flute = 16;
int num_oboe = 8;
int num_violas = 12;
int num_violins = 31;

// a list that corresponds to the list of instruments in the instrument_names array with the number of notes for each.
int[] num_instrument_notes = {num_bass, num_violas, num_oboe, num_bassoon, num_flute, num_violins, num_cellos, num_clarinet};

// probabilities from most to least (easier for later use).
float[] instrment_probabilities = {0.6, 0.7, 0.8, 0.85, 0.9, 0.95, 0.99, 1.0};

// the number of rows and columns on the screen via pixels.
int columns;
int rows;

// the different simulation modes.
boolean chaos = false;
boolean silence = false;

// bubbles elements for scrolling.
Bubbles[] bubbles = new Bubbles[50];
int max_buble_size = 50; // the maximum bubble size.
int bubble_offset = 350; // to hide it off the screen.
color depths; // the blue surface.
color surface; // the black depths

// for the automata...
boolean[][] current_generation; // the current screen.
boolean[][] next_generation;  // the next screen.
int[][] age; // the numebr of times each cell has prolonged after each update.
int autoamata_life_span; // the maximum number of times a cell can exist after an update.
color younger_cell_color; // dim cells.
color older_cell_color; // bright cells.

// font.
PFont avenier;



void setup() {
  frameRate(20); // sets to a reasonable frame rate.
  size(640, 360);
  
  // loading Sounds...
  water_noise = new SoundFile(this, "sounds/water-noise.wav"); // background noise
  water_noise.amp(0.4);
  water_noise.play();
  
  instruments = new SoundFile[arbitrary_length][arbitrary_length]; // instantiates the instruments array.

  for(int i = 0; i < num_instruments; i++){ // loads all notes of instruments in an arbitrary w dimensional array
      for(int j = 0; j < num_instrument_notes[i]; j++){
        
        instruments[i][j] = new SoundFile(this, "sounds/" + instrument_names[i] + "/" + (j + 1) + ".wav"); 
         if(instrument_names[i] == "violins"){ // decreases violin amp.
           instruments[i][j].amp(0.5);
         
         }else if(instrument_names[i] == "viola"){ // increases viola amp.
           instruments[i][j].amp(1);
         }
    }
  }
  
    for(int i = 0; i < num_instruments; i++){ // loads all notes of instruments in an arbitrary 2-dimensional array.
      for(int j = 0; j < num_instrument_notes[i]; j++){
      }
  }

  // instantiates the color of the younger and older cells.
  younger_cell_color = color(100,100,146);
  older_cell_color = color(242,242,205);
  
  // the maximum life span is 100 updates.
  autoamata_life_span = 100;
  
  // instantiates the color of the depths and the surface.
  depths = color(0,0,0);
  surface = color(20,20,180);
  
  // instantiates rows and columns.
  columns = width;
  rows = height;

  // instantiates automata dispalys and ages.
  current_generation = new boolean[columns][rows];
  next_generation = new boolean[columns][rows];
  age = new int[columns][rows];
  
  
  // load the generations array with dead values (black color code of 0).
  for(int i = 0; i < columns; i++){
    for(int j = 0; j < rows; j++){
      current_generation[i][j] = false;
      next_generation[i][j] = false;
      age[i][j] = 0;
    }
  }
  
  
  // loads bubbles into bubbles arry for scrolling.
  for(int i = 0; i < bubbles.length; i++){
    bubbles[i] = (new Bubbles(int(random(0, width)), int(random(height, height + bubble_offset))));
   }
}


// different keys corresponds to different modes.
void keyReleased() {
  if (key == 'c') { // chaos mode (a symmetrical explosion of cells)/
    chaos = true;
    silence = false;
    stop_all_music();
    setup();
        
  } else if (key == 's') { // silence mode (constantly growing cells with no sound).
    chaos = false;
    silence = true;
    stop_all_music();
    setup();
  
  }else if (key == 'n'){ // normal mode.
    chaos = false;
    silence = false;
    stop_all_music();
    setup();
  }
}

// allows the user to draw automata.
void mouseDragged(){
  int x_position = mouseX;
  int y_position = mouseY;
  draw_automata(x_position, y_position, false); 
}


void draw()
{
    // removes cursor from screen.
    noCursor();
    draw_background(depths, surface); // draws thew background gradient.

  // draws bubbles to scroll.
  for(int i = 0; i < bubbles.length; i++){
    bubbles[i].display();
    bubbles[i].float_up();
    
    // offsets the bubbles back to "original" position (bellow screen) if it floats up.
    if(bubbles[i].y < -100){
      bubbles[i].x = int(random(0, width));
      bubbles[i].y = int(random(height, height + bubble_offset));
    }
  }
  // draws automata.
   automata_effect();
}


// draws the background gradient.
void draw_background(color depths, color surface){

  noFill();
  strokeWeight(10);
  
  // makes a gradient by lerping between two colors.
  for (int i = 0; i <= height; i+=10) {
    color c = lerpColor(surface, depths, map(i, 0, height, 0, 1));
    stroke(c);
    line(0, i, width, i);
    }
}

void automata_effect(){
    
  // start image.
  loadPixels();
  
  // goes through the game of life rules.
  for(int x = 1; x < columns - 1; x++){
    for(int y = 1; y < rows - 1; y++){
      
      
      /// CCONWAY GAME OF LIFE SETTING ///
      if(current_generation[x][y] == false && (num_neighbors(x,y) == 3)){
        next_generation[x][y] = true;
      }else if(current_generation[x][y] == true && (num_neighbors(x,y) < 2 || num_neighbors(x,y) > 3 )){
        next_generation[x][y] = false;
        age[x][y] = 0;
      }else{
        next_generation[x][y] = current_generation[x][y];
        
        if(next_generation[x][y] == true || chaos){ // this extra rule only plays durring chaos mode
        age[x][y]++;
        }
      }
    }
  }
  
  // this checks for any cells that have aged out and exlode in reproduction.
  for(int x = 1; x < columns - 1; x++){
    for(int y = 1; y < rows - 1; y++){
     
      // once the cells ages out it draws a new set of automata and palys an instrument.
      if(age[x][y] > autoamata_life_span){
        draw_automata(x, y, true);
        age[x][y] = 0;
        play_instrument();
      }
    }
  }
  
    // iterates the next_generation array.
    for(int x = 1; x < columns - 1; x++){
      for(int y = 1; y < rows - 1; y++){
        
        int location = x + y * columns; // algorithm to find the proper two dimensional pixel in a one dimensional array.
    
        // if the cell is alive (true).
        if(next_generation[x][y] == true){
          
            // color the pixel in accordance with its age.
            pixels[location] = lerpColor(younger_cell_color, older_cell_color, map(age[x][y],0, autoamata_life_span, 0, 1));
            
      }
    }
  }
  
  
  
   if(!silence){ // normal settings
   
   // this updates the future generation as the current generation.
    for(int x = 0; x < columns; x++){
      for(int y = 0; y < rows; y++){
          current_generation[x][y] = next_generation[x][y];
  
      }
    }
   }else{ // silence mode (this allow the automata to grow indeffinitley).
       current_generation = next_generation;
   }
  
  // close image.
  updatePixels();
}

// this plays, or does not play, a random instrument.
void play_instrument(){
  
       // temporary placement variables to find a random instrument based off its probability.
       int instrument_index = 0;
       float temp_prob = random(1);
       boolean found = false;
       
       // this finds a random instrument leveraged off its probability in the probability array.
       for(int i = 0; i < instrment_probabilities.length; i++){
         if(temp_prob <  instrment_probabilities[i] && !found){
           instrument_index = i; 
           found = true;
         }
       }
        
      if(chaos){ // if its in chaos mode, then there is less of a probability that a sound will play to stop reverb overload.
        if(random(1) > 0.9995){
          // play a random note fromt the instrument. 
          instruments[instrument_index][int(random(0, num_instrument_notes[instrument_index]))].play();
        }
        
        }else if(random(1) > 0.8){ // otherwise there is a greater probabilty.
          // play a random note fromt the instrument. 
          instruments[instrument_index][int(random(0, num_instrument_notes[instrument_index]))].play();
        }  
}

// stops all music thatis being played
void stop_all_music(){
    for(int i = 0; i < num_instruments; i++){ // loads all notes of instruments in an arbitrary w dimensional array
      for(int j = 0; j < num_instrument_notes[i]; j++){
        instruments[i][j].stop(); // iterates through the entire instrument array and stops the sounds.
      }
    }
  }


// draws active automata in a diamond format.
void draw_automata(int x, int y, boolean is_next){
  
  // if the automata dies and reproduces.
  if(is_next){
  next_generation[int(x)][int(y)] = true;
  next_generation[int(x)-1][int(y)] = true;
  next_generation[int(x)+1][int(y)] = true;
  next_generation[int(x)][int(y)-1] = true;
  next_generation[int(x)][int(y)+1] = true;
  
  // else the user is drawing the automata.
  }else{
  current_generation[int(x)][int(y)] = true;
  current_generation[int(x)-1][int(y)] = true;
  current_generation[int(x)+1][int(y)] = true;
  current_generation[int(x)][int(y)-1] = true;
  current_generation[int(x)][int(y)+1] = true;
  }
}
  
  
// counts the number of neighbors of each cell.
int num_neighbors(int x,int y){
  int total_neighbors = 0;
  if(current_generation[x+1][y] == true){
     total_neighbors++;
     }
  if(current_generation[x-1][y] == true){
     total_neighbors++;
     }
  if(current_generation[x][y+1] == true){
     total_neighbors++;
     }
  if(current_generation[x][y-1] == true){
     total_neighbors++;
     }
    if(current_generation[x-1][y-1] == true){
     total_neighbors++;
     }
    if(current_generation[x+1][y-1] == true){
     total_neighbors++;
     }
    if(current_generation[x+1][y+1] == true){
     total_neighbors++;
     }
    if(current_generation[x-1][y+1] == true){
     total_neighbors++;
     }
  
  return total_neighbors;
}

// this creates bubble staht scroll up.
class Bubbles{
   float x; // x position.
   float y; // y position.
   float rate; // the rate.
   int size; // size of the bubble.
  
  // constructor.
  Bubbles(float x, float y){
    this.x = x;
    this.y = y;
    this.rate = random(0.5,1.5) * -1; // random rate.
    this.size = int(random(5,max_buble_size)); // random size.

  }
  
  // allows the bubble to move up.
  void float_up(){
    this.y += this.rate;
  }
  
  // draws the bubble on the screen.
  void display(){
    stroke(93,93,139,180);
    strokeWeight(1);
    ellipse(this.x,this.y, size, size);
  }
}
