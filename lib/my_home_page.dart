import 'dart:async';
import 'package:flutter/material.dart';
import './barrier.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    static double  Y = 0;
    double initialPos = Y;
    double height = 0;
    double time = 0;
    double gr = -6;
    double velocity = 4.3; 
    bool gameHasStarted = false;
    int score = 0;

    double birdWidth  = 0.1; // Out of 2, 2 being the enqtire screen width
    double birdHeight = 0.1; //Out of 2

    //barrier variables
    static List<double> barrierX = [2, 2 + 1.5];
    static double barrierWidth = 0.5; // Out of 2

    List<List<double>> barrierHeight = [
      [0.6,0.4],
      [0.4,0.6],
    ];

    List<int> flag = [1,1];

    void gameoverPopup(BuildContext context) {

      showDialog(

        context : context,
         builder: (BuildContext context) {
          
          return AlertDialog(
            backgroundColor : Colors.green,
            title : Center(
              child: Column(

                children: [
                const Text(
                "GAME OVER",
                style : TextStyle(color : Colors.white),
                ),
              Text("${score}",style : TextStyle(fontSize : 30,color : Colors.white) ),
              ],),
              ),
              actions : [
                GestureDetector(
                  onTap : resetGame,
                  child : ClipRRect(
                    borderRadius : BorderRadius.circular(5),
                    child : Container(
                      padding : const EdgeInsets.all(8),
                      color : Colors.white,
                      child : const Text('Play Again',
                      style : TextStyle(color : Colors.brown)), 
                    )
                  ),
                ),
              ],
          );
        }
        );

}

    void startGame() {

      gameHasStarted = true;
      Timer.periodic(const Duration(milliseconds : 10), (timer) { 

          height = gr * time * time + velocity * time;

          setState(() {
            Y = initialPos - height;
          },
          );

        if(birdIsDead()) {
          timer.cancel();
          gameHasStarted = false;
          gameoverPopup(context);
        }

        moveMap();
        time += 0.01;
      });
       
    }

    void moveMap() {

      for(int i = 0; i < barrierX.length; i++) {

        setState( () {

          barrierX[i]-=0.005;

        if(barrierX[i] + barrierWidth < 0 && flag[i]==1) {
          score++;
          flag[i] = 0;
         }

        }); 

     // If barrier exits the left part of the screen, keep it looping
        if(barrierX[i] < -1.5) {
          barrierX[i] += 3;
          flag[i] = 1;
        }
      }
    }

    void jump() {

      setState(() {
        time = 0;
        initialPos = Y;
      });
    }

    bool birdIsDead() {

      if(Y + birdHeight < -1 || Y - birdHeight > 1) {
          return true;
      }
  // hits barriers
  // checks if bird is within x coord and y coord of barriers
    for(int i = 0; i < barrierX.length; i++) {

      if(barrierX[i] < birdWidth && barrierX[i] + barrierWidth > -birdWidth &&
      (Y < -1 + barrierHeight[i][0] || Y + birdHeight > 1 - barrierHeight[i][1]) ) {
        return true;
      }
    }
      return false;
    }

    void resetGame() {

      Navigator.pop(context);

      setState( () {
        Y = 0;
        gameHasStarted = false;
        time  = 0;
        initialPos = Y;
        barrierX = [2, 2 + 1.5];
        flag = [1,1];
        score = 0;
      });
  
}

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap : gameHasStarted ? jump : startGame,
    child : Scaffold(

      body : Column(
        children: [
            Expanded(
              flex : 3,
              child : Container(
                color : Colors.blue,

                child : Container(

                  child : Stack(  

                   children : [

                     Container(
                      alignment : Alignment(0, 0.6),
                      child : Text(
                      gameHasStarted ? '' : 'T A P  T O  P L A Y',
                      style :const TextStyle(fontSize : 25,color: Colors.white), 
                    ),
                    ),                      

                     Container(
                      // alignment : Alignment(0, Y),
                      //alignment: Alignment(0, (2 * Y + birdHeight)),
                      alignment: Alignment(0, (Y)),
                      child  : Container(
                      //   height : 50,
                      //  width : 50,
                      height : MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 1.5,
                      width : MediaQuery.of(context).size.height * birdWidth / 1.5,
                     // decoration : BoxDecoration(color : Colors.red),
                      child : Image.asset('bird_low.png'),
                      // color : Colors.red,s
                     ),
                  ),

                // Top Barrier 0
                  Barrier(
                    barrierX : barrierX[0],
                    barrierWidth : barrierWidth,
                    barrierHeight : barrierHeight[0][0],
                    isThisBottomBarrier: false,
                  ),

                // Bottom Barrier 0
                  Barrier(
                    barrierX : barrierX[0],
                    barrierWidth : barrierWidth,
                    barrierHeight : barrierHeight[0][1],
                    isThisBottomBarrier: true,
                  ),

                // Top Barrier 1

                  Barrier(
                    barrierX : barrierX[1],
                    barrierWidth : barrierWidth,
                    barrierHeight : barrierHeight[1][0],
                    isThisBottomBarrier: false,
                  ),

                // Bottom Barrier 1
                  Barrier(
                    barrierX : barrierX[1],
                    barrierWidth : barrierWidth,
                    barrierHeight : barrierHeight[1][1],
                    isThisBottomBarrier: true,
                  ),

                  ],
                ),
              ),
            ),
            ),

            Expanded(
              child: Container(
                child : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child : Text("SCORE",style : TextStyle(fontSize : 30,)),
                      ),
                    Text("${score}",style : TextStyle(fontSize : 30,color : Colors.white) ),
                  ],
                ),
                color : Colors.brown,
              ),
            ),
        ],
        ),
    ),
    );
  }  
}


