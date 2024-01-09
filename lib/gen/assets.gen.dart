/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsMapTilesGen {
  const $AssetsMapTilesGen();

  /// File path: assets/map_tiles/row-1-column-1.jpg
  AssetGenImage get row1Column1 =>
      const AssetGenImage('assets/map_tiles/row-1-column-1.jpg');

  /// File path: assets/map_tiles/row-1-column-10.jpg
  AssetGenImage get row1Column10 =>
      const AssetGenImage('assets/map_tiles/row-1-column-10.jpg');

  /// File path: assets/map_tiles/row-1-column-2.jpg
  AssetGenImage get row1Column2 =>
      const AssetGenImage('assets/map_tiles/row-1-column-2.jpg');

  /// File path: assets/map_tiles/row-1-column-3.jpg
  AssetGenImage get row1Column3 =>
      const AssetGenImage('assets/map_tiles/row-1-column-3.jpg');

  /// File path: assets/map_tiles/row-1-column-4.jpg
  AssetGenImage get row1Column4 =>
      const AssetGenImage('assets/map_tiles/row-1-column-4.jpg');

  /// File path: assets/map_tiles/row-1-column-5.jpg
  AssetGenImage get row1Column5 =>
      const AssetGenImage('assets/map_tiles/row-1-column-5.jpg');

  /// File path: assets/map_tiles/row-1-column-6.jpg
  AssetGenImage get row1Column6 =>
      const AssetGenImage('assets/map_tiles/row-1-column-6.jpg');

  /// File path: assets/map_tiles/row-1-column-7.jpg
  AssetGenImage get row1Column7 =>
      const AssetGenImage('assets/map_tiles/row-1-column-7.jpg');

  /// File path: assets/map_tiles/row-1-column-8.jpg
  AssetGenImage get row1Column8 =>
      const AssetGenImage('assets/map_tiles/row-1-column-8.jpg');

  /// File path: assets/map_tiles/row-1-column-9.jpg
  AssetGenImage get row1Column9 =>
      const AssetGenImage('assets/map_tiles/row-1-column-9.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
        row1Column1,
        row1Column10,
        row1Column2,
        row1Column3,
        row1Column4,
        row1Column5,
        row1Column6,
        row1Column7,
        row1Column8,
        row1Column9
      ];
}

class Assets {
  Assets._();

  static const AssetGenImage doneLvl = AssetGenImage('assets/done_lvl.png');
  static const AssetGenImage doneLvl1star =
      AssetGenImage('assets/done_lvl_1star.png');
  static const AssetGenImage doneLvl2star =
      AssetGenImage('assets/done_lvl_2star.png');
  static const AssetGenImage fullmap = AssetGenImage('assets/fullmap.jpg');
  static const $AssetsMapTilesGen mapTiles = $AssetsMapTilesGen();
  static const AssetGenImage mockPath = AssetGenImage('assets/mock_path.png');
  static const AssetGenImage undoneLvl = AssetGenImage('assets/undone_lvl.png');

  /// List of all assets
  static List<AssetGenImage> get values =>
      [doneLvl, doneLvl1star, doneLvl2star, fullmap, mockPath, undoneLvl];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
