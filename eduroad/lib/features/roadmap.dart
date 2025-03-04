import 'package:eduroad/services/api_service.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoadMapService {
    static  final Logger logger = Logger();
    static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    static Future<List<String>> fetch(String subject) async {
        //this would be the prompt to make the roadmap
        String content = "Make a list from simple to complex for a roadmap about $subject. Just a list of concepts no intro text and no bullters (dots or numbers).";
        logger.i(content);
        //the output of the prompt
        String roadmapText =  await ApiService.fetchInfo(content);
        // Process and clean the roadmap list
        List<String> roadmapList = roadmapText.split("\n").where((e) => e.trim().isNotEmpty).toList();

        // Save to Firestore only if the user is logged in
        await _saveToFirestore(subject, roadmapList);

        return roadmapList;
    }

    // Saves the roadmap to Firestore as a separate document
    static Future<void> _saveToFirestore(String subject, List<String> roadmap) async {
        String? userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId == null) {
      logger.w("User not logged in. Skipping Firestore save.");
      return;
    }

       try {
      for (String concept in roadmap) {
        await _firestore
            .collection("Users")
            .doc(userId)
            .collection("Roadmaps")
            .doc(subject) // Subject is now a collection
            .collection("topics") // Store concepts inside this collection
            .add({
          "title": concept, // Concept name
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
      logger.i("Roadmap concepts for '$subject' saved under separate collection.");
    } catch (e) {
      logger.e("Error saving roadmap concepts to Firestore: $e");
    }
  }
}

