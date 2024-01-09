import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_map/gen/assets.gen.dart';
import 'package:game_map/ui/models/checkpoints.dart';
import 'dart:ui' as ui;

import 'package:talker/talker.dart';
part 'map_state.dart';
part 'map_cubit.freezed.dart';

class MapCubit extends Cubit<MapState> {
  final List<Checkpoint> checkpoints;

  MapCubit()
      : checkpoints = _initializeCheckpoints(),
        super(const MapState.loading());

  static List<Checkpoint> _initializeCheckpoints() {
    return [
      Checkpoint(
        onTap: () => loadLvl(1),
        countDoneStars: 1,
        position: const Offset(40, 310),
      ),
      Checkpoint(
        onTap: () => loadLvl(2),
        countDoneStars: 2,
        position: const Offset(200, 200),
      ),
      Checkpoint(
        onTap: () => loadLvl(3),
        countDoneStars: 3,
        position: const Offset(380, 260),
      ),
      Checkpoint(
        onTap: () => loadLvl(4),
        countDoneStars: 2,
        position: const Offset(500, 260),
      ),
      Checkpoint(
        onTap: () => loadLvl(5),
        countDoneStars: 3,
        position: const Offset(550, 40),
      ),
    ];
  }

  static void loadLvl(int indexLvl) {
    Talker().warning('loadLvl for level $indexLvl');
    // Tutaj dodaj kod związany z ładowaniem poziomu
  }

  Future loadImage() async {
    Future<ByteData> img = rootBundle.load(Assets.fullmap.path);
    final codec =
        await ui.instantiateImageCodec((await img).buffer.asUint8List());
    final frame = await codec.getNextFrame();
    emit(MapState.loaded(checkpoints: checkpoints, image: frame.image, lvl: 3));
  }
}
