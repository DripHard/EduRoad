import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eduroad/pages/notes.dart';

class CustomCard extends StatefulWidget {
  final  String data;
final String searchQuery;
  const CustomCard({super.key, required this.data, required this.searchQuery});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotesPage(title: widget.data,
                            concept: widget.searchQuery),
                    ),
                );
            },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 90,
        width: MediaQuery.of(context).size.width * 1,
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
            child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child:  Center(
                    child: Text(
                        textAlign: TextAlign.center,
                      widget.data,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ), //Center
                    ), //Padding
          ),
        ),
      ),
    );
  }

}
