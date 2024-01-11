
import 'package:it_forum/blocs/seriesDetail_bloc.dart';
import 'package:it_forum/models/bookmarkInfo.dart';
import 'package:it_forum/models/follow.dart';
import 'package:it_forum/models/series.dart';
import 'package:it_forum/models/sp.dart';
import 'package:it_forum/models/user.dart';
import 'package:it_forum/repositories/bookmark_repository.dart';
import 'package:it_forum/repositories/follow_repository.dart';
import 'package:it_forum/repositories/series_repository.dart';
import 'package:it_forum/repositories/user_repository.dart';
import 'package:it_forum/ui/common/utils/date_time.dart';
import 'package:it_forum/ui/views/profile/widgets/posts_tab/post_tab_item.dart';
import 'package:it_forum/ui/views/series_detail/seriesContent.dart';
import 'package:it_forum/ui/views/series_detail/votes_side.dart';
import 'package:it_forum/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../dtos/jwt_payload.dart';
import '../../../dtos/vote_dto.dart';
import '../../../models/post.dart';
import '../../../models/vote.dart';
import '../../../repositories/post_repository.dart';
import '../../../repositories/sp_repository.dart';
import '../../../repositories/vote_repository.dart';
import '../../router.dart';
import '../../widgets/comment/comment_view.dart';
import '../details_post/menuAnchor.dart';

class SeriesDetail extends StatefulWidget {
  final int id;

  const SeriesDetail({super.key, required this.id});

  @override
  State<SeriesDetail> createState() => _SeriesDetailState();
}

class _SeriesDetailState extends State<SeriesDetail> {
  final postRepository = PostRepository();
  final seriesRepository = SeriesRepository();
  final voteRepository = VoteRepository();
  final spRepository = SpRepository();
  final userRepository = UserRepository();
  final followRepository = FollowRepository();
  final bookmarkRepository = BookmarkRepository();
  late SeriesDetailBloc seriesDetailBloc;
  late List<String> listTagsPost;
  late List<String> listTagsSeries;
  late Follow follow;

  late List<Post> listPostDetail = [];
  bool stateVote = false;
  bool upVote = false;
  bool downVote = false;
  bool typeVote = false;
  bool isHoveredTitle = false;
  bool isClickedTitle = false;
  bool isHoveredUserLink = false;
  bool isFollow = false;
  bool isBookmark = false;
  bool isLoading = true;
  bool isPrivate = true;
  int idVote = 0;
  String type = "series";
  String username = JwtPayload.sub ?? '';
  int _currentId = 0;
  int totalSeries = 0;
  int totalFollow = 0;
  int score = 0;
  User user = User.empty();
  User authorSeries = User.empty();
  List<String> listTag = [];
  late DateTime updateAt= DateTime.now();
  @override
  void initState() {
    super.initState();
    _initSeries(widget.id);
  }

