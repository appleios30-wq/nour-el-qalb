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

  List<Dhikr> get _allAdhkar {
    List<Dhikr> result = [];
    result.addAll(_adhkar);
    result.addAll(_customAdhkar.where((d) => d.category == DhikrCategory.general));
    result.addAll(MorningAdhkarData.adhkar);
    result.addAll(_customAdhkar.where((d) => d.category == DhikrCategory.morning));
    result.addAll(EveningAdhkarData.adhkar);
    result.addAll(_customAdhkar.where((d) => d.category == DhikrCategory.evening));
    result.addAll(SleepAdhkarData.adhkar);
    result.addAll(_customAdhkar.where((d) => d.category == DhikrCategory.sleep));

    for (var dhikr in result) {
      if (_progress.containsKey(dhikr.id)) {
        dhikr.currentCount = _progress[dhikr.id]!;
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
      backgroundColor: const Color(0xFF0a0a1a),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: Icon(Icons.menu, color: NeonColors.gold, size: 26),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Column(
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
              style: NeonColors.getNeonTextStyle(
                NeonColors.gold,
                fontSize: 26,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: NeonColors.gold, size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          const DynamicBackground(),
          Padding(
            padding: EdgeInsets.only(top: topPad + 70),
            child: _buildAdhkarList(),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NamesScreen()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.note_alt_outlined,
              title: 'الملاحظات',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotesScreen()),
                );
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

  Widget _buildAdhkarList() {
    final currentList = _allAdhkar;
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
      ),
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
}
