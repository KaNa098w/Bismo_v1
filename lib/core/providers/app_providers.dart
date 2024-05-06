import 'package:bismo/core/helpers/login_helper.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:bismo/core/models/user/get_profile_response.dart';
import 'package:bismo/core/providers/global_state_manager.dart';
import 'package:bismo/core/providers/theme_provider.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> getAppProviders() async {
  CategoryResponse? authResponse = await authData();

  return [
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider<GlobalStateManager>(
      create: (context) => GlobalStateManager(),
    ),
    ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(authResponse),
    ),
  ];
}
