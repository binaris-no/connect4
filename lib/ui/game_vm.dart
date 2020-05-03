import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

const ROWS = 6;
const COLUMNS = 7;

class GameViewModel extends BaseViewModel {
  List<List<bool>> get grid => _grid;
  int get rowsCount => _grid.length;
  int get columnsCount => _grid.first.length;
  String get gameStatus => _gameStatus;
  String _gameStatus = 'Your turn';

  final _grid = List<List<bool>>.generate(
    ROWS,
    (_) => List<bool>.generate(COLUMNS, (_) => null),
  );
  final _random = Random();
  bool _playersTurn = true;
  List<List<int>> _win;

  void resetGame() {
    _playersTurn = true;
    _grid.asMap().forEach((row, _) => _grid[row] = List<bool>.generate(
          COLUMNS,
          (_) => null,
        ));
    _gameStatus = 'Your turn';
    _win = null;
    notifyListeners();
  }

  void dropInColumn(int gridIndex) async {
    if (_win != null) {
      return;
    }

    if (!_playersTurn) {
      setBusy(true);
      await Future.delayed(Duration(milliseconds: 750));
      setBusy(false);
    }

    final int col = gridIndex % 7;
    final int row = _getEmptyRow(col);
    if (row == null) {
      if (!_playersTurn) {
        return dropInColumn(_random.nextInt(ROWS * COLUMNS));
      }

      return;
    }

    // Drop
    _grid[row][col] = _playersTurn;

    // Check row win
    var indexes = _hasConsecutiveFour(_grid[row], _playersTurn);
    if (indexes != null) {
      _win = [
        [row, indexes[0]],
        [row, indexes[1]],
        [row, indexes[2]],
        [row, indexes[3]]
      ];
      _gameStatus = _playersTurn ? 'You win!' : 'Computer wins!';
      return notifyListeners();
    }

    // Check column win
    indexes =
        _hasConsecutiveFour(_grid.map((e) => e[col]).toList(), _playersTurn);
    if (indexes != null) {
      _win = [
        [indexes[0], col],
        [indexes[1], col],
        [indexes[2], col],
        [indexes[3], col]
      ];
      _gameStatus = _playersTurn ? 'You win!' : 'Computer wins!';
      return notifyListeners();
    }

    _playersTurn = !_playersTurn;
    _gameStatus = _playersTurn ? 'Your turn' : 'Computer\'s turn';
    notifyListeners();
    if (!_playersTurn) {
      dropInColumn(_random.nextInt(ROWS * COLUMNS));
    }
  }

  List<int> _hasConsecutiveFour(List<bool> elements, bool match) {
    final List<int> indexes = [];
    elements.asMap().forEach((index, value) {
      if (value == match) {
        indexes.add(index);
      }
    });

    if (indexes.length < 4) {
      return null;
    }

    int previous = indexes[0];
    for (var i = 1; i < indexes.length; i++) {
      if (indexes[i] != previous + 1) {
        return null;
      }

      previous = indexes[i];
    }

    return indexes;
  }

  int _getEmptyRow(int col) {
    int i = ROWS - 1;
    for (; i >= 0; i--) {
      if (_grid[i][col] == null) {
        return i;
      }
    }

    return null;
  }

  Color getCellColor(int gridIndex) {
    final int row = (gridIndex / 7).floor();
    final int col = gridIndex % 7;
    final bool player = _grid[row][col];
    if (_win != null) {
      for (List coord in _win) {
        if (ListEquality().equals(coord, [row, col])) {
          return Color(player ? 0xFF770000 : 0xFF777700);
        }
      }
    }

    switch (player) {
      case true:
        return Color(0xFFFF0000);
      case false:
        return Color(0xFFFFFF00);
      default:
        return Color(0xFFCCCCCC);
    }
  }
}
