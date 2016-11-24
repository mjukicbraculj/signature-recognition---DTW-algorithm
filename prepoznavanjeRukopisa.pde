//Cilj:
//1.translatirati i normalizirati točke učitane iz odabranih datoteka
//2.izračunati udaljaljenost nizova pomoću dinamic time warping algoritma

import java.util.Collections;
import controlP5.*;
ControlP5 controlP5;      //used for drawing user controls: dropdown, button etc.
DropdownList dropDown1, dropDown2;
Button compareBtn, backBtn, makeTableBtn, findBtn;
int personNum;        //numbers of person who have signature in base
int filePerPersonNum;      //numbers of signature per person
Drawer drawer;                //calss used for setting fonts 
DTW algorithm;
String item1, item2, errorMessage, resultMessage;
PrintWriter output, koordinate, outputAvg;

int stariX, stariY;
int noviX, noviY;


void setup(){
  controlP5 = new ControlP5(this);
  drawer = new Drawer();
  size(900, 900);
  personNum = 6;
  filePerPersonNum = 5;
  addControls();
  showBeginningControls(true);
  algorithm = new DTW();
  errorMessage = item1 = item2 = "";
  resultMessage = "";

  stariX = -1;
  stariY = -1;
  noviX = -1;
  noviY = -1;
  stroke(255,0,0);
  frameRate(30);
  //koordinate = createWriter("./izlaz/koordinate.txt"); 
   
}

void draw(){
  background(color(200, 200, 200));
  drawer.makeText(errorMessage, 20, 0, width/2, height*6/7);
  drawer.makeText(resultMessage, 20, 0, width/2, height/2);
  
  if (mousePressed ) {
    noviX = mouseX; noviY = mouseY;
    if (stariX != -1) {
        stroke(255,0,0);
        line(stariX,stariY,noviX,noviY);
        println(stariX,stariY,noviX,noviY,millis());
        //koordinate.println(stariX+"\t"+stariY+"\t"+noviX+"\t"+noviY+"\t"+millis());
    }
    stariX = noviX; stariY = noviY;
    // background(255,255,255);   
  } else {
    // background(250,250,250);
    stariX = -1; stariY = -1;
  }
}

//method compares file osobai, potpisj with all other files in base
//matrix is simetric so we can drow only the lower triangle
private String compareWithAllOther(int i, int j){
  String line = "";
  String item1 = "osoba" + i + ", " + "potpis" + j;

  //for(int a = 0; a <= i; ++a)
  //  for(int b = 0; (a < i && b < filePerPersonNum) || (a == i && b < j); ++b){
  //    String item2 = "osoba" + a + ", " + "potpis" + b;
  //    algorithm.readData("files/" + item1 + ".txt", "files/" + item2 + ".txt");
  //    algorithm.normaliseData();
  //    double distance = algorithm.findDistance();
  //    line += (int)distance + "\t";
  //    algorithm = new DTW();
      
  //  }
    for(int a = 0; a < personNum; ++a)
    for(int b = 0; b < filePerPersonNum; ++b){
      String item2 = "osoba" + a + ", " + "potpis" + b;
      algorithm.readData("files/" + item1 + ".txt", "files/" + item2 + ".txt");
      algorithm.normaliseData();
      double distance = algorithm.findDistance();
      line += (int)distance + "\t";
      algorithm = new DTW();
      
    }
    return line;
    
}


//adds contols to GUI and sets their properties
void addControls(){
  dropDown1 = controlP5.addDropdownList("firstList")
            .setPosition(100, 100)
            .setSize(200, 200)
            .setVisible(false);
  dropDown2 = controlP5.addDropdownList("secondList")
            .setPosition(width-300, 100)
            .setSize(200, 200)
            .setVisible(false);
  compareBtn = controlP5.addButton("Compare")
               .setPosition(width/2-100, 2*height/3)
               .setSize(200, 100)
               .setVisible(false);
  backBtn = controlP5.addButton("Back")
               .setPosition(width - 100, 20)
               .setSize(70, 50)
               .setVisible(false);
   makeTableBtn = controlP5.addButton("Make table")
               .setPosition(width/2 - 100, 4*height/5)
               .setSize(200, 100)
               .setVisible(false);
  
    findBtn = controlP5.addButton("Find")
       .setPosition(width - 200, 300)
       .setSize(200, 50)
       .setVisible(false);
     
  compareBtn.getCaptionLabel().setFont(drawer.getControlFont(20));
  makeTableBtn.getCaptionLabel().setFont(drawer.getControlFont(20));
  addItemsToDropDown(dropDown1);
  addItemsToDropDown(dropDown2);
  
}

