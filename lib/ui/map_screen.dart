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
    //if state image not null

    context.read<MapCubit>().loadImage(MediaQuery.of(context).size.height);
    return Material(
        child: SizedBox(
      width: 1600,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        controller: horizontalScrollController1,
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const Center(child: CircularProgressIndicator()),
              loaded: (loaded) {
                return MapGenerate(state: loaded);
              },
            );
          },
        ),
      ),
    ));
  }
}

class MapGenerate extends StatefulWidget {
  const MapGenerate({super.key, required this.state});
  final MapState state;

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
    return SizedBox(
        width: 1600,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: MapPathPainter(
                  bgImage: widget.state.image,
                  progress: widget._progress,
                  repaint: widget._controllerAnimatePath,
                  checkpoints: loaded.checkpoints,
                  lvl: loaded.lvl),
            ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
            for (final element
                in loaded.checkpoints.sublist(0, loaded.lvl + 1)) ...[
              if (element == loaded.checkpoints.last && widget._progress == 1.0)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: element.position.dx - widget.halfSizeCheckpoint,
                      top: element.position.dy - widget.halfSizeCheckpoint * 2,
                      child: Container(
                        width: widget.halfSizeCheckpoint * 2,
                        height: widget.halfSizeCheckpoint * 2,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/done_lvl.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: element.position.dx - widget.halfSizeCheckpoint,
                        top: element.position.dy - widget.halfSizeCheckpoint,
                        child: Container(
                          width: widget.halfSizeCheckpoint * 2,
                          height: widget.halfSizeCheckpoint * 2,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/undone_lvl.png'),
                            ),
                          ),
                        )),
                  ],
                ).animate().fadeIn(duration: const Duration(milliseconds: 500))
              else if (element != loaded.checkpoints.last)
                Positioned(
                  left: element.position.dx - widget.halfSizeCheckpoint,
                  top: element.position.dy - widget.halfSizeCheckpoint,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/done_lvl.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ));
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

    canvas.drawImage(bgImage, Offset.zero, Paint());

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
