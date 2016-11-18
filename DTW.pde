class DTW{
  Signature signature1;
  Signature signature2;
  
  DTW(){
    signature1 = new Signature();
    signature2 = new Signature();
  }
  
  //method reads data from selected files
  void readData(String file1, String file2){
    signature1.read(file1);
    signature2.read(file2);
  }
  
  
  //putting signature data in fixed size rectangle
  void normaliseData(){
    signature1.normaliseData();
    signature2.normaliseData();
  }
  
  
  //implementation of dtw algorithm
  double findDistance(){
    int n = signature1.x.size();
    int m = signature2.x.size();
    
    //println("n je" +  n + "m je " + m);
    double[][] dtwArray = new double[n+1][m+1];
    
    for(int i = 1; i < n+1; ++i)
      dtwArray[i][0] = Double.POSITIVE_INFINITY;
    for(int i = 1; i < m+1; ++i)
      dtwArray[0][i] = Double.POSITIVE_INFINITY;
    dtwArray[0][0] = 0;
    
    for(int i = 1; i < n+1; ++i)
      for(int j = 1; j < m+1; ++j){
        double cost = pointDistance(i-1, j-1);
        //if(i == 1 && j == 1)
          //println("cost je" + cost + 
          //          "(x1, y1) " + signature1.x.get(i-1) + ", " + signature1.y.get(j-1)
          //          +", (x2, y2) " + signature2.x.get(i-1) + ", " + signature2.y.get(j-1));
        dtwArray[i][j] = cost + myMin(dtwArray[i-1][j],
                                 dtwArray[i][j-1],
                                 dtwArray[i-1][j-1]);
      }
      
    return dtwArray[n][m];
   
  }
  
  //returns Euclidean distance of two points
  double pointDistance(int i, int j){
    return sqrt(pow((float)(signature1.x.get(i)-signature2.x.get(j)), 2) + 
                        pow((float)(signature1.y.get(i)-signature2.y.get(j)), 2));
  }
  
  
  //finds min of three numbers
  double myMin(double a, double b, double c){
    if(a < b)
      if(a < c)
        return a;
       else return c;
    else
      if(b < c)
        return b;
      else 
        return c;
  }
  
  
  
 
  
  



}