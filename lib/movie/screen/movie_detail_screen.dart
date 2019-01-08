import 'package:flutter/material.dart';

import '../../dao/movie_response.dart';

class MovieDetailScreen extends StatelessWidget {
  final MovieDetails data;

  MovieDetailScreen({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  "https://image.tmdb.org/t/p/w500/${data.backDropPath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text('data'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
