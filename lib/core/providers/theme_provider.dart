import 'package:bismo/core/providers/base_theme_provider.dart';

class ThemeProvider extends BaseThemeProvider {
  int _index = 0;

  get index => _index;

  setNavIndex(int index) {
    _index = index;
    if (index != 0) {
      notifyListeners();
    }
  }

  setNavIndexWithoutNotify(int index) {
    _index = index;
  }
}
