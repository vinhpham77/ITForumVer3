import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:it_forum/dtos/vote_dto.dart';
import 'package:it_forum/models/bookmarkInfo.dart';
import 'package:it_forum/models/follow.dart';
import 'package:it_forum/models/tag.dart';
import 'package:it_forum/repositories/bookmark_repository.dart';
import 'package:it_forum/repositories/follow_repository.dart';
import 'package:it_forum/repositories/post_repository.dart';
import 'package:it_forum/repositories/tag_repository.dart';
import 'package:it_forum/repositories/vote_repository.dart';
import 'package:it_forum/ui/router.dart';
import 'package:it_forum/ui/views/series_detail/votes_side.dart';
import 'package:it_forum/ui/widgets/comment/comment_view.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../dtos/jwt_payload.dart';
import '../../../dtos/post_user.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../models/vote.dart';
import '../../../repositories/user_repository.dart';
import '../../common/utils/common_utils.dart';
import 'TableOfContents.dart';
import 'menuAnchor.dart';

class PostDetailsPage extends StatefulWidget {
  final int id;

  const PostDetailsPage({super.key, required this.id});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPage();
}

class _PostDetailsPage extends State<PostDetailsPage> {
  bool stateVote = false;
  bool upVote = false;
  bool downVote = false;
  bool typeVote = false;
  bool isCheckBookmark = false;
  bool isBookmark = false;
  bool isHovered = false;
  bool isLoading = true;
  bool isFollow = false;
  bool isLoadingFollow = false;
  bool postsSameAuthorIsNull = false;
  PostUser postUser = PostUser.empty();
  String type = "bài viết";
  String username = JwtPayload.sub ?? '';
  int idVote = 0;
  String updatedAt = '';
  int _currentId = 0;
  int totalPost = 0;
  int totalFollow = 0;
  int score = 0;
  late bool isPrivate;

  IconData? get icon => Icons.add;
  Color textColor = Colors.grey;
  List<Tag> listTag = [];

  List<DateTime> listDateTime = [];
  List<Post> posts = [];
  List<Tag> selectedTags = [];
  late List<String> listTitlePost;
  User user = User.empty();
  User authorPost = User.empty();
  Follow follow = Follow.empty();
  Tag? selectedTag;
  final postRepository = PostRepository();
  final tagRepository = TagRepository();
  final voteRepository = VoteRepository();
  final bookmarkRepository = BookmarkRepository();
  final userRepository = UserRepository();
  final followRepository = FollowRepository();

  @override
  void initState() {
    super.initState();
    initPost(widget.id);
  }

