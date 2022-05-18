import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _wordPairList = <WordPair>[];
  final _savedPairs = Set<WordPair>();

  Widget _ListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _wordPairList.length) {
          _wordPairList.addAll(generateWordPairs().take(10)); /*4*/
        }
        return _buildRow(_wordPairList[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final isSaved = _savedPairs.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.red : Colors.grey,
        semanticLabel: isSaved ? 'Remove from Save' : 'Save',
      ),
      onTap: () => setState(
        () {
          isSaved ? _savedPairs.remove(pair) : _savedPairs.add(pair);
        },
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedPairs.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          );
          final List<Widget> divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Saved Word',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueGrey[600],
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPair Generator'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[600],
        actions: <Widget>[
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: _ListView(),
    );
  }
}
