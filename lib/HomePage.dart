import 'dart:async';

import 'package:flutter/material.dart';

import 'bird.dart';

import 'barrier.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bird variables
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -15;
  double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  var jumpCount = 0;

  //game setting
  bool gameHasStarted = false;

  //barrier variables
  static List<double > barrierX = [ 2, 2+1.5];
  static double barrierWidth = 0.5;
    List<List<double>> barrierHeight = [
        [0.6,0.4],
      [0.4,0.6],

  ];

  void startGame() {
    gameHasStarted = true;
    jumpCount=0;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPos - height;
      });
      print(birdY);

      // check bird is dead
      if(birdIsDead()){
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }

      moveMap();

      time += 0.01;
    });
  }

  void moveMap(){

    for(int i =0;i<barrierX.length;i++){

      setState(() {
        barrierX[i] -= 0.005;
      });
    }
  }
  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "G A M E O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        "PLAY AGAIN",
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
      jumpCount++;
    });
  }

  bool birdIsDead(){
    if (birdY < -1 || birdY > 1) {
    return true;
    }

    //hit barrier
    for(int i=0; i <barrierX.length; i++){
      if(barrierX[i]<= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >=1 - barrierHeight[i][1])){
        return true;
      }
    }
    return false;

  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white10,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),

                      // Top barrier 0
                      MyBarrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          isThisBottomBarrier: false),
                      // Bottom barrier 0
                      MyBarrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][1],
                          isThisBottomBarrier: true),
                      // Top barrier 1
                      MyBarrier(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          isThisBottomBarrier: false),
                      // Bottom barrier 1
                      MyBarrier(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][1],
                          isThisBottomBarrier: true),

                      Container(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          gameHasStarted ? '': 'T A P  T O  P L A Y',

                          style: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Center(
                  child: Stack(
                    children: [
                      Text('JUMP  COUNT ${jumpCount} ')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
