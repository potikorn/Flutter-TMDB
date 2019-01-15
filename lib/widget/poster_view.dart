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
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: (item.posterPath != null)
                  ? Image(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w185/${item.posterPath}"),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      child: Icon(
                        Icons.image,
                        size: 64.0,
                      ),
                      color: Colors.grey[500],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
