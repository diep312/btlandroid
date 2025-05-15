import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/data/utils/string_utils.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:chit_chat/src/app/widgets/post_options_bottom_sheet.dart';


class KPost extends StatelessWidget {
  final Post post;
  final Function(Post post) changePostLike;
  final Function(Post post) toggleFavoriteState;
  final Function(BuildContext context, Post post) navigateToComments;
  final Function(Post post) onEdit;
  final Function(Post post) onDelete;

  final int index;
  final bool isSeen = false;
  final bool showAnimation;

  KPost({
    required this.index,
    required this.post,
    required this.changePostLike,
    required this.toggleFavoriteState,
    required this.navigateToComments,
    required this.onEdit,
    required this.onDelete,
    required this.showAnimation,
  });

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PostOptionsBottomSheet(
        post: post,
        isCurrentUserPost:
            post.publisherId == FirebaseAuth.instance.currentUser!.uid,
        onEdit: onEdit,
        onDelete: onDelete,
        onToggleFavorite: toggleFavoriteState,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isCurrentUserPost =
        post.publisherId == FirebaseAuth.instance.currentUser!.uid;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Color(0xFFF5F7FE),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: post.publisherLogoUrl.isEmpty
                            ? Image.asset(
                                isCurrentUserPost
                                    ? 'assets/icons/png/current_user.png'
                                    : 'assets/icons/png/default_user.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: post.publisherLogoUrl,
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                placeholder: (a, b) {
                                  return ShimmheredPublisher();
                                },
                              ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.publisher,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '@' + post.publisher,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      StringUtils.getPublishDateShort(post.publishedOn),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width - 34,
                    height: MediaQuery.of(context).size.width - 34,
                    placeholder: (a, b) {
                      return ImageShimmer();
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => changePostLike(post),
                      child: Row(
                        children: [
                          Icon(
                            post.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 6),
                          Text(post.numberOfLikes.toString()),
                        ],
                      ),
                    ),
                    SizedBox(width: 18),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => navigateToComments(context, post),
                      child: Row(
                        children: [
                          Icon(Icons.mode_comment_outlined,
                              color: Colors.black54),
                          SizedBox(width: 6),
                          Text(post.numberOfComments.toString()),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _showOptionsBottomSheet(context),

                      child: Icon(Icons.more_horiz, color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: post.publisher + ' ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: post.description,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShimmeredPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: kWhite,
      child: Shimmer(
        child: Container(
          width: size.width,
          padding: EdgeInsets.only(bottom: 5, left: 17, right: 17),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: kGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kBlack.withOpacity(0.04)),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 15,
                          margin: EdgeInsets.only(left: 3),
                          decoration: BoxDecoration(
                            color: kGrey,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kBlack.withOpacity(0.04)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 30,
                      height: 15,
                      decoration: BoxDecoration(
                        color: kGrey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kBlack.withOpacity(0.04)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: size.width - 34,
                height: size.width - 34,
                decoration: BoxDecoration(
                  color: kGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kBlack.withOpacity(0.04)),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 12,
                    decoration: BoxDecoration(
                      color: kGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kBlack.withOpacity(0.04)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 12,
                    decoration: BoxDecoration(
                      color: kGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kBlack.withOpacity(0.04)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        gradient: kLinearGradient,
      ),
    );
  }
}

class ImageShimmer extends StatelessWidget {
  const ImageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Shimmer(
        child: Container(
          width: size.width - 34,
          height: size.width - 34,
          decoration: BoxDecoration(
            color: kGrey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kBlack.withOpacity(0.04)),
          ),
        ),
        gradient: kLinearGradient);
  }
}

class ShimmheredPublisher extends StatelessWidget {
  const ShimmheredPublisher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Shimmer(
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: kGrey,
            shape: BoxShape.circle,
            border: Border.all(color: kBlack.withOpacity(0.04)),
          ),
        ),
        gradient: kLinearGradient);
  }
}
