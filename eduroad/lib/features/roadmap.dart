import 'package:eduroad/services/api_service.dart';
import 'package:flutter/material.dart';

class initRoadMap extends StatefulWidget{
    final String subject;
    initRoadMap(this.subject);

    @override
    _initRoadMapState createState() => _initRoadMapState();
}

class _initRoadMapState extends State<initRoadMap> {
    String? info;

    @override
    void initState(){
        super.initState();
        fetch();
    }

    Future<void> fetch() async {
        setState((){
            info = "Creating Roadmap for ${widget.subject}...";
        });
            //this would be the prompt to make the roadmap
            String content = "Make a list from simple to complex for a roadmap about ${widget.subject}. Just a list of concepts.";

            //the output of the prompt
            String roadmapText =  await ApiService.fetchInfo(content);
            List<String> roadmapItems = roadmapText.split("\n").where((e) => e.trim().isNotEmpty).toList();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(title: Text("Roadmap for $widget.subject")),
            body: Center(child: Text(info ?? "Fetching information...")),
        );
    }
}
