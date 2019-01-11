import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widget/circular_icon.dart';
import '../../widget/similar_and_trailer_view.dart';

import '../../dao/movie_response.dart';
import '../../dao/credits_response.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieDetails data;

  MovieDetailScreen({Key key, @required this.data}) : super(key: key);

  @override
  MovieDetailScreenState createState() {
    return new MovieDetailScreenState();
  }
}

class MovieDetailScreenState extends State<MovieDetailScreen> {
  var url = "api.themoviedb.org";

  var queryParameters = {
    'api_key': "2987da0f3538bdb63ed97b29c1571587",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  "https://image.tmdb.org/t/p/w500/${widget.data.backDropPath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularIcon(
                          icon: Icons.list,
                          radius: 45.0,
                        ),
                        SizedBox(width: 10.0),
                        CircularIcon(
                          icon: Icons.favorite_border,
                          radius: 45.0,
                        ),
                        SizedBox(width: 10.0),
                        CircularIcon(
                          icon: Icons.bookmark_border,
                          radius: 45.0,
                        ),
                        SizedBox(width: 10.0),
                        CircularIcon(
                          icon: Icons.star_border,
                          radius: 45.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FutureBuilder(
                          future: fetchMovieDetail(),
                          builder:
                              (context, AsyncSnapshot<MovieDetails> snapshot) {
                            if (snapshot.hasData) {
                              return _buildTitleAndOverview(snapshot.data);
                            } else {
                              return Container(width: 0.0, height: 0.0);
                            }
                          },
                        ),
                        FutureBuilder(
                          future: fetchCrews(),
                          builder: (context,
                              AsyncSnapshot<CreditsResponse> snapshot) {
                            if (snapshot.hasData) {
                              return _buildCastsAndCrewSection(snapshot.data);
                            } else {
                              return Container(width: 0.0, height: 0.0);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SimilarAndTrailerTabView(
                    futureSimilarData: fetchMovieSimilar(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndOverview(MovieDetails details) {
    final releaseDate = details.releaseDate.split('-').first;
    final runTimeHours = details.runtime ~/ 60;
    final runTimeMinute = details.runtime % 60;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${details.title}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        Row(
          children: <Widget>[
            Text(
              '$releaseDate',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              '$runTimeHours Hours $runTimeMinute min',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            '${details.overView}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCastsAndCrewSection(CreditsResponse creditResponse) {
    String castsText = "";
    final topCasts = creditResponse.cast.take(5).toList();
    topCasts.forEach((cast) => castsText += "${cast.name}, ");
    final director =
        creditResponse.crew.where((crew) => crew.job == 'Director').first;
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Casts: ', style: TextStyle(color: Colors.white)),
            Expanded(
              child: Text(castsText, style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Director: ', style: TextStyle(color: Colors.white)),
            Expanded(
              child: Text(director.name, style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ],
    );
  }

  Future<CreditsResponse> fetchCrews() async {
    var uri =
        Uri.https(url, '/3/movie/${widget.data.id}/credits', queryParameters);
    final response = await http.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      return CreditsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }

  Future<MovieDetails> fetchMovieDetail() async {
    var uri = Uri.https(url, '/3/movie/${widget.data.id}', queryParameters);
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

  Future<MovieResponse> fetchMovieSimilar() async {
    var uri =
        Uri.https(url, '/3/movie/${widget.data.id}/similar', queryParameters);
    final response = await http.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }
}
