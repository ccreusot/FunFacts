import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String fact = "Loading";

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
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.center,
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                  "\"$fact\"",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                  ),
                )),
                Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        iconSize: 64.0,
                        onPressed: _reloadRandomFact,
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        iconSize: 48.0,
                        onPressed: () => {},
                      )
                    ],
                  )
                ),
              ],
            )));
  }

  void _reloadRandomFact() {
    _loadRandomFact();
  }

  _loadRandomFact() async {
    String url =
        "https://www.chucknorrisfacts.fr/api/get?data=tri:alea;type:txt;nb:1";
    http.Response response = await http.get(url);
    var body = json.decode(response.body);
    var unescape = HtmlUnescape();
    setState(() {
      fact = unescape.convert(body[0]['fact']);
    });
  }
}
