import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteFacts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoriteFacts();
  }
}

class _FavoriteFacts extends State<FavoriteFacts> {
  bool loading = false;
  List<String> facts;

  @override
  void initState() {
    super.initState();
    _loadFacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => {Navigator.pop(context)}),
      ),
      body: Builder(builder: (BuildContext context) {
        if (loading) {
          return Center(
            child: Text("Chuck Norris te charge !"),
          );
        } else {
          return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemBuilder: (BuildContext context, int index) {
                if (index <= facts.length - 1) {
                  return Container(
                    child: Text(
                      facts[index],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                      fontWeight: FontWeight.bold),
                    ),
                  );
                }
              });
        }
      }),
    );
  }

  void _loadFacts() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = false;
      facts = prefs.getStringList("favorite_facts") ?? List<String>();
    });
  }
}
