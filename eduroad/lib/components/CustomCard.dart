import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class CustomCard extends StatefulWidget {
  final Map<String, String> data;

  const CustomCard({super.key, required this.data});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _expanded ? 90 : 90,
        width: _expanded ? 270 : MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: _expanded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => _launchURL(widget.data['article']),
                          child: Text(
                            "Read",
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => _launchURL(widget.data['video']),
                          child: Text(
                            "Watch",
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      widget.data['title'] ?? 'No Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String? url) {
    if (url != null) {
      // Implement your URL launcher logic here
    }
  }
}
