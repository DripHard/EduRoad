import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NotesPage extends StatefulWidget {
  final Map<String, String> data;

  const NotesPage({super.key, required this.data});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  final videoURL = "https://youtu.be/sdYdnpYn-1o?si=OHPGE4N3WA8Dnwc0";

  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoURL);

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false
      )
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.data['title'] ?? 'Notes';

    return SafeArea (
      child: Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                title: Hero(
                  tag: "title-$title",
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      height: 24,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            title,
                            textStyle: GoogleFonts.bricolageGrotesque(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            speed: const Duration(milliseconds: 80),
                            cursor: '|',
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ),
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
     body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Integration by Substitution", //title or something header
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text( //introduction
                "The **Substitution Method** (also called **u-substitution**) is a technique used in calculus "
                "to evaluate integrals by simplifying complex expressions. It transforms an integral into a more manageable form "
                "by making a suitable substitution.",
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "General Steps:", //how to or steps
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "1. Choose a substitution: Let u = f(x), such that its derivative (du/dx) simplifies the integral.\n"
                  "2. Differentiate both sides to find du.\n"
                  "3. Rewrite the integral in terms of u.\n"
                  "4. Integrate with respect to u.\n"
                  "5. Substitute back the original function in terms of x.",
                  style: GoogleFonts.bricolageGrotesque(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
              const SizedBox(height: 16),
              Text(
                "Example:",
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Evaluate ∫ (2x) * cos(x²) dx.\n\n"
                  "Step 1: Choose u = x² → Then, du/dx = 2x  → du = 2x dx.\n"
                  "Step 2: Rewrite integral in terms of u:\n"
                  "       ∫ cos(u) du\n"
                  "Step 3: Integrate: ∫ cos(u) du = sin(u)\n"
                  "Step 4: Substitute back u = x²:\n"
                  "       sin(x²) + C.",
                  style: GoogleFonts.bricolageGrotesque(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text( //summary
                "Integration by substitution simplifies complex integrals by transforming them into "
                "familiar forms, making it an essential technique in calculus.",
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}