import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/ui/views/profile/blocs/personal_tab/personal_tab_bloc.dart';

import '../../../../../repositories/image_repository.dart';
import '../../../../../repositories/user_repository.dart';

class PersonalTabProvider extends StatelessWidget {
  final Widget child;
  final String username;

  const PersonalTabProvider(
      {super.key, required this.child, required this.username});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalTabBloc>(
      create: (context) {
        final bloc = PersonalTabBloc(
            userRepository: UserRepository(),
            imageRepository: ImageRepository())
          ..add(LoadUserEvent(username: username));

        return bloc;
      },
      child: child,
    );
  }
}
