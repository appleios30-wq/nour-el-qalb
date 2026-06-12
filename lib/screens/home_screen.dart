import 'package:flutter/material.dart';
import '../data/adhkar_data.dart';
import '../data/morning_adhkar_data.dart';
import '../data/evening_adhkar_data.dart';
import '../data/sleep_adhkar_data.dart';
import '../models/dhikr.dart';
import '../services/storage_service.dart';
import '../utils/neon_colors.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/dynamic_background.dart';
import 'tasbih_screen.dart';
import 'names_screen.dart';
import 'notes_screen.dart';
import 'add_dhikr_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Dhikr> _adhkar = [];
  List<Dhikr> _customAdhkar = [];
  Map<String, int> _progress = {};
  double _fontSizeMultiplier = 1.0;
  List<String> _categoryTabs = [];
  String _selectedTabId = 'morning';
  bool _editMode = false;
  Map<String, String> _selectedBackgrounds = {};

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final progress = await StorageService.getAdhkarProgress();
    final customAdhkar = await StorageService.getCustomDhikrs();
    final fontSettings = await StorageService.getFontSettings();
    final sizeStr = fontSettings['size'] ?? '1.0';
    final tabs = await StorageService.getCategoryTabs();
    final bgs = await StorageService.getAllSelectedBackgrounds();

    final adhkar = AdhkarData.defaultAdhkar;
    for (var dhikr in adhkar) {
      if (progress.containsKey(dhikr.id)) {
        dhikr.currentCount = progress[dhikr.id]!;
      }
    }

    for (var dhikr in customAdhkar) {
      if (progress.containsKey(dhikr.id)) {
        dhikr.currentCount = progress[dhikr.id]!;
      }
      if (progress.containsKey('${dhikr.id}_color')) {
        dhikr.neonColor = Color(progress['${dhikr.id}_color']!);
      }
    }

    setState(() {
      _adhkar = adhkar;
      _customAdhkar = customAdhkar;
      _progress = progress;
      _fontSizeMultiplier = double.tryParse(sizeStr) ?? 1.0;
      _categoryTabs = tabs;
      _selectedBackgrounds = bgs;
      if (!_categoryTabs.contains(_selectedTabId)) {
        _selectedTabId = _categoryTabs.isNotEmpty ? _categoryTabs.first : 'morning';
      }
    });
  }

  List<Dhikr> get _filteredAdhkar {
    final result = <Dhikr>[];
    for (final dhikr in _adhkar) {
      if (dhikr.isInCategory(_selectedTabId)) result.add(dhikr);
    }
    for (final dhikr in MorningAdhkarData.adhkar) {
      if (dhikr.isInCategory(_selectedTabId)) result.add(dhikr);
    }
    for (final dhikr in EveningAdhkarData.adhkar) {
      if (dhikr.isInCategory(_selectedTabId)) result.add(dhikr);
    }
    for (final dhikr in SleepAdhkarData.adhkar) {
      if (dhikr.isInCategory(_selectedTabId)) result.add(dhikr);
    }
    for (final dhikr in _customAdhkar) {
      if (dhikr.isInCategory(_selectedTabId)) {
        if (_progress.containsKey(dhikr.id)) {
          dhikr.currentCount = _progress[dhikr.id]!;
        }
        result.add(dhikr);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      backgroundColor: NeonColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        leading: _editMode
            ? IconButton(
                icon: Icon(Icons.close, color: NeonColors.gold, size: 26),
                onPressed: () => setState(() => _editMode = false),
              )
            : IconButton(
                icon: Icon(Icons.menu, color: NeonColors.gold, size: 26),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
        title: _editMode
            ? Text(
                'تعديل الأذكار',
                style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 20),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'بسم الله الرحمن الرحيم',
                    style: TextStyle(
                      color: NeonColors.gold.withOpacity(0.6),
                      fontSize: 10 * _fontSizeMultiplier,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'نور قلبك',
                    style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 26),
                  ),
                ],
              ),
        centerTitle: true,
        actions: [
          if (!_editMode) ...[
            IconButton(
              icon: Icon(Icons.search, color: NeonColors.gold, size: 26),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.edit, color: NeonColors.gold, size: 26),
              onPressed: () => setState(() => _editMode = true),
            ),
          ],
          if (_editMode)
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: NeonColors.gold, size: 26),
              onPressed: _openAddDhikr,
            ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Padding(
            padding: EdgeInsets.only(top: topPad + 60),
            child: Column(
              children: [
                _buildCategoryTabs(),
                Expanded(child: _buildAdhkarList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _editMode
          ? null
          : FloatingActionButton(
              backgroundColor: NeonColors.gold,
              onPressed: _openAddDhikr,
              child: Icon(Icons.add, color: NeonColors.darkBackground, size: 30),
            ),
    );
  }

  Widget _buildBackground() {
    final presetId = _selectedBackgrounds[_selectedTabId];
    final presets = backgroundPresets[_selectedTabId] ?? backgroundPresets['general']!;
    final preset = presetId != null
        ? presets.firstWhere((p) => p.id == presetId, orElse: () => presets.first)
        : presets.first;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: preset.gradientColors,
        ),
      ),
      child: CustomPaint(
        painter: _StarPainter(),
        child: Container(),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categoryTabs.length,
        itemBuilder: (context, index) {
          final tabId = _categoryTabs[index];
          final isSelected = tabId == _selectedTabId;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabId = tabId),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? NeonColors.gold.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? NeonColors.gold.withOpacity(0.6)
                      : Colors.white.withOpacity(0.1),
                ),
                boxShadow: isSelected
                    ? NeonColors.getNeonGlow(NeonColors.gold, intensity: 0.3)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    categoryLabel(tabId),
                    style: TextStyle(
                      color: isSelected ? NeonColors.gold : Colors.white54,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (!_editMode) ...[
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _showBackgroundPicker(tabId),
                      child: Icon(
                        Icons.palette_outlined,
                        color: isSelected
                            ? NeonColors.gold.withOpacity(0.7)
                            : Colors.white24,
                        size: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdhkarList() {
    final currentList = _filteredAdhkar;
    if (currentList.isEmpty) {
      return Center(
        child: Text(
          'لا توجد أذكار في هذا التصنيف',
          style: TextStyle(color: Colors.white38, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        final dhikr = currentList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: DhikrCard(
            dhikr: dhikr,
            editMode: _editMode,
            onTap: _editMode ? null : () => _openTasbih(dhikr),
            onEdit: dhikr.isCustom ? () => _editCustomDhikr(dhikr) : null,
            onDelete: dhikr.isCustom ? () => _deleteCustomDhikr(dhikr.id) : null,
            leading: _editMode
                ? ReorderableDragStartListener(
                    index: index,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.drag_handle, color: Colors.white38, size: 20),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  void _showBackgroundPicker(String categoryId) {
    final presets = backgroundPresets[categoryId] ?? backgroundPresets['general']!;
    final current = _selectedBackgrounds[categoryId];
    showModalBottomSheet(
      context: context,
      backgroundColor: NeonColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اختر الخلفية',
              style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...presets.map((preset) => GestureDetector(
              onTap: () async {
                await StorageService.setSelectedBackground(categoryId, preset.id);
                await _loadAllData();
                if (mounted) Navigator.pop(ctx);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: preset.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: current == preset.id
                        ? NeonColors.gold
                        : Colors.white.withOpacity(0.15),
                    width: current == preset.id ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      current == preset.id ? Icons.check_circle : Icons.circle_outlined,
                      color: NeonColors.gold,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      preset.name,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _openAddDhikr() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDhikrScreen()),
    );
    await _loadAllData();
  }

  void _editCustomDhikr(Dhikr dhikr) {
    _showEditDhikrDialog(dhikr);
  }

  void _showEditDhikrDialog(Dhikr dhikr) {
    final textController = TextEditingController(text: dhikr.text);
    final nameController = TextEditingController(text: dhikr.arabicName);
    final virtueController = TextEditingController(text: dhikr.virtue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeonColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
        ),
        title: Text(
          'تعديل الذكر',
          style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'نص الذكر',
                  labelStyle: TextStyle(color: NeonColors.gold),
                  filled: true,
                  fillColor: NeonColors.darkBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'اسم الذكر',
                  labelStyle: TextStyle(color: NeonColors.gold),
                  filled: true,
                  fillColor: NeonColors.darkBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: virtueController,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'الفضل',
                  labelStyle: TextStyle(color: NeonColors.gold),
                  filled: true,
                  fillColor: NeonColors.darkBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              dhikr.text = textController.text.trim();
              dhikr.arabicName = nameController.text.trim();
              dhikr.virtue = virtueController.text.trim();
              await StorageService.updateCustomDhikr(dhikr);
              if (mounted) {
                Navigator.pop(ctx);
                await _loadAllData();
              }
            },
            child: Text('حفظ', style: TextStyle(color: NeonColors.gold)),
          ),
        ],
      ),
    );
  }

  // ===== القائمة الجانبية =====
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: NeonColors.darkBackground,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [NeonColors.darkCard, NeonColors.darkBackground],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'بسم الله الرحمن الرحيم',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      color: NeonColors.gold,
                      fontSize: 22,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: NeonColors.gold, width: 2),
                      boxShadow: NeonColors.getNeonGlow(NeonColors.gold, intensity: 0.5),
                    ),
                    child: Icon(Icons.nightlight_round, color: NeonColors.gold, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'نور قلبك',
                    style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 22),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildDrawerItem(
              icon: Icons.menu_book,
              title: 'الأذكار',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.star_outline,
              title: 'أسماء الله الحسنى',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NamesScreen()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.note_alt_outlined,
              title: 'الملاحظات',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen()));
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Divider(color: Colors.white12),
            ),
            _buildDrawerItem(
              icon: Icons.settings_outlined,
              title: 'الإعدادات',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'عن البرنامج',
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('نور قلبك v1.0', style: TextStyle(color: Colors.white24, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: NeonColors.gold, size: 22),
      title: Text(
        title,
        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 15),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeonColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
        ),
        title: Text(
          'نور قلبك',
          style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 22),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'تطبيق أذكار يومية مع تأثيرات نيون متوهجة',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text('الإصدار 1.0', style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              'نسأل الله أن ينفع بهذا التطبيق',
              style: TextStyle(
                color: NeonColors.gold.withOpacity(0.6),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: NeonColors.gold)),
          ),
        ],
      ),
    );
  }

  void _openTasbih(Dhikr dhikr) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TasbihScreen(selectedDhikr: dhikr)),
    ).then((_) => _loadAllData());
  }

  Future<void> _deleteCustomDhikr(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeonColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('حذف الذكر', style: TextStyle(color: NeonColors.gold)),
        content: Text('هل أنت متأكد من حذف هذا الذكر؟', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('إلغاء', style: TextStyle(color: Colors.white54))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('حذف', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (confirm == true) {
      await StorageService.deleteCustomDhikr(id);
      await _loadAllData();
    }
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 80; i++) {
      final x = (i * 13.7) % size.width;
      final y = (i * 7.3) % size.height;
      final r = (i % 3) * 0.5 + 0.3;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
