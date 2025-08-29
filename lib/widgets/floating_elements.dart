import 'package:flutter/material.dart';

class FloatingElements extends StatefulWidget {
  const FloatingElements({super.key});

  @override
  State<FloatingElements> createState() => _FloatingElementsState();
}

class _FloatingElementsState extends State<FloatingElements>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(4, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 500)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Element 1 - Top Left
        Positioned(
          top: 80,
          left: 32,
          child: AnimatedBuilder(
            animation: _animations[0],
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_animations[0].value * 0.4),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),

        // Element 2 - Top Right
        Positioned(
          top: 128,
          right: 48,
          child: AnimatedBuilder(
            animation: _animations[1],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[1].value * 10),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF08A).withOpacity(0.3), // yellow-300
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),

        // Element 3 - Bottom Left
        Positioned(
          bottom: 160,
          left: 64,
          child: AnimatedBuilder(
            animation: _animations[2],
            builder: (context, child) {
              return Transform.scale(
                scale: 0.7 + (_animations[2].value * 0.6),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC4899).withOpacity(0.2), // pink-500
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),

        // Element 4 - Bottom Right
        Positioned(
          bottom: 240,
          right: 80,
          child: AnimatedBuilder(
            animation: _animations[3],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[3].value * 15),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9333EA).withOpacity(0.4), // purple-600
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}