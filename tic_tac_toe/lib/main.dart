import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class Square extends StatelessWidget {
  Square({
    Key key, 
    this.value, 
    this.onPressed, 
    this.highlight
  }): super(key: key);

  final value;
  final onPressed;
  final highlight;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.all(30),
      shape: CircleBorder(),
      onPressed: onPressed,
      child: Text(
        value,
        style:TextStyle(
          color: Colors.white,
          fontSize: 23.0,
          fontWeight: FontWeight.bold
        ),
      ),
      color: this.highlight? Colors.green: Colors.blue,
    );
  }
}

class Board extends StatelessWidget {
  Board({
    Key key, 
    this.squares, 
    this.onPressed, 
    this.onReset,
    this.winSquares
  }): super(key: key);

  final squares;
  final onPressed;
  final onReset;
  final List<int> winSquares;

  Widget renderSquare(int i) => Square(
    value: squares[i], 
    onPressed: ()=>this.onPressed(i),
    highlight: winSquares != null && winSquares.contains(i),
  );

  Widget renderResetButton() => Square(
      value:'RESET', 
      onPressed: ()=>this.onReset(),
      highlight: false,
  );

  @override
  Widget build(BuildContext context) {

    List<Widget> rows = [];
    for(int i = 0; i < 3; i++) {
      List<Widget> row = [];
      for(int j = 0; j < 3; j++) {
        row.add(this.renderSquare((i*3)+j));
        if(j != 2) row.add(Padding(padding: const EdgeInsets.all(8.0),));
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: row,
      ));
      rows.add(Padding(padding: const EdgeInsets.all(8.0),));
    }

    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: this.renderResetButton())
    ]));

    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows
    );
  }
}

calculateWinner(List<String> squares) {
  final List<List<int>> lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  for(int i = 0; i < lines.length; i ++) {
    final l = lines[i];
    if (squares[l[0]] != '' 
        && squares[l[0]] == squares[l[1]]
        && squares[l[0]] == squares[l[2]]) {
        
        return {
          'winner': squares[l[0]],
          'winSquares': lines[i]
        };
    }
  }
  return {'winner': null, 'winSquares': null};
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> squares = ['','','','','','','','',''];
  bool xIsNext = true;

  void handleClick(int i) {
    List<String> squares = List<String>.from(this.squares);

    if(squares[i] != '' || calculateWinner(squares)['winner'] != null) return;

    squares[i] = xIsNext ? 'X': 'O';
    setState(() {
      this.squares = squares;
      this.xIsNext = !xIsNext;
    });
  }

  void handleReset() {
    setState(() {
      this.squares = ['','','','','','','','',''];
      this.xIsNext = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> squares = List<String>.from(this.squares);
    final winInfo = calculateWinner(squares);
    return Scaffold(
      body: Center(child: Board(
        squares: squares,
        onPressed: (i)=>this.handleClick(i),
        onReset: ()=>this.handleReset(),
        winSquares: winInfo['winSquares'],
      )),
    );
  }
}
