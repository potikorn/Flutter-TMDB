import 'package:flutter/material.dart';

import '../movie/screen/movie_detail_screen.dart';
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
        return AspectRatio(
          aspectRatio: 2 / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(
                          data: items[index],
                        )),
              );
            },
            child: Card(
              // margin: EdgeInsets.all(8.0),
              elevation: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${items[index].posterPath}"),
                      fit: BoxFit.cover),
                ),
                child: Center(
                  child: Text('${items[index].title}'),
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
