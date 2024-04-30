import 'package:bismo/core/providers/global_state_manager.dart';
import 'package:bismo/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> getAppProviders() async {
  return [
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider<GlobalStateManager>(
      create: (context) => GlobalStateManager(),
    ),
  ];
}
