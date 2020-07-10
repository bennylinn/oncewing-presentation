import 'package:image_picker/image_picker.dart';

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    return pickedFile;
  }