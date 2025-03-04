import 'package:eduroad/services/api_service.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteService{
    static  final Logger logger = Logger();
    static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    static Future<String> fetchIntro(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = "Write a one paragraph concise introduction on $subject in the context of $context. Focus on its significance, key aspects, and relevance. Avoid unnecessary phrases like 'Here is an introduction' and go straight to the point.";
        logger.i(content);
        //the output of the prompt
        String introText =  await ApiService.fetchGeminiInfo(content);
        logger.i(introText);
         await _saveToFirestore(subject, "Introduction", context, introText);
        return introText;
    }


    static Future<String> fetchBody(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = "Provide detailed notes on $subject in the context of $context, including key concepts, definitions, and important points. Avoid introductory phrases and just present the information clearly, concisely and directly.";
        logger.i(content);
        //the output of the prompt
        String bodyText =  await ApiService.fetchGeminiInfo(content);
        logger.i(bodyText);
        await _saveToFirestore(subject, "MainPoint", context, bodyText);
        return bodyText;
    }

    static Future<List<String>> fetchYouTubeLink(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = subject;
        logger.i(content);
        //the output of the prompt
        List<String>  youtubeLink =  await ApiService.fetchYouTubeVideos(content, context);
        logger.i(youtubeLink);
         await _saveToFirestore(subject, "Videos", context, youtubeLink);
        return youtubeLink;
    }

    static Future<List<String>> fetchArticleLink(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = subject;
        logger.i(content);
        //the output of the prompt
        List<String> articleLink =  await ApiService.fetchOnlineReferences(subject, context);
        logger.i(articleLink);
        await _saveToFirestore(subject, "Articles", context,  articleLink);
        return articleLink;
    }
    static Future<String> fetchSummary(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = "Summarize $subject in the context of $context  in a clear and concise manner, covering the most important points without introductory or concluding phrases. Just provide the key information directly.";
        logger.i(content);
        //the output of the prompt
        String summary =  await ApiService.fetchGeminiInfo(content);
        logger.i(summary);

        await _saveToFirestore(subject, "Summary", context,  summary);
        return summary;
    }

    // Generic function to save data to Firestore only if a user is logged in
  static Future<void> _saveToFirestore(String subject, String field, String context,  dynamic data) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      logger.w("User not logged in. Skipping Firestore save for $field.");
      return;
    }

    try {
      await _firestore.collection("Users").doc(userId).collection("Roadmaps").doc(context).
            collection("topics").doc(subject).set(
        {field: data},
        SetOptions(merge: true), // Merge ensures we don't overwrite existing fields
      );
      logger.i("Saved $field for $subject to Firestore.");
    } catch (e) {
      logger.e("Error saving $field to Firestore: $e");
    }
  }
}



