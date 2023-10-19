import 'package:converse/common/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    GoRouter.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 120;
    double iconSize = 60;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appCard(
            context: context,
            onTap: () => navigateToType(context, 'Image'),
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: SvgPicture.asset(
              "assets/images/svgs/home/image.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).canvasColor,
                BlendMode.srcIn,
              ),
              height: iconSize,
            ),
          ),
          appCard(
            context: context,
            onTap: () => navigateToType(context, 'Text'),
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: SvgPicture.asset(
              "assets/images/svgs/home/text.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).canvasColor,
                BlendMode.srcIn,
              ),
              height: iconSize,
            ),
          ),
          appCard(
            context: context,
            onTap: () => navigateToType(context, 'Link'),
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: SvgPicture.asset(
              "assets/images/svgs/home/link.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).canvasColor,
                BlendMode.srcIn,
              ),
              height: iconSize,
            ),
          ),
        ],
      ),
    );
  }
}
