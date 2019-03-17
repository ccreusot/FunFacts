import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String fact = "Chuck Norris te balance une fact !";

  @override
  void initState() {
    super.initState();
    _loadRandomFact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          leading: IconButton(
            tooltip: "Ouvre le menu des Facts préférées.",
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () => {Navigator.pushNamed(context, "/favorites")}),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(32),
              child: Stack(
                children: <Widget>[
                  Container(
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.only(bottom: 64.0),
                      child: Semantics(
                        liveRegion: true,
                        label: "Fact : ",
                        child: Text(
                          "\"$fact\"",
                          style: TextStyle(
                            fontSize: 28.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )),
                  Container(
                      alignment: AlignmentDirectional.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MergeSemantics(
                              child: Semantics(
                                label: "Charger une nouvelle fact",
                                child: RawMaterialButton(
                                  child: Icon(
                                    Icons.refresh,
                                    size: 64.0,
                                  ),
                                  onPressed: _reloadRandomFact,
                                  shape: CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: Colors.blueGrey[300],
                                  padding: const EdgeInsets.all(16.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MergeSemantics(
                              child: Semantics(
                                label: "Ajouter la fact au favoris",
                                child: RawMaterialButton(
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: 48.0,
                                  ),
                                  shape: CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: Colors.blueGrey[100],
                                  padding: const EdgeInsets.all(16.0),
                                  onPressed: () => _saveFact(context),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ));
        }));
  }

  void _reloadRandomFact() {
    _loadRandomFact();
  }

  void _loadRandomFact() async {
    String url =
        "https://www.chucknorrisfacts.fr/api/get?data=tri:alea;type:txt;nb:1";
    http.Response response = await http.get(url);
    var body = json.decode(response.body);
    var unescape = HtmlUnescape();
    setState(() {
      fact = unescape.convert(body[0]['fact']);
    });
    SemanticsService.announce("Nouvelle fact chargée", TextDirection.ltr);
  }

  void _saveFact(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var facts = prefs.getStringList("favorite_facts") ?? List<String>();
    var found = facts.singleWhere((item) => fact == item, orElse: () => null);
    if (found == null) {
      facts.add(fact);
      SemanticsService.announce("Fact sauvegardé", TextDirection.ltr);
    } else {
      final snackbar = SnackBar(
          content: Text("Chuck Norris ne sauvegarde jamais la même fact..."));
      Scaffold.of(context).showSnackBar(snackbar);
    }
    await prefs.setStringList("favorite_facts", facts);
  }
}
