import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/repositories/auth_repository.dart';

import '../../../../repositories/comment_repository.dart';
import '../../../../repositories/post_repository.dart';
import '../../../../repositories/series_repository.dart';
import 'cu_series_bloc.dart';

class CuSeriesBlocProvider extends StatelessWidget {
  final Widget child;
  final int? id;

  const CuSeriesBlocProvider({super.key, required this.child, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final bloc = CuSeriesBloc(
            authRepository: AuthRepository(),
            seriesRepository: SeriesRepository(),
            postRepository: PostRepository(),
            commentRepository: CommentRepository());
        if (id != null) {
          bloc.add(LoadSeriesEvent(id: id!));
        } else {
          bloc.add(InitEmptySeriesEvent());
        }
        return bloc;
      },
      child: child,
    );
  }
}
