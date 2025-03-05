import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:eduroad/pages/roadmap.dart';
import 'package:eduroad/services/store_service.dart';
import 'dart:convert';

class HomePageAccount extends StatefulWidget {
  const HomePageAccount({super.key});

  @override
  _HomePageAccountState createState() => _HomePageAccountState();
}

class _HomePageAccountState extends State<HomePageAccount> {
  TextEditingController searchController = TextEditingController();
  List<String> recentSearches = [];

    @override
    void initState(){
        super.initState();
        fetchRecent();
    }

    Future<void> fetchRecent() async {
        List<String> searches = await LocalStorage.readSearchHistory();
        setState((){
            recentSearches = searches;
        });

    }

  void addSearch(String query) {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches.removeLast(); // Keep only the last 5 searches
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF121212), // Dark sidebar background
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 20),
              Text(
                "Recent Searches",
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              ...recentSearches.map(
                (search) => ListTile(
                  title: Text(
                    search,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    searchController.text = search; // Autofill search bar
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF121212), Color(0x752A1E11), Color(0xFFF78000)],
              stops: [0.0, 0.46, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder:
                              (context) => IconButton(
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'ed',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: 'R',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: RichText(
                        text: TextSpan(
                          text: 'Welcome, Keane!',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 30,
                right: 30,
                bottom: 100,
                child: Hero(
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
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: GoogleFonts.bricolageGrotesque(
                                fontSize: 18,
                                color: const Color.fromARGB(
                                  255,
                                  196,
                                  196,
                                  196,
                                ).withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 35,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            onSubmitted: (value) {
                              addSearch(
                                value,
                              ); // Save search to recent searches
                              if (value.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => Roadmap(searchQuery: value),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.2),
                                          end: const Offset(0, 0),
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeIn,
                                          ),
                                        ),
                                        child: child,
                                      );
                                    },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
