import 'dart:io' show File, Directory;
import 'dart:math' show Random;
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univalle_app/config/providers/shared_preferences_provider.dart';

final profilePictureProvider =
    StateNotifierProvider<ProfilePictureNotifier, File?>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return ProfilePictureNotifier(sharedPrefs);
});

class ProfilePictureNotifier extends StateNotifier<File?> {
  final SharedPreferences _sharedPrefs;
  ProfilePictureNotifier(this._sharedPrefs) : super(null) {
    _loadImage();
  }

  Future<void> pickImage(ProfilePictureAction action) async {
    if (action == ProfilePictureAction.removeImage) {
      removeImage();
      return;
    }
    final source = action == ProfilePictureAction.camarePicker
        ? ImageSource.camera
        : ImageSource.gallery;
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;
    removeImage();

    final directory = await getApplicationDocumentsDirectory();

    final path = p.join(directory.path, 'imagen-perfil');
    final directoryPath = Directory(path);

    if (!directoryPath.existsSync()) {
      directoryPath.createSync(recursive: true);
    }

    final fileName = '${_generateRamdomString()}.png';
    await _sharedPrefs.setString('profile', fileName);
    final filePath = p.join(directoryPath.path, fileName);
    final file = File(filePath);
    await file.writeAsBytes(await pickedFile.readAsBytes());

    state = file;
  }

  void _loadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = _sharedPrefs.getString('profile');
    if (fileName == null) return;
    final path = p.join(directory.path, 'imagen-perfil', fileName);
    final file = File(path);
    if (file.existsSync()) {
      state = file;
    }
  }

  void removeImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = _sharedPrefs.getString('profile');
    if (fileName == null) return;
    final path = p.join(directory.path, 'imagen-perfil', fileName);
    final file = File(path);

    if (file.existsSync()) {
      file.deleteSync();
      state = null;
    }
  }

  String _generateRamdomString() {
    const String chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const int length = 10;
    final Random rnd = Random();
    final String result = String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    return result;
  }
}

enum ProfilePictureAction { camarePicker, removeImage, galleryPicker }
