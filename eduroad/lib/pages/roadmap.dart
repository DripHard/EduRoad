import 'package:eduroad/components/CustomCard.dart';
import 'package:eduroad/features/notes.dart';
import 'package:eduroad/features/roadmap.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Roadmap extends StatefulWidget {
  final String searchQuery;

  const Roadmap({super.key, required this.searchQuery});

  @override
  State<Roadmap>  createState() => _RoadmapState();
}

class _RoadmapState extends State<Roadmap> {
  late TextEditingController _searchController;
    List<String> titles = [];

    bool hasResult = false;

    Future<void> fetchData() async {
        List<String> results  = await RoadMapService.fetch(widget.searchQuery);
        setState(() {
            titles = results;
            hasResult = true;
        });
    }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
    void _onDelete(int index) {
        setState(() {
            titles.removeAt(index);
        });
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 45, 30, 0),
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
          if (!hasResult)
            AnimatedTextKit(
              animatedTexts: [
              TyperAnimatedText('Generating', textStyle: TextStyle(fontSize: 20, decoration: TextDecoration.none, color: Colors.white )),
              TyperAnimatedText('Roadmap...', textStyle: TextStyle(fontSize: 20, decoration: TextDecoration.none, color: Colors.white )),
            ],)
          else
            Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = titles.removeAt(oldIndex);
                  titles.insert(newIndex, item);
                });
              },
              proxyDecorator: (Widget child, int index, Animation<double> animation) {
                return Opacity(
                  opacity: 0.5,
                  child: child,
                );
              },
              children: titles.asMap().entries.map((entry) {
                int index = entry.key;
                String data = entry.value;

                return Dismissible(
                  key: ValueKey(data),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    color: const Color.fromARGB(255, 241, 118, 3),
                    height: 50,
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  onDismissed: (_) => _onDelete(index),
                  child: ReorderableDelayedDragStartListener(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: CustomCard(data: data,
                                        searchQuery: widget.searchQuery),
                    ),
                  ),
                );
              }).toList(),
            ),
          ), //Expanded
                ]
      ),
    );
  }
}
