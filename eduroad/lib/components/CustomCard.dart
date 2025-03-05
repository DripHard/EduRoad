import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduroad/pages/notes.dart';

class CustomCard extends StatelessWidget {
  final  String data;
    final String searchQuery;


  const CustomCard({super.key, required this.data, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotesPage(title: data,
                            concept: searchQuery),
                    ),
                );
            },
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Hero(
              tag: "title-$data",
              child: Material(
                color: Colors.transparent,
                child: Text(
                  data,
                  textAlign: TextAlign.center,
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
      ),
    );
  }
}

