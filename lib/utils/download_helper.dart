import 'download_helper_stub.dart'
    if (dart.library.html) 'download_helper_web.dart'
    if (dart.library.io) 'download_helper_mobile.dart';

/// Downloads a file with the given name and byte content on compatible platforms.
void downloadFile(List<int> bytes, String fileName) {
  downloadFileImpl(bytes, fileName);
}

/// Opens a file with the given name and byte content in a new viewer on compatible platforms.
void viewFile(List<int> bytes, String fileName) {
  viewFileImpl(bytes, fileName);
}
