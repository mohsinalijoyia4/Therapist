import 'package:docapp/games/jigsaw/Models/jigsawPos.dart';
import 'package:flutter/material.dart';

class ImageBox {
  Widget image;
  JigsawPos posSide;
  Offset offsetCenter;
  Size size;
  double radiusPoint;
  bool isDone;

  ImageBox(
      {required this.image,
      required this.posSide,
      required this.offsetCenter,
      required this.size,
      required this.radiusPoint,
      required this.isDone});
}
