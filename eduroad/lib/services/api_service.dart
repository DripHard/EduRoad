import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

final String BASE_URL=dotenv.env['BASE_URL'] ?? '';
final String API_KEY=dotenv.env['API_KEY'] ?? '';

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
}
