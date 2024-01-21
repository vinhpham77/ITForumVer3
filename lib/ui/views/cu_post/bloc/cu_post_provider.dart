import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/repositories/comment_repository.dart';
import 'package:it_forum/repositories/post_repository.dart';
import 'package:it_forum/repositories/tag_repository.dart';

import 'cu_post_bloc.dart';

class CuPostBlocProvider extends StatelessWidget {
  final Widget child;
  final int? id;
  final bool isQuestion;

  const CuPostBlocProvider(
      {super.key, required this.child, this.id, required this.isQuestion});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CuPostBloc>(
      create: (context) {
        final bloc = CuPostBloc(
            postRepository: PostRepository(), tagRepository: TagRepository(), commentRepository: CommentRepository());
        if (id == null) {
          bloc.add(InitEmptyPostEvent(isQuestion: isQuestion));
        } else {
          bloc.add(LoadPostEvent(id: id!, isQuestion: isQuestion));
        }

        return bloc;
      },
      child: child,
    );
  }
}
