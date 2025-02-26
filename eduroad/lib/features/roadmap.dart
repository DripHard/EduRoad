import 'package:eduroad/services/api_service.dart';
import 'package:logger/logger.dart';
class RoadMapService {
    static  final Logger logger = Logger();
    static Future<List<String>> fetch(String subject) async {
        //this would be the prompt to make the roadmap
        String content = "Make a list from simple to complex for a roadmap about $subject. Just a list of concepts no intro text and no bullters (dots or numbers).";
        logger.i(content);
        //the output of the prompt
        String roadmapText =  await ApiService.fetchInfo(content);
        logger.i("roadmaptext");
        logger.i(roadmapText);
        return roadmapText.split("\n").where((e) => e.trim().isNotEmpty).toList();
    }
}

