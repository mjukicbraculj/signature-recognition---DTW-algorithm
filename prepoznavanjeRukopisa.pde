//Cilj:
//1.translatirati i normalizirati točke učitane iz odabranih datoteka
//2.izračunati udaljaljenost nizova pomoću dinamic time warping algoritma

import java.util.Collections;
import controlP5.*;
ControlP5 controlP5;      //used for drawing user controls: dropdown, button etc.
DropdownList dropDown1, dropDown2;
Button compareBtn, backBtn, makeTableBtn;
int personNum;        //numbers of person who have signature in base
int filePerPersonNum;      //numbers of signature per person
Drawer drawer;                //calss used for setting fonts 
DTW algorithm;
String item1, item2, errorMessage, resultMessage;
PrintWriter output;

void setup(){
  controlP5 = new ControlP5(this);
  drawer = new Drawer();
  size(900, 900);
  personNum = 6;
  filePerPersonNum = 5;
  addControls();
  showBeginningControls(true);
  frameRate(100);
  algorithm = new DTW();
  errorMessage = item1 = item2 = "";
  resultMessage = "";

  
   
}

void draw(){
  background(color(200, 200, 200));
  drawer.makeText(errorMessage, 20, 0, width/2, height*6/7);
  drawer.makeText(resultMessage, 20, 0, width/2, height/2);
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