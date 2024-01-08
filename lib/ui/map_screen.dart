import 'dart:ui';
import 'dart:core';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_map/ui/cubit/map_cubit.dart';

import 'package:path_drawing/path_drawing.dart';

import 'models/checkpoints.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  final horizontalScrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    context.read<MapCubit>().loadImage(MediaQuery.of(context).size.height);
    return SingleChildScrollView(
      controller: horizontalScrollController1,
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (checkpoints, image, lvl) {
              return MapGenerate(
                  lvl: lvl, checkpoints: checkpoints, image: image);
            },
          );
        },
      ),
    );
  }
}

class MapGenerate extends StatefulWidget {
  const MapGenerate(
      {super.key,
      required this.lvl,
      required this.checkpoints,
      required this.image});
  final int lvl;
  final List<Checkpoint> checkpoints;
  final ui.Image image;

  @override
  State<MapGenerate> createState() => _MapGenerateState();
}

class _MapGenerateState extends State<MapGenerate>
    with TickerProviderStateMixin {
  late Size size;
  double _progress = 0.0;
  late Animation _animationPath;
  late AnimationController _controllerAnimatePath;
  final double halfSizeCheckpoint = 20;
  ui.Image? bgImage;

  @override
  void initState() {
    _controllerAnimatePath = AnimationController(
      duration: const Duration(
        seconds: 3,
      ),
      vsync: this,
    );
    _animationPath =
        Tween(begin: 0.0, end: 1.0).animate(_controllerAnimatePath);

    _controllerAnimatePath.addListener(() {
      setState(() {
        _progress = _animationPath.value;
      });
    });
    _controllerAnimatePath.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controllerAnimatePath.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final checkpoints = widget.checkpoints.sublist(0, widget.lvl + 1);
    final unDoneCheckpoints = checkpoints.last;
    final doneCheckpoints = checkpoints.sublist(0, checkpoints.length - 1);

    return SizedBox(
        width: 1600,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: MapPathPainter(
                  bgImage: widget.image,
                  progress: _progress,
                  repaint: _controllerAnimatePath,
                  checkpoints: widget.checkpoints,
                  lvl: widget.lvl),
            ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
            ...doneCheckpoints
                .map((e) => _checkpointWidget(e, 'assets/done_lvl.png')),
            if (_progress == 1)
              _checkpointWidget(unDoneCheckpoints, 'assets/undone_lvl.png')
                ..animate().fadeIn(duration: const Duration(milliseconds: 500)),
          ],
        ));
  }

  Positioned _checkpointWidget(Checkpoint e, String assetImage) {
    return Positioned(
      left: e.position.dx - halfSizeCheckpoint,
      top: e.position.dy - halfSizeCheckpoint,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetImage),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class MapPathPainter extends CustomPainter {
  final double _progress;
  final int lvl;
  final List<Path> levels = [];
  final ui.Image bgImage;
  final List<Checkpoint> checkpoints;
  final Paint donePathPaint = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final Paint unDonePathPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = const Color.fromARGB(255, 79, 0, 249);

  MapPathPainter(
      {required this.checkpoints,
      required this.lvl,
      super.repaint,
      required double progress,
      required this.bgImage})
      : _progress = progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (levels.isEmpty) {
      levels.addAll(_getLevels(size));
    }

    canvas.drawImageRect(
        bgImage,
        Rect.fromLTWH(
            0, 0, bgImage.width.toDouble(), bgImage.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint());

    final Path statciPath = _generateStaticPathAndDoneLvl(size, lvl, levels);

    final animatePath = _generateAnimatePathAndUnDoneLvl(size, lvl, levels);

    final PathMetrics animPathMetrics = animatePath.computeMetrics();

    canvas.drawPath(
        dashPath(
          statciPath,
          dashArray: CircularIntervalList<double>(<double>[10, 20]),
        ),
        donePathPaint);

    ///
    /// draw animated path with dash
    ///
    for (final element in animPathMetrics) {
      final double length = element.length * _progress;
      final Path newPath = element.extractPath(0, length);
      canvas.drawPath(
          dashPath(
            newPath,
            dashArray: CircularIntervalList<double>(<double>[10, 20]),
          ),
          unDonePathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<Path> _getLevels(
    Size size,
  ) {
    var lvls = [
      Path()
        ..moveTo(0, 30)
        ..cubicTo(120, size.height / 5, 60, size.height / 4,
            checkpoints[0].position.dx, checkpoints[0].position.dy),
      Path()
        ..moveTo(checkpoints[0].position.dx, checkpoints[0].position.dy)
        ..cubicTo(60, size.height, 260, size.height - 40,
            checkpoints[1].position.dx, checkpoints[1].position.dy),
      Path()
        ..moveTo(checkpoints[1].position.dx, checkpoints[1].position.dy)
        ..cubicTo(200, 0, 460, 0, checkpoints[2].position.dx,
            checkpoints[2].position.dy),
      Path()
        ..moveTo(checkpoints[2].position.dx, checkpoints[2].position.dy)
        ..cubicTo(350, 360, 520, 400, checkpoints[3].position.dx,
            checkpoints[3].position.dy),
    ];
    return lvls;
  }
}

Path _generateStaticPathAndDoneLvl(Size size, int lvl, List<Path> levels) {
  final indexes = levels.where((element) => levels.indexOf(element) < lvl);
  final path = Path();
  for (var element in indexes) {
    path.addPath(element, Offset.zero);
  }
  return path;
}

Path _generateAnimatePathAndUnDoneLvl(Size size, int lvl, List<Path> levels) {
  return levels[lvl];
}
