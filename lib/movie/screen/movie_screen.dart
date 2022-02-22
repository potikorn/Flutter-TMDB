import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_movie_db/movie/screen/movie_detail_screen.dart';
import 'package:flutter_movie_db/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../../dao/movie_response.dart';
import '../../widget/poster_list_section.dart';
import '../../widget/top_backdrop.dart';

class MovieScreen extends StatefulWidget {
  @override
  MovieScreenState createState() {
    return new MovieScreenState();
  }
}

class MovieScreenState extends State<MovieScreen> {
  var url = BASE_URL;
  var queryParameters = {
    'api_key': API_KEY,
  };
  final randomNumber = 0 + Random().nextInt(9 - 0);
  Future<MovieResponse> nowPlaying;
  Future<MovieResponse> popular;
  Future<MovieResponse> upcoming;
  Future<MovieResponse> topRated;

  @override
  void initState() {
    super.initState();
    debugPrint('Enter this again!@');
    nowPlaying = fetchNowPlayingMovies();
    popular = fetchPopularMovies();
    upcoming = fetchUpcomingMovies();
    topRated = fetchTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _buildNowplaying(nowPlaying),
              _buildDataList('Popular', popular),
              _buildDataList('Upcoming', upcoming),
              _buildDataList('Top Rated', topRated),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNowplaying(Future<MovieResponse> fetch) {
    return FutureBuilder(
      future: fetch,
      builder: (
        BuildContext context,
        AsyncSnapshot<MovieResponse> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: Icon(Icons.sync_problem));
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Container(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              final randomMovie = snapshot.data.movieDetails[randomNumber];
              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return MovieDetailScreen(data: randomMovie);
                        }),
                      );
                    },
                    child: TopBackDrop(
                      movieDetail: randomMovie,
                      isShowTitle: true,
                    ),
                  ),
                  PosterListSection(
                    title: "Now playing",
                    height: 250.0,
                    items: snapshot.data.movieDetails,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
        }
      },
    );
  }

  Widget _buildDataList(String title, Future<MovieResponse> fetchData) {
    return FutureBuilder<MovieResponse>(
      future: fetchData,
      builder: (
        BuildContext context,
        AsyncSnapshot<MovieResponse> snapshot,
      ) {
        if (snapshot.hasData) {
          return PosterListSection(
            title: title,
            height: 250.0,
            items: snapshot.data.movieDetails,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<MovieResponse> fetchNowPlayingMovies() async {
    var uri = Uri.https(url, '/3/movie/now_playing', queryParameters);
    final response = await http.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      debugPrint("fetch again!");
      return MovieResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }

  Future<MovieResponse> fetchPopularMovies() async {
    var uri = Uri.https(url, '/3/movie/popular', queryParameters);
    final response = await http.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      var movieResponse = MovieResponse.fromJson(json.decode(response.body));
      movieResponse.movieDetails.shuffle();
      return movieResponse;
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }

  Future<MovieResponse> fetchUpcomingMovies() async {
    var uri = Uri.https(url, '/3/movie/upcoming', queryParameters);
    final response = await http.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      var upcomingMovie = MovieResponse.fromJson(json.decode(response.body));
      upcomingMovie.movieDetails.shuffle();
      return upcomingMovie;
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }

  Future<MovieResponse> fetchTopRatedMovies() async {
    var uri = Uri.https(url, '/3/movie/top_rated', queryParameters);
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
