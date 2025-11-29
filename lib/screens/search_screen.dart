import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
      _query = widget.initialQuery!;
    }
  }

  final List<String> _allItems = [
    'Wheat', 'Paddy', 'Maize', 'Cotton', 'Sugarcane',
    'Tomato', 'Potato', 'Onion',
    'Leaf Blight', 'Stem Borer', 'Rust',
    'PM Kissan', 'Soil Health Card',
    'Market Prices', 'Weather', 'Soil Test'
  ];

  @override
  Widget build(BuildContext context) {
    final results = _query.isEmpty 
        ? [] 
        : _allItems.where((item) => item.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (val) => setState(() => _query = val),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.search, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Search for crops, pests, or services', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(LucideIcons.search, size: 18, color: AppColors.primary),
                  title: Text(results[index]),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: ${results[index]}')));
                  },
                );
              },
            ),
    );
  }
}
