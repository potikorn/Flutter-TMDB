import 'package:flutter/material.dart';
import '../movie/screen/movie_detail_screen.dart';
import '../dao/movie_response.dart' show MovieDetails;

class PosterView extends StatelessWidget {
  final MovieDetails item;

  PosterView({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(data: item),
            ),
          );
        },
        child: Card(
          elevation: 6.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://image.tmdb.org/t/p/w500/${item.posterPath}"),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
