import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import '../utils/neon_colors.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  bool _isAuthenticated = false;
  String? _pin;
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    _pin = await StorageService.getPin();
    if (_pin != null) {
      // يوجد رقم سري مسجل
      _showPinDialog();
    } else {
      // لا يوجد رقم سري، يجب إنشاؤه
      _isAuthenticated = true;
      _loadNotes();
    }
  }

  void _showPinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: NeonColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: NeonColors.gold.withOpacity(0.5),
          ),
        ),
        title: Text(
          'أدخل الرقم السري',
          style: NeonColors.getNeonTextStyle(NeonColors.gold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الرقم السري مبني على عدد الضغطات على الشاشة',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'الرقم السري',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: NeonColors.gold.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: NeonColors.gold,
                  ),
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _authenticate();
            },
            child: Text(
              'تأكيد',
              style: TextStyle(color: NeonColors.gold),
            ),
          ),
        ],
      ),
    );
  }

  void _authenticate() {
    if (_pinController.text == _pin) {
      setState(() {
        _isAuthenticated = true;
      });
      Navigator.pop(context);
      _loadNotes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('الرقم السري غير صحيح'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadNotes() async {
    final notes = await StorageService.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _saveNotes() async {
    await StorageService.saveNotes(_notes);
  }

  void _addNote() {
    if (_noteController.text.isNotEmpty) {
      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _noteController.text,
      );
      setState(() {
        _notes.insert(0, note);
      });
      _noteController.clear();
      _saveNotes();
    }
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(NeonColors.gold),
        ),
      );
    }

    return Column(
      children: [
        // رأس الصفحة
        _buildHeader(),
        
        // إدخال ملاحظة جديدة
        _buildNoteInput(),
        
        // قائمة الملاحظات
        Expanded(
          child: _buildNotesList(),
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
            'سرك في بير',
            style: NeonColors.getNeonTextStyle(
              NeonColors.gold,
              fontSize: 24,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lock, color: Colors.white),
            onPressed: _changePin,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _noteController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'اكتب ملاحظتك هنا...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _addNote,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeonColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    if (_notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد ملاحظات بعد',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        return _buildNoteCard(_notes[index]);
      },
    );
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeonColors.darkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: NeonColors.gold.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(note.createdAt),
                style: TextStyle(
                  color: NeonColors.gold.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              GestureDetector(
                onTap: () => _deleteNote(note.id),
                child: Icon(
                  Icons.delete,
                  color: Colors.red.withOpacity(0.7),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _changePin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeonColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: NeonColors.gold.withOpacity(0.5),
          ),
        ),
        title: Text(
          'تغيير الرقم السري',
          style: NeonColors.getNeonTextStyle(NeonColors.gold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'الرقم السري الجديد',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: NeonColors.gold.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: NeonColors.gold,
                  ),
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'إلغاء',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.savePin(_pinController.text);
              _pin = _pinController.text;
              _pinController.clear();
              Navigator.pop(context);
            },
            child: Text(
              'حفظ',
              style: TextStyle(color: NeonColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}
