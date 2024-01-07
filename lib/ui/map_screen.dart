import 'dart:ui';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:path_drawing/path_drawing.dart';
import 'package:talker/talker.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  final horizontalScrollController1 = ScrollController();
  final horizontalScrollController2 = ScrollController();
  late Size size;
  double _progress = 0.0;
  double _showCurretLevel = 0.0;
  late Animation _animationPath;
  late Animation _animationUndoneLvl;

  late AnimationController _controllerAnimatePath;
  late AnimationController _controllerAnimateUndoneLvl;
  @override
  void initState() {
    _controllerAnimateUndoneLvl = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _controllerAnimatePath = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animationPath =
        Tween(begin: 0.0, end: 1.0).animate(_controllerAnimatePath);
    _animationUndoneLvl =
        Tween(begin: 0.0, end: 1.0).animate(_controllerAnimateUndoneLvl);
    _controllerAnimatePath.forward().whenComplete(() {
      _controllerAnimateUndoneLvl.forward();
    });

    _controllerAnimateUndoneLvl.addListener(() {
      setState(() {
        _showCurretLevel = _animationUndoneLvl.value;
      });
    });

    _controllerAnimatePath.addListener(() {
      setState(() {
        _progress = _animationPath.value;
      });
    });
    horizontalScrollController2.addListener(() {
      setState(() {
        horizontalScrollController1
            .jumpTo(horizontalScrollController2.position.pixels);
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: 1600,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: horizontalScrollController1,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1600,
                  child: Image.asset(
                    'assets/fullmap.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                controller: horizontalScrollController2,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1600,
                  height: MediaQuery.of(context).size.height,
                  child: CustomPaint(
                    painter: MapPathPainter(
                        showCurrentLevel: _showCurretLevel,
                        progress: _progress,
                        repaint: _controllerAnimatePath,
                        lvl: 2),
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

class Level {
  const Level({
    required this.path,
  });
  final Path path;
}

class MapPathPainter extends CustomPainter {
  final double _progress;
  final double _showCurretLevel;
  final int lvl;

  MapPathPainter(
      {required this.lvl,
      super.repaint,
      required double progress,
      required double showCurrentLevel})
      : _progress = progress,
        _showCurretLevel = showCurrentLevel;

  @override
  void paint(Canvas canvas, Size size) {
    List<Level> levels = _getLevels(size);

    final Path x = Path()
      ..moveTo(20, 20)
      ..lineTo(40, 40)
      ..moveTo(40, 20)
      ..lineTo(20, 40);

    final Path xDone = Path()
      ..moveTo(20, 20)
      ..lineTo(40, 40)
      ..moveTo(40, 20)
      ..lineTo(20, 40);

// animate path
    final Path statciPath = _generateStaticPathAndDoneLvl(size, lvl, levels).$1;
    final List<Offset> selectedPoints =
        _generateStaticPathAndDoneLvl(size, lvl, levels).$2;
    final animatePath = _generateAnimatePathandUnDoneLvl(size, lvl, levels).$1;
    final Offset lastPoint =
        _generateAnimatePathandUnDoneLvl(size, lvl, levels).$2;
    final PathMetrics animPathMetrics = animatePath.computeMetrics();

    canvas.drawPath(
      dashPath(
        statciPath,
        dashArray: CircularIntervalList<double>(<double>[10, 20]),
      ),
      Paint()
        ..color = const Color.fromARGB(255, 0, 0, 0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    ///
    /// draw animated path with dash
    ///
    for (var element in animPathMetrics) {
      final double length = element.length * _progress;
      final Path newPath = element.extractPath(0, length);
      canvas.drawPath(
          dashPath(
            newPath,
            dashArray: CircularIntervalList<double>(<double>[10, 20]),
          ),
          Paint()
            ..color = const Color.fromARGB(255, 26, 255, 0)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round);
    }

    ///
    /// draw done levels
    ///

    for (var element in selectedPoints) {
      canvas.drawPath(
        x.transform(Matrix4.translationValues(
                //polowa x
                (element.dx - 25),
                (element.dy - 25),
                0)
            .storage),
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    ///
    /// draw undone level
    ///
    canvas.drawPath(
      xDone.transform(
          Matrix4.translationValues(lastPoint.dx - 25, lastPoint.dy - 25, 0)
              .storage),
      Paint()
        ..color = Colors.blue.withOpacity(_showCurretLevel)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<Level> _getLevels(Size size) {
    var lvls = [
      Level(
        path: Path()
          ..moveTo(0, 0)
          ..cubicTo(
              120, size.height / 5, 60, size.height / 4, 40, size.height - 40),
      ),
      Level(
        path: Path()
          ..moveTo(40, size.height - 40)
          ..cubicTo(60, size.height, 270, size.height + 40, 200, 200),
      ),
      Level(
        path: Path()
          ..moveTo(200, 200)
          ..cubicTo(200, 0, 450, -80, 380, 270),
      ),
    ];
    return lvls;
  }
}

(Path, List<Offset>) _generateStaticPathAndDoneLvl(
    Size size, int lvl, List<Level> levels) {
  List<Offset> selectedPoints = [];

  final indexes =
      levels.where((element) => levels.indexOf(element) < lvl).toList();
  Path path = Path();
  for (var element in indexes) {
    path.addPath(element.path, Offset.zero);
    final PathMetrics pathMetrics = element.path.computeMetrics();
    for (final PathMetric pathMetric in pathMetrics) {
      final Tangent tangent =
          pathMetric.getTangentForOffset(pathMetric.length)!;
      selectedPoints.add(tangent.position);
    }
    Talker().good(selectedPoints.toString());
  }
  return (path, selectedPoints);
}

(Path, Offset) _generateAnimatePathandUnDoneLvl(
    Size size, int lvl, List<Level> levels) {
  PathMetric pathMetric = levels[lvl].path.computeMetrics().first;
  Offset lastPoint =
      pathMetric.getTangentForOffset(pathMetric.length)!.position;
  return (levels[lvl].path, lastPoint);
}
