import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class LocalStorage {
  static final Logger logger = Logger();
  static const String fileName = 'data.json';

  // Get file path
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  // Save data
  static Future<void> saveData(String key, String data) async {
    try {
      final file = await _getFile();
      Map<String, String> storageData = await readData();
      storageData[key] = data;
      await file.writeAsString(jsonEncode(storageData));
      logger.i("Data saved locally for key: $key");
    } catch (e) {
      logger.e("Error saving local data: $e");
    }
  }

  // Read data
 static Future<Map<String, String>> readData() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return {}; // Return empty if file doesn't exist

      String content = await file.readAsString();
      final decodedData = jsonDecode(content);

      if (decodedData is Map<String, dynamic>) {
        return decodedData.map((key, value) => MapEntry(key, value.toString()));
      } else {
        print("⛔ Invalid data format in local storage.");
        return {};
      }
    } catch (e) {
      print("⛔ Error reading local data: $e");
      return {};
    }
  }
  // Save search history
  static Future<void> saveSearch(String subject) async {
    final file = await _getFile();
    List<String> searchHistory = await readSearchHistory();

    if (!searchHistory.contains(subject)) {
      searchHistory.insert(0, subject); // Add to the top
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10); // Limit to 10 searches
      }
      await file.writeAsString(jsonEncode(searchHistory));
    }
  }

  // Read search history
  static Future<List<String>> readSearchHistory() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      String contents = await file.readAsString();
      return List<String>.from(jsonDecode(contents));
    } catch (e) {
      return [];
    }
  }
}

