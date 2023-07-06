import 'dart:ui';

import 'package:docapp/games/jigsaw/Widgets/jigsawBlockWidget.dart';

// import 'package:jigsawpuzzle/Screens/jigsawPuzzle.dart';

class BlockClass {
  Offset offset;
  Offset offsetDefault;
  JigsawBlockWidget jigsawBlockWidget;

  BlockClass(
      {required this.offset,
      required this.offsetDefault,
      required this.jigsawBlockWidget});
}
