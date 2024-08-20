import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';

class SummaryCardClipper extends StatelessWidget {
  final ColorPair colorPair;
  final CustomClipper<Path> clipper;
  final String description;

  const SummaryCardClipper({
    super.key,
    required this.clipper,
    required this.colorPair,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipPath(
          clipper: clipper,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            height: MediaQuery.of(context).size.width - 100,
            child: RepaintBoundary(
              child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ClipOval(
                        child: ColoredBox(color: colorPair.accent),
                      ),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 20,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          description,
          style: context.textTheme.displayMedium!
              .copyWith(color: colorPair.accent),
        ),
      ],
    );
  }
}
