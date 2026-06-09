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

  int _targetCount = 33;
  Color _selectedColor = const Color(0xFF00BFFF);
  DhikrCategory _selectedCategory = DhikrCategory.general;
  String _selectedFont = 'Cairo';

  final List<String> _fonts = [
    'Cairo',
    'Amiri',
    'Noto Naskh Arabic',
    'Reem Kufi',
    'Scheherazade New',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _nameController.dispose();
    _virtueController.dispose();
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
                  // رأس الصفحة
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

                  // نص الذكر
                  _buildLabel('نص الذكر', NeonColors.blue),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _textController,
                    hint: 'اكتب نص الذكر هنا...',
                    validator: (v) => v?.isEmpty ?? true ? 'الرجاء إدخال نص الذكر' : null,
                  ),
                  const SizedBox(height: 20),

                  // اسم الذكر
                  _buildLabel('اسم الذكر (للشاشة)', NeonColors.green),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'مثال: التسبيح، التحميد...',
                    validator: (v) => v?.isEmpty ?? true ? 'الرجاء إدخال اسم الذكر' : null,
                  ),
                  const SizedBox(height: 20),

                  // العدد المستهدف
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
                          inactiveColor: NeonColors.purple.withOpacity( 0.2),
                          label: '$_targetCount',
                          onChanged: (v) => setState(() => _targetCount = v.round()),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: NeonColors.darkCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NeonColors.purple.withOpacity( 0.3)),
                        ),
                        child: Text(
                          '$_targetCount',
                          style: NeonColors.getNeonTextStyle(NeonColors.purple, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // فضيلة الذكر
                  _buildLabel('الفضل (اختياري)', NeonColors.orange),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _virtueController,
                    hint: 'فضل هذا الذكر...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  // لون النيون
                  NeonColorPicker(
                    selectedColor: _selectedColor,
                    onColorChanged: (color) => setState(() => _selectedColor = color),
                  ),
                  const SizedBox(height: 20),

                  // نوع الخط
                  _buildLabel('نوع الخط', NeonColors.cyan),
                  const SizedBox(height: 8),
                  _buildFontPicker(),
                  const SizedBox(height: 20),

                  // التصنيف
                  _buildLabel('التصنيف', NeonColors.gold),
                  const SizedBox(height: 8),
                  _buildCategoryPicker(),
                  const SizedBox(height: 32),

                  // زر الحفظ
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
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
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
        hintStyle: TextStyle(color: Colors.white.withOpacity( 0.4)),
        filled: true,
        fillColor: NeonColors.darkCard.withOpacity( 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: NeonColors.gold.withOpacity( 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFontPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity( 0.5),
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

  Widget _buildCategoryPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity( 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DhikrCategory>(
          value: _selectedCategory,
          isExpanded: true,
          dropdownColor: NeonColors.darkCard,
          style: TextStyle(color: NeonColors.gold),
          items: DhikrCategory.values.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat.label, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedCategory = v!),
        ),
      ),
    );
  }

  Future<void> _saveCustomDhikr() async {
    if (!_formKey.currentState!.validate()) return;

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
      category: _selectedCategory,
    );

    await StorageService.saveCustomDhikr(dhikr);

    if (!mounted) return;
    Navigator.pop(context, true);
  }
}
