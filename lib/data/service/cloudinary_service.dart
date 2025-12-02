import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CloudinaryService {
  final String cloudName = "YOUR_CLOUD_NAME";
  final String uploadPreset = "YOUR_UPLOAD_PRESET";

  Future<String> uploadImage(File file) async {
    final mimeType = lookupMimeType(file.path)!.split('/');

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final uploadRequest = http.MultipartRequest("POST", uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );

    final response = await uploadRequest.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final url = res.body.split('"secure_url":"')[1].split('"')[0];
      return url.replaceAll(r'\/', '/');
    } else {
      throw Exception("Cloudinary upload failed");
    }
  }
}