  @override
  void didUpdateWidget(SeriesDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != _currentId) {
      _currentId = widget.id;
      _initSeries(_currentId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<void> _initSeries(int id) async {
    setState(() {
      isLoading = true;
    });
    BookmarkInfo bookmarkInfo = BookmarkInfo(targetId: widget.id, type: false);
    await _loadCheckVote(widget.id, false);
    await _loadScoreSeries(widget.id);
    await _loadListPost(widget.id);
    await _loadUser(username);
    await _loadFollow(authorSeries.username);
    await _loadBookmark(username, bookmarkInfo);
    await _loadTotalSeries(authorSeries.username);
    await _loadTotalFollower(authorSeries.username);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    seriesDetailBloc = SeriesDetailBloc(context: context);
    seriesDetailBloc.getOneSP(widget.id);

    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return SizedBox(
          width: constraints.maxWidth,
          child: Center(
            child: SizedBox(
                width: 1200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VoteSection(
                            stateVote: stateVote,
                            upVote: upVote,
                            downVote: downVote,
                            score: score,
                            onUpVote: _upVote,
                            onDownVote: _downVote),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                Text( "Cập nhật lần cuối: ${getTimeAgo(updateAt)}"),
                                const SizedBox(width: 10),
                                MoreHoriz(
                                    type: type,
                                    idContent: widget.id,
                                    authorname: authorSeries.username,
                                    username: username),
                              ],),

                              StreamBuilder<Series>(
                                stream: seriesDetailBloc.spStream,
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SeriesContentWidget(
                                        series: snapshot.data!,postList: listPostDetail);
                                  } else if (snapshot.hasError) {
                                    return Text('Lỗi: ${snapshot.error}');
                                  } else {
                                    return _buildLoadingIndicator();
                                  }
                                },
                              ),
                              _sectionTitleLine(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: listPostDetail.map((e) {
                                    return PostTabItem(post: e);
                                  }).toList()),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        stickySideBar(),

                      ],
                    ),
                    CommentView(
                      postId: widget.id,
                      isSeries: true,
                    )
                  ],
                )),
          ));
    });
  }

  Widget _sectionTitleLine() {
    return Row(
      children: [
        const Text(
          "Nội dung",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0, // Độ dày của border
                ),
              ),
            ),
          ),
        ),
        // Row(
        //   children: [
        //     IconButton(onPressed: () => {}, icon: const Icon(Icons.add)),
        //     const Text("Add my post to this series")
        //   ],
        // )
      ],
    );
  }

  bool checkPrivate(
      int postId, String userName, String authorName, bool isPrivate) {
    if (isPrivate && userName == authorName || !isPrivate) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 600,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Future<bool> checkVote(int target, bool targetType) async {
    Future<bool> isFuture;
    var future = voteRepository.checkVote(target, targetType);
    isFuture = future.then((response) {
      if (response.data == null) {
        return Future<bool>.value(false);
      } else {
        Vote vote = Vote.fromJson(response.data);
        // idVote = vote.id;
        typeVote = vote.voteType;
        return Future<bool>.value(true);
      }
    }).catchError((error) {
      // String message = getMessageFromException(error);
      // showTopRightSnackBar(context, message, NotifyType.error);
      return Future<bool>.value(false);
    });
    return isFuture;
  }

  Future<void> _loadCheckVote(int targetId, bool targetType) async {
    var futureVote = await voteRepository.checkVote(targetId, targetType);
    if (futureVote.data is Map<String, dynamic>) {
      Vote vote = Vote.fromJson(futureVote.data);
      if (mounted) {
        setState(() {
          upVote = vote.voteType;
          downVote = !vote.voteType;
        });
      }
    } else {
      if (futureVote.statusCode == 404) {
        if (mounted) {
          setState(() {
            upVote = false;
            downVote = false;
          });
        }
      }
    }
  }

  Future<void> _loadTotalSeries(String username) async {
    var future = await seriesRepository.totalSeries(username);
    if (future.data is int) {
      if (mounted) {
        setState(() {
          totalSeries = future.data;
        });
      }
    }
  }

  Future<void> _loadTotalFollower(String followed) async {
    var future = await followRepository.totalFollower(followed);
    if (future.data is int) {
      if (mounted) {
        setState(() {
          totalFollow = future.data;
        });
      }
    }
  }

  Future<void> _loadScoreSeries(int postId) async {
    var futureSp = await seriesRepository.getOne(postId);

    Series series = Series.fromJson(futureSp.data);
    updateAt=series.updatedAt;
    if (mounted) {
      setState(() {
        authorSeries = series.createdBy!;
        score = series.score;
        isPrivate = series.isPrivate;
      });
    }
  }

  Widget stickySideBar() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    appRouter.go("/profile/${authorSeries.username}/posts");
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:
                        UserAvatar(imageUrl: authorSeries.avatarUrl, size: 48),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        setState(() {
                          isHoveredUserLink = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isHoveredUserLink = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          appRouter
                              .go("/profile/${authorSeries.username}/posts");
                        },
                        child: Text(
                          authorSeries.displayName,
                          style: TextStyle(
                            color: isHoveredUserLink
                                ? Colors.lightBlueAccent
                                : Colors.indigo,
                            decoration: isHoveredUserLink
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("@${authorSeries.username}"),
                    const SizedBox(height: 8),
                    if (authorSeries.id != user.id)
                      ElevatedButton(
                        onPressed: () => _follow(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isFollow
                                ? const Icon(Icons.check)
                                : const Icon(Icons.add),
                            isFollow
                                ? const Text("Đã theo dõi")
                                : const Text('Theo dõi'),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIconWithText(
                    Icons.verified_user_sharp, totalFollow.toString()),
                const SizedBox(width: 12),
                _buildIconWithText(
                    Icons.pending_actions, totalSeries.toString()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed:
                    authorSeries.id != user.id ? () => _toggleBookmark() : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isBookmark
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_add_outlined),
                    isBookmark
                        ? const Text('HỦY BOOKMARK SERIES')
                        : const Text('BOOKMARK SERIES NÀY'),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 20,
          width: 200,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0, // Độ dày của border
              ),
            ),
          ),
        ),
        _buildSocialShareSection(widget.id),

      ],
    );
  }

  Widget _buildSocialShareSection(int idPost) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.facebook),
            onPressed: () =>
                _shareFacebook('http://localhost:8000/posts/$idPost'),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () => _sharePost('http://localhost:8000/posts/$idPost'),
          ),
          const SizedBox(width: 16),
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareTwitter(
                  "http://localhost:8000/posts/$idPost",
                  "Đã share lên Twitter")),
        ],
      ),
    );
  }

  void _shareFacebook(String url) async {
    url =
        'https://www.youtube.com/watch?v=GbVfBSZE1Zc&t=977s&ab_channel=ACDAcademyChannel';
    final fbUrl = 'https://www.facebook.com/sharer/sharer.php?u=$url';

    if (await canLaunchUrlString(fbUrl)) {
      await launchUrlString(fbUrl);
    } else {
      throw 'Could not launch $fbUrl';
    }
  }

  void _sharePost(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link đã được sao chép')),
    );
  }

  void _shareTwitter(String url, String text) async {
    final twitterUrl = 'https://twitter.com/intent/tweet?text=$text&url=$url';
    if (await canLaunchUrlString(twitterUrl)) {
      await launchUrlString(twitterUrl);
    } else {
      throw 'Could not launch $twitterUrl';
    }
  }

  Future<void> _loadListPost(int seriesId) async {
    var futureSeries = await spRepository.getOne(seriesId);
    for (var element in futureSeries.data) {
      listPostDetail.add(Post.fromJson(element));
    }
    // listPostDetail = formJson(futureSeries.data);
    Map<String, int> uniqueTagCount = countUniqueTags(listTag);
    List<String> getTop5Tags = this.getTop5Tags(uniqueTagCount);
    listTag = getTop5Tags;
  }

  List<Post> formJson(Map<String, dynamic> json) {
    return json['resultList'] == null
        ? []
        : json['resultList']
            .map<Post>((e) => Post.fromJson(e as Map<String, dynamic>))
            .toList();
  }

  List<String> getTop5Tags(Map<String, int> tagCount) {
    var sortedEntries = tagCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var top5Entries = sortedEntries.take(5);
    List<String> top5Tags = top5Entries.map((entry) => entry.key).toList();

    return top5Tags;
  }

  Map<String, int> countUniqueTags(List<String> tags) {
    Map<String, int> tagCount = {};

    for (String tag in tags) {
      if (tagCount.containsKey(tag)) {
        tagCount[tag] = (tagCount[tag]! + 1);
      } else {
        tagCount[tag] = 1;
      }
    }

    return tagCount;
  }

  Widget _buildIconWithText(IconData icon, String text) {
    String messageValue = "";
    switch (icon) {
      case Icons.verified_user_sharp:
        messageValue = 'Người theo dõi';
        break;
      case Icons.pending_actions:
        messageValue = 'Series';
        break;
      default:
        messageValue = 'Default Message';
    }
    return Tooltip(
      message: messageValue,
      child: Row(
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: Center(child: Icon(icon)),
          ),
          const SizedBox(width: 2),
          Center(child: Text(text)),
        ],
      ),
    );
  }

  Future<void> _loadUser(String username) async {
    if (JwtPayload.sub != null) {
      var futureUser = await userRepository.getUser(username);
      user = User.fromJson(futureUser.data);
    }
  }

  Future<void> _loadBookmark(String username, BookmarkInfo bookmarkInfo) async {
    var future = await bookmarkRepository.checkBookmark(username, bookmarkInfo);
    if (future.data == true) {
      if (mounted) {
        setState(() {
          isBookmark = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isBookmark = false;
        });
      }
    }
  }

  Future<void> _loadFollow(String followed) async {
    if (JwtPayload.sub == null) {
      return;
    }
    var future = await followRepository.checkfollow(followed);
    if (future.data) {
      if (mounted) {
        setState(() {
          isFollow = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isFollow = false;
        });
      }
    }
  }

  void _follow() async {
    if (JwtPayload.sub == null) {
      appRouter.go("/login");
    } else {
      if (isFollow == true) {
        await followRepository.delete(authorSeries.username);
        if (mounted) {
          setState(() {
            isFollow = false;
          });
        }
      } else {
        await followRepository.add(authorSeries.username);
        if (mounted) {
          setState(() {
            isFollow = true;
          });
        }
      }
      _loadTotalFollower(authorSeries.username);
    }
  }

  Widget buildTagButton(String tag) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  Future<void> _toggleBookmark() async {
    if (JwtPayload.sub != null) {
      if (isBookmark == true) {
        BookmarkInfo bookmarkInfo =
            BookmarkInfo(targetId: widget.id, type: false);
        await bookmarkRepository.unBookmark(JwtPayload.sub!, bookmarkInfo);
        setState(() {
          isBookmark = !isBookmark;
        });
      } else {
        if (isBookmark == false) {
          BookmarkInfo bookmarkInfo =
              BookmarkInfo(targetId: widget.id, type: false);
          await bookmarkRepository.addBookmark(JwtPayload.sub!, bookmarkInfo);
          setState(() {
            isBookmark = !isBookmark;
          });
        }
      }
    } else {
      appRouter.go('/login');
      // String message = "Bạn chưa đăng nhập";
      //  showTopRightSnackBar(context, message, NotifyType.error);
    }
  }

  void _upVote() async {
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
      //GoRouter.of(context).go('/login');
    } else {
      if (stateVote == false) {
        setState(() {
          stateVote = true;
        });
        VoteDTO voteDTO = VoteDTO(
          targetId: widget.id,
          username: JwtPayload.sub,
          targetType: false,
          voteType: true,
        );
        hasVoted = await checkVote(widget.id, false);
        if (hasVoted == false) {
          VoteDTO voteDTO = VoteDTO(
            targetId: widget.id,
            username: JwtPayload.sub,
            targetType: false,
            voteType: true,
          );
          await voteRepository.createVote(voteDTO);
          var seriesScore =
              await seriesRepository.updateScore(widget.id, score + 1);
          Series series = Series.fromJson(seriesScore.data);
          setState(() {
            score = series.score;
            upVote = true;
            downVote = false;
          });
        } else {
          if (hasVoted == true && typeVote == true) {
            var seriesScore =
                await seriesRepository.updateScore(widget.id, score - 1);
            Series series = Series.fromJson(seriesScore.data);
            setState(() {
              score = series.score;
              upVote = false;
              downVote = false;
            });
            await voteRepository.deleteVote(widget.id, false);
          } else {
            if (hasVoted == true && typeVote == false) {
              var seriesScore =
                  await seriesRepository.updateScore(widget.id, score + 1);
              Series series = Series.fromJson(seriesScore.data);
              setState(() {
                score = series.score;
                upVote = false;
                downVote = false;
              });
              await voteRepository.deleteVote(widget.id, false);
            }
          }
        }
        setState(() {
          stateVote = false;
        });
      }
    }
  }

  void _downVote() async {
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
      GoRouter.of(context).go('/login');
    } else {
      if (stateVote == false) {
        setState(() {
          stateVote == true;
        });
        VoteDTO voteDTO = VoteDTO(
          targetId: widget.id,
          username: JwtPayload.sub,
          targetType: false,
          voteType: false,
        );
        hasVoted = await checkVote(widget.id, false);
        if (hasVoted == false) {
          VoteDTO voteDTO = VoteDTO(
            targetId: widget.id,
            username: JwtPayload.sub,
            targetType: false,
            voteType: false,
          );
          await voteRepository.createVote(voteDTO);
          var seriesScore =
              await seriesRepository.updateScore(widget.id, score - 1);

          Series series = Series.fromJson(seriesScore.data);
          setState(() {
            score = series.score;
            downVote = true;
            upVote = false;
          });
        } else {
          if (hasVoted == true && typeVote == false) {
            var seriesScore =
                await seriesRepository.updateScore(widget.id, score + 1);
            Series series = Series.fromJson(seriesScore.data);
            setState(() {
              score = series.score;
              upVote = false;
              downVote = false;
            });
            await voteRepository.deleteVote(widget.id, false);
          } else {
            if (hasVoted == true && typeVote == true) {
              var seriesScore =
                  await seriesRepository.updateScore(widget.id, score - 1);
              Series series = Series.fromJson(seriesScore.data);
              setState(() {
                score = series.score;
                downVote = false;
                upVote = false;
              });

              await voteRepository.deleteVote(widget.id, false);
            }
          }
        }
        setState(() {
          stateVote = false;
        });
      }
    }
  }
}
