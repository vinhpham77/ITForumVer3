import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:it_forum/ui/common/utils/jwt_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/router.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadJwt(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        var isLoading = snapshot.connectionState != ConnectionState.done;
        return buildMaterialApp(isLoading: isLoading);
      },
    );
  }

  Future<void> loadJwt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    await JwtInterceptor().parseJwt(accessToken, needToRefresh: true);
  }

  Widget buildMaterialApp({bool isLoading = false}) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.indigoAccent,
        ),
      ),
      routerConfig: appRouter,
      builder: (context, child) {
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : child!;
      },
    );
  }
}
