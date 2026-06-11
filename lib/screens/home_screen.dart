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
import 'font_settings_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Dhikr> _adhkar = [];
  List<Dhikr> _customAdhkar = [];
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;
  Map<String, int> _progress = {};
  double _fontSizeMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _loadFontSize();
  }

  Future<void> _loadAllData() async {
    final progress = await StorageService.getAdhkarProgress();
    final customAdhkar = await StorageService.getCustomDhikrs();
    final fontSettings = await StorageService.getFontSettings();
    final sizeStr = fontSettings['size'] ?? '1.0';

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
    });
  }

  Future<void> _loadFontSize() async {
    final fontSettings = await StorageService.getFontSettings();
    final sizeStr = fontSettings['size'] ?? '1.0';
    setState(() {
      _fontSizeMultiplier = double.tryParse(sizeStr) ?? 1.0;
    });
  }

  List<Dhikr> get _currentCategoryAdhkar {
    final category = _categories[_selectedCategoryIndex];
    List<Dhikr> result = [];

    switch (category) {
      case DhikrCategory.general:
        result.addAll(_adhkar);
        result.addAll(_customAdhkar.where((d) => d.category == DhikrCategory.general));
        break;
      case DhikrCategory.morning:
        result.addAll(MorningAdhkarData.adhkar);
        result.addAll(_customAdhkar.where((d) => d.category == DhikrCategory.morning));
        break;
      case DhikrCategory.evening:
        result.addAll(EveningAdhkarData.adhkar);
        result.addAll(_customAdhkar.where((d) => d.category == DhikrCategory.evening));
        break;
      case DhikrCategory.sleep:
        result.addAll(SleepAdhkarData.adhkar);
        result.addAll(_customAdhkar.where((d) => d.category == DhikrCategory.sleep));
        break;
    }

    for (var dhikr in result) {
      if (_progress.containsKey(dhikr.id)) {
        dhikr.currentCount = _progress[dhikr.id]!;
      }
    }

    return result;
  }

  static const List<DhikrCategory> _categories = [
    DhikrCategory.general,
    DhikrCategory.morning,
    DhikrCategory.evening,
    DhikrCategory.sleep,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          const DynamicBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildCategoryTabs(),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeonColors.darkCard.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: NeonColors.gold.withOpacity(0.3),
                ),
              ),
              child: Icon(Icons.menu, color: NeonColors.gold, size: 22),
            ),
          ),
          Column(
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
                style: NeonColors.getNeonTextStyle(
                  NeonColors.gold,
                  fontSize: 26,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeonColors.darkCard.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: NeonColors.gold.withOpacity(0.3),
                ),
              ),
              child: Icon(Icons.search, color: NeonColors.gold, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: NeonColors.darkBackground,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    NeonColors.darkCard,
                    NeonColors.darkBackground,
                  ],
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
                      fontSize: 20,
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
                    child: Icon(
                      Icons.nightlight_round,
                      color: NeonColors.gold,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'نور قلبك',
                    style: NeonColors.getNeonTextStyle(
                      NeonColors.gold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildDrawerItem(
              icon: Icons.menu_book,
              title: 'الأذكار',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            _buildDrawerItem(
              icon: Icons.add_circle_outline,
              title: 'إضافة ذكر مخصص',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddDhikrScreen()),
                ).then((_) => _loadAllData());
              },
            ),
            _buildDrawerItem(
              icon: Icons.star_outline,
              title: 'أسماء الله الحسنى',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            _buildDrawerItem(
              icon: Icons.note_alt_outlined,
              title: 'الملاحظات',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 3;
                });
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                ).then((_) => _loadAllData());
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
              child: Text(
                'نور قلبك v1.0',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 12,
                ),
              ),
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
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: 15,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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
            Text(
              'الإصدار 1.0',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
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
            child: Text(
              'إغلاق',
              style: TextStyle(color: NeonColors.gold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final currentList = _currentCategoryAdhkar;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: NeonColors.darkCard.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedCategoryIndex == index;
                final category = _categories[index];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getCategoryColor(index).withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            category.label,
                            style: TextStyle(
                              color: isSelected
                                  ? _getCategoryColor(index)
                                  : Colors.white54,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${currentList.length}',
                            style: TextStyle(
                              color: isSelected
                                  ? _getCategoryColor(index)
                                  : Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          _buildProgressBar(currentList),
        ],
      ),
    );
  }

  Widget _buildProgressBar(List<Dhikr> list) {
    final total = list.length;
    final completed = list.where((d) => d.isCompleted).length;
    final progress = total > 0 ? completed / total : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: NeonColors.darkCard.withOpacity(0.5),
        valueColor: AlwaysStoppedAnimation<Color>(
          _getCategoryColor(_selectedCategoryIndex),
        ),
        minHeight: 6,
      ),
    );
  }

  Color _getCategoryColor(int index) {
    switch (index) {
      case 0: return const Color(0xFF00BFFF);
      case 1: return const Color(0xFFFFB347);
      case 2: return const Color(0xFF6A5ACD);
      case 3: return const Color(0xFF7B68EE);
      default: return NeonColors.gold;
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAdhkarList();
      case 1:
        return const TasbihScreen();
      case 2:
        return const NamesScreen();
      case 3:
        return const NotesScreen();
      default:
        return _buildAdhkarList();
    }
  }

  Widget _buildAdhkarList() {
    final currentList = _currentCategoryAdhkar;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        final dhikr = currentList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Stack(
            children: [
              DhikrCard(
                dhikr: dhikr,
                onTap: () => _openTasbih(dhikr),
              ),
              if (dhikr.isCustom)
                Positioned(
                  top: 4,
                  left: 4,
                  child: GestureDetector(
                    onTap: () => _deleteCustomDhikr(dhikr.id),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 14),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _openTasbih(Dhikr dhikr) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasbihScreen(selectedDhikr: dhikr),
      ),
    ).then((_) => _loadAllData());
  }

  Future<void> _deleteCustomDhikr(String id) async {
    await StorageService.deleteCustomDhikr(id);
    await _loadAllData();
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: NeonColors.gold.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, 'الرئيسية'),
          _buildNavItem(1, Icons.circle, 'المسبحة'),
          _buildNavItem(2, Icons.star, 'أسماء الله'),
          _buildNavItem(3, Icons.note, 'الملاحظات'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? NeonColors.gold.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? NeonColors.gold : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? NeonColors.gold : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? NeonColors.gold : Colors.white54,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
