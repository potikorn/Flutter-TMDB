import 'package:flutter/material.dart';
import '../movie/screen/movie_detail_screen.dart';

import '../dao/movie_response.dart';

class SimilarAndTrailerTabView extends StatefulWidget {
  final Future<MovieResponse> futureSimilarData;

  SimilarAndTrailerTabView({
    Key key,
    @required this.futureSimilarData,
  }) : super(key: key);

  @override
  _SimilarAndTrailerTabViewState createState() =>
      _SimilarAndTrailerTabViewState();
}

class _SimilarAndTrailerTabViewState extends State<SimilarAndTrailerTabView> {
  int _currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildTab(0, "Similar"),
            _buildTab(1, "Trailer"),
          ],
        ),
        (_currentTab == 0)
            ? _buildSimilarView(widget.futureSimilarData)
            : _buildTrailersView()
      ],
    );
  }

  Widget _buildTab(int currentTab, String tabName) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _nTabSelected(currentTab);
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          height: 48.0,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              (_currentTab == currentTab)
                  ? _buildSelectedTab(_currentTab)
                  : Container(),
              Center(
                child: Text(
                  tabName,
                  style: TextStyle(
                      color: (_currentTab == currentTab)
                          ? Colors.white
                          : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTab(_currentTab) {
    return SizedBox(
        width: double.infinity,
        height: 4.0,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(color: Colors.red)));
  }

  Widget _buildSimilarView(Future<MovieResponse> futureSimilarData) {
    return FutureBuilder(
      future: futureSimilarData,
      builder: (BuildContext context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          return _buildSimilarGrid(
              snapshot.data.movieDetails.take(12).toList());
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSimilarGrid(List<MovieDetails> movieDetails) {
    return GridView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: (movieDetails.length > 12) ? 12 : movieDetails.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 2 / 3),
      itemBuilder: (BuildContext context, int index) {
        return AspectRatio(
          aspectRatio: 2 / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(
                          data: movieDetails[index],
                        )),
              );
            },
            child: Card(
              elevation: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${movieDetails[index].posterPath}"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrailersView() {
    return Container(
      child: Text('1'),
    );
  }

  void _nTabSelected(int currentTab) {
    if (_currentTab == currentTab) return;
    setState(() {
      _currentTab = currentTab;
    });
  }
}
