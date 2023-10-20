import 'package:any_link_preview/any_link_preview.dart';
import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/app_shimmer.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/image_widgets.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/pages/conclave/controller/conclave_controller.dart';
import 'package:converse/pages/post/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/models/post_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(BuildContext context, WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToConclaveScreen(BuildContext context) {
    GoRouter.of(context).push('/c/${post.conclaveName}');
  }

  void navigateToUserProfileScreen(BuildContext context) {
    GoRouter.of(context).push('/u/${post.uid}');
  }

  void navigateToPostCommentScreen(BuildContext context) {
    GoRouter.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'Image';
    final isTypeText = post.type == 'Text';
    final isTypeLink = post.type == 'Link';
    final user = ref.watch(userProvider)!;
    final check = post.uid == user.uid;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .drawerTheme
                .backgroundColor
                ?.withOpacity(0.35),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => navigateToConclaveScreen(context),
                                child: circleAvatar(
                                  backgroundImage:
                                      NetworkImage(post.conclaveDisplayPic),
                                  radius: 16,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: check ? 0 : 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text16Bold(
                                        context: context,
                                        text: "c/${post.conclaveName}",
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            navigateToUserProfileScreen(
                                                context),
                                        child: text14Medium(
                                          context: context,
                                          text: "u/${post.username}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (check)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: iconButton(
                                      onPressed: () => deletePost(context, ref),
                                      icon: SvgPicture.asset(
                                        "assets/images/svgs/home/delete.svg",
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8)
                                .copyWith(right: 10),
                            child: text20Bold(
                              context: context,
                              text: post.title,
                            ),
                          ),
                          if (isTypeImage)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8)
                                  .copyWith(right: 16),
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress,
                                  ) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return shimmer(
                                        context: context,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        width: double.infinity,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8)
                                  .copyWith(right: 16),
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 16),
                              alignment: Alignment.bottomLeft,
                              child: text16SemiBold(
                                context: context,
                                text: post.description!,
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  iconButton(
                                    onPressed: () => upvotePost(ref),
                                    icon: post.upVotes.contains(user.uid)
                                        ? SvgPicture.asset(
                                            "assets/images/svgs/home/upvote_filled.svg",
                                            colorFilter: ColorFilter.mode(
                                              Theme.of(context).hintColor,
                                              BlendMode.srcIn,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            "assets/images/svgs/home/upvote.svg",
                                            colorFilter: ColorFilter.mode(
                                              Theme.of(context).hintColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                  ),
                                  text17Medium(
                                    context: context,
                                    text:
                                        '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                                  ),
                                  iconButton(
                                    onPressed: () => downVotePost(ref),
                                    icon: post.downVotes.contains(user.uid)
                                        ? SvgPicture.asset(
                                            "assets/images/svgs/home/downvote_filled.svg",
                                            colorFilter: ColorFilter.mode(
                                              Theme.of(context).hintColor,
                                              BlendMode.srcIn,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            "assets/images/svgs/home/downvote.svg",
                                            colorFilter: ColorFilter.mode(
                                              Theme.of(context).hintColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  iconButton(
                                    onPressed: () =>
                                        navigateToPostCommentScreen(context),
                                    icon: SvgPicture.asset(
                                      "assets/images/svgs/home/comment.svg",
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).hintColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  text17Medium(
                                    context: context,
                                    text:
                                        '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ref
                                  .watch(getConclaveByNameProvider(
                                      post.conclaveName))
                                  .when(
                                    data: (data) {
                                      if (data.moderators.contains(user.uid)) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: iconButton(
                                            onPressed: () =>
                                                deletePost(context, ref),
                                            icon: SvgPicture.asset(
                                              "assets/images/svgs/home/mod_tools.svg",
                                              colorFilter: ColorFilter.mode(
                                                Theme.of(context).hintColor,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    error: (error, stackTrace) => ErrorText(
                                      error: error.toString(),
                                    ),
                                    loading: () => const Loader(),
                                  ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
