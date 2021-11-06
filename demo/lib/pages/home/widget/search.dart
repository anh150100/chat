import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({
    Key? key,
    required TextEditingController searchController,
  }) : _searchController = searchController, super(key: key);

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        cursorColor: Colors.black,
        controller: _searchController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.5),
            ),
            hintText: "Search",
            border: InputBorder.none),
      ),
    );
  }
}