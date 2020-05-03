import 'package:connect4/ui/game_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GameViewModel>.reactive(
      viewModelBuilder: () => GameViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Connect 4'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.replay),
              onPressed: model.resetGame,
            )
          ],
        ),
        body: Container(
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: model.columnsCount,
                ),
                itemCount: model.columnsCount * model.rowsCount,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () => model.dropInColumn(index),
                  child: GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        color: model.getCellColor(index),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Center(
                  child: Text(
                    model.gameStatus,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
