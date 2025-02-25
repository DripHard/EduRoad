import 'package:eduroad/components/CustomCard.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class Roadmap extends StatefulWidget {
  final String searchQuery;

  const Roadmap({super.key, required this.searchQuery});

  @override
  _RoadmapState createState() => _RoadmapState();
}

class _RoadmapState extends State<Roadmap> {
  late TextEditingController _searchController;

  List<Map<String, String>> manualData = [
    {
      'title': 'Introduction to AI',
      'video': 'https://youtu.be/SSE4M0gcmvE?si=XLCi-dfibyMsS45N',
      'article': 'https://www.researchgate.net/publication/351758474_Introduction_to_Artificial_Intelligence'
    },
    {
      'title': 'Fundamentals',
      'video': 'https://youtu.be/SSE4M0gcmvE?si=XLCi-dfibyMsS45N',
      'article': 'https://www.researchgate.net/publication/351758474_Introduction_to_Artificial_Intelligence'
    },
    {
      'title': 'Python Essentials', // Fixed typo from "Phython Essentials"
      'video': 'https://youtu.be/SSE4M0gcmvE?si=XLCi-dfibyMsS45N',
      'article': 'https://www.researchgate.net/publication/351758474_Introduction_to_Artificial_Intelligence'
    },
    {
      'title': 'Introduction to AI',
      'video': 'https://youtu.be/SSE4M0gcmvE?si=XLCi-dfibyMsS45N',
      'article': 'https://www.researchgate.net/publication/351758474_Introduction_to_Artificial_Intelligence'
    },
    {
      'title': 'Fundamentals',
      'video': 'https://youtu.be/SSE4M0gcmvE?si=XLCi-dfibyMsS45N',
      'article': 'https://www.researchgate.net/publication/351758474_Introduction_to_Artificial_Intelligence'
    },
    {
      'title': 'Python Essentials', // Fixed typo from "Phython Essentials"
      'video': 'https://youtu.be/SSE4M0gcmvE?si=XLCi-dfibyMsS45N',
      'article': 'https://www.researchgate.net/publication/351758474_Introduction_to_Artificial_Intelligence'
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF121212), Color(0x752A1E11), Color(0xFFF78000)],
          stops: [0.0, 0.46, 1.0],
        ),
      ),
      child: Column(
        children: [
          Hero(
            tag: 'searchbar',
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 196, 196, 196).withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Roadmap(searchQuery: value),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: manualData.map((data) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: CustomCard(data: data),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
