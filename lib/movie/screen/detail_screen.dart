import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_movie_db/dao/movie_response.dart';

var url = "api.themoviedb.org";
// var apiToken = "2987da0f3538bdb63ed97b29c1571587";
var queryParameters = {
  'api_key': "2987da0f3538bdb63ed97b29c1571587",
};

class DetailScreen extends StatelessWidget {
  final int movieId;
  const DetailScreen({Key key, this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder<MovieDetails>(
            future: fetchMovieDetail(),
            builder:
                (BuildContext context, AsyncSnapshot<MovieDetails> snapshot) {
              if (snapshot.hasData) {
                return _movieDetailWidget(snapshot.data);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<MovieDetails> fetchMovieDetail() async {
    var uri = Uri.https(url, '/3/movie/$movieId', queryParameters);
    final response = await http.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      return MovieDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }
}

Widget _movieDetailWidget(MovieDetails movieDetail) {
  return Column(
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://image.tmdb.org/t/p/w500/${movieDetail.backDropPath}"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            width: 130.0,
            left: 8.0,
            bottom: -130,
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
                            "https://image.tmdb.org/t/p/w500/${movieDetail.posterPath}"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      Padding(
        padding: EdgeInsets.only(left: 146.0),
        child: Container(
          padding: EdgeInsets.only(right: 8.0),
          width: double.infinity,
          height: 130.0,
          // color: Colors.amberAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movieDetail.title,
                style: TextStyle(fontSize: 24.0),
              ),
              Text('(rate) ${movieDetail.releaseDate}'),
              Text('${movieDetail.genres[0].name} ๐ (length)'),
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Text(movieDetail.overView),
      )
    ],
  );
}