  @override
  void didUpdateWidget(PostDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != _currentId) {
      _currentId = widget.id;
      initPost(_currentId);
    }
  }

  Future<void> initPost(int id) async {
    BookmarkInfo bookmarkInfo = BookmarkInfo(targetId: widget.id, type: true);

    if (mounted) {
      setState(() {
        isLoading = true;
      });
      await _loadPost(id);
      var postsAuthorFuture =
          _loadPostsByTheSameAuthor(authorPost.username, widget.id);
      var userFuture = _loadUser(username);
      // var checkVoteFuture = _loadCheckVote(widget.id, true);

      var bookmarkFuture = _loadBookmark(username, bookmarkInfo);

      var totalPostFuture = _loadTotalPost(authorPost.username);
      var totalFollowerFuture = _loadTotalFollower(authorPost.username);
      var followFuture = _loadFollow(authorPost.username);

      final responses = await Future.wait([
         postsAuthorFuture,
        userFuture,
        // checkVoteFuture,
        bookmarkFuture,
        // totalPostFuture,
        // totalFollowerFuture,
          followFuture

      ]);
      // responses as List <Response<dynamic>>;
      // Response<dynamic> response = responses[0];
      // User user = User.fromJson(userResponse.data);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          // color: Colors.white,
          child: Center(
            child: SizedBox(
              width: 1200,
              child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _postActions(),
                          const SizedBox(width: 10),
                          _postBody(),
                          const SizedBox(width: 20),
                          _sidebar(),
                        ],
                      ),
                      CommentView(
                        postId: widget.id,
                        isSeries: false,
                      )
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }

  Widget _postActions() {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          VoteSection(
              stateVote: stateVote,
              upVote: upVote,
              downVote: downVote,
              score: score,
              onUpVote: _upVote,
              onDownVote: _downVote),
          const SizedBox(height: 10),
          _buildBookmarkSection(isBookmark),
          const SizedBox(height: 10),
          _buildSocialShareSection(widget.id),
        ],
      ),
    );
  }

  Widget _buildBookmarkSection(bool isBookmark) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: IconButton(
          icon: Icon(isBookmark ? Icons.bookmark : Icons.bookmark_border),
          onPressed: () => _toggleBookmark(),
          color: isBookmark ? Colors.blue : null),
    );
  }

  Widget _buildSocialShareSection(int idPost) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
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
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareTwitter(
                  "http://localhost:8000/posts/$idPost",
                  "Đã share lên Twitter")),
        ],
      ),
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

  Widget _buildLoadingIndicator() {
    return Container(
      height: 600,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
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

  bool checkPrivate(String userName, String authorName, bool isPrivate) {
    if (isPrivate && userName == authorName || !isPrivate) {
      return true;
    } else {
      return false;
    }
  }

  Widget _postBody() {
    // _builderTitlePostContent();
    var postPreview = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 8.0,
                children:
                    listTag.map((tag) => buildTagButton(tag.name)).toList(),
              ),
            ),
            MoreHoriz(
                idContent: widget.id,
                type: type,
                authorname: authorPost.username,
                username: username),
          ],
        ),
        Container(
          decoration: const BoxDecoration(
              //   color: Colors.white,
              ),
          child: Markdown(
            data: getMarkdown(),
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              textScaleFactor: 1.4,
              h1: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 32),
              h2: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 22),
              h3: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18),
              h6: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 13),
              p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
              blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
              listBullet: const TextStyle(
                  fontSize: 16), // Custom list item bullet style
            ),
            softLineBreak: true,
            shrinkWrap: true,
          ),
        ),
      ],
    );
    return Expanded(
      child: isLoading
          ? Container(
              height: 600,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                _builderAuthorPostContent(),
                postPreview,
              ],
            ),
    );
  }

  getMarkdown() {
    String titleRaw = postUser.post.title;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    // String tags = selectedTags.map((tag) => '#${tag.name}').join('\t');
    String content = postUser.post.content;
    String tags = "#";
    tags = tags + listTag.join('\t#');
    return '$title \n $content';
  }

  Future<void> _loadPost(int id) async {
    try {
      var postResponse = await postRepository.getOne(id);
      var post = Post.fromJson(postResponse.data);
      var userResponse = await userRepository.get(post.createdBy);
      var user = User.fromJson(userResponse.data);
       postUser = PostUser(post: post, user: user);
      if (mounted) {
        setState(()  {
          postUser = postUser;
          authorPost = postUser.user;
          listTag = postUser.post.tags;
          updatedAt =
              "Cập nhật lần cuối: ${getTimeAgo(postUser.post.updatedAt)}";
          score = postUser.post.score;
          isPrivate = postUser.post.isPrivate;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _loadUser(String username) async {
    if (JwtPayload.sub != null) {
      var futureUser = await userRepository.get(username);
      if (mounted) {
        user = User.fromJson(futureUser.data);
      }
    }
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

  Future<void> _loadTotalPost(String username) async {
    var future = await postRepository.totalPost(username);
    if (future.data is int) {
      if (mounted) {
        setState(() {
          totalPost = future.data;
        });
      }
    }
  }

  Future<void> _loadTotalFollower(String followedId) async {
    var future = await followRepository.totalFollower(followedId);
    if (future.data is int) {
      if (mounted) {
        setState(() {
          totalFollow = future.data;
        });
      }
    } else {
      print("không có dữ liệu");
    }
  }

  void _follow() async {
    if (JwtPayload.sub == null) {
      appRouter.go("/login");
    } else {
      if (isFollow == true) {
        await followRepository.delete(authorPost.username);
        if (mounted) {
          setState(() {
            isFollow = false;
          });
        }
      } else {
        await followRepository.add(authorPost.username);
        if (mounted) {
          setState(() {
            isFollow = true;
          });
        }
      }
      _loadTotalFollower(authorPost.username);
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

  Future<void> _loadBookmark(String username, BookmarkInfo bookmarkInfo) async {
    print("1");
    var future = await bookmarkRepository.checkBookmark(username, bookmarkInfo);
    print("2");
print( future.data);
    if (future.data != null && future.data is bool) {
      bool isBookmarked = future.data;
      if (mounted) {
        isBookmark = isBookmarked;
      }
    } else {
      print(" lỗi bookmark");
      // Xử lý trường hợp dữ liệu trả về từ API không đúng
    }
  }

  Future<void> _loadPostsByTheSameAuthor(String authorName, int postId) async {
    var future = postRepository.getPostsSameAuthor(authorName, postId);
    future.then((response) {
      setState(() {
        List<Map<String, dynamic>> jsonDataList =
            List<Map<String, dynamic>>.from(response.data);
        posts = jsonDataList.map((json) => Post.fromJson(json)).toList();
        if (posts.isEmpty) {
          postsSameAuthorIsNull = true;
        }
        posts = posts.length > 5 ? posts.take(5).toList() : List.from(posts);
        listTitlePost = posts.map((post) => post.title).toList();
        listDateTime = posts.map((post) => post.updatedAt).toList();
      });
    }).catchError((error) {
      // String message = getMessageFromException(error);
      // showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Widget _builderAuthorPostContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildUserDetails(), Text(updatedAt)],
    );
  }

  Widget _buildUserDetails() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              appRouter.go("/profile/${postUser.post.createdBy}/posts");
            },
            child: ClipOval(
              child: _buildPostImage(authorPost.avatarUrl ?? ""),
            ),
          ),
          const SizedBox(width: 10),
          _buildUserProfile(),
          const SizedBox(width: 10),
          if (user.id != authorPost.id) _buildFollowButton(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // width: 200,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    appRouter.go("/profile/${postUser.post.createdBy}/posts");
                  },
                  child: Text(
                    postUser.post.createdBy,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 6),
                Text("@${postUser.post.createdBy}"),
              ]),
        ),
        SizedBox(
          width: 200,
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIconWithText(
                  Icons.verified_user_sharp, totalFollow.toString()),
              const SizedBox(width: 12),
              _buildIconWithText(Icons.pending_actions, totalPost.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconWithText(IconData icon, String text) {
    String messageValue = "";
    switch (icon) {
      case Icons.verified_user_sharp:
        messageValue = 'Người theo dõi';
        break;
      case Icons.pending_actions:
        messageValue = 'Bài viết';
        break;
      default:
        messageValue = 'Default Message';
    }
    return Tooltip(
      message: messageValue,
      child: Row(
        children: [
          Container(
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

  Widget _buildFollowButton() {
    return ElevatedButton(
      onPressed: () => _follow(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isFollow ? Icon(Icons.check) : Icon(Icons.add),
          isFollow ? Text("Đã theo dõi") : Text('Theo dõi'),
        ],
      ),
    );
  }

  Future<bool> checkVote(int target, bool targetType) async {
    Future<bool> isFuture;
    var future = voteRepository.checkVote(target, targetType);
    print(future);
    isFuture = future.then((response) {
      if (response.data == null) {
        return Future<bool>.value(false);
      } else {
        Vote vote = Vote.fromJson(response.data);
        //  idVote = vote.targetId;
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

  void _upVote() async {
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
    } else {
      if (stateVote == false) {
        setState(() {
          stateVote = true;
        });
        hasVoted = await checkVote(widget.id, true);
        if (hasVoted == false) {
          VoteDTO voteDTO = VoteDTO(
            targetId: widget.id,
            username: JwtPayload.sub,
            targetType: true,
            voteType: true,
          );
          await voteRepository.createVote(voteDTO);
          var postScore =
              await postRepository.updateScore(widget.id, score + 1);
          Post post = Post.fromJson(postScore.data);
          setState(() {
            score = post.score;
            upVote = true;
            downVote = false;
          });
        } else {
          if (hasVoted == true && upVote == true ) {
            var postScore =
                await postRepository.updateScore(widget.id, score - 1);
            Post post = Post.fromJson(postScore.data);
            setState(() {
              score = post.score;
              upVote = false;
              downVote = false;
            });
            await voteRepository.deleteVote(widget.id, true);
          } else {
            if (hasVoted == true && downVote == true) {
              var postScore =
                  await postRepository.updateScore(widget.id, score + 2);
              Post post = Post.fromJson(postScore.data);
              setState(() {
                score = post.score;
                upVote = true;
                downVote = false;
              });
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
          targetType: true,
          voteType: false,
        );
        hasVoted = await checkVote(widget.id, true);
        if (hasVoted == false) {
          VoteDTO voteDTO = VoteDTO(
            targetId: widget.id,
            username: JwtPayload.sub,
            targetType: true,
            voteType: false,
          );
          await voteRepository.createVote(voteDTO);
          var postScore =
              await postRepository.updateScore(widget.id, score - 1);

          Post post = Post.fromJson(postScore.data);
          setState(() {
            score = post.score;
            downVote = true;
            upVote = false;
          });
        } else {
          if (hasVoted == true && downVote==true) {
            var postScore =
                await postRepository.updateScore(widget.id, score + 1);
            Post post = Post.fromJson(postScore.data);
            setState(() {
              score = post.score;
              upVote = false;
              downVote = false;
            });
            await voteRepository.deleteVote(widget.id, true);
          } else {
            if (hasVoted == true && upVote == true) {
              var postScore =
                  await postRepository.updateScore(widget.id, score - 2);
              Post post = Post.fromJson(postScore.data);
              setState(() {
                score = post.score;
                downVote = true;
                upVote = false;
              });
            }
          }
        }
        setState(() {
          stateVote = false;
        });
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (JwtPayload.sub != null) {
      if (isBookmark == true) {
        BookmarkInfo bookmarkInfo =
            BookmarkInfo(targetId: widget.id, type: true);
        await bookmarkRepository.unBookmark(JwtPayload.sub!, bookmarkInfo);
        setState(() {
          isBookmark = !isBookmark;
        });
      } else {
        if (isBookmark == false) {
          BookmarkInfo bookmarkInfo =
              BookmarkInfo(targetId: widget.id, type: true);
          await bookmarkRepository.addBookmark(bookmarkInfo);
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

  void _sharePost(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link đã được sao chép')),
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

  Widget _sidebar() {
    Widget? tableOfContentsWidget = _tableOfContents();
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titletableOfContents(),
          if (tableOfContentsWidget != null)
            tableOfContentsWidget
          else
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Text(
                "Không có mục lục",
                style: TextStyle(fontSize: 16),
              ),
            ),
          _relatedArticles(),
        ],
      ),
    );
  }

  List<String> extractHeadingsFromMarkdown(String markdownText) {
    List<String> headings = [];
    List<markdown.Node> nodes = markdown.Document(
      extensionSet: markdown.ExtensionSet.gitHubWeb,
    ).parseLines(markdownText.split('\n'));
    for (var node in nodes) {
      if (node is markdown.Element && node.tag == 'h1') {
        headings.add(node.textContent);
      } else if (node is markdown.Element && node.tag == 'h2') {
        headings.add(node.textContent);
      } else if (node is markdown.Element && node.tag == 'h3') {
        headings.add(node.textContent);
      }
    }
    return headings;
  }

  Widget? _tableOfContents() {
    List<String> headings = extractHeadingsFromMarkdown(postUser.post.content);
    if (headings.isEmpty) {
      return null;
    }
    ScrollController scrollController = ScrollController();
    return TableOfContents(
      headings: headings,
      scrollController: scrollController,
    );
  }

  Widget _relatedArticles() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleRelatedArticles(),
          postsSameAuthorIsNull
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    "Không còn bài viết nào",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : _bodyRelatedArticles(),
        ]);
  }

  Widget _titletableOfContents() {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Mục lục",
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
        )
      ],
    );
  }

// open cac bai viet lien quan

  Widget _bodyRelatedArticles() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var post in posts)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _openRelatedArticle(post.id),
                        child: RichText(
                          text: TextSpan(
                            text: post.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(getTimeAgo(post.updatedAt)),
                  ),
                  // _feedItem(),
                  Container(
                    height: 1,
                    width: 300,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _openRelatedArticle(int postId) {
    appRouter.go('/posts/$postId');
  }

  Widget _feedItem() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Tooltip(
            message: "Lượt xem",
            child: Row(
              children: [
                Icon(
                  Icons.remove_red_eye, // Mã Unicode của biểu tượng con mắt
                  color: Color.fromARGB(255, 212, 211, 211),
                  // Màu của biểu tượng,
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('30'),
              ],
            ),
          ),
          SizedBox(width: 12),
          Tooltip(
            message: "Bình luận",
            child: Row(
              children: [
                Icon(
                  Icons.comment,
                  color: Color.fromARGB(255, 212, 211, 211),
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('18'),
              ],
            ),
          ),
          SizedBox(width: 12),
          Tooltip(
            message: "Đã bookmark",
            child: Row(
              children: [
                Icon(
                  Icons.bookmark, // Mã Unicode của biểu tượng con mắt
                  color: Color.fromARGB(255, 212, 211, 211),
                  // Màu của biểu tượng,
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('12'),
              ],
            ),
          ),
          SizedBox(width: 12),
          Tooltip(
            message: "Điểm",
            child: Row(
              children: [
                Icon(
                  Icons.score, // Mã Unicode của biểu tượng con mắt
                  color: Color.fromARGB(255, 212, 211, 211),
                  // Màu của biểu tượng,
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('9'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(String avatarUrl) {
    if (avatarUrl != null) {
      return Image.network(
        avatarUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Icon(Icons.account_circle_rounded,
              size: 48, color: Colors.black54);
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.account_circle_rounded,
              size: 48, color: Colors.black54);
        },
      );
    } else {
      return const Icon(Icons.account_circle_rounded,
          size: 48, color: Colors.black54);
    }
  }
}

///// close cac bai viet lien quan
Widget _titleRelatedArticles() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      const Text(
        "Các bài viết liên quan",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Container(
          height: 20,
          width: 50,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0, // Độ dày của border
              ),
            ),
          ),
        ),
      )
    ],
  );
}
