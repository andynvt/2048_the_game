import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:the_game_2048/service/cache/cache_service.dart';

import '../config.dart';
import '../widget/consum.dart';
import '../widget/theme.dart';
import 'logic.dart';

class GameWidget extends StatefulWidget {
  final int size;

  const GameWidget({Key key, this.size}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GameWidgetState(size, size);
  }
}

class _GameWidgetState extends State<GameWidget> {
  Game _game;
  MediaQueryData _queryData;
  int row;
  int column;
  final double cellPadding = 8.0;
  final EdgeInsets _gameMargin = EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0);
  bool _isDragging = false;
  bool _isGameOver = false;
  int bestScore = 0;

  _GameWidgetState(this.row, this.column);

  @override
  void initState() {
    super.initState();

    newGame(4);
  }

  void newGame(int size) {
    _game = Game(size, size);
    _game.init();
    setState(() {
      row = column = size;
      _isGameOver = false;
    });
    bestScore = CacheService.shared().getInt('score_$row');
  }

  void moveLeft() {
    setState(() {
      _game.moveLeft();
      checkGameOver();
    });
  }

  void moveRight() {
    setState(() {
      _game.moveRight();
      checkGameOver();
    });
  }

  void moveUp() {
    setState(() {
      _game.moveUp();
      checkGameOver();
    });
  }

  void moveDown() {
    setState(() {
      _game.moveDown();
      checkGameOver();
    });
  }

  void checkGameOver() {
    if (_game.isGameOver()) {
      _isGameOver = true;
      if (_game.score > bestScore) {
        setState(() {
          bestScore = _game.score;
        });
      }
      CacheService.shared().setInt('score_$row', bestScore);
    }
  }

  void _infoClick(BuildContext bottom, BuildContext context) {
    Navigator.of(bottom).pop();
    showDialog(
      context: context,
      builder: (__) {
        return AlertDialog(
          title: Text(
            'About',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Config.about),
              SizedBox(height: 16),
              Text(
                '2048 The Game ${Config.version}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _helpClick(BuildContext bottom, BuildContext context) {
    Navigator.of(bottom).pop();
    showDialog(
      context: context,
      builder: (__) {
        return AlertDialog(
          title: Text(
            'How to play',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          content: Text(Config.howToPlay),
        );
      },
    );
  }

  void menuClick() {
    final w = MediaQuery.of(context).size.width;
    final width = (w - 64) / 3;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Icon(Icons.info_outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              onPressed: () => _infoClick(_, context),
                            ),
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Icon(Icons.help_outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              onPressed: () => _helpClick(_, context),
                            ),
                          ),
                        ],
                      ),
                      OutlineButton(
                        child: Consum<TTheme>(
                            value: TTheme.shared,
                            builder: (_, theme) {
                              String text = 'System';
                              if (theme.mode == 1) {
                                text = 'Light mode';
                              } else if (theme.mode == 2) {
                                text = 'Dark mode';
                              }
                              return Text(text);
                            }),
                        highlightedBorderColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        onPressed: () {
                          TTheme.shared.changeTheme();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(_).pop();
                              newGame(2);
                            },
                            child: Container(
                              color: Colors.red,
                              height: width,
                              width: width,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('3 x 3')
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(_).pop();
                              newGame(4);
                              // props.onChange(4);
                            },
                            child: Container(
                              color: Colors.red,
                              height: width,
                              width: width,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('4 x 4')
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(_).pop();
                              newGame(5);
                              // props.onChange(5);
                            },
                            child: Container(
                              color: Colors.red,
                              height: width,
                              width: width,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('5 x 5')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CellWidget> _cellWidgets = List<CellWidget>();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _cellWidgets.add(CellWidget(cell: _game.get(r, c), state: this));
      }
    }
    _queryData = MediaQuery.of(context);
    List<Widget> children = List<Widget>();
    children.add(BoardGridWidget(this));
    children.addAll(_cellWidgets);
    EdgeInsets padding = const EdgeInsets.fromLTRB(20, 20, 20, 0);
    return Column(
      children: <Widget>[
        Padding(
          padding: padding,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '2048',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 27,
                    child: AutoSizeText(
                      'Join and get to the',
                      maxLines: 2,
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ),
                  Text(
                    '2048 tile!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 110,
                height: 60.0,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "SCORE",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        _game.score.toString(),
                        // '0000000',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 110,
                height: 60.0,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "BEST",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        bestScore.toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 30,
                ),
                onPressed: menuClick,
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        GestureDetector(
          onVerticalDragUpdate: (detail) {
            if (detail.delta.distance == 0 || _isDragging) {
              return;
            }
            _isDragging = true;
            if (detail.delta.direction > 0) {
              moveDown();
            } else {
              moveUp();
            }
          },
          onVerticalDragEnd: (detail) {
            _isDragging = false;
          },
          onVerticalDragCancel: () {
            _isDragging = false;
          },
          onHorizontalDragUpdate: (detail) {
            if (detail.delta.distance == 0 || _isDragging) {
              return;
            }
            _isDragging = true;
            if (detail.delta.direction > 0) {
              moveLeft();
            } else {
              moveRight();
            }
          },
          onHorizontalDragDown: (detail) {
            _isDragging = false;
          },
          onHorizontalDragCancel: () {
            _isDragging = false;
          },
          child: Stack(
            children: [
              Container(
                margin: _gameMargin,
                width: _queryData.size.width,
                height: _queryData.size.width,
                child: Stack(
                  children: children,
                ),
              ),
              Container(
                margin: _gameMargin,
                width: _queryData.size.width,
                height: _queryData.size.width,
                color: _isGameOver ? Color.fromRGBO(255, 255, 255, 0.4) : Colors.transparent,
                child: Opacity(
                  opacity: _isGameOver ? 1.0 : 0.0,
                  child: Center(
                    child: Text(
                      "Game Over!",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Size boardSize() {
    assert(_queryData != null);
    Size size = _queryData.size;
    num width = size.width - _gameMargin.left - _gameMargin.right;
    return Size(width, width);
  }
}

class BoardGridWidget extends StatelessWidget {
  final _GameWidgetState _state;
  BoardGridWidget(this._state);
  @override
  Widget build(BuildContext context) {
    final boardSize = _state.boardSize();
    double width = (boardSize.width - (_state.column + 1) * _state.cellPadding) / _state.column;
    List<CellBox> _backgroundBox = List<CellBox>();
    for (int r = 0; r < _state.row; ++r) {
      for (int c = 0; c < _state.column; ++c) {
        CellBox box = CellBox(
          left: c * width + _state.cellPadding * (c + 1),
          top: r * width + _state.cellPadding * (r + 1),
          size: width,
          color: Colors.grey[300],
        );
        _backgroundBox.add(box);
      }
    }
    return Positioned(
      left: 0.0,
      top: 0.0,
      child: Container(
        width: _state.boardSize().width,
        height: _state.boardSize().height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Stack(
          children: _backgroundBox,
        ),
      ),
    );
  }
}

class AnimatedCellWidget extends AnimatedWidget {
  final BoardCell cell;
  final _GameWidgetState state;
  AnimatedCellWidget({Key key, this.cell, this.state, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.cellPadding) / state.column;
    if (cell.number == 0) {
      return Container();
    } else {
      return CellBox(
        left: (cell.column * width + state.cellPadding * (cell.column + 1)) +
            width / 2 * (1 - animationValue),
        top: cell.row * width +
            state.cellPadding * (cell.row + 1) +
            width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: Config.boxColors.containsKey(cell.number)
            ? Config.boxColors[cell.number]
            : Config.boxColors[Config.boxColors.keys.last],
        text: Text(
          cell.number.toString(),
          maxLines: 1,
          style: TextStyle(
            fontSize: 30.0 * animationValue,
            fontWeight: FontWeight.bold,
            color: cell.number < 32 ? Colors.grey[600] : Colors.grey[50],
          ),
        ),
      );
    }
  }
}

class CellWidget extends StatefulWidget {
  final BoardCell cell;
  final _GameWidgetState state;
  CellWidget({this.cell, this.state});
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  dispose() {
    controller.dispose();
    super.dispose();
    widget.cell.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cell.isNew && !widget.cell.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.cell.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    return AnimatedCellWidget(
      cell: widget.cell,
      state: widget.state,
      animation: animation,
    );
  }
}

class CellBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text text;
  CellBox({this.left, this.top, this.size, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Center(
              child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.center, child: text))),
    );
  }
}
