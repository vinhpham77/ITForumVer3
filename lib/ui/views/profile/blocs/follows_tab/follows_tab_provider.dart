import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/user_repository.dart';
import 'follows_tab_bloc.dart';

class FollowsTabBlocProvider extends StatelessWidget {
  final Widget child;
  final String username;
  final int page;
  final int size;
  final bool isFollowed;

  const FollowsTabBlocProvider(
      {super.key,
      required this.child,
      required this.isFollowed,
      required this.username,
      required this.page,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowsTabBloc>(
        create: (context) {
          final bloc = FollowsTabBloc(userRepository: UserRepository())
            ..add(LoadFollowsEvent(
              username: username,
              page: page,
              size: size,
              isFollowed: isFollowed,
            ));

          return bloc;
        },
        child: child);
  }
}
