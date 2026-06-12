import 'package:flutter/material.dart';
import '../data/names_data.dart';
import '../models/allah_name.dart';
import '../utils/neon_colors.dart';
import '../widgets/dynamic_background.dart';

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  String _searchQuery = '';
  List<AllahName> _filteredNames = [];
  bool _showSearch = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredNames = NamesData.names;
  }

  void _filterNames(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredNames = NamesData.names;
      } else {
        _filteredNames = NamesData.names.where((name) =>
          name.name.contains(query) ||
          name.meaning.contains(query) ||
          name.description.contains(query)
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: NeonColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: NeonColors.gold, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: _showSearch
            ? TextField(
                controller: _searchController,
                onChanged: _filterNames,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'ابحث عن اسم...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  border: InputBorder.none,
                ),
              )
            : Text(
                'أسماء الله الحسنى',
                style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 24),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showSearch ? Icons.close : Icons.search,
              color: NeonColors.gold,
              size: 26,
            ),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  _filterNames('');
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const DynamicBackground(),
          Padding(
            padding: EdgeInsets.only(top: topPad + 60),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredNames.length,
              itemBuilder: (context, index) {
                return _buildNameCard(_filteredNames[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard(AllahName name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // رقم الاسم مع أيقونة زخرفية
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NeonColors.gold.withOpacity(0.12),
              border: Border.all(color: NeonColors.gold.withOpacity(0.5), width: 1.5),
            ),
            child: Center(
              child: Text(
                '${name.number}',
                style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // معلومات الاسم
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.name,
                  style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 22),
                ),
                const SizedBox(height: 6),
                _buildInfoRow('المعنى:', name.meaning, NeonColors.green),
                const SizedBox(height: 4),
                _buildInfoRow('التعريف:', name.description, NeonColors.blue),
                const SizedBox(height: 4),
                _buildInfoRow('الاتصاف:', name.howToEmbody, NeonColors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
          ),
        ),
      ],
    );
  }
}
