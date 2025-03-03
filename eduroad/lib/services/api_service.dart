import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

final String BASE_URL=dotenv.env['BASE_URL'] ?? '';
final String API_KEY=dotenv.env['API_KEY'] ?? '';
final String GEMINI_BASE_URL=dotenv.env["GEMINI_BASE_URL"] ?? '';
final String GEMINI_KEY=dotenv.env["GEMINI_API_KEY"] ?? '';

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
        var geminiResponse;
        try{
            geminiResponse = await http.post(
                Uri.parse("$GEMINI_BASE_URL?key=$GEMINI_KEY"),
                headers: {
                'Content-Type': 'application/json',
            },
                body: jsonEncode({
                    "contents": [
                        {
                        "parts":[{"text": content}]
                        }
                    ],
                }),
            );

            if (geminiResponse.statusCode == 200) { //success
                var data = jsonDecode(geminiResponse.body);
                if (data.containsKey('candidates') &&
                    data['candidates'].isNotEmpty &&
                    data['candidates'][0].containsKey('content') &&
                    data['candidates'][0]['content'].containsKey('parts') &&
                    data['candidates'][0]['content']['parts'].isNotEmpty) {
                    return data['candidates'][0]['content']['parts'][0]['text'];
                 } else {
                    return "Error: Response did not contain expected content.";
                 }
             } else {
                 logger.e("API Error: ${geminiResponse.statusCode} - ${geminiResponse.body}");
                 return "Error: ${geminiResponse.statusCode}";
                 }
             }
            catch(err){
                logger.i("error $err");
                return "An error occured while fetching data.";
        }
    }
}
