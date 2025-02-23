import 'package:flutter/material.dart';
import 'package:eduroad/services/api_service.dart';

class initNotes extends StatefulWidget{
    final String title;

     const initNotes(this.title, {Key? key}) : super(key: key);

    @override
    _initNotesState createState() => _initNotesState();
}

class _initNotesState extends State<initNotes> {
    String? info;

    @override
    void initState(){
        super.initState();
        fetch();
    }

    Future<void> fetch() async {
        String prompt = "Create a detailed Notes about ${widget.title}. Include revelant links and videos.";
        String notes = await ApiService.fetchInfo(prompt);

        setState((){
            info = notes;
        });

    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: Center(
                child: info == null
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(info!),
                ),
            ),
        );
    }

}
