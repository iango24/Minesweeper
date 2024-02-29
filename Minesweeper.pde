import de.bezier.guido.*;
int NUM_ROWS = 14;
int NUM_COLS = 18;
int NUM_BOMBS = 40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(396, 393);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
     buttons = new MSButton[NUM_ROWS][NUM_COLS];
     for(int r=0;r<NUM_ROWS;r++){
       for(int c=0;c<NUM_COLS;c++){
         buttons[r][c] = new MSButton(r,c);
       }
     }
    setMines();
}
public void setMines()
{
    while(mines.size()<NUM_BOMBS){
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[r][c]))
      mines.add(buttons[r][c]);
      System.out.println(r+", "+c);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r=0;r<NUM_ROWS;r++){
      for(int c=0;c<NUM_COLS;c++){
        if(buttons[r][c].clicked==false && (!mines.contains(buttons[r][c])))
          return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
  for(int r=0;r<NUM_ROWS;r++){
    for(int c=0;c<NUM_COLS;c++){
      buttons[r][c].flagged=false;
    }
  }
  for(int i=0; i<mines.size(); i++){
      mines.get(i).clicked=true;
  }
  for(int r=0;r<NUM_ROWS;r++){
    for(int c=0;c<NUM_COLS;c++){
      if((countMines(r,c)==0&&(!mines.contains(buttons[r][c])))||buttons[r][c].clicked==false)
        buttons[r][c].setLabel(":(");
    } 
  }
    buttons[NUM_ROWS/2][NUM_COLS/2-3].setLabel("E");
    buttons[NUM_ROWS/2][NUM_COLS/2-2].setLabel("P");
    buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel("S");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("T");
    buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel("E");
    buttons[NUM_ROWS/2][NUM_COLS/2+2].setLabel("I");
    buttons[NUM_ROWS/2][NUM_COLS/2+3].setLabel("N");    
}
public void displayWinningMessage()
{
    for(int r=0;r<NUM_ROWS;r++){
      for(int c=0;c<NUM_COLS;c++){
        if(countMines(r,c)==0&&(!mines.contains(buttons[r][c])))
          buttons[r][c].setLabel(":)");
      }
    }
    buttons[NUM_ROWS/2][NUM_COLS/2-3].setLabel("S");
    buttons[NUM_ROWS/2][NUM_COLS/2-2].setLabel("U");
    buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel("C");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("C");
    buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel("E");
    buttons[NUM_ROWS/2][NUM_COLS/2+2].setLabel("S");
    buttons[NUM_ROWS/2][NUM_COLS/2+3].setLabel("S");
}
public boolean isValid(int row, int col){
  if(row<NUM_ROWS && row >= 0 && col<NUM_COLS && col>=0)
    return true;
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r<=row+1;r++){
      for(int c = col-1; c<=col+1;c++){
        if(isValid(r,c)&&(mines.contains(buttons[r][c])))
          numMines++;
      }
    }
    if(mines.contains(buttons[row][col]))
      numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if (flagged == false)
            clicked = false;
        }  
        else if(mines.contains(this)){
            displayLosingMessage();
        } else if (countMines(myRow, myCol)>0){
            setLabel(countMines(myRow,myCol));
        } else{
            for(int r = myRow-1; r <=myRow+1; r++){
              for(int c = myCol-1; c <= myCol+1; c++){
                if(isValid(r,c) && buttons[r][c].clicked==false)
                  buttons[r][c].mousePressed();
              }
            }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
