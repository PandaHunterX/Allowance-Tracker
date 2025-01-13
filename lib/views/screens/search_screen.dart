// lib/views/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:productivity_app/styles/text_style.dart';
import '../../controllers/data controller/search_bar.dart';
import '../widgets/search widgets/recent_data.dart';
import '../widgets/search widgets/date_sorting.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String _selectedMonth = 'All';

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onMonthSelected(String month) {
    setState(() {
      _selectedMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(onSearch: _updateSearchQuery),
        TitleText(
            words: 'Your Transaction History',
            size: 24,
            fontWeight: FontWeight.w800),
        Divider(),
        DateSorting(
          onMonthSelected: _onMonthSelected,
        ),
        Expanded(child: RecentDataList(searchQuery: _searchQuery, selectedMonth: _selectedMonth)),
      ],
    );
  }
}