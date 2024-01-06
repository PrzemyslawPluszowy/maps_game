import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:path_drawing/path_drawing.dart';
import 'package:talker/talker.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget>
    with SingleTickerProviderStateMixin {
  final horizontalScrollController1 = ScrollController();
  final horizontalScrollController2 = ScrollController();
  final horizontalScrollController3 = ScrollController();
  late Size size;
  double _progress = 0.0;
  late Animation<double> animation;
  late Animation _animation;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward().whenComplete(() => _controller.repeat());
    _controller.addListener(() {
      setState(() {
        _progress = _animation.value;
      });
    });
    horizontalScrollController2.addListener(() {
      setState(() {
        horizontalScrollController1
            .jumpTo(horizontalScrollController2.position.pixels);
        // horizontalScrollController3
        //     .jumpTo(horizontalScrollController2.position.pixels);
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
                    'assets/fullmap.jpg', // Zastąp to odpowiednią ścieżką do swojego pliku PNG
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
                    painter: MapPathPainter(progress: _progress),
                  ),
                ),
              ),
            ),

            // Positioned.fill(
            //   child: SingleChildScrollView(
            //     controller: horizontalScrollController2,
            //     scrollDirection: Axis.horizontal,
            //     child: SizedBox(
            //       width: 1600,
            //       child: Image.asset(
            //         'assets/mock_path.png', // Zastąp to odpowiednią ścieżką do swojego pliku PNG
            //         fit: BoxFit.fitWidth,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class MapPathPainter extends CustomPainter {
  final double _progress;

  MapPathPainter({super.repaint, required double progress})
      : _progress = progress;
  @override
  void paint(Canvas canvas, Size size) {
    final Path x = Path()
      ..moveTo(20, 20)
      ..lineTo(40, 40)
      ..moveTo(40, 20)
      ..lineTo(20, 40);

    final Path path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width * 0.08, size.width * 0.03,
          size.height * 0.11, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.01, size.height * 1.1,
          size.width * 0.12, size.height * 0.95)
      ..quadraticBezierTo(230, size.height / 700, 300, 40)
      ..quadraticBezierTo(400, 0, 385, size.height - 100)
      ..quadraticBezierTo(400, size.height + 70, 520, size.height - 100);

    final PathMetrics pathMetrics = path.computeMetrics();
    final PathMetrics xPathMetrics = path.computeMetrics();
    final PathMetrics animPathMetrics = path.computeMetrics();
    final int divisions = xPathMetrics.first.length.floor();

//compute patch to animate

    for (var element in animPathMetrics) {
      final double length = element.length * _progress;
      final Path newPath = element.extractPath(0, length);
      canvas.drawPath(
          dashPath(
            newPath,
            dashArray: CircularIntervalList<double>(<double>[10, 20]),
          ),
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round);
    }

    // canvas.drawPath(
    //   dashPath(
    //     path,
    //     dashArray: CircularIntervalList<double>(<double>[10, 20]),
    //   ),
    //   Paint()
    //     ..color = Colors.black
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 10
    //     ..strokeCap = StrokeCap.round
    //     ..strokeJoin = StrokeJoin.round,
    // );
    List<Offset> selectedPoints = [];

    for (final PathMetric pathMetric in pathMetrics) {
      for (double i = 0.0; i <= divisions; i++) {
        double offset = pathMetric.length * (i / divisions);
        Tangent tangent = pathMetric.getTangentForOffset(offset)!;
        selectedPoints.add(tangent.position);

        if (selectedPoints.length >= 10 && selectedPoints.length % 150 == 0) {
          canvas.drawPath(
            x.transform(Matrix4.translationValues(
                    //polowa x
                    tangent.position.dx - 30,
                    tangent.position.dy - 30,
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
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
