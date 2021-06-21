import 'package:flutter/material.dart';
import 'package:pokemon_tcg/pokemon_tcg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String _apiKey = "7ac0ef65-12c3-4a0b-86e3-8cdc3a31eac6";
  static late PokemonTcgApi _api;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track your poke',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Pokemon Cards List")),
        body: PokemonList(),
      ),
    );
  }

  static PokemonTcgApi get api => _api;

  static String get apiKey => _apiKey;

  static set api(PokemonTcgApi value) {
    _api = value;
  }
}

class PokemonList extends StatefulWidget {
  const PokemonList({Key? key}) : super(key: key);

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final _cards = <PokemonCard>[];
  int _cardsPage = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd)
              return const Divider(
                color: Colors.grey,
              );

            if (!projectSnap.hasData) {
              print("no data found");
              return new Container();
            }

            final index = i ~/ 2;
            var cards;
            if (index >= _cards.length) {
              cards = projectSnap.data as List<PokemonCard>;
              _cardsPage = _cardsPage + 1;
              _cards.addAll(cards);
            }
            print("card ${_cards[index]}");
            return _cardRow(card: _cards[index]);
          },
        );
      },
      future: _getNextCardPage(),
    );
  }

  Widget _cardRow({required PokemonCard card}) {
    return Material(
        child: ListTile(
      title: Text(
        card.name,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 18.0),
      ),
      onTap: () => print("${card.name} tapped"),
    ));
  }

  _getNextCardPage() async {
    return await MyApp.api.getCards(page: _cardsPage);
  }

  @override
  void initState() {
    MyApp.api = PokemonTcgApi(apiKey: MyApp.apiKey);
    super.initState();
  }
}
