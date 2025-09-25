import 'package:flutter/material.dart';

class LoagingAnimatinPage extends StatefulWidget {
  const LoagingAnimatinPage({super.key});

  @override
  State<LoagingAnimatinPage> createState() => _LoagingAnimatinPageState();
}

class _LoagingAnimatinPageState extends State<LoagingAnimatinPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotScales;
  late List<Animation<double>> _dotOpacities;

  final int dotCount = 3;
  final Duration singleDotDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    // AnimationController for the whole sequence
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: singleDotDuration.inMilliseconds * dotCount,
      ),
    )..repeat();

    // Create Tween animations for each dot with delay
    _dotScales = List.generate(dotCount, (i) {
      final start = i / dotCount;
      final end = (i + 1) / dotCount;
      return Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    _dotOpacities = List.generate(dotCount, (i) {
      final start = i / dotCount;
      final end = (i + 1) / dotCount;
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Proper disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading Dots Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(dotCount, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Transform.scale(
                    scale: _dotScales[i].value,
                    child: Opacity(
                      opacity: _dotOpacities[i].value,
                      child: const DotWidget(),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class DotWidget extends StatelessWidget {
  const DotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }
}
