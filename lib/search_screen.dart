import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_movie_db/dao/movie_response.dart';
import 'package:flutter_movie_db/utils/constants.dart';
import 'package:flutter_movie_db/widget/poster_view.dart';
import 'package:flutter_movie_db/widget/search_box.dart';

import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<MovieResponse> fetchSearchResult;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SearchBox(
            onTextChangedListener: (text) {
              debugPrint('Enter this again!');
              fetchSearchResult = fetchSearchQuery(text);
              setState(() {});
            },
          ),
          _buildSearchResult(),
        ],
      ),
    );
  }

  Widget _buildSearchResult() {
    return FutureBuilder(
      future: fetchSearchResult,
      builder: (BuildContext context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.movieDetails.isNotEmpty) {
            return _buildPosterGrid(
                snapshot.data.movieDetails.take(12).toList());
          } else {
            return Container(
              height: 200.0,
              child: Center(
                child: Text('No related movies'),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildPosterGrid(List<MovieDetails> movieDetails) {
    return Expanded(
      child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          itemCount: (movieDetails.length > 12) ? 12 : movieDetails.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 2 / 3),
          itemBuilder: (BuildContext context, int index) =>
              PosterView(item: movieDetails[index])),
    );
  }

  Future<MovieResponse> fetchSearchQuery(String query) async {
    var uri = Uri.https(
      BASE_URL,
      '/3/search/multi',
      {
        'api_key': API_KEY,
        'query': query,
      },
    );
    final response = await http.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return MovieResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }
}
