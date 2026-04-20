import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'themes/app_theme.dart';
import 'views/dashboard_view.dart';
import 'views/list_view_page.dart';
import 'views/detail_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'lib/config/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const DashboardView(),
        ),
        GoRoute(
          name: 'list',
          path: '/list/:endpoint',
          builder: (context, state) {
            final endpoint = state.params['endpoint']!;
            return ListViewPage(endpoint: endpoint);
          },
        ),
        GoRoute(
          name: 'detail',
          path: '/detail',
          builder: (context, state) {
            final extra = state.extra;
            return DetailView(item: extra);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Taller 4: datos abiertos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}