import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/neon_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _generalFont = 'Cairo';
  String _dhikrFont = 'Amiri';
  double _fontSize = 1.0;
  String _currentPin = '';
  bool _hasPin = false;

  final List<Map<String, String>> _fonts = [
    {'name': 'Cairo', 'label': 'Cairo'},
    {'name': 'Amiri', 'label': 'Amiri'},
    {'name': 'NotoNaskhArabic', 'label': 'Noto Naskh Arabic'},
    {'name': 'ReemKufi', 'label': 'Reem Kufi'},
    {'name': 'ScheherazadeNew', 'label': 'Scheherazade New'},
  ];

  final List<Map<String, dynamic>> _neonColors = [
    {'name': 'أزرق سماوي', 'color': NeonColors.blue},
    {'name': 'أخضر ربيعي', 'color': NeonColors.green},
    {'name': 'ذهبي', 'color': NeonColors.gold},
    {'name': 'بنفسجي', 'color': NeonColors.purple},
    {'name': 'وردي', 'color': NeonColors.pink},
    {'name': 'برتقالي', 'color': NeonColors.orange},
    {'name': 'سماوي', 'color': NeonColors.cyan},
    {'name': 'فضي', 'color': NeonColors.silver},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final fontSettings = await StorageService.getFontSettings();
    final pin = await StorageService.getPin();
    setState(() {
      _generalFont = fontSettings['general'] ?? 'Cairo';
      _dhikrFont = fontSettings['dhikr'] ?? 'Amiri';
      _fontSize = double.tryParse(fontSettings['size'] ?? '1.0') ?? 1.0;
      _hasPin = pin != null && pin.isNotEmpty;
      _currentPin = pin ?? '';
    });
  }

  Future<void> _saveFontSettings() async {
    await StorageService.saveFontSettings({
      'general': _generalFont,
      'dhikr': _dhikrFont,
      'size': _fontSize.toString(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم حفظ إعدادات الخطوط',
            textAlign: TextAlign.center,
          ),
          backgroundColor: NeonColors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showChangePinDialog() {
    final pinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeonColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
        ),
        title: Text(
          _hasPin ? 'تغيير الرقم السري' : '设置 الرقم السري',
          style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasPin)
                TextField(
                  controller: pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'الرقم السري الحالي',
                    hintStyle: TextStyle(color: Colors.white38),
                    prefixIcon: Icon(Icons.lock, color: NeonColors.gold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
                    ),
                  ),
                ),
              if (_hasPin) const SizedBox(height: 12),
              TextField(
                controller: newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'الرقم السري الجديد',
                  hintStyle: TextStyle(color: Colors.white38),
                  prefixIcon: Icon(Icons.lock_outline, color: NeonColors.gold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'تأكيد الرقم السري',
                  hintStyle: TextStyle(color: Colors.white38),
                  prefixIcon: Icon(Icons.lock_reset, color: NeonColors.gold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: NeonColors.gold.withOpacity(0.3)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              if (newPinController.text != confirmPinController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('الرقم السري غير متطابق'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              if (newPinController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('الرقم السري يجب أن يكون 4 أرقام على الأقل'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              await StorageService.savePin(newPinController.text);
              setState(() {
                _hasPin = true;
                _currentPin = newPinController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تغيير الرقم السري بنجاح'),
                  backgroundColor: NeonColors.green,
                ),
              );
            },
            child: Text('حفظ', style: TextStyle(color: NeonColors.gold)),
          ),
        ],
      ),
    );
  }

  void _showDeletePinDialog() {
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeonColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
        ),
        title: Text(
          'حذف الرقم السري',
          style: TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'أدخل الرقم السري الحالي للتأكيد',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'الرقم السري',
                hintStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(Icons.lock, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red.withOpacity(0.3)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              if (pinController.text == _currentPin) {
                await StorageService.savePin('');
                setState(() {
                  _hasPin = false;
                  _currentPin = '';
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف الرقم السري'),
                    backgroundColor: NeonColors.orange,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('الرقم السري خاطئ'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.darkBackground,
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildFontSection(),
                        const SizedBox(height: 16),
                        _buildFontSizeSection(),
                        const SizedBox(height: 16),
                        _buildSecuritySection(),
                        const SizedBox(height: 16),
                        _buildAboutSection(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeonColors.darkCard.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: NeonColors.gold.withOpacity(0.3),
                ),
              ),
              child: Icon(Icons.arrow_forward, color: NeonColors.gold, size: 22),
            ),
          ),
          Expanded(
            child: Text(
              'الإعدادات',
              style: NeonColors.getNeonTextStyle(
                NeonColors.gold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: NeonColors.gold, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
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

  Widget _buildFontSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('الخطوط', Icons.text_fields),
          Text(
            'الخط العام',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: NeonColors.darkBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NeonColors.gold.withOpacity(0.2)),
            ),
            child: DropdownButton<String>(
              value: _generalFont,
              isExpanded: true,
              dropdownColor: NeonColors.darkCard,
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down, color: NeonColors.gold),
              items: _fonts.map((f) {
                return DropdownMenuItem(
                  value: f['name'],
                  child: Text(
                    f['label']!,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _generalFont = value!);
                _saveFontSettings();
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'خط الأذكار',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: NeonColors.darkBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NeonColors.gold.withOpacity(0.2)),
            ),
            child: DropdownButton<String>(
              value: _dhikrFont,
              isExpanded: true,
              dropdownColor: NeonColors.darkCard,
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down, color: NeonColors.gold),
              items: _fonts.map((f) {
                return DropdownMenuItem(
                  value: f['name'],
                  child: Text(
                    f['label']!,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _dhikrFont = value!);
                _saveFontSettings();
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NeonColors.darkBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'بسم الله الرحمن الرحيم',
                  style: TextStyle(
                    fontFamily: _dhikrFont,
                    color: NeonColors.gold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'سبحان الله وبحمده',
                  style: TextStyle(
                    fontFamily: _dhikrFont,
                    color: NeonColors.green,
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

  Widget _buildFontSizeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('حجم الخط', Icons.format_size),
          Row(
            children: [
              Text(
                'صغير',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 0.7,
                  max: 1.5,
                  divisions: 8,
                  activeColor: NeonColors.gold,
                  inactiveColor: NeonColors.darkBackground,
                  onChanged: (value) {
                    setState(() => _fontSize = value);
                    _saveFontSettings();
                  },
                ),
              ),
              Text(
                'كبير',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: NeonColors.darkBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'معاينة حجم الخط',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14 * _fontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('الأمان', Icons.security),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeonColors.darkBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _hasPin ? Icons.lock : Icons.lock_open,
                color: _hasPin ? NeonColors.green : Colors.white38,
                size: 20,
              ),
            ),
            title: Text(
              'الرقم السري للملاحظات',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: Text(
              _hasPin ? 'تم التفعيل' : 'غير مفعل',
              style: TextStyle(
                color: _hasPin ? NeonColors.green : Colors.white38,
                fontSize: 12,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_hasPin)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    onPressed: _showDeletePinDialog,
                    tooltip: 'حذف الرقم السري',
                  ),
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white38),
                  onPressed: _showChangePinDialog,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('عن البرنامج', Icons.info_outline),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeonColors.darkBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.nightlight_round,
                color: NeonColors.gold,
                size: 20,
              ),
            ),
            title: Text(
              'نور قلبك',
              style: TextStyle(color: NeonColors.gold, fontSize: 14),
            ),
            subtitle: Text(
              'الإصدار 1.0 - أذكار يومية مع تأثيرات نيون',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NeonColors.darkBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'نسأل الله أن ينفع بهذا التطبيق وأن يجعله في ميزان حسناتنا',
              style: TextStyle(
                color: NeonColors.gold.withOpacity(0.6),
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
