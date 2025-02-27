import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/tile_state.dart';

class BoardTile extends StatelessWidget {
  final TileState tileState;
  final double dimension;
  final VoidCallback onPressed;

  BoardTile({Key? key, required this.tileState, required this.dimension, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      child: TextButton(
        onPressed: onPressed,
        child: _widgetForTileState(),
      ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget;

    switch (tileState) {
      case TileState.EMPTY:
        widget = Container(); // Empty tile, no widget.
        break;

      case TileState.CROSS:
        widget = Image.asset('images/x.png');
        break;

      case TileState.CIRCLE:
        widget = Image.asset('images/o.png');
        break;
    }

    return widget;
  }
}
