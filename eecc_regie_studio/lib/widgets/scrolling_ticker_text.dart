import 'package:flutter/material.dart';

class ScrollingTickerText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double speed; // pixels par frame / vitesse

  const ScrollingTickerText({
    Key? key,
    required this.text,
    this.style,
    this.speed = 1.2,
  }) : super(key: key);

  @override
  State<ScrollingTickerText> createState() => _ScrollingTickerTextState();
}

class _ScrollingTickerTextState extends State<ScrollingTickerText> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
    while (_running && mounted) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          final current = _scrollController.offset;
          final target = (current + 80).clamp(0.0, maxScroll);

          await _scrollController.animateTo(
            target,
            duration: const Duration(seconds: 2),
            curve: Curves.linear,
          );

          if (_scrollController.offset >= maxScroll) {
            _scrollController.jumpTo(0.0);
          }
        }
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  void dispose() {
    _running = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        '  ${widget.text}      •      ${widget.text}  ',
        style: widget.style ?? const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}
