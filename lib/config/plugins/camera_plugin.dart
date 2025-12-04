import 'package:image_picker/image_picker.dart';

class CameraPlugin {
  final ImagePicker _picker = ImagePicker();

  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    return photo?.path;
  }

  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
      preferredCameraDevice: CameraDevice.rear,
    );

    return photo?.path;
  }
}
