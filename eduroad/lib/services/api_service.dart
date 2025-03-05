import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

final String BASE_URL=dotenv.env['BASE_URL'] ?? '';
final String API_KEY=dotenv.env['API_KEY'] ?? '';
final String GEMINI_BASE_URL=dotenv.env["GEMINI_BASE_URL"] ?? '';
final String GEMINI_KEY=dotenv.env["GEMINI_API_KEY"] ?? '';
final String YOUTUBE_BASE=dotenv.env["YOUTUBE_BASE_URL"] ?? '';
final String YOUTUBE_KEY=dotenv.env["YOUTUBE_API_KEY"] ?? '';
final String GOOGLE_BASE=dotenv.env["GOOGLE_SEARCH_BASE_URL"] ?? '';
final String GOOGLE_API=dotenv.env["GOOGLE_SEARCH_API_KEY"] ?? '';
final String SEARCH_ENGINE_ID=dotenv.env["SEARCH_ENGINE_ID"] ?? '';

class ApiService {
    static Logger logger = Logger();

    static Future<String> fetchInfo(String content)async{
        var response;
        try{
            response = await http.post(
                Uri.parse(BASE_URL),
                headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $API_KEY'
            },
                body: jsonEncode({
                    "model": "gpt-4o",
                    "messages": [
                    {
                        "role": "user",
                        "content": content
                    }
                    ],
                    "temperature": 0.6
                }),
            );

            if (response.statusCode == 200) { //success
                var data = jsonDecode(response.body);
                return data['choices'][0]['message']['content'];
            } else {
                 logger.e("API Error: ${response.statusCode} - ${response.body}");
                 return "Error: ${response.statusCode}";
        }
        }
            catch(err){
            logger.i("error $err");
           return "An error occured while fetching data.";
        }
    }

    static Future<String> fetchGeminiInfo(String content)async{
        try{
             final geminiResponse = await http.post(
                Uri.parse("$GEMINI_BASE_URL$GEMINI_KEY"),
                headers: {
                'Content-Type': 'application/json',
            },
                body: jsonEncode({
                    "contents": [
                        {
                        "parts":[{"text": content}]
                        }
                    ]
                }),
            );

            if (geminiResponse.statusCode == 200) {
                 var data = jsonDecode(geminiResponse.body);

                 // Use null-aware operators for safer access
                 var textResponse = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
            if (textResponse != null) {
                 return textResponse;
             } else {
                 return "Error: Response did not contain expected content.";
                 }
               } else {
                 logger.e("API Error: ${geminiResponse.statusCode} - ${geminiResponse.body}");
                 return "E1rror: ${geminiResponse.statusCode}";
                 }
             }
            catch(err){
                logger.i("error $err");
                return "An error occured while fetching data.";
        }
    }

static Future<List< String>> fetchYouTubeVideos(String query, String context) async {
    try {

        //to avoid unrelevant results
        String refinedQuery = "$query $context";
        final response = await http.get(
            Uri.parse("$YOUTUBE_BASE?part=snippet&q=$refinedQuery&type=video&maxResults=6&videoDuration=medium&key=$YOUTUBE_KEY"),
        );

        if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final List videos = data["items"];

            if (videos.isNotEmpty) {
                return videos
                    .take(4)
                    .map((video) {
                    final String videoId = video["id"]["videoId"] as String;
                    final String videoUrl = "https://www.youtube.com/watch?v=$videoId";
                    return videoUrl.contains("shorts") ? null : videoUrl;
                    })
                    .where((url) => url != null) // Remove null values
                    .cast<String>() // Convert to List<String>
                    .toList();
                } else {
                return [];
            }
        } else {
            logger.e("API Error: ${response.statusCode} - ${response.body}");
            return [];
        }
    } catch (err) {
        logger.e("Error fetching YouTube videos: $err");
        return [];
    }}

    static Future<List<String>> fetchOnlineReferences(String query, String context) async {
        try {
            //to avoid unrelevant results
            String refinedQuery = "$query $context";

            final response = await http.get(
                Uri.parse("$GOOGLE_BASE?q=$refinedQuery&key=$GOOGLE_API&cx=$SEARCH_ENGINE_ID"),

            );
            if (response.statusCode == 200) {
                final data = jsonDecode(response.body);
                final List items = data["items"] ?? [];

            // Extracts and returns only the links
            return items.map<String>((item) => item["link"] as String).take(5).toList();
        } else {
            print("Error: ${response.statusCode} - ${response.body}");
            return [];
        }
        } catch (e) {
            print("Error fetching search results: $e");
            return [];
        }
    }
}
