class Drawer{
  
  PFont font;
  
  
  Drawer(){
    font = createFont("Arial",16,true);
  }
  
  void makeText(String text, int fontSize,  
                    int fontColor,int center_x, int center_y){
    setFont(fontSize, fontColor);
    textAlign(CENTER);
    text(text,center_x, center_y);
  }
  
  void makeTextLeft(String text, int fontSize,  
                    int fontColor,int center_x, int center_y){
    setFont(fontSize, fontColor);
    textAlign(LEFT);
    text(text,center_x, center_y);
  }
  
  void setFont(int fontSize, int fontColor){
    textFont(font,fontSize);
    fill(fontColor);
  }
  
  ControlFont getControlFont(int fontSize){
    return new ControlFont(font, fontSize);
  }
}