import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class LocalStorage {
  static final Logger logger = Logger();
  static const String dataFileName = 'data.json';
  static const String searchHistoryFileName = 'search_history.json';

  // Get the directory path
  static Future<String> _getDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get file reference
  static Future<File> _getFile(String fileName) async {
    final path = await _getDirectoryPath();
    return File('$path/$fileName');
  }

  // Save key-value data
  static Future<void> saveData(String key, String data) async {
    try {
      final file = await _getFile(dataFileName);
      Map<String, String> storageData = await readData();

      storageData[key] = data;
      await file.writeAsString(jsonEncode(storageData));

      logger.i(" Data saved for key: $key");
    } catch (e) {
      logger.e(" Error saving local data: $e");
    }
  }

  // Read key-value data
  static Future<Map<String, String>> readData() async {
    try {
      final file = await _getFile(dataFileName);
      if (!await file.exists()) return {}; // Return empty map if file does not exist

      String content = await file.readAsString();
      final decodedData = jsonDecode(content);

      if (decodedData is Map<String, dynamic>) {
        return decodedData.map((key, value) => MapEntry(key, value.toString()));
      } else {
        logger.e("Invalid format in data.json. Resetting file.");
        await file.writeAsString(jsonEncode({})); // Reset file
        return {};
      }
    } catch (e) {
      logger.e("Error reading local data: $e");
      return {};
    }
  }

  // Save search history
  static Future<void> saveSearch(String subject) async {
    try {
      final file = await _getFile(searchHistoryFileName);
      List<String> searchHistory = await readSearchHistory();

      if (!searchHistory.contains(subject)) {
        searchHistory.insert(0, subject); // Add new search at the top
        if (searchHistory.length > 10) {
          searchHistory = searchHistory.sublist(0, 10); // Keep last 10 searches
        }
        await file.writeAsString(jsonEncode(searchHistory));
        logger.i(" Search history updated");
      }
    } catch (e) {
      logger.e(" Error saving search history: $e");
    }
  }

  // Read search history
  static Future<List<String>> readSearchHistory() async {
    try {
      final file = await _getFile(searchHistoryFileName);
      if (!await file.exists()) return [];

      String contents = await file.readAsString();
      final decodedData = jsonDecode(contents);

      if (decodedData is List) {
        return List<String>.from(decodedData);
      } else {
        logger.e(" Invalid format in search_history.json. Resetting file.");
        await file.writeAsString(jsonEncode([])); // Reset file
        return [];
      }
    } catch (e) {
      logger.e(" Error reading search history: $e");
      return [];
    }
  }
}

