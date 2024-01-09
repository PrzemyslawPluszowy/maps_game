import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_map/ui/cubit/map_cubit.dart';
import 'package:game_map/ui/widgets/map_generate.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  final horizontalScrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    context.read<MapCubit>().loadImage();
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
