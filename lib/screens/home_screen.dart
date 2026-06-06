import 'package:flutter/material.dart';
import '../data/adhkar_data.dart';
import '../models/dhikr.dart';
import '../services/storage_service.dart';
import '../services/time_service.dart';
import '../utils/neon_colors.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/dynamic_background.dart';
import 'tasbih_screen.dart';
import 'names_screen.dart';
import 'notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Dhikr> _adhkar = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAdhkar();
  }

  Future<void> _loadAdhkar() async {
    final progress = await StorageService.getAdhkarProgress();
    final adhkar = AdhkarData.defaultAdhkar;
    
    // تحديث التقدم المحفوظ
    for (var dhikr in adhkar) {
      if (progress.containsKey(dhikr.id)) {
        dhikr.currentCount = progress[dhikr.id]!;
      }
    }
    
    setState(() {
      _adhkar = adhkar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية الديناميكية
          const DynamicBackground(),
          
          // المحتوى الرئيسي
          SafeArea(
            child: Column(
              children: [
                // شريط العنوان
                _buildHeader(),
                
                // المحتوى الرئيسي
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
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TimeService.getTimeGreeting(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'نور قلبك',
                style: NeonColors.getNeonTextStyle(
                  NeonColors.gold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: NeonColors.darkCard.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: NeonColors.gold.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: NeonColors.gold,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_selectedIndex',
                  style: NeonColors.getNeonTextStyle(
                    NeonColors.gold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    return Column(
      children: [
        // ملخص اليوم
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeonColors.darkCard.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NeonColors.gold.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('أذكار مكتملة', _getCompletedCount().toString(), NeonColors.green),
              _buildStatItem('أذكار متبقية', _getRemainingCount().toString(), NeonColors.orange),
              _buildStatItem('الإجمالي', _adhkar.length.toString(), NeonColors.gold),
            ],
          ),
        ),
        
        // قائمة الأذكار
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _adhkar.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DhikrCard(
                  dhikr: _adhkar[index],
                  onTap: () => _openTasbih(_adhkar[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: NeonColors.getNeonTextStyle(color, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  int _getCompletedCount() {
    return _adhkar.where((d) => d.isCompleted).length;
  }

  int _getRemainingCount() {
    return _adhkar.where((d) => !d.isCompleted).length;
  }

  void _openTasbih(Dhikr dhikr) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasbihScreen(selectedDhikr: dhikr),
      ),
    ).then((_) => _loadAdhkar());
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
