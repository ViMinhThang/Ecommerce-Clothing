import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import '../../models/chat_message.dart';
import '../../services/ml_kit/smart_reply_service.dart';

class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({super.key});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final SmartReplyService _smartReplyService = SmartReplyService();
  final ScrollController _scrollController = ScrollController();
  List<String> _suggestedReplies = [];
  List<String> _suggestedActions = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    // Add welcome message
    setState(() {
      _messages.add(
        ChatMessage.support(
          "Hello! Welcome to our customer support. How can I help you today?",
        ),
      );
      _updateSuggestions();
    });
  }

  void _updateSuggestions() {
    setState(() {
      _suggestedReplies = _smartReplyService.generateReplies(_messages);
      _suggestedActions = _smartReplyService.getSuggestedActions(_messages);
    });
  }

  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage.user(text.trim());

    setState(() {
      _messages.add(userMessage);
      _textController.clear();
    });

    _scrollToBottom();
    _updateSuggestions();

    // Simulate support response delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _addAutoResponse(text);
      }
    });
  }

  void _addAutoResponse(String userText) {
    final responses = _smartReplyService.generateReplies(_messages);
    if (responses.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage.support(responses.first));
        _updateSuggestions();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSuggestionTap(String suggestion) {
    _textController.text = suggestion;
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CUSTOMER SUPPORT',
              style: AppTheme.h4.copyWith(letterSpacing: 1.5, fontSize: 16),
            ),
            Text(
              'Online - Quick replies enabled',
              style: AppTheme.caption.copyWith(
                color: Colors.green.shade700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),

          // Suggested actions
          if (_suggestedActions.isNotEmpty) ...[
            const Divider(height: 1),
            _buildSuggestedActions(),
          ],

          // Smart reply suggestions
          if (_suggestedReplies.isNotEmpty && _textController.text.isEmpty) ...[
            const Divider(height: 1),
            _buildSmartReplies(),
          ],

          // Input field
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent, size: 80, color: AppTheme.lightGray),
          const SizedBox(height: 16),
          Text(
            'NO MESSAGES YET',
            style: AppTheme.h4.copyWith(
              letterSpacing: 1.5,
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: AppTheme.primaryBlack),
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppTheme.primaryBlack
                    : const Color(0xFFF5F5F5),
                border: Border.all(
                  color: message.isUser
                      ? AppTheme.primaryBlack
                      : AppTheme.lightGray,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTheme.bodyMedium.copyWith(
                      color: message.isUser
                          ? Colors.white
                          : AppTheme.primaryBlack,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: AppTheme.caption.copyWith(
                      color: message.isUser
                          ? Colors.white70
                          : AppTheme.mediumGray,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: const Icon(
                Icons.person,
                color: AppTheme.mediumGray,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmartReplies() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        border: Border(top: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 14,
                color: AppTheme.mediumGray,
              ),
              const SizedBox(width: 6),
              Text(
                'SUGGESTED REPLIES',
                style: AppTheme.caption.copyWith(
                  color: AppTheme.mediumGray,
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedReplies.take(3).map((reply) {
              return InkWell(
                onTap: () => _handleSuggestionTap(reply),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.primaryBlack),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          reply,
                          style: AppTheme.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedActions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(top: BorderSide(color: Colors.blue.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.touch_app, size: 14, color: Colors.blue.shade900),
              const SizedBox(width: 6),
              Text(
                'QUICK ACTIONS',
                style: AppTheme.caption.copyWith(
                  color: Colors.blue.shade900,
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedActions.map((action) {
              return OutlinedButton(
                onPressed: () {
                  // TODO: Handle action
                  _handleSubmit("I want to: $action");
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue.shade900,
                  side: BorderSide(color: Colors.blue.shade900),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(
                  action,
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.lightGray, width: 2)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: Border.all(color: AppTheme.lightGray),
                ),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: _handleSubmit,
                  onChanged: (text) {
                    setState(() {}); // Update to hide/show suggestions
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => _handleSubmit(_textController.text),
              child: Container(
                width: 48,
                height: 48,
                color: AppTheme.primaryBlack,
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
