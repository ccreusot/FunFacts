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
        title: Text("Favorite Facts", style: TextStyle(color: Colors.black),),
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
              itemBuilder: (BuildContext context, int index) {
            if (index <= facts.length - 1) {
              return ListTile(
                contentPadding: const EdgeInsets.all(12.0),
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          facts[index],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        color: Colors.black,
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.black,
                        onPressed: () => {},
                      ),
                    ],
                  ),
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
