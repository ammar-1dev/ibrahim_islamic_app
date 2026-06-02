import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ai/ai_config_providers.dart';
import '../../../../core/ai/chat_message.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/storage/local_storage.dart';

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
      final apiKey = ref.read(aiApiKeyProvider);
      final providerId = ref.read(selectedAiProviderId);
      final model = ref.read(selectedAiModel);

      final resolvedModel = model.isNotEmpty ? model : ref.read(currentAiProvider).defaultModel;

      if (apiKey.isEmpty) {
        throw Exception('API key not set');
      }

      final reply = await ref.read(aiServiceProvider).generateResponse(
        providerId: providerId,
        model: resolvedModel,
        apiKey: apiKey,
        messages: _messages.where((m) => m != _messages.last || !m.isUser).toList(),
        systemPrompt: _systemPrompt,
      );

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

  void _showSettingsDialog() {
    final storage = LocalStorage();
    final providerId = ref.read(selectedAiProviderId);
    final provider = ref.read(currentAiProvider);

    final apiCtrl = TextEditingController(text: ref.read(aiApiKeyProvider));
    String tempProvider = providerId;
    String tempModel = ref.read(selectedAiModel).isNotEmpty
        ? ref.read(selectedAiModel)
        : provider.defaultModel;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final currentProv = ref.read(aiServiceProvider).getProvider(tempProvider);
          final models = currentProv.availableModels;

          return AlertDialog(
            backgroundColor: AppColors.navy,
            title: const Text('إعدادات الذكاء الاصطناعي', textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('مزود الخدمة', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: tempProvider,
                    dropdownColor: AppColors.navyLight,
                    style: const TextStyle(color: Colors.white, fontFamily: 'Amiri'),
                    decoration: _fieldDeco(),
                    items: ref.read(aiServiceProvider).allProviders.map((p) => DropdownMenuItem(
                      value: p.id,
                      child: Text(p.displayName, style: const TextStyle(fontSize: 13)),
                    )).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() {
                          tempProvider = v;
                          tempModel = ref.read(aiServiceProvider).getProvider(v).defaultModel;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('النموذج', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: models.contains(tempModel) ? tempModel : currentProv.defaultModel,
                    dropdownColor: AppColors.navyLight,
                    style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 12),
                    decoration: _fieldDeco(),
                    items: models.map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m, style: const TextStyle(fontSize: 12)),
                    )).toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => tempModel = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(currentProv.apiKeyLabel, style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: apiCtrl,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: currentProv.apiKeyLabel,
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                      filled: true,
                      fillColor: AppColors.navyLight,
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
              TextButton(onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء', style: TextStyle(color: Colors.white70))),
              TextButton(
                onPressed: () {
                  ref.read(selectedAiProviderId.notifier).state = tempProvider;
                  ref.read(selectedAiModel.notifier).state = tempModel;
                  ref.read(aiApiKeyProvider.notifier).state = apiCtrl.text;
                  storage.saveString('ai_provider', tempProvider);
                  storage.saveString('ai_model_$tempProvider', tempModel);
                  storage.saveString('ai_key_$tempProvider', apiCtrl.text);
                  Navigator.pop(ctx);
                },
                child: const Text('حفظ', style: TextStyle(color: AppColors.gold)),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _fieldDeco() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.navyLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
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
            onPressed: _showSettingsDialog,
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
            final hasKey = ref.watch(aiApiKeyProvider).isNotEmpty;
            final providerName = ref.watch(currentAiProvider).displayName;
            final model = ref.watch(selectedAiModel).isNotEmpty
                ? ref.watch(selectedAiModel)
                : ref.watch(currentAiProvider).defaultModel;
            return Column(
              children: [
                TextButton.icon(
                  onPressed: _showSettingsDialog,
                  icon: Icon(hasKey ? Icons.check_circle : Icons.key, color: hasKey ? AppColors.success : AppColors.gold),
                  label: Text(
                    hasKey ? 'مضبوط ✓' : 'إعداد المفتاح',
                    style: TextStyle(color: hasKey ? AppColors.success : AppColors.gold, fontFamily: 'Amiri', fontSize: 14),
                  ),
                ),
                if (hasKey)
                  Text('$providerName — $model',
                    style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 11)),
              ],
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
