import 'package:flutter/material.dart';
import 'package:get_inspired/QuoteSlide.dart';
import 'package:get_inspired/TitleWidget.dart';
import 'FavouritesPage.dart';
import 'Quote.dart';
import 'RemoteService.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController controller = PageController();

  List<Quote>? quotes;
  List<Quote> favouriteQuotes = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getQuotes();
  }

  _getQuotes() async {
    quotes = await RemoteService().fetchQuotes();
    quotes?.shuffle();
    if (quotes != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  _addQuoteToFavourites(Quote quote) {
    var result = favouriteQuotes.where((element) =>
        element.text == quote.text && element.author == quote.author);

    if (result.isEmpty) {
      favouriteQuotes.add(quote);
    }
  }

  var counter = 0;

  Color _getSlideColor() {
    final List<Color> slideColors = [
      Colors.pink,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.amber,
      Colors.cyan
    ];

    if (counter == 5) {
      counter = 0;
    } else {
      counter++;
    }
    return slideColors[counter];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FavouritesPage(
                        favouriteQuotes: favouriteQuotes,
                      )),
            );
          },
          child: const Icon(
            Icons.favorite,
            color: Colors.pinkAccent,
          )),
      body: Stack(children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: quotes?.length,
          itemBuilder: (context, index) {
            return QuoteSlide(
              slideColor: _getSlideColor(),
              quote: quotes?[index] ?? Quote(text: "", author: ""),
              onFavouriteSelected: (Quote quote) =>
                  _addQuoteToFavourites(quote),
            );
          },
        ),
        const SafeArea(child: TitleWidget())
      ]),
    );
  }
}
