import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it_forum/dtos/jwt_payload.dart';
import 'package:it_forum/ui/views/posts/posts_view.dart';
import 'package:it_forum/ui/views/posts/widgets/bookmark/bookmark_post.dart';
import 'package:it_forum/ui/views/posts/widgets/follow/follow_post.dart';
import 'package:it_forum/ui/views/posts/widgets/left_menu.dart';
import 'package:it_forum/ui/views/posts/widgets/post/posts_feed.dart';
import 'package:it_forum/ui/views/posts/widgets/right_page/right.dart';

import '../../common/app_constants.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({super.key, this.indexSelected = 0, required this.params});
  final Map<String, String> params;
  final int indexSelected;
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  late List<NavigationPost> listSelectBtn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(JwtPayload.sub == null) {
      listSelectBtn = navi;
    } else {
      listSelectBtn = naviSignin;
    }
    listSelectBtn[widget.indexSelected].isSelected = true;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: maxContent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: LeftMenu(listSelectBtn: listSelectBtn),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: listSelectBtn[widget.indexSelected].widget,
                    ),
                  ),
                  const SizedBox(
                    width: 280,
                    child: Right(page: 1, limit: 5, isQuestion: false,),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<NavigationPost> get naviSignin => [
    NavigationPost(index: 0, text: "Mới nhất", path: "/viewquestion",
      widget: PostsFeed(page: getPage(widget.params['page'] ?? "1"), limit: 10, isQuestion: true, params: widget.params,)),
    NavigationPost(index: 1, text: "Đang theo dõi", path: "/viewquestionfollow",
      widget: FollowPost(page: getPage(widget.params['page'] ?? "1"), limit: 10, isQuestion: true, params: widget.params,)),
    NavigationPost(index: 2, text: "Đã Bookmark", path: "/viewquestionbookmark}",
      widget: BookmarkPost(username: JwtPayload.sub!, page: getPage(widget.params['page'] ?? "1"), limit: 10, isQuestion: true, params: widget.params,)),
  ];

  List<NavigationPost> get navi => [
    NavigationPost(index: 0, text: "Mới nhất", path: "/viewquestion",
        widget: PostsFeed(page: getPage(widget.params['page'] ?? "1"), limit: 10, isQuestion: true, params: widget.params,)),
  ];
}