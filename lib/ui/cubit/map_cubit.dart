import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_map/ui/models/checkpoints.dart';
import 'dart:ui' as ui;

part 'map_state.dart';
part 'map_cubit.freezed.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState.loading());

  final List<Checkpoint> checkpoints = [
    const Checkpoint(
      countDoneStars: 1,
      position: Offset(40, 310),
    ),
    const Checkpoint(
      countDoneStars: 2,
      position: Offset(200, 200),
    ),
    const Checkpoint(
      countDoneStars: 3,
      position: Offset(380, 260),
    ),
    const Checkpoint(
      countDoneStars: 4,
      position: Offset(500, 260),
    ),
  ];

  Future loadImage(double height) async {
    Future<ByteData> img = rootBundle.load('assets/fullmap.jpg');
    final codec = await ui.instantiateImageCodec(
        (await img).buffer.asUint8List(),
        targetWidth: 1600,
        targetHeight: height.toInt());
    final frame = await codec.getNextFrame();

    emit(MapState.loaded(checkpoints: checkpoints, image: frame.image, lvl: 3));
  }
}
