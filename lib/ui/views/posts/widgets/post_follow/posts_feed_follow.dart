// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../dtos/notify_type.dart';
// import '../../../../widgets/notification.dart';
// import '../../../../widgets/pagination.dart';
// import '../../../profile/widgets/posts_tab/post_tab_item.dart';
//
//
// class PostsFeedFollow extends StatefulWidget {
//   final int page;
//   final int limit;
//   final bool isQuestion;
//   final Map<String, String> params;
//
//   const PostsFeedFollow(
//       {super.key,
//         required this.page,
//         required this.limit,
//         required this.isQuestion,
//         required this.params
//       });
//
//   @override
//   State<PostsFeedFollow> createState() => _PostsFeedFollowState();
// }
//
// class _PostsFeedFollowState extends State<PostsFeedFollow> {
//   late PostFollowBloc _bloc;
//   late Map<String, String> indexing = widget.isQuestion ? {'name' : 'hỏi đáp', 'path': '/viewquestionfollow'} :
//   {'name' : 'bài viết', 'path': '/viewpostsfollow'};
//
//   @override
//   void initState() {
//     super.initState();
//     _bloc = PostFollowBloc()
//       ..add(LoadPostsEvent(
//           limit: widget.limit,
//           page: widget.page,
//           tag: widget.isQuestion ? "HoiDap" : ""
//       ));
//   }
//
//   @override
//   void didUpdateWidget(PostsFeedFollow oldWidget) {
//
//     super.didUpdateWidget(oldWidget);
//     _bloc..add(LoadPostsEvent(
//         limit: widget.limit,
//         page: widget.page,
//         tag: widget.isQuestion ? "HoiDap" : ""
//     ));
//
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _bloc.close();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => _bloc,
//       child: BlocListener<PostFollowBloc, PostFollowState>(
//         listener: (context, state) {
//           if (state is PostFollowTabErrorState) {
//             showTopRightSnackBar(context, state.message, NotifyType.error);
//           }
//         },
//         child: BlocBuilder<PostFollowBloc, PostFollowState>(
//           builder: (context, state) {
//             if (state is PostFollowEmptyState) {
//               return Container(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Không có ${indexing['name']} nào!",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               );
//             } else if (state is PostFollowLoadedState) {
//               return Column(
//                 children: [
//                   Column(
//                       children: state.posts.resultList
//                           .map((e) {
//                         return PostTabItem(
//                             post: e);
//                       }).toList()),
//                   Pagination(
//                     path: indexing['path'] ?? '',
//                     totalItem: state.posts.count,
//                     params: widget.params,
//                     selectedPage: widget.page,
//                   )
//                 ],
//               );
//             } else if (state is PostFollowLoadErrorState) {
//               return Container(
//                 alignment: Alignment.center,
//                 child:
//                 Text(state.message, style: const TextStyle(fontSize: 16)),
//               );
//             }
//
//             return Container(
//                 alignment: Alignment.center,
//                 child: const CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }
