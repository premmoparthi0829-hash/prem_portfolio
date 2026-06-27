import 'dart:ui' show ImageFilter;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../services/resume_service.dart';

/// Credentials for Administrator authentication
const String _adminEmail = 'premnithin9718@gmail.com';
const String _adminPassword = 'Prem@2001';

/// Login Dialog triggered by administrator gesture
class AdminLoginDialog extends StatefulWidget {
  const AdminLoginDialog({super.key});

  @override
  State<AdminLoginDialog> createState() => _AdminLoginDialogState();
}

class _AdminLoginDialogState extends State<AdminLoginDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    // Provide a short delay for fluid loading micro-animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (email == _adminEmail && password == _adminPassword) {
        if (!mounted) return;
        Navigator.of(context).pop(); // Close login screen
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => const AdminDialog(),
        );
      } else {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Invalid administrator credentials';
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: const Color(0xFF141414).withOpacity(0.95),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF5C35).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFFFF5C35),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'ADMIN LOGIN',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded, color: Colors.white60),
                          hoverColor: Colors.white10,
                          splashRadius: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white10, height: 1),
                    const SizedBox(height: 24),

                    // Email Input
                    Text(
                      'EMAIL ADDRESS',
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      cursorColor: const Color(0xFFFF5C35),
                      decoration: InputDecoration(
                        hintText: 'admin@example.com',
                        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.white38, size: 18),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.04),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF5C35),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Input
                    Text(
                      'PASSWORD',
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      cursorColor: const Color(0xFFFF5C35),
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.white38, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Colors.white38,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.04),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF5C35),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Error Message
                    if (_errorMessage.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Authenticate Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5C35),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text(
                              'AUTHENTICATE',
                              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Admin Dashboard Dialog to manage dynamic resume uploads
class AdminDialog extends StatefulWidget {
  const AdminDialog({super.key});

  @override
  State<AdminDialog> createState() => _AdminDialogState();
}

class _AdminDialogState extends State<AdminDialog> {
  ResumeData? _currentResume;
  bool _isLoading = false;
  String _statusMessage = '';
  bool _isError = false;

  final TextEditingController _urlController = TextEditingController();
  PlatformFile? _selectedFile;
  Uint8List? _selectedFileBytes;

  @override
  void initState() {
    super.initState();
    _loadCurrentResume();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentResume() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final resume = await ResumeService.getActiveResume();
      final url = await ResumeService.getCurrentUrl();
      setState(() {
        _currentResume = resume;
        _urlController.text = url;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading resume config: $e';
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFile() async {
    setState(() {
      _statusMessage = '';
      _isError = false;
    });
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes == null) {
          setState(() {
            _statusMessage = 'Could not read file bytes. Try another PDF.';
            _isError = true;
          });
          return;
        }
        setState(() {
          _selectedFile = file;
          _selectedFileBytes = file.bytes;
          _statusMessage = 'Selected: ${file.name} (${(file.size / 1024).toStringAsFixed(1)} KB)';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error picking file: $e';
        _isError = true;
      });
    }
  }

  Future<void> _saveFile() async {
    if (_selectedFile == null || _selectedFileBytes == null) return;
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });
    try {
      await ResumeService.saveResumeFile(_selectedFile!.name, _selectedFileBytes!);
      await _loadCurrentResume();
      setState(() {
        _selectedFile = null;
        _selectedFileBytes = null;
        _statusMessage = 'Resume PDF file saved successfully!';
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving file: $e';
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter a valid URL';
        _isError = true;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });
    try {
      await ResumeService.saveResumeUrl(url);
      await _loadCurrentResume();
      setState(() {
        _statusMessage = 'Resume URL saved successfully!';
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving URL: $e';
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _resetToDefault() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });
    try {
      await ResumeService.resetToDefault();
      await _loadCurrentResume();
      setState(() {
        _selectedFile = null;
        _selectedFileBytes = null;
        _statusMessage = 'Resume reset to default successfully!';
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error resetting: $e';
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String sourceText = 'Loading...';
    if (_currentResume != null) {
      switch (_currentResume!.sourceType) {
        case ResumeSourceType.defaultAsset:
          sourceText = 'Default Asset (prem_moparthi_resume.pdf)';
          break;
        case ResumeSourceType.customUrl:
          sourceText = 'Custom Link';
          break;
        case ResumeSourceType.customFile:
          sourceText = 'Custom File (${_currentResume!.fileName})';
          break;
      }
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 550),
          decoration: BoxDecoration(
            color: const Color(0xFF141414).withOpacity(0.95),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF5C35).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.admin_panel_settings_rounded,
                                  color: Color(0xFFFF5C35),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'PORTFOLIO ADMIN',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded, color: Colors.white60),
                          hoverColor: Colors.white10,
                          splashRadius: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white10, height: 1),
                    const SizedBox(height: 24),

                    // Active Configuration Display
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRENT ACTIVE RESUME',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFFF5C35),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_isLoading && _currentResume == null)
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Color(0xFFFF5C35)),
                              ),
                            )
                          else
                            Text(
                              sourceText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section: Upload PDF
                    Text(
                      'OPTION A: UPLOAD PDF FILE',
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, rowConstraints) {
                        final useVertical = rowConstraints.maxWidth < 340;
                        if (useVertical) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _isLoading ? null : _pickFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.08),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.attach_file_rounded, size: 18),
                                label: const Text('CHOOSE PDF FILE'),
                              ),
                              if (_selectedFile != null) ...[
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _saveFile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF5C35),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text('SAVE FILE'),
                                ),
                              ],
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _pickFile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.08),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.05),
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.attach_file_rounded, size: 18),
                                  label: const Text('CHOOSE PDF FILE'),
                                ),
                              ),
                              if (_selectedFile != null) ...[
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _saveFile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF5C35),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text('SAVE FILE'),
                                ),
                              ],
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 28),

                    // Section: Resume URL
                    Text(
                      'OPTION B: PROVIDE RESUME URL',
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, rowConstraints) {
                        final useVertical = rowConstraints.maxWidth < 340;
                        if (useVertical) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _urlController,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                cursorColor: const Color(0xFFFF5C35),
                                decoration: InputDecoration(
                                  hintText: 'https://example.com/my_resume.pdf',
                                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.04),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFFF5C35),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _saveUrl,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5C35),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('SAVE URL'),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _urlController,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  cursorColor: const Color(0xFFFF5C35),
                                  decoration: InputDecoration(
                                    hintText: 'https://example.com/my_resume.pdf',
                                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.04),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.08),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFFF5C35),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _saveUrl,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5C35),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('SAVE URL'),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 28),

                    // Section: Reset / Default Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: _isLoading ? null : _resetToDefault,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white60,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.restore_rounded, size: 16),
                          label: const Text('RESET TO DEFAULT'),
                        ),
                        if (_isLoading)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Color(0xFFFF5C35)),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Status Messages Alert Area
                    if (_statusMessage.isNotEmpty) ...[
                      const Divider(color: Colors.white10, height: 1),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _isError
                              ? Colors.redAccent.withOpacity(0.1)
                              : const Color(0xFFB2FF33).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isError
                                ? Colors.redAccent.withOpacity(0.2)
                                : const Color(0xFFB2FF33).withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                              color: _isError ? Colors.redAccent : const Color(0xFFB2FF33),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _statusMessage,
                                style: TextStyle(
                                  color: _isError ? Colors.redAccent : const Color(0xFFB2FF33),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
