// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkpoints.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Checkpoint {
  Offset get position => throw _privateConstructorUsedError;
  int get countDoneStars => throw _privateConstructorUsedError;
  dynamic Function() get onTap => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CheckpointCopyWith<Checkpoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckpointCopyWith<$Res> {
  factory $CheckpointCopyWith(
          Checkpoint value, $Res Function(Checkpoint) then) =
      _$CheckpointCopyWithImpl<$Res, Checkpoint>;
  @useResult
  $Res call({Offset position, int countDoneStars, dynamic Function() onTap});
}

/// @nodoc
class _$CheckpointCopyWithImpl<$Res, $Val extends Checkpoint>
    implements $CheckpointCopyWith<$Res> {
  _$CheckpointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? countDoneStars = null,
    Object? onTap = null,
  }) {
    return _then(_value.copyWith(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      countDoneStars: null == countDoneStars
          ? _value.countDoneStars
          : countDoneStars // ignore: cast_nullable_to_non_nullable
              as int,
      onTap: null == onTap
          ? _value.onTap
          : onTap // ignore: cast_nullable_to_non_nullable
              as dynamic Function(),
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckpointImplCopyWith<$Res>
    implements $CheckpointCopyWith<$Res> {
  factory _$$CheckpointImplCopyWith(
          _$CheckpointImpl value, $Res Function(_$CheckpointImpl) then) =
      __$$CheckpointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Offset position, int countDoneStars, dynamic Function() onTap});
}

/// @nodoc
class __$$CheckpointImplCopyWithImpl<$Res>
    extends _$CheckpointCopyWithImpl<$Res, _$CheckpointImpl>
    implements _$$CheckpointImplCopyWith<$Res> {
  __$$CheckpointImplCopyWithImpl(
      _$CheckpointImpl _value, $Res Function(_$CheckpointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? countDoneStars = null,
    Object? onTap = null,
  }) {
    return _then(_$CheckpointImpl(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      countDoneStars: null == countDoneStars
          ? _value.countDoneStars
          : countDoneStars // ignore: cast_nullable_to_non_nullable
              as int,
      onTap: null == onTap
          ? _value.onTap
          : onTap // ignore: cast_nullable_to_non_nullable
              as dynamic Function(),
    ));
  }
}

/// @nodoc

class _$CheckpointImpl with DiagnosticableTreeMixin implements _Checkpoint {
  const _$CheckpointImpl(
      {required this.position,
      required this.countDoneStars,
      required this.onTap});

  @override
  final Offset position;
  @override
  final int countDoneStars;
  @override
  final dynamic Function() onTap;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Checkpoint(position: $position, countDoneStars: $countDoneStars, onTap: $onTap)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Checkpoint'))
      ..add(DiagnosticsProperty('position', position))
      ..add(DiagnosticsProperty('countDoneStars', countDoneStars))
      ..add(DiagnosticsProperty('onTap', onTap));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckpointImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.countDoneStars, countDoneStars) ||
                other.countDoneStars == countDoneStars) &&
            (identical(other.onTap, onTap) || other.onTap == onTap));
  }

  @override
  int get hashCode => Object.hash(runtimeType, position, countDoneStars, onTap);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckpointImplCopyWith<_$CheckpointImpl> get copyWith =>
      __$$CheckpointImplCopyWithImpl<_$CheckpointImpl>(this, _$identity);
}

abstract class _Checkpoint implements Checkpoint {
  const factory _Checkpoint(
      {required final Offset position,
      required final int countDoneStars,
      required final dynamic Function() onTap}) = _$CheckpointImpl;

  @override
  Offset get position;
  @override
  int get countDoneStars;
  @override
  dynamic Function() get onTap;
  @override
  @JsonKey(ignore: true)
  _$$CheckpointImplCopyWith<_$CheckpointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
