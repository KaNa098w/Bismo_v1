import 'package:path_provider/path_provider.dart';

Future<String> getTemporaryDirectoryPath() async {
  final directory = await getTemporaryDirectory();
  return directory.path;
}
