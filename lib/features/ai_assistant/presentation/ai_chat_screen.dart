import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/storage/local_storage.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  const ChatMessage({required this.content, required this.isUser, required this.timestamp});
}

final geminiApiKeyProvider = StateProvider<String>((ref) {
  final storage = LocalStorage();
  return storage.getString('gemini_api_key', defaultValue: '');
});

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isLoading = false;

  static const String _systemPrompt = '''
أنت مساعد إسلامي متخصص اسمه إبراهيم. تجيب على أسئلة الفقه والتفسير
والحديث والسيرة النبوية والأدعية. تستند دائماً إلى القرآن الكريم والسنة
النبوية الصحيحة. أسلوبك هادئ، موثوق، ومحترم. تذكر المصادر دائماً.
لا تفتي في المسائل الخلافية الكبرى — أحل المستخدم إلى العلماء.
''';

  final List<String> _suggestions = [
    'ما هي أركان الصلاة؟',
    'اشرح لي تفسير آية الكرسي',
    'ما فضل قراءة القرآن؟',
    'أدعية عند الكرب والضيق',
    'ما صحة حديث... ؟',
  ];

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _inputCtrl.clear();

    setState(() {
      _messages.add(ChatMessage(content: text, isUser: true, timestamp: DateTime.now()));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final reply = await _callGemini(text);
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(content: reply, isUser: false, timestamp: DateTime.now()));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            content: 'عذراً، تعذّر الاتصال. ${e.toString().contains('API key') ? 'يرجى إضافة مفتاح API صحيح في الإعدادات.' : 'تأكد من اتصالك بالإنترنت.'}',
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _callGemini(String userMessage) async {
    final apiKey = ref.read(geminiApiKeyProvider);
    if (apiKey.isEmpty) {
      throw Exception('API key not set');
    }
    final dio = ref.read(dioProvider);
    final response = await dio.post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
      data: {
        'contents': [
          {'parts': [{'text': '$_systemPrompt\n\nالمستخدم: $userMessage'}]}
        ],
      },
    );
    final candidates = response.data['candidates'] as List;
    return candidates[0]['content']['parts'][0]['text'] as String;
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showApiKeyDialog() {
    final ctrl = TextEditingController(text: ref.read(geminiApiKeyProvider));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.navy,
        title: const Text('مفتاح API', textAlign: TextAlign.center, style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri')),
        content: TextField(
          controller: ctrl,
          textDirection: TextDirection.ltr,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: const InputDecoration(
            hintText: 'أدخل مفتاح Gemini API',
            hintStyle: TextStyle(color: Colors.white30, fontSize: 12),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.goldMuted)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: Colors.white70))),
          TextButton(
            onPressed: () {
              ref.read(geminiApiKeyProvider.notifier).state = ctrl.text;
              LocalStorage().saveString('gemini_api_key', ctrl.text);
              Navigator.pop(context);
            },
            child: const Text('حفظ', style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.mosque, color: AppColors.gold, size: 20),
            SizedBox(width: 8),
            Text('إبراهيم AI'),
          ],
        ),
        backgroundColor: AppColors.navy,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.gold),
            onPressed: _showApiKeyDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty ? _buildWelcome() : _buildMessages(),
          ),
          if (_messages.isEmpty) _buildSuggestions(),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              color: AppColors.goldMuted, shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: const Icon(Icons.mosque, color: AppColors.gold, size: 44),
          ),
          const SizedBox(height: AppDimensions.xl),
          const Text('إبراهيم AI',
            style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppDimensions.sm),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
            child: Text(
              'مساعدك الإسلامي الذكي — اسألني عن الفقه والتفسير والحديث والسيرة النبوية',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16, height: 1.8),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Consumer(builder: (context, ref, _) {
            final hasKey = ref.watch(geminiApiKeyProvider).isNotEmpty;
            return TextButton.icon(
              onPressed: _showApiKeyDialog,
              icon: Icon(hasKey ? Icons.check_circle : Icons.key, color: hasKey ? AppColors.success : AppColors.gold),
              label: Text(
                hasKey ? 'مفتاح API مضبوط ✓' : 'إعداد مفتاح API',
                style: TextStyle(color: hasKey ? AppColors.success : AppColors.gold, fontFamily: 'Amiri', fontSize: 14),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        itemCount: _suggestions.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => _send(_suggestions[i]),
          child: Container(
            margin: const EdgeInsets.only(left: AppDimensions.sm, bottom: 8, top: 4),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.navyLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(color: AppColors.goldMuted),
            ),
            child: Center(
              child: Text(_suggestions[i],
                style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 13)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(AppDimensions.lg),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) return const _TypingIndicator();
        final msg = _messages[index];
        return _MessageBubble(message: msg);
      },
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, AppDimensions.lg),
      decoration: const BoxDecoration(
        color: AppColors.navyLight,
        border: Border(top: BorderSide(color: AppColors.goldMuted)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              textDirection: TextDirection.rtl,
              maxLines: null,
              style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16),
              decoration: InputDecoration(
                hintText: 'اسألني...',
                hintStyle: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16),
                filled: true,
                fillColor: AppColors.navy,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
              ),
              onSubmitted: _send,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          GestureDetector(
            onTap: () => _send(_inputCtrl.text),
            child: Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: AppColors.navy, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        margin: const EdgeInsets.only(bottom: AppDimensions.md),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.navyLight : AppColors.goldMuted,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppDimensions.radiusLg),
            topRight: const Radius.circular(AppDimensions.radiusLg),
            bottomLeft: message.isUser ? Radius.zero : const Radius.circular(AppDimensions.radiusLg),
            bottomRight: message.isUser ? const Radius.circular(AppDimensions.radiusLg) : Radius.zero,
          ),
          border: Border.all(color: message.isUser ? AppColors.goldMuted : AppColors.gold.withOpacity(0.3)),
        ),
        child: Text(
          message.content,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: message.isUser ? AppColors.textOnDark : AppColors.gold,
            fontFamily: 'Amiri',
            fontSize: 16,
            height: 1.8,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.md),
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.goldMuted,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: FadeTransition(
          opacity: _anim,
          child: const Text('...', style: TextStyle(color: AppColors.gold, fontSize: 20, fontFamily: 'Inter')),
        ),
      ),
    );
  }
}
