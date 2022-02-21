import 'package:flutter/material.dart';
import 'package:flutter_movie_db/movie/screen/detail_screen.dart';

import '../dao/movie_response.dart' show MovieDetails;

class PosterListSection extends StatelessWidget {
  final String title;
  final double height;
  final List<MovieDetails> items;

  PosterListSection({Key key, this.title, this.height, @required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 8.0),
          child: Text(
            (title != null) ? title : "Not Defined",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        Container(
          height: (height != null) ? height : 200.0,
          child: (items.isNotEmpty) ? _buildPosterList() : _buildEmptyList(),
        ),
      ],
    );
  }

  Widget _buildPosterList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print('enter this');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                          movieId: items[index].id,
                        )));
          },
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${items[index].posterPath}"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Text('Empty Data'),
    );
  }
}
