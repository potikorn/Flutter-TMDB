import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_movie_db/auth/login_screen.dart';
import 'package:flutter_movie_db/auth/main_auth.dart';
import 'package:flutter_movie_db/dao/video_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import '../../widget/circular_icon.dart';
import '../../widget/similar_and_trailer_view.dart';
import '../../widget/top_backdrop.dart';
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

  Future<MovieResponse> similarMovies;
  Future<MovieDetails> movieDetail;
  Future<VideoResponse> movieVideos;
  Future<CreditsResponse> credits;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool _isLogin;

  @override
  void initState() {
    super.initState();
    prefs.then((SharedPreferences prefs) {
      _isLogin = (prefs.getBool('is_login') ?? false);
    });
    similarMovies = fetchMovieSimilar();
    movieDetail = fetchMovieDetail();
    movieVideos = fetchMovieVideos();
    credits = fetchCrews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: TopBackDrop(movieDetail: widget.data),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  RaisedButton(
                    onPressed: () {
                      prefs.then((p) {
                        p.setBool('is_login', false);
                        _isLogin = false;
                      });
                    },
                    child: Text('Dump Logout'),
                  ),
                  // FIXME Show when ready
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
                          onTap: () {
                            if (!_isLogin) {
                              _buildUnauthorizedDialog();
                            } else {
                              // FIXME Plz I want to bookmark.
                            }
                          },
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
                    child: FutureBuilder(
                      future: Future.wait([movieDetail, credits])
                          .then((response) => Tuple2(response[0], response[1])),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Center(child: Icon(Icons.sync_problem));
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              var movieDetails = snapshot.data.item1;
                              var credits = snapshot.data.item2;
                              return Column(
                                children: <Widget>[
                                  _buildTitleAndOverview(movieDetails),
                                  _buildCastsAndCrewSection(credits)
                                ],
                              );
                            }
                        }
                      },
                    ),
                  ),
                  SimilarAndTrailerTabView(
                    futureSimilarData: similarMovies,
                    futureVideos: movieVideos,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _navigateToAuthScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    _isLogin = result ?? false;
  }

  Widget _buildTitleAndOverview(MovieDetails details) {
    final releaseDate = details.releaseDate.split('-').first;
    final runTimeHours = (details.runtime ?? 0) ~/ 60;
    final runTimeMinute = (details.runtime ?? 0) % 60;
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

  _buildUnauthorizedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Authentication',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            'Must Login first!',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Login Now!',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToAuthScreen();
              },
            )
          ],
        );
      },
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

  Future<VideoResponse> fetchMovieVideos() async {
    var uri =
        Uri.https(url, '/3/movie/${widget.data.id}/videos', queryParameters);
    final response = await http.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      return VideoResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }
}
