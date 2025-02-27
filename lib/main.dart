import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/board_tiles.dart';
import 'package:tic_tac_toe_flutter/tile_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9, TileState.EMPTY);

  var _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Image.asset('images/board.png'),
              _boardTiles(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tileDimension = boardDimension / 3;

      return Container(
        width: boardDimension,
        height: boardDimension,
        child: Column(
          children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value;

            return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;

                return Expanded(
                  child: BoardTile(
                    tileState: tileState,
                    dimension: tileDimension,
                    onPressed: () => _updateTileStateForIndex(tileIndex),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      );
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != null) {
        print('Winner is: $winner');
        _showWinnerDialog(winner);
      }
          // Check if the board is full and there's no winner
    else if (!_boardState.contains(TileState.EMPTY)) {
      print('The game is a draw');
      _showWinnerDialog(null);  // Passing null to indicate a draw
    }
    }
  }

  TileState? _findWinner() {
    TileState? Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState? winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i];
        break;
      }
    }

    return winner;
  }

void _showWinnerDialog(TileState? tileState) {
  final context = navigatorKey.currentState!.context;
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(tileState == null ? 'Draw' : 'Winner'),
        content: tileState == null
            ? Text('The game ended in a draw!')
            : Image.asset(
                tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png',
              ),
        actions: [
          TextButton(
            onPressed: () {
              _resetGame();
              Navigator.of(context).pop();
            },
            child: Text('New Game'),
          ),
        ],
      );
    },
  );
}


  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
