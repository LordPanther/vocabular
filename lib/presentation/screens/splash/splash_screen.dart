// import 'package:black_market_app/presentation/widgets/others/background.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/widgets/others/logo_full.dart';
import 'package:flutter/material.dart';
// import 'package:black_market_app/configs/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -2), // Offscreen at the top
      end: Offset.zero, // Center of the screen
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceIn,
      ),
    );

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SlideTransition(
              position: _offsetAnimation,
              child: const LogoFull(),
            ),
          ),
          SizedBox(height: SizeConfig.defaultSize * 8),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(COLOR_CONST.dividerColor),
          ),
        ],
      ),
    );
  }
}
