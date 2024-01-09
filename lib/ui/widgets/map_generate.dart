import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_map/gen/assets.gen.dart';
import 'package:game_map/ui/models/checkpoints.dart';
import 'package:path_drawing/path_drawing.dart';

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
  static const double _widthCheckpoint = 40;
  static const double _heightCheckpoint = 40;
  static const Duration _durationAnimatePath = Duration(seconds: 3);
  static const double _widthMap = 1600;
  late final Size size;
  late final Animation _animationPath;
  late final AnimationController _controllerAnimatePath;
  late final ui.Image? bgImage;
  double _progressAnimation = 0.0;

  @override
  void initState() {
    _controllerAnimatePath = AnimationController(
      duration: _durationAnimatePath,
      vsync: this,
    );
    _animationPath =
        Tween(begin: 0.0, end: 1.0).animate(_controllerAnimatePath);

    _controllerAnimatePath.addListener(() {
      setState(() {
        _progressAnimation = _animationPath.value;
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
    const animateDuration = Duration(milliseconds: 800);
    return SizedBox(
        width: _widthMap,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: MapPathPainter(
                  bgImage: widget.image,
                  progress: _progressAnimation,
                  repaint: _controllerAnimatePath,
                  checkpoints: widget.checkpoints,
                  lvl: widget.lvl),
            ).animate().fadeIn(duration: animateDuration),
            ...doneCheckpoints.map((e) => _checkpointWidget(checkpoint: e)),
            if (_progressAnimation == 1)
              _checkpointWidget(checkpoint: unDoneCheckpoints, isUndone: true)
                ..animate().fadeIn(duration: animateDuration),
            if (_progressAnimation == 1)
              _animatedArrowDown(unDoneCheckpoints)
                  .animate(
                      onPlay: (controller) => controller.repeat(
                          reverse: false, period: animateDuration * 1.5))
                  .moveY(begin: -10, end: 10, duration: animateDuration * 1.5)
                  .fadeOut(duration: animateDuration)
                  .shimmer(
                    duration: animateDuration,
                    color: Colors.orange,
                  )
          ],
        ));
  }

  Positioned _animatedArrowDown(Checkpoint unDoneCheckpoints) {
    return Positioned(
        left: unDoneCheckpoints.position.dx - _widthCheckpoint / 2,
        top: unDoneCheckpoints.position.dy - _heightCheckpoint,
        child: const RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 40,
          ),
        ));
  }

  Positioned _checkpointWidget(
      {required Checkpoint checkpoint, bool isUndone = false}) {
    final String assetImage;
    if (isUndone) {
      assetImage = Assets.undoneLvl.path;
    } else {
      switch (checkpoint.countDoneStars) {
        case 1:
          assetImage = Assets.doneLvl1star.path;
          break;
        case 2:
          assetImage = Assets.doneLvl2star.path;
          break;
        case 3:
          assetImage = Assets.doneLvl.path;
          break;
        default:
          assetImage = Assets.doneLvl.path;
      }
    }
    return Positioned(
      left: checkpoint.position.dx - _widthCheckpoint / 2,
      top: checkpoint.position.dy - _heightCheckpoint / 2,
      child: GestureDetector(
        onTap: checkpoint.onTap,
        child: Container(
          width: _widthCheckpoint,
          height: _heightCheckpoint,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(assetImage),
              fit: BoxFit.fill,
            ),
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
  static const List<double> _dashArray = <double>[15, 15];
  static const List<Color> _shaderColors = <Color>[
    Colors.deepPurple,
    Colors.blue,
    Colors.green
  ];

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

    /// draw background image
    canvas.drawImageRect(
        bgImage,
        Rect.fromLTWH(
            0, 0, bgImage.width.toDouble(), bgImage.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint());

    /// draw static path with dash
    final Path statciPath = _generateStaticPathAndDoneLvl(lvl, levels);
    canvas.drawPath(
        dashPath(
          statciPath,
          dashArray: CircularIntervalList<double>(_dashArray),
        ),
        donePathPaint);

    /// draw animated path with dash
    /// with shader gradient
    final animatePath = _generateAnimatePathAndUnDoneLvl(lvl, levels);
    final PathMetrics animPathMetrics = animatePath.computeMetrics();
    unDonePathPaint.shader = const LinearGradient(
            colors: _shaderColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
        .createShader(animatePath.getBounds());
    for (final element in animPathMetrics) {
      final double length = element.length * _progress;
      final Path newPath = element.extractPath(0, length);
      canvas.drawPath(
          dashPath(
            newPath,
            dashArray: CircularIntervalList<double>(_dashArray),
          ),
          unDonePathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<Path> _getLevels(Size size) {
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
        ..cubicTo(350, 440, 520, 400, checkpoints[3].position.dx,
            checkpoints[3].position.dy),
      Path()
        ..moveTo(checkpoints[3].position.dx, checkpoints[3].position.dy)
        ..cubicTo(500, 100, 500, 40, checkpoints[4].position.dx,
            checkpoints[4].position.dy),
    ];
    return lvls;
  }
}

Path _generateStaticPathAndDoneLvl(int lvl, List<Path> levels) {
  final indexes = levels.where((element) => levels.indexOf(element) < lvl);
  final path = Path();
  for (var element in indexes) {
    path.addPath(element, Offset.zero);
  }
  return path;
}

Path _generateAnimatePathAndUnDoneLvl(int lvl, List<Path> levels) {
  return levels[lvl];
}
