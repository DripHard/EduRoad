import 'package:eduroad/services/api_service.dart';
import 'package:logger/logger.dart';
import  'package:eduroad/services/store_service.dart';
import 'dart:convert';
class RoadMapService {
    static  final Logger logger = Logger();

    static Future<List<String>> fetch(String subject) async {
        String key = "roadmap_$subject";

        await LocalStorage.saveSearch(subject); // Save locally
        //  ✅Check if the roadmap exists locally
        Map<String, String> localData = await LocalStorage.readData();
        if (localData.containsKey(key)) {
      logger.i("Loaded roadmap for '$subject' from local storage.");
      return List<String>.from(jsonDecode(localData[key] ?? '')); // Convert JSON string back to List
    }
        //this would be the prompt to make the roadmap
        String content = "Make a list from simple to complex for a roadmap about $subject. Just a list of concepts no intro text and no bullters (dots or numbers).";

        //the output of the prompt
        String roadmapText =  await ApiService.fetchInfo(content);

        // Process and clean the roadmap list
        List<String> roadmapList = roadmapText.split("\n").where((e) => e.trim().isNotEmpty).toList();

        // Save locally and to Firestore
        await LocalStorage.saveData(key, jsonEncode(roadmapList));

        return roadmapList;
    }
}

