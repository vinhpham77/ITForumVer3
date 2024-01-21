import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:it_forum/dtos/comment_show.dart';
import 'package:it_forum/dtos/jwt_payload.dart';
import 'package:it_forum/models/comment_details.dart';
import 'package:it_forum/repositories/comment_repository.dart';
import 'package:it_forum/ui/router.dart';
import 'package:it_forum/ui/widgets/comment/create_comment_view.dart';

import '../../../dtos/notify_type.dart';
import '../../../models/user.dart';
import '../../common/utils/common_utils.dart';
import '../notification.dart';
import '../user_avatar.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key, required this.postId, required this.isSeries});

  final int postId;
  final bool isSeries;

  @override
  State<CommentView> createState() => _CommentState();
}

class _CommentState extends State<CommentView> {
  final CommentRepository _commentRepository = CommentRepository();
  List<CommentShow> _comments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComment(subId: null);
  }

  @override
  void didUpdateWidget(CommentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    getComment(subId: null);
  }

  void upComment(CommentDetails commentDetails) {
    setState(() {
      _comments.insert(0, CommentShow(commentDetails: commentDetails));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bình luận",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: JwtPayload.sub == null
                    ? const Center(
                        child: Text(
                          "Đăng nhập để bình luận",
                          style: TextStyle(color: Colors.black38),
                        ),
                      )
                    : CreateCommentView(
                        postId: widget.postId,
                        type: widget.isSeries,
                        callback: upComment),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child:
                    listSubCommentView(paddingLeft: 0, commentShows: _comments),
              )
            ],
          ),
        );
      },
    );
  }

  Future getComment({int? subId}) async {
    var future =
        _commentRepository.getSubComment(widget.postId, widget.isSeries, subId);
    future.then((response) {
      _comments = response == null
          ? []
          : response.data
              .map<CommentShow>((e) =>
                  CommentShow(commentDetails: CommentDetails.fromJson(e)))
              .toList();
      setState(() {});
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Widget listSubCommentView(
      {required double paddingLeft, required List<CommentShow> commentShows}) {
    return Container(
      padding: EdgeInsets.only(left: paddingLeft, top: 8),
      child: Column(
          children: commentShows.map((e) {
        return subCommentView(commentShow: e, commentShows: commentShows);
      }).toList()),
    );
  }

  Widget subCommentView(
      {required CommentShow commentShow,
      required List<CommentShow> commentShows}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, width: 1),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerComment(commentShow.commentDetails.createdBy,
              commentShow.commentDetails.updatedAt),
          commentShow.isEdit
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => {
                        _showConfirmCancel(context, commentShow, () {
                          commentShow.isEdit = false;
                        })
                      },
                    ),
                    CreateCommentView(
                      postId: widget.postId,
                      type: widget.isSeries,
                      subId: commentShow.commentDetails.id,
                      callback: (CommentDetails subCom) {
                        setState(() {
                          commentShow.commentDetails = subCom;
                          commentShow.isEdit = false;
                        });
                      },
                      context: commentShow.commentDetails.content,
                    )
                  ],
                )
              : contentComment(content: commentShow.commentDetails.content),
          Container(
            padding: const EdgeInsets.only(left: 24),
            child: commentShow.isEdit
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          if (JwtPayload.sub == null) {
                            appRouter.go('/login');
                            return;
                          }
                          setState(() {
                            if (!commentShow.isReply)
                              commentShow.isReply = true;
                          });
                        },
                        child: const Text(
                          "Trả lời",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      menuComment(
                          username:
                              commentShow.commentDetails.createdBy.username,
                          commentShow: commentShow,
                          commentShows: commentShows),
                    ],
                  ),
          ),
          commentShow.isReply
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => {
                        _showConfirmCancel(context, commentShow, () {
                          commentShow.isReply = false;
                        })
                      },
                    ),
                    CreateCommentView(
                        postId: widget.postId,
                        type: widget.isSeries,
                        subId: commentShow.commentDetails.id,
                        callback: (CommentDetails subCom) {
                          setState(() {
                            commentShow.commentShows
                                .insert(0, CommentShow(commentDetails: subCom));
                            commentShow.isReply = false;
                          });
                        })
                  ],
                )
              : Container(),
          const SizedBox(
            width: 16,
          ),
          commentShow.commentShows.isEmpty
              ? Container()
              : listSubCommentView(
                  paddingLeft: 24, commentShows: commentShow.commentShows),
          Container(
            padding: const EdgeInsets.only(left: 32),
            child: (commentShow.commentDetails.right >
                        commentShow.commentDetails.left + 1 &&
                    !commentShow.isShowChildren)
                ? InkWell(
                    onTap: () {
                      Future<Response<dynamic>> future =
                          _commentRepository.getSubComment(widget.postId,
                              widget.isSeries, commentShow.commentDetails.id);
                      future.then((response) {
                        commentShow.commentShows = response == null
                            ? []
                            : response.data
                                .map<CommentShow>((e) => CommentShow(
                                    commentDetails: CommentDetails.fromJson(e)))
                                .toList();
                        commentShow.isShowChildren = true;
                        setState(() {});
                      }).catchError((error) {
                        String message = getMessageFromException(error);
                        showTopRightSnackBar(
                            context, message, NotifyType.error);
                      });
                    },
                    child: const Text(
                      "Xem thêm",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  )
                : Container(),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 16))
        ],
      ),
    );
  }

  Widget headerComment(User user, DateTime updatedAt) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: InkWell(
            onTap: () {},
            child: ClipOval(
              child: UserAvatar(
                imageUrl: user.avatarUrl,
                size: 32,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    user.displayName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "@${user.username}",
                  style: const TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ],
            ),
            Text(
              getTimeAgo(updatedAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget contentComment({required String content}) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 4, left: 20, right: 20),
      child: Markdown(
        data: content,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          textScaleFactor: 1.4,
          h1: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 32),
          h2: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 28),
          h3: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
          h6: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13),
          p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
          blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
              ),
          // Custom blockquote style
          listBullet:
              const TextStyle(fontSize: 16), // Custom list item bullet style
        ),
        softLineBreak: true,
        shrinkWrap: true,
      ),
    );
  }

  Widget menuComment(
      {required String username,
      required CommentShow commentShow,
      required List<CommentShow> commentShows}) {
    return MenuAnchor(
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return InkWell(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: const Icon(Icons.more_horiz),
          );
        },
        menuChildren: username == JwtPayload.sub
            ? menuSignIn(commentShows, commentShow)
            : [
                MenuItemButton(
                    onPressed: () => {},
                    child: const Row(
                      children: [
                        Icon(Icons.report),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Báo cáo')
                      ],
                    )),
              ]);
  }

  List<Widget> menuSignIn(
      List<CommentShow> commentShows, CommentShow commentShow) {
    return <Widget>[
      MenuItemButton(
          onPressed: () {
            setState(() {
              if (!commentShow.isEdit) commentShow.isEdit = true;
            });
          },
          child: const Row(
            children: [
              Icon(Icons.edit),
              SizedBox(
                width: 20,
              ),
              Text('Sửa')
            ],
          )),
      MenuItemButton(
          onPressed: () {
            _showConfirmationDialog(
                context, commentShows, commentShow.commentDetails.id);
          },
          child: const Row(
            children: [
              Icon(Icons.delete),
              SizedBox(
                width: 20,
              ),
              Text('Xóa')
            ],
          ))
    ];
  }

  _showConfirmationDialog(
      BuildContext context, List<CommentShow> commentShows, int subId) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Xác nhận'),
          content: const Text(
              'Bạn có chắc chắn muốn xóa bình luận này và các câu trả lời của bình luận này?'),
          actions: <Widget>[
            SizedBox(
              height: 40,
              child: FloatingActionButton(
                child: const Text('Hủy'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              height: 40,
              width: 100,
              child: FloatingActionButton(
                child: const Text(
                  'Chấp nhận',
                  softWrap: false,
                ),
                onPressed: () {
                  var future = _commentRepository.deleteSubComment(
                      widget.postId, widget.isSeries, subId);
                  future.then((response) {
                    bool result = response.data;
                    if (!result) return;
                    int index = commentShows
                        .indexWhere((item) => item.commentDetails.id == subId);
                    if (index == -1) return;
                    setState(() {
                      commentShows.removeAt(index);
                    });
                  }).catchError((error) {
                    String message = getMessageFromException(error);
                    showTopRightSnackBar(context, message, NotifyType.error);
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    ); // Thêm '?? false' ở đây
  }

  _showConfirmCancel(
      BuildContext context, CommentShow commentShow, Function() callback) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn hủy?'),
          actions: <Widget>[
            SizedBox(
              height: 40,
              child: FloatingActionButton(
                child: const Text('Hủy'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              height: 40,
              width: 100,
              child: FloatingActionButton(
                child: const Text('Chấp nhận', softWrap: false),
                onPressed: () {
                  setState(() {
                    callback();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
