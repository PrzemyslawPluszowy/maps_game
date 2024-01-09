import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'checkpoints.freezed.dart';

@freezed
class Checkpoint with _$Checkpoint {
  const factory Checkpoint({
    required Offset position,
    required int countDoneStars,
    required Function() onTap,
  }) = _Checkpoint;
}
