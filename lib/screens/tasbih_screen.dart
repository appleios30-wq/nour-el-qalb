import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dhikr.dart';
import '../data/adhkar_data.dart';
import '../services/storage_service.dart';
import '../utils/neon_colors.dart';
import '../widgets/progress_ring.dart';
import '../widgets/ray_effect.dart';
import '../widgets/celebration_overlay.dart';

class TasbihScreen extends StatefulWidget {
  final Dhikr? selectedDhikr;

  const TasbihScreen({super.key, this.selectedDhikr});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  late Dhikr _currentDhikr;
  bool _showCelebration = false;
  bool _isRayActive = false;
  int _totalCompletions = 0;
  List<Dhikr> _allDhikrs = [];

  @override
  void initState() {
    super.initState();
    _currentDhikr = widget.selectedDhikr ?? AdhkarData.defaultAdhkar.first;
    _loadProgress();
    _loadAllDhikrs();
  }

  Future<void> _loadAllDhikrs() async {
    final custom = await StorageService.getCustomDhikrs();
    setState(() {
      _allDhikrs = [...AdhkarData.defaultAdhkar, ...custom];
    });
  }

  Future<void> _loadProgress() async {
    final progress = await StorageService.getAdhkarProgress();
    if (progress.containsKey(_currentDhikr.id)) {
      setState(() {
        _currentDhikr.currentCount = progress[_currentDhikr.id]!;
      });
    }
  }

  Future<void> _saveProgress() async {
    final customAdhkar = await StorageService.getCustomDhikrs();
    final allAdhkar = [...AdhkarData.defaultAdhkar, ...customAdhkar];
    final index = allAdhkar.indexWhere((d) => d.id == _currentDhikr.id);
    if (index != -1) {
      allAdhkar[index].currentCount = _currentDhikr.currentCount;
      await StorageService.saveAdhkarProgress(allAdhkar);
    }
  }

  void _incrementCounter() {
    setState(() {
      _currentDhikr.increment();
      _isRayActive = true;
      
      // اهتزاز خفيف
      if (true) { // vibrationEnabled
        HapticFeedback.lightImpact();
      }
      
      // إخفاء الشعاع بعد فترة
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isRayActive = false;
          });
        }
      });
      
      // التحقق من اكتمال العدد
      if (_currentDhikr.isCompleted) {
        _totalCompletions++;
        _showCelebration = true;
      }
    });
    
    _saveProgress();
  }

  void _resetCounter() {
    setState(() {
      _currentDhikr.reset();
    });
    _saveProgress();
  }

  void _dismissCelebration() {
    setState(() {
      _showCelebration = false;
      _currentDhikr.reset();
    });
    _saveProgress();
  }

  void _changeDhikr(Dhikr dhikr) {
    setState(() {
      _currentDhikr = dhikr;
    });
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // المحتوى الرئيسي
        Column(
          children: [
            // رأس الصفحة
            _buildHeader(),
            
            // منطقة المسبحة
            Expanded(
              child: _buildTasbihArea(),
            ),
            
            // قائمة الأذكار
            _buildDhikrSelector(),
          ],
        ),
        
        // تأثير الشعاع
        if (_isRayActive)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.5 - 150,
            child: RayEffect(
              rayColor: _getRayColor(),
              sparkColor: _currentDhikr.neonColor,
              isActive: _isRayActive,
            ),
          ),
        
        // شاشة الاحتفال
        CelebrationOverlay(
          isVisible: _showCelebration,
          onDismiss: _dismissCelebration,
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
            _currentDhikr.arabicName,
            style: NeonColors.getNeonTextStyle(
              _currentDhikr.neonColor,
              fontSize: 24,
            ).copyWith(
              fontFamily: _currentDhikr.fontFamily,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetCounter,
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihArea() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // نص الذكر
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: NeonColors.darkCard.withOpacity( 0.8),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _currentDhikr.neonColor.withOpacity( 0.5),
                width: 2,
              ),
            ),
            child: Text(
              _currentDhikr.text,
              style: NeonColors.getNeonTextStyle(
                _currentDhikr.neonColor,
                fontSize: 28,
              ).copyWith(
                fontFamily: _currentDhikr.fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // زر المسبحة
          GestureDetector(
            onTap: _incrementCounter,
            child: ProgressRing(
              progress: _currentDhikr.targetCount > 0
                  ? _currentDhikr.currentCount / _currentDhikr.targetCount
                  : 0,
              neonColor: _currentDhikr.neonColor,
              size: 200,
              strokeWidth: 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_currentDhikr.currentCount}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _currentDhikr.neonColor,
                      fontFamily: _currentDhikr.fontFamily,
                      shadows: [
                        Shadow(
                          color: _currentDhikr.neonColor.withOpacity( 0.8),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'من ${_currentDhikr.targetCount}',
                    style: TextStyle(
                      color: Colors.white.withOpacity( 0.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // معلومات إضافية
          Text(
            'اضغط على الدائرة للتسبيح',
            style: TextStyle(
              color: Colors.white.withOpacity( 0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'الدورات المكتملة: $_totalCompletions',
            style: TextStyle(
              color: NeonColors.gold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrSelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _allDhikrs.length,
        itemBuilder: (context, index) {
          final dhikr = _allDhikrs[index];
          final isSelected = dhikr.id == _currentDhikr.id;
          
          return GestureDetector(
            onTap: () => _changeDhikr(dhikr),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 80,
              decoration: BoxDecoration(
                color: isSelected
                    ? dhikr.neonColor.withOpacity( 0.2)
                    : NeonColors.darkCard.withOpacity( 0.8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? dhikr.neonColor : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? NeonColors.getNeonGlow(dhikr.neonColor, intensity: 0.5)
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: dhikr.neonColor,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dhikr.arabicName,
                    style: TextStyle(
                      color: isSelected ? dhikr.neonColor : Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${dhikr.currentCount}/${dhikr.targetCount}',
                    style: TextStyle(
                      color: Colors.white.withOpacity( 0.4),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getRayColor() {
    // لون الشعاع حسب الوقت
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return const Color(0xFFFFB347); // برتقالي متوهج
    } else {
      return const Color(0xFF87CEEB); // أبيض مزرق مضيء
    }
  }
}
