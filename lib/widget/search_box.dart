import 'dart:async';

import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final Function onTextChangedListener;

  const SearchBox({Key key, this.onTextChangedListener}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchQuery = TextEditingController();
  Timer debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          performSearch(_searchQuery.text);
        }
      });
    });
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  void performSearch(String query) {
    if (query.isEmpty) return;
    widget.onTextChangedListener(query);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[900]),
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchQuery,
        cursorColor: Colors.white,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          fillColor: Colors.grey[700],
          filled: true,
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[200],
          ),
          // suffixIcon: _buildSearchState(),
        ),
      ),
    );
  }
}
