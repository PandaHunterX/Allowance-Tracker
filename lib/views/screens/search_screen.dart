import 'package:flutter/material.dart';
import 'package:productivity_app/styles/textstyle.dart';
import '../../controllers/search_bar.dart';
import '../widgets/recent_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(onSearch: _updateSearchQuery),
        TitleText(words: 'Your Transaction History', size: 24, fontWeight: FontWeight.w800),
        Divider(),
        Expanded(child: RecentDataList(searchQuery: _searchQuery)),
      ],
    );
  }
}