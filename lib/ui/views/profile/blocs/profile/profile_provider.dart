import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/ui/views/profile/blocs/profile/profile_bloc.dart';

import '../../../../../repositories/content_repository.dart';
import '../../../../../repositories/follow_repository.dart';
import '../../../../../repositories/tag_repository.dart';
import '../../../../../repositories/user_repository.dart';

class ProfileBlocProvider extends StatelessWidget {
  final Widget child;
  final String username;

  const ProfileBlocProvider(
      {super.key, required this.child, required this.username});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) {
        final bloc = ProfileBloc(
          followRepository: FollowRepository(),
          userRepository: UserRepository(),
          tagRepository: TagRepository(),
          contentRepository: ContentRepository(),
        )..add(LoadProfileEvent(username: username));

        return bloc;
      },
      child: child,
    );
  }
}
