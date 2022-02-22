import 'package:flutter/material.dart';
import 'package:flutter_movie_db/dao/movie_response.dart';

class TopBackDrop extends StatelessWidget {
  final MovieDetails movieDetail;
  final isShowTitle;

  const TopBackDrop({
    Key key,
    this.movieDetail,
    this.isShowTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://image.tmdb.org/t/p/w780/${movieDetail.backDropPath}"),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.grey[850],
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            Visibility(
              visible: (isShowTitle != null) ? true : false,
              child: Positioned(
                bottom: 20.0,
                left: 16.0,
                child: Text(
                  '${movieDetail.title}',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
