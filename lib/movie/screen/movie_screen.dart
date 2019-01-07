import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../dao/movie_response.dart';
import '../../widget/poster_list_section.dart';

class MovieScreen extends StatefulWidget {
  @override
  MovieScreenState createState() {
    return new MovieScreenState();
  }
}

class MovieScreenState extends State<MovieScreen> {
  var url = "api.themoviedb.org";
  // var apiToken = "2987da0f3538bdb63ed97b29c1571587";
  var queryParameters = {
    'api_key': "2987da0f3538bdb63ed97b29c1571587",
  };
  Future<MovieResponse> fetchNowPlayingMovies() async {
    var uri = Uri.https(url, '/3/movie/now_playing', queryParameters);
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

  Future<MovieResponse> fetchPopulargMovies() async {
    var uri = Uri.https(url, '/3/movie/popular', queryParameters);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              PosterListSection(
                title: 'Popular Movie',
                height: 200.0,
                items: [],
              ),
              _buildDataList('Now Playing', fetchNowPlayingMovies()),
              _buildDataList('Popular', fetchPopulargMovies()),
              _buildDataList('Now Playing', fetchNowPlayingMovies()),
              _buildDataList('Now Playing', fetchNowPlayingMovies()),
            ]),
          )
        ],
      ),
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
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
