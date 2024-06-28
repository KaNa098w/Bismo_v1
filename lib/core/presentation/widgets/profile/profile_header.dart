import 'package:bismo/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/profile/profile_header_options.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _UserData extends StatefulWidget {
  const _UserData({Key? key}) : super(key: key);

  @override
  __UserDataState createState() => __UserDataState();
}

class __UserDataState extends State<_UserData> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _pickImage() async {
    try {
      if (await Permission.storage.request().isGranted) {
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
          await _saveAvatar(pickedFile.path);
        }
      } else {
        print('Permission not granted');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _loadAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('avatar_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _saveAvatar(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_path', path);
  }

  Future<void> _deleteAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('avatar_path');
    setState(() {
      _image = null;
    });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primaryColor,
                ),
                title: const Text('Загрузить фото'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: AppColors.primaryColor,
                ),
                title: const Text('Удалить фото'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _deleteAvatar();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();

    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: [
          const SizedBox(width: AppDefaults.padding),
          GestureDetector(
            // onTap: () => _showOptions(context),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : const NetworkImage(
                          'https://w7.pngwing.com/pngs/244/76/png-transparent-avatar-male-man-person-profile-user-website-website-internet-icon.png')
                      as ImageProvider,
            ),
          ),
          const SizedBox(width: AppDefaults.padding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${userProvider.user?.storeName ?? ""}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                userProvider.user?.message ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background
        // Image.asset('assets/images/profile_page_image.avif'),

        Image.asset('assets/images/background_image.webp'),

        /// Contentasd
        Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const _UserData(),
            const ProfileHeaderOptions()
          ],
        ),
      ],
    );
  }
}
