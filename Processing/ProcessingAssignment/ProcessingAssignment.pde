//This sketch creates a visualization for a granular sampler,
// the whole project can be found at 
//https://github.com/lore-aaa/Final-Project---CS6042---Lorenzo-Anzuini
//The sketch is based on 
//https://www.youtube.com/watch?v=IKB1hWWedMk
//by Daniel Shiffman

//Lorenzo Anzuini
//05/05/2019
//v0.8



//Libraries
import processing.net.*;

//Declaration

//used to connect to PD
Server server;

int port = 11000;


//used to store values from PD
// index numbers 0 to 2 are directly the input that comes from the three pots
// index 3 and 4 recevie a new number when something changes randomly 
// respectively in converter3 (piano sound) and converter1 (throat singing sound
float[] input;

//used to create che grid of vertexes that create the terrain
int cols, rows;

//resolution of the vertexes
int scale = 20;

//dimensions of the terrain
int w, h;

//speed at witch the point of view flies over the terrain
float flySpeed = 0;
float speed = 0;

//used to store the vertexes that create the terrain
float[][] terrain;

//height of the mountains, z value of the vertexes
//controlled by "distance" pot input[2]
float mountHeight;


//used in the randomEvent() function
float num1 = 0;
float num2 = 0;

//used to store what the randomEvent() function returns
int whatRandom;

//used to tilt the terrain when a random event happens
int randomTilt = 0;

void setup() {
  size(600, 600, P3D);

  //initializing server to connect to PD
  server = new Server(this, port);


  //array to store inputs from PD
  input = new float[5];

  w = width*4;
  h = height*4;




  cols = w / scale;
  rows = h / scale;

  terrain = new float[cols][rows];

  whatRandom = 0;
}

void draw() {

  readFromPd();

  whatRandom = randomEvent();



  //change the speed variable if a random event happens
  //whatRandom == 1 means that a random event occoured in the piano sample
  //therefore it has effect only if that is what is being primairely heard
  //and so when input[0] is lower than 0.2 or higher than 0.8
  if (whatRandom == 1 ) {

    if (input[0] <= 0.2) {
      speed = 1;
    }
    if (input[0] >= 0.81) {
      speed = 1;
    }
  } 
  //whatRandom == 2 means that a random event occoured in the throat singing sample
  //therefore it has effect only if that is what is being primairely heard
  //and so when input[0] is between 0.2 and 0.8
  if (whatRandom == 2) {

    if ((input[0] >= 0.2) && (input[0] <= 0.8)) {
      speed = 1;
    }
  } 

  //whatRandom == 0 means no random event occoured
  // the speed is normal
  if (whatRandom == 0) {
    speed = 0.1;
  }

  flySpeed -= speed;

  //change the height of the mountains based on input[2], the DISTANCE pot
  mountHeight = map(input[2], 1, 0, 50, 250);

  lights();

  //offsetting the Perlin noise space by the flySpeed
  //and assigning depth to every vertex
  float yoff = flySpeed;
  for (int y = 0; y < rows; y++) { 
    float xoff =0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 1, 0, -mountHeight, mountHeight);

      xoff+= 0.1;
    }
    yoff+= 0.1;
  }

  background(0);

  pushStyle();
  noStroke();
  fill(0, 0, 255);

  //translating to the center
  translate(width/2, height/2);

  //if a random event occoured, 1 in 10 times the terrain will have an additional rotation
  if (whatRandom != 0) {
    if (random(10) > 9) {
      randomTilt = 10;
    }
  } else {
    randomTilt = 0;
  }

  //rotating the matrix of vertexes to make them look like a terrain in prospective
  //the inclination is based on input[0] LIGHT-ABYSS pot and input[2] DISTANCE pot
  rotateX(PI/2-10 +  map(input[0], 0, 1, 0, PI)- map(input[2], 0, 1, 0, PI/20)+ randomTilt);

  //translating to draw the matrix in the middle of the screen
  translate(-w/2, -h/2, map(input[2], 0, 1, 0, -1000));


  //drawing the matrix
  //the matrix is drawn as an 2D array of triangle strips
  for (int y = 0; y < rows-1; y++) {

    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {

      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }
  popStyle();
}


//Other Functions

/*
This function takes input from the Pure Data patch and stores them into the input array
 index numbers 0 to 2 are directly the input that comes from the three pots
 index 3 and 4 recevie a new number when something changes randomly 
 respectively in converter3 (piano sound) and converter1 (throat singing sound) subpatches
 */
void readFromPd() {
  Client thisClient = server.available();

  if (thisClient != null) {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
      String message[] = splitTokens(whatClientSaid, " ;");

      for (int i = 0; i < input.length; i++) {

        input[i] = float(message[i]);
      }
    }
  }
}

/*
This function checs if a random event happened in the piano sample (input[3]) or the 
 throat singing sample (input[4]).
 It does that by checking if the number sent from Pure Data in those inputs has changed
 */
int randomEvent() {
  float tempNum1 = input[3];
  float tempNum2 = input[4];
  if (tempNum1 != num1) {
    num1 = tempNum1;
    return 1;
  }
  if (tempNum2 != num2) {
    num2 = tempNum2;
    return 2;
  } else {
    return 0;
  }
}
