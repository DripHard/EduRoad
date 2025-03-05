import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:logger/logger.dart';
import 'package:eduroad/features/notes.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NotesPage extends StatefulWidget {
  final  String title;
    final String concept;
  const NotesPage({super.key, required this.title, required this.concept});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
        static  final Logger logger = Logger();

    String intro = '';
    String body = '';
    List<String> videolink = [];
    List<String> articlelink = [];
    String? summary;
    bool isLoading = true; // Add loading state
    List<YoutubePlayerController> _controllers = []; // Initialize as empty list

    @override
    void initState() {
        super.initState();
        fetchNotes();
    }
  final videoURL = "https://youtu.be/sdYdnpYn-1o?si=OHPGE4N3WA8Dnwc0";
    Future<void> fetchNotes() async {

        //fetch necessary data
        String introduction  = await NoteService.fetchIntro(widget.title, widget.concept);
        String main  = await NoteService.fetchBody(widget.title, widget.concept);
        List<String> ylink = await NoteService.fetchYouTubeLink(widget.title, widget.concept);
        List<String> arlink  = await NoteService.fetchArticleLink(widget.title, widget.concept);
        String summ = await NoteService.fetchSummary(widget.title, widget.concept);

        //prepare the youtube links
        List<YoutubePlayerController> controllers =ylink
            .map((url) => YoutubePlayer.convertUrlToId(url))
            .where((id) => id != null)
            .map((id) => YoutubePlayerController(
                  initialVideoId: id!,
                  flags: const YoutubePlayerFlags(autoPlay: false),
            ))
            .toList();

        setState((){
            intro = introduction;
            body = main;
            videolink = ylink;
            articlelink = arlink;
            summary = summ;
            _controllers = controllers;
            isLoading = false; // Mark loading as complete
        });
        }



  @override
  Widget build(BuildContext context) {
    String title = widget.title;

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
                              fontSize: 17,
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
          child: isLoading
            ?  Center(
              child: AnimatedTextKit(
              animatedTexts: [
              TyperAnimatedText('Generating', textStyle: TextStyle(fontSize: 20, decoration: TextDecoration.none, color: Colors.white )),
              TyperAnimatedText('Notes...', textStyle: TextStyle(fontSize: 20, decoration: TextDecoration.none, color: Colors.white )),
            ],))
            : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Introduction:",
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
                child: GptMarkdown(
                    intro,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.bricolageGrotesque(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
                    Column(
                        children: _controllers
                        .map((controller) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                            child: YoutubePlayer(
                            controller: controller,
                            showVideoProgressIndicator: true,
                        ),
                    ))
                 .toList(),
              ),

              const SizedBox(height: 16),
              Text(
                "Main Points:",
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
                child: GptMarkdown(
                    body,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.bricolageGrotesque(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
                                Text(
                                    "Summary:",
                                    style: GoogleFonts.bricolageGrotesque(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                    ),
                                ),

              GptMarkdown( //summary
                summary ?? '',
                textAlign: TextAlign.justify,
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
                                Text(
                                    "If you want to read more check the links below:",
                                    style: GoogleFonts.bricolageGrotesque(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                    ),
                                ),
                                              const SizedBox(height: 5),

                                Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: articlelink.map((link) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(
                                            url: link,
                                            title: widget.title,
                  ),
                ),
              );
            },
            child: Text(
              "- $link",
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.blue, // Makes it look like a link
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    ),

            ],
          ),
        ),
      ),
    )
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;
    final String title;
  const WebViewPage({
        super.key,
        required this.url,
        required this.title,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
      ),
    );
  }
}
