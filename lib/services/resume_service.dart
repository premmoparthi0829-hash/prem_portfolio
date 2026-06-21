import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

enum ResumeSourceType { defaultAsset, customUrl, customFile }

class ResumeData {
  final ResumeSourceType sourceType;
  final String? url;
  final String fileName;
  final Uint8List? bytes;

  ResumeData({
    required this.sourceType,
    this.url,
    required this.fileName,
    this.bytes,
  });
}

class ResumeService {
  static const String _keyType = 'portfolio_resume_type';
  static const String _keyUrl = 'portfolio_resume_url';
  static const String _keyFileName = 'portfolio_resume_file_name';
  static const String _keyFileBytes = 'portfolio_resume_file_bytes';

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Saves an external URL for the resume.
  static Future<void> saveResumeUrl(String url) async {
    await _initPrefs();
    await _prefs!.setString(_keyType, 'url');
    await _prefs!.setString(_keyUrl, url);
  }

  /// Saves uploaded PDF file bytes (encoded as Base64).
  static Future<void> saveResumeFile(String fileName, Uint8List bytes) async {
    await _initPrefs();
    final base64String = base64Encode(bytes);
    await _prefs!.setString(_keyType, 'file');
    await _prefs!.setString(_keyFileName, fileName);
    await _prefs!.setString(_keyFileBytes, base64String);
  }

  /// Resets the resume configuration to the default asset.
  static Future<void> resetToDefault() async {
    await _initPrefs();
    await _prefs!.setString(_keyType, 'default');
  }

  /// Retrieves the configuration of the current active resume.
  static Future<ResumeData> getActiveResume() async {
    await _initPrefs();
    final type = _prefs!.getString(_keyType) ?? 'default';

    if (type == 'url') {
      final url = _prefs!.getString(_keyUrl) ?? '';
      return ResumeData(
        sourceType: ResumeSourceType.customUrl,
        url: url,
        fileName: 'resume.pdf',
      );
    } else if (type == 'file') {
      final fileName = _prefs!.getString(_keyFileName) ?? 'uploaded_resume.pdf';
      final base64String = _prefs!.getString(_keyFileBytes);
      if (base64String != null && base64String.isNotEmpty) {
        try {
          final bytes = base64Decode(base64String);
          return ResumeData(
            sourceType: ResumeSourceType.customFile,
            fileName: fileName,
            bytes: bytes,
          );
        } catch (e) {
          print("Error decoding cached resume file: $e");
        }
      }
    }

    // Default Fallback
    try {
      final byteData = await rootBundle.load('assets/resume.pdf');
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
      return ResumeData(
        sourceType: ResumeSourceType.defaultAsset,
        fileName: 'prem_moparthi_resume.pdf',
        bytes: bytes,
      );
    } catch (e) {
      // Return a basic fallback if asset loading fails
      print("Failed to load assets/resume.pdf: $e");
      return ResumeData(
        sourceType: ResumeSourceType.defaultAsset,
        fileName: 'prem_moparthi_resume.pdf',
        bytes: Uint8List.fromList(utf8.encode("%PDF-1.4 ... Default Resume Fallback ...")),
      );
    }
  }

  /// Check what the current source is
  static Future<String> getCurrentType() async {
    await _initPrefs();
    return _prefs!.getString(_keyType) ?? 'default';
  }

  /// Check current custom url
  static Future<String> getCurrentUrl() async {
    await _initPrefs();
    return _prefs!.getString(_keyUrl) ?? '';
  }

  /// Check current custom filename
  static Future<String> getCurrentFileName() async {
    await _initPrefs();
    return _prefs!.getString(_keyFileName) ?? '';
  }
}
