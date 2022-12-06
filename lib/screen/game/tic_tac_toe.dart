import 'package:flutter/material.dart';
import 'package:skype_clone/component/app_theme.dart';
import 'package:skype_clone/logic/game_setup.dart';

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  //adding the necessary variables
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];

  GameSetup gameSetup = GameSetup();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameSetup.board = GameSetup.initGameBoard();
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppThemes.blackColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "It's ${lastValue} turn".toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 58,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            //now we will make the game board
            //but first we will create a Game class that will contains all the data and method that we will need
            SizedBox(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: GameSetup.boardLength ~/
                    3, // the ~/ operator allows you to evade to integer and return an Int as a result
                padding: const EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(GameSetup.boardLength, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                      //when we click we need to add the new value to the board and refresh the screen
                      //we need also to toggle the player
                      //now we need to apply the click only if the field is empty
                      //now let's create a button to repeat the game

                      if (gameSetup.board![index] == "") {
                        setState(() {
                          gameSetup.board![index] = lastValue;
                          turn++;
                          gameOver = gameSetup.winnerCheck(
                              lastValue, index, scoreboard, 3);

                          if (gameOver) {
                            result = "$lastValue is the Winner";
                          } else if (!gameOver && turn == 9) {
                            result = "It's a Draw!";
                            gameOver = true;
                          }
                          if (lastValue == "X") {
                            lastValue = "O";
                          } else {
                            lastValue = "X";
                          }
                        });
                      }
                    },
                    child: Container(
                      width: GameSetup.blocSize,
                      height: GameSetup.blocSize,
                      decoration: BoxDecoration(
                        color: AppThemes.separatorColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text(
                          gameSetup.board![index],
                          style: TextStyle(
                            color: gameSetup.board![index] == "X"
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 64.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Text(
              result,
              style: const TextStyle(color: Colors.white, fontSize: 54.0),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  //erase the board
                  gameSetup.board = GameSetup.initGameBoard();
                  lastValue = "X";
                  gameOver = false;
                  turn = 0;
                  result = "";
                  scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              icon: const Icon(Icons.replay),
              label: const Text("Repeat the Game"),
            ),
          ],
        ));
  }
}
