import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';

class FavoriteFacts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoriteFacts();
  }
}

class ActionMenu {
  const ActionMenu({this.title});

  final String title;
}

const List<ActionMenu> actions = [
  const ActionMenu(title: "Partager"),
  const ActionMenu(title: "Effacer")
];

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
        title: Text(
          "Fact Favorite",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
            tooltip: "Ferme la page de favoris",
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => {Navigator.pop(context)}),
      ),
      body: Builder(builder: (BuildContext context) {
        if (loading) {
          return Center(
            child: Text("Chargement des facts !"),
          );
        } else {
          return ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.black,
                );
              },
              itemCount: facts.length,
              itemBuilder: (BuildContext context, int index) {

                final popupMenu = PopupMenuButton<ActionMenu>(
                    padding: const EdgeInsets.all(16.0),
                    onSelected: (ActionMenu action) {
                      if (action == actions[0]) {
                          _shareFact(index);
                      } else if (action == actions[1]) {
                        _removeFact(index);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        actions.map((ActionMenu action) {
                          return PopupMenuItem<ActionMenu>(
                            value: action,
                            child: Text(action.title),
                          );
                        }).toList());


                if (index <= facts.length - 1) {
                  return ListTile(
                    trailing: popupMenu,
                    title: Text(facts[index]),
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

  void _shareFact(int index) async {
    await Share.share(facts[index]);
  }

  void _removeFact(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    facts.removeAt(index);
    await prefs.setStringList("favorite_facts", facts);
    setState(() {
      loading = false;
      facts = prefs.getStringList("favorite_facts") ?? List<String>();
    });
  }
}
