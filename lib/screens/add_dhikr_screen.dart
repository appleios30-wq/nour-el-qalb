import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../services/storage_service.dart';
import '../utils/neon_colors.dart';
import '../widgets/neon_color_picker.dart';

class AddDhikrScreen extends StatefulWidget {
  const AddDhikrScreen({super.key});

  @override
  State<AddDhikrScreen> createState() => _AddDhikrScreenState();
}

class _AddDhikrScreenState extends State<AddDhikrScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _nameController = TextEditingController();
  final _virtueController = TextEditingController();
  final _newCategoryController = TextEditingController();

  int _targetCount = 33;
  Color _selectedColor = const Color(0xFF00BFFF);
  Set<String> _selectedCategories = {'morning'};
  String _selectedFont = 'Cairo';
  List<String> _categoryTabs = [];

  final List<String> _fonts = [
    'Cairo',
    'Amiri',
    'Noto Naskh Arabic',
    'Reem Kufi',
    'Scheherazade New',
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final tabs = await StorageService.getCategoryTabs();
    setState(() => _categoryTabs = tabs);
  }

  @override
  void dispose() {
    _textController.dispose();
    _nameController.dispose();
    _virtueController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0a0a1a),
              Color(0xFF1a0a2a),
              Color(0xFF0a0a1a),
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'إضافة ذكر جديد',
                        style: NeonColors.getNeonTextStyle(
                          NeonColors.gold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildLabel('نص الذكر', NeonColors.blue),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _textController,
                    hint: 'اكتب نص الذكر هنا...',
                    validator: (v) => v?.isEmpty ?? true ? 'الرجاء إدخال نص الذكر' : null,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('اسم الذكر (للشاشة)', NeonColors.green),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'مثال: التسبيح، التحميد...',
                    validator: (v) => v?.isEmpty ?? true ? 'الرجاء إدخال اسم الذكر' : null,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('العدد المستهدف', NeonColors.purple),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _targetCount.toDouble(),
                          min: 1,
                          max: 1000,
                          divisions: 999,
                          activeColor: NeonColors.purple,
                          inactiveColor: NeonColors.purple.withOpacity(0.2),
                          label: '$_targetCount',
                          onChanged: (v) => setState(() => _targetCount = v.round()),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: NeonColors.darkCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NeonColors.purple.withOpacity(0.3)),
                        ),
                        child: Text(
                          '$_targetCount',
                          style: NeonColors.getNeonTextStyle(NeonColors.purple, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('الفضل (اختياري)', NeonColors.orange),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _virtueController,
                    hint: 'فضل هذا الذكر...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  NeonColorPicker(
                    selectedColor: _selectedColor,
                    onColorChanged: (color) => setState(() => _selectedColor = color),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('نوع الخط', NeonColors.cyan),
                  const SizedBox(height: 8),
                  _buildFontPicker(),
                  const SizedBox(height: 20),

                  _buildLabel('التصنيفات (اختيار متعدد)', NeonColors.gold),
                  const SizedBox(height: 8),
                  _buildCategoryCheckboxes(),
                  const SizedBox(height: 12),
                  _buildAddCategoryButton(),
                  const SizedBox(height: 32),

                  GestureDetector(
                    onTap: _saveCustomDhikr,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [NeonColors.gold, NeonColors.orange],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: NeonColors.getNeonGlow(NeonColors.gold),
                      ),
                      child: const Center(
                        child: Text(
                          'حفظ الذكر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: NeonColors.darkCard.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: NeonColors.gold.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildFontPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFont,
          isExpanded: true,
          dropdownColor: NeonColors.darkCard,
          style: TextStyle(color: NeonColors.cyan),
          items: _fonts.map((font) {
            return DropdownMenuItem(
              value: font,
              child: Text(font, style: TextStyle(color: Colors.white, fontFamily: font)),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedFont = v!),
        ),
      ),
    );
  }

  Widget _buildCategoryCheckboxes() {
    if (_categoryTabs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'لا توجد تصنيفات متاحة',
          style: TextStyle(color: Colors.white38, fontSize: 14),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: _categoryTabs.map((catId) {
          final isSelected = _selectedCategories.contains(catId);
          return CheckboxListTile(
            title: Text(
              categoryLabel(catId),
              style: TextStyle(
                color: isSelected ? NeonColors.gold : Colors.white70,
                fontSize: 15,
              ),
            ),
            value: isSelected,
            activeColor: NeonColors.gold,
            checkColor: Colors.black,
            onChanged: (v) {
              setState(() {
                if (v == true) {
                  _selectedCategories.add(catId);
                } else {
                  _selectedCategories.remove(catId);
                }
              });
            },
            dense: true,
            controlAffinity: ListTileControlAffinity.trailing,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddCategoryButton() {
    return GestureDetector(
      onTap: _showAddCategoryDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: NeonColors.gold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: NeonColors.gold.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: NeonColors.gold, size: 18),
            const SizedBox(width: 8),
            Text(
              'إضافة تبويب جديد',
              style: TextStyle(color: NeonColors.gold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    _newCategoryController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeonColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
        ),
        title: Text(
          'إضافة تبويب جديد',
          style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: _newCategoryController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'مثال: أذكار الصلاة',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: NeonColors.darkBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              final name = _newCategoryController.text.trim();
              if (name.isEmpty) return;
              await StorageService.addCategoryTab(name);
              await _loadCategories();
              if (!mounted) return;
              Navigator.pop(ctx);
            },
            child: Text('إضافة', style: TextStyle(color: NeonColors.gold)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCustomDhikr() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('الرجاء اختيار تصنيف واحد على الأقل'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final dhikr = Dhikr(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      text: _textController.text.trim(),
      arabicName: _nameController.text.trim(),
      neonColor: _selectedColor,
      targetCount: _targetCount,
      virtue: _virtueController.text.trim().isEmpty
          ? 'ذكر مخصص'
          : _virtueController.text.trim(),
      isCustom: true,
      fontFamily: _selectedFont,
      categoryIds: _selectedCategories.toList(),
    );

    await StorageService.saveCustomDhikr(dhikr);

    if (!mounted) return;
    Navigator.pop(context, true);
  }
}