//shows or hides contorls on first screen
void showBeginningControls(boolean yesOrNo){
  dropDown1.setVisible(yesOrNo);
  dropDown2.setVisible(yesOrNo);
  compareBtn.setVisible(yesOrNo);
  makeTableBtn.setVisible(yesOrNo);
  findBtn.setVisible(yesOrNo);
  if(!yesOrNo){
    compareBtn.hide();        //controlP5 is not active anymore when hidden.
    makeTableBtn.hide();
  }
}



void addItemsToDropDown(DropdownList list){
  for(int i = 0; i < personNum; ++i)
    for(int j = 0; j < filePerPersonNum; ++j)
      list.addItem("osoba" + i + ", potpis" + j, i*personNum + j);

  list.setItemHeight(30);
  list.setBarHeight(30);
  list.getCaptionLabel().set("izbor je...");
  list.getCaptionLabel().getStyle().marginTop = 3;
  list.getCaptionLabel().getStyle().marginLeft = 3;
  list.getValueLabel().getStyle().marginTop = 3;
  list.setOpen(false);
  list.getCaptionLabel().setFont(drawer.getControlFont(18));
  list.getValueLabel().setFont(drawer.getControlFont(16));
}


void controlEvent(ControlEvent theEvent){
  if(theEvent.getName().equals("Back"))
    backBtnClick();
  else if(theEvent.getName().equals("Make table"))
    makeTableClick();
  else if(theEvent.getName().equals("Find"))
    findBtnClick();
  else if(theEvent.getName().equals("Compare"))
    compareBtnClick();
  else if(theEvent.getController().getName().equals("firstList"))
    item1 = (String)dropDown2.getItem(int(theEvent.getValue())).get("text");
  else if(theEvent.getController().getName().equals("secondList"))
    item2 = (String)dropDown2.getItem(int(theEvent.getValue())).get("text");
}

void compareBtnClick(){
  if(item1.equals("") || item2.equals("")){
    errorMessage = "You have to chose two files!";
    return;
  }
  showBeginningControls(false);
  backBtn.setVisible(true);
  errorMessage = "";
  algorithm.readData("files/" + item1 + ".txt", "files/" + item2 + ".txt");
  algorithm.normaliseData();
  double distance = algorithm.findDistance();
  resultMessage = "Result of dtw algoritm is " + distance;
  
  
}

void makeTableClick(){
  output = createWriter("usporedba.xlsx"); 
  for(int i = 0; i < personNum; ++i)
    for(int j = 0; j < filePerPersonNum; ++j ){
      String line = compareWithAllOther(i, j);
      System.gc();          //we call garbage collector to free some memory
      output.println(line);
    }
      
  output.flush(); // Ispiše preostale podatke u datoteku
  output.close(); // Zatvara datoteku
}
////
void backBtnClick(){
  showBeginningControls(true);
  backBtn.hide();
  resultMessage = "";
  algorithm = new DTW();
}

void findBtnClick(){
  
  double sum = 0, avg;
  double minAvg = 5000000;
  double min = 5000000;
  int person = -1, personAvg = -1;
  
  
  showBeginningControls(true);
  findBtn.hide();
  println("findddd");
  showBeginningControls(false);
  backBtn.setVisible(true);
  errorMessage = "";
  //koordinate.flush(); // Ispiše preostale podatke u datoteku
  //koordinate.close(); // Zatvara datoteku
  //saveFrame("potpis.png");
  
  output = createWriter("test.xlsx"); 
  outputAvg = createWriter("testAvg.xlsx"); 
  String line = "";
  String line2 = "";
  
  for(int a = 0; a < personNum; ++a) {
    sum = 0;
    for(int b = 0; b < filePerPersonNum; ++b){
      String item2 = "osoba" + a + ", " + "potpis" + b;
      algorithm.readData("./koordinate.txt", "files/" + item2 + ".txt");
      algorithm.normaliseData();
      double distance = algorithm.findDistance();
      sum += distance;
      if(distance < min) {
        min = distance;
        person = a;
      }  
      line += (int)distance + "\t";
      algorithm = new DTW();
    }
    avg = sum/filePerPersonNum;
    if(avg < minAvg) {
        minAvg = avg;
        personAvg = a;
      }
    line2 += (int)avg + "\t";
  }
    System.gc();          //we call garbage collector to free some memory
    output.println(line);
    output.flush(); // Ispiše preostale podatke u datoteku
    output.close(); // Zatvara datoteku
    outputAvg.println(line2);
    outputAvg.flush(); // Ispiše preostale podatke u datoteku
    outputAvg.close(); // Zatvara datoteku
    
  
    resultMessage = "Probably person" + person + " Distance: " + min + "\n personAvg " + personAvg + " minAvg " + minAvg;
}