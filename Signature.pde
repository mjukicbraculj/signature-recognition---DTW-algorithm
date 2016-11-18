class Signature{
  ArrayList<Double> x;
  ArrayList<Double> y;
  ArrayList<Integer> time;
  String fileName;
  double minX, minY, maxX, maxY;
  
  
  Signature(){
    x = new ArrayList<Double>();
    y = new ArrayList<Double>();
    time = new ArrayList<Integer>();
    minX = minY = maxX = maxY = -1;
  }
 
  
   //method read all lines from file fileName
  //and parse numbers from lines
  void read(String fileName){
    this.fileName = fileName; 
    BufferedReader reader = createReader(fileName);
    String line;
    try{
      while((line = reader.readLine()) != null){
        String[] pieces = split(line, TAB);
        x.add(new Double(int(pieces[0])));
        y.add(new Double(int(pieces[1])));
        time.add(new Integer(int(pieces[4])));
      }
    }catch(IOException exception){
      exception.printStackTrace();
    }
  }
  
  //method finds the max distance in x array and y array
  //puts data in the origin of coordinate system
  //normalises x and y coordinates to be in rectangle dimesion 300*100
  void normaliseData(){
    findMinAndMaxElement();
    //we don't sort because than we need two more lists
    //java.util.Collections.sort(x);
    //java.util.Collections.sort(y);
    translate(x, minX);
    translate(y, minY);
    writeSignature("trans");
    normalise(300, 100);
    writeSignature("norm");
  }
  
  //method finds minimal and maximal element of list
  void findMinAndMaxElement(){
    for(int i = 0; i < x.size(); ++i){
      double itemX = x.get(i);
      double itemY = y.get(i);
      if(minX > itemX || minX == -1)
        minX = itemX;
      if(maxX < itemX || maxX == -1)
        maxX = itemX;
      if(minY > itemY || minY == -1)
        minY = itemY;
      if(maxY < itemY || maxY == -1)
        maxY = itemY;
    }
    //println(minX + ", " + maxX + "\n" + minY + ", " + maxY);
  }
  
   
  //translates list for "translate" value
  void translate(ArrayList<Double> list, double translate){
    for(int i = 0; i < list.size(); ++i)
      list.set(i, list.get(i) - translate);
  }
  
  //puts data in rectangle dimensions normaliseWidth x normaliseHeight
  void normalise(int normaliseWidth, int normaliseHeight){
    double divisorX = (maxX - minX)/normaliseWidth;
    double divisorY = (maxY - minY)/normaliseHeight;
    for(int i = 0; i < x.size(); ++i){
        x.set(i, x.get(i)/divisorX);
        y.set(i, y.get(i)/divisorY);
    }
  }

  
  private void writeSignature(String direcory){
    PrintWriter output = createWriter("./" + direcory + "/" + fileName);
    for(int i = 0; i < x.size(); ++i)
      output.println(x.get(i) + "\t" + y.get(i));
    output.flush();
    output.close();
  }
  
  
 

}