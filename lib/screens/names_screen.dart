import 'package:flutter/material.dart';
import '../data/names_data.dart';
import '../models/allah_name.dart';
import '../utils/neon_colors.dart';

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  String _searchQuery = '';
  List<AllahName> _filteredNames = [];

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
    return Column(
      children: [
        // رأس الصفحة
        _buildHeader(),
        
        // شريط البحث
        _buildSearchBar(),
        
        // قائمة الأسماء
        Expanded(
          child: _buildNamesList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'أسماء الله الحسنى',
            style: NeonColors.getNeonTextStyle(
              NeonColors.gold,
              fontSize: 24,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.3),
        ),
      ),
      child: TextField(
        onChanged: _filterNames,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'ابحث عن اسم...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: NeonColors.gold,
          ),
        ),
      ),
    );
  }

  Widget _buildNamesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredNames.length,
      itemBuilder: (context, index) {
        return _buildNameCard(_filteredNames[index]);
      },
    );
  }

  Widget _buildNameCard(AllahName name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // رقم الاسم
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NeonColors.gold.withOpacity(0.2),
                  border: Border.all(
                    color: NeonColors.gold,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${name.number}',
                    style: NeonColors.getNeonTextStyle(
                      NeonColors.gold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // الاسم
              Expanded(
                child: Text(
                  name.name,
                  style: NeonColors.getNeonTextStyle(
                    NeonColors.gold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // المعنى
          _buildInfoRow('المعنى:', name.meaning, NeonColors.green),
          const SizedBox(height: 8),
          // التعريف
          _buildInfoRow('التعريف:', name.description, NeonColors.blue),
          const SizedBox(height: 8),
          // الدلالة على الاتصاف بالاسم
          _buildInfoRow('الاتصاف:', name.howToEmbody, NeonColors.purple),
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
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
