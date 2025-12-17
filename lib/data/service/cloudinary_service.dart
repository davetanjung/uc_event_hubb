// lib/services/cloudinary_service.dart
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart'; // Change import from dart:io
import 'package:mime/mime.dart';

class CloudinaryService {
  final String cloudName = "ddc0f90ph";
  final String uploadPreset = "depd2526";

  // Change parameter from File to XFile
  Future<String> uploadImage(XFile file) async {
    final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
    
    final uploadRequest = http.MultipartRequest("POST", uri);
    uploadRequest.fields['upload_preset'] = uploadPreset;

    // Detect MimeType
    // Note: lookupMimeType might need a fallback on web if path doesn't have extension
    final mimeTypeData = lookupMimeType(file.path, headerBytes: await file.readAsBytes());
    final mimeType = mimeTypeData?.split('/') ?? ['image', 'jpeg']; // Fallback

    // Load file as Bytes (Works on Web & Mobile)
    final fileBytes = await file.readAsBytes();

    uploadRequest.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: file.name,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ),
    );

    final response = await uploadRequest.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final url = res.body.split('"secure_url":"')[1].split('"')[0];
      return url.replaceAll(r'\/', '/');
    } else {
      throw Exception("Cloudinary upload failed: ${response.statusCode}");
    }
  }
}