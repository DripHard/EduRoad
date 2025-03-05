import 'package:eduroad/services/api_service.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eduroad/services/store_service.dart';
import 'dart:convert';

class NoteService{
    static  final Logger logger = Logger();
    static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    static Future<String> fetchIntro(String subject, String context) async {
         String key = "intro_$subject";

        // Check local storage first
        Map<String, String> localData = await LocalStorage.readData();
        if (localData.containsKey(key)) {
      logger.i("Loaded intro from local storage.");
      return localData[key] ?? ' ';
    }
        //this would be the prompt to make the roadmap
        String content = "Write a one paragraph concise introduction on $subject in the context of $context. Focus on its significance, key aspects, and relevance. Avoid unnecessary phrases like 'Here is an introduction' and go straight to the point.";
        logger.i(content);
        //the output of the prompt
        String introText =  await ApiService.fetchGeminiInfo(content);
        logger.i(introText);
        // Save locally and to Firestore
    await LocalStorage.saveData(key, introText);
        return introText;
    }


    static Future<String> fetchBody(String subject, String context) async {

        String key = "body_$subject";

        // Check local storage first
        Map<String, String> localData = await LocalStorage.readData();
        if (localData.containsKey(key)) {
      logger.i("Loaded intro from local storage.");
      return localData[key] ?? ' ';
    }

        //this would be the prompt to make the roadmap
        String content = "Provide detailed notes on $subject in the context of $context, including key concepts, definitions, and important points. Avoid introductory phrases and just present the information clearly, concisely and directly.";
        logger.i(content);
        //the output of the prompt
        String bodyText =  await ApiService.fetchGeminiInfo(content);
        logger.i(bodyText);
            await LocalStorage.saveData(key, bodyText);
        return bodyText;
    }

    static Future<List<String>> fetchYouTubeLink(String subject, String context) async {
        String key = "video_$subject";

        // Check local storage first
        Map<String, String> localData = await LocalStorage.readData();
        if (localData.containsKey(key)) {
        logger.i("Loaded YouTube links from local storage.");

        // Decode stored JSON string back into a List<String>
        try {
            return List<String>.from(jsonDecode(localData[key] as String));
        } catch (e) {
            logger.e("Error decoding local storage data: $e");
        }
    }

        //this would be the prompt to make the roadmap
        String content = subject;

        //the output of the prompt
        List<String>  youtubeLink =  await ApiService.fetchYouTubeVideos(content, context);
        logger.i(youtubeLink);
        await LocalStorage.saveData(key, jsonEncode(youtubeLink));
        return youtubeLink;
    }

    static Future<List<String>> fetchArticleLink(String subject, String context) async {
        String key = "article_$subject";

        // Check local storage first
        Map<String, String> localData = await LocalStorage.readData();
       if (localData.containsKey(key)) {
        logger.i("Loaded Article links from local storage.");

        // Decode stored JSON string back into a List<String>
        try {
            return List<String>.from(jsonDecode(localData[key] as String));
        } catch (e) {
            logger.e("Error decoding local storage data: $e");
        }
    }
        //this would be the prompt to make the roadmap
        String content = subject;
        logger.i(content);
        //the output of the prompt
        List<String> articleLink =  await ApiService.fetchOnlineReferences(subject, context);
        logger.i(articleLink);
        await LocalStorage.saveData(key, jsonEncode(articleLink));
        return articleLink;
    }
    static Future<String> fetchSummary(String subject, String context) async {

        String key = "summary_$subject";

        // Check local storage first
        Map<String, String> localData = await LocalStorage.readData();
        if (localData.containsKey(key)) {
      logger.i("Loaded intro from local storage.");
      return localData[key] ?? '';
    }

        //this would be the prompt to make the roadmap
        String content = "Summarize $subject in the context of $context  in a clear and concise manner, covering the most important points without introductory or concluding phrases. Just provide the key information directly.";
        logger.i(content);
        //the output of the prompt
        String summary =  await ApiService.fetchGeminiInfo(content);
        logger.i(summary);
                    await LocalStorage.saveData(key, summary);
        return summary;
    }

}



