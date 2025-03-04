import 'package:eduroad/services/api_service.dart';
import 'package:logger/logger.dart';

class NoteService{
    static  final Logger logger = Logger();

    static Future<String> fetchIntro(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = "Write a one paragraph concise introduction on $subject in the context of $context. Focus on its significance, key aspects, and relevance. Avoid unnecessary phrases like 'Here is an introduction' and go straight to the point.";
        logger.i(content);
        //the output of the prompt
        String introText =  await ApiService.fetchGeminiInfo(content);
        logger.i(introText);
        return introText;
    }


    static Future<String> fetchBody(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = "Provide detailed notes on $subject in the context of $context, including key concepts, definitions, and important points. Avoid introductory phrases and just present the information clearly, concisely and directly.";
        logger.i(content);
        //the output of the prompt
        String bodyText =  await ApiService.fetchGeminiInfo(content);
        logger.i(bodyText);
        return bodyText;
    }

    static Future<List<String>> fetchYouTubeLink(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = subject;
        logger.i(content);
        //the output of the prompt
        List<String>  youtubeLink =  await ApiService.fetchYouTubeVideos(content, context);
        logger.i(youtubeLink);
        return youtubeLink;
    }

    static Future<List<String>> fetchArticleLink(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = subject;
        logger.i(content);
        //the output of the prompt
        List<String> articleLink =  await ApiService.fetchOnlineReferences(subject, context);
        logger.i(articleLink);
        return articleLink;
    }
    static Future<String> fetchSummary(String subject, String context) async {
        //this would be the prompt to make the roadmap
        String content = "Summarize $subject in the context of $context  in a clear and concise manner, covering the most important points without introductory or concluding phrases. Just provide the key information directly.";
        logger.i(content);
        //the output of the prompt
        String summary =  await ApiService.fetchGeminiInfo(content);
        logger.i(summary);
        return summary;
    }

}

