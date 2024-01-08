part of 'map_cubit.dart';

@freezed
class MapState with _$MapState {
  const factory MapState.loading() = _Loading;
  const factory MapState.loaded({
    required List<Checkpoint> checkpoints,
    required ui.Image image,
    required int lvl,
  }) = _Loaded;
}
