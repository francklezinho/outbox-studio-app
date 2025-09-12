// lib/splash/animated_splash.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedSplash extends StatefulWidget {
  const AnimatedSplash({super.key});

  @override
  State<AnimatedSplash> createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late Animation<double> _progressAnimation;
  late Animation<double> _particleAnimation;

  int _currentProgress = 0;
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    // Controller do progresso (0% -> 100%)
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 4000), // 4 segundos
      vsync: this,
    );

    // Controller das partículas animadas do fundo
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 8000), // 8 segundos loop
      vsync: this,
    )..repeat(); // Loop infinito

    // Controller do logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));

    _progressAnimation.addListener(() {
      setState(() {
        _currentProgress = (_progressAnimation.value * 100).round();
      });
    });

    _progressAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showLogoAndNavigate();
      }
    });

    _startLoading();
  }

  _startLoading() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _progressController.forward();
  }

  _showLogoAndNavigate() async {
    setState(() {
      _showLogo = true;
    });

    // Anima entrada do logo
    await _logoController.forward();

    // Logo fica mais tempo na tela (5 segundos)
    await Future.delayed(const Duration(milliseconds: 5000));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _backgroundController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fundo preto animado com partículas
          _buildAnimatedBackground(),
          // Conteúdo principal
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              child: _showLogo
                  ? _buildLogoSection()
                  : _buildLoadingSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              // Gradiente sutil de fundo
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      Color(0xFF0A0A0A), // Cinza muito escuro no centro
                      Colors.black, // Preto nas bordas
                    ],
                  ),
                ),
              ),
              // Partículas animadas flutuantes
              ...List.generate(15, (index) {
                final delay = index * 0.1;
                final offsetY = (MediaQuery.of(context).size.height *
                    (((_particleAnimation.value + delay) % 1.0) - 0.1)) - 100;
                final offsetX = 50 + (index * 80.0) % MediaQuery.of(context).size.width;
                final opacity = (0.3 + (index % 3) * 0.1) *
                    (1.0 - ((_particleAnimation.value + delay) % 1.0));

                return Positioned(
                  left: offsetX,
                  top: offsetY,
                  child: Container(
                    width: 4 + (index % 3) * 2,
                    height: 4 + (index % 3) * 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBAF2A).withOpacity(opacity),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFBAF2A).withOpacity(opacity * 0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // Efeitos de luz ambiente
              Positioned(
                left: -100,
                top: MediaQuery.of(context).size.height * 0.2,
                child: AnimatedBuilder(
                  animation: _particleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_particleAnimation.value * 0.3),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFBAF2A).withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: -150,
                bottom: MediaQuery.of(context).size.height * 0.3,
                child: AnimatedBuilder(
                  animation: _particleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + ((_particleAnimation.value + 0.5) % 1.0) * 0.4,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFF8C42).withOpacity(0.08),
                              Colors.transparent,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      key: const ValueKey('loading'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Título "Loading..."
        const Text(
          'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            fontFamily: 'Oswald',
          ),
        ),
        const SizedBox(height: 60),

        // Barra de progresso moderna
        Container(
          width: 340,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                width: 340 * _progressAnimation.value,
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFBAF2A),
                      Color(0xFFFF8C42),
                      Color(0xFFFBAF2A),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFBAF2A).withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Porcentagem animada
        Text(
          '$_currentProgress%',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            fontFamily: 'Lato',
          ),
        ),
        const SizedBox(height: 20),

        // Texto de status
        Text(
          'Preparing your experience...',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            fontFamily: 'Lato',
          ),
        ),
      ],
    ).animate()
        .fadeIn(duration: 800.ms, delay: 200.ms)
        .slideY(begin: 0.3, end: 0, duration: 1000.ms);
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        final fadeValue = Curves.easeOut.transform(_logoController.value);
        final scaleValue = Curves.easeOutBack.transform(_logoController.value);

        return Opacity(
          opacity: fadeValue,
          child: Transform.scale(
            scale: 0.3 + (scaleValue * 0.7), // Escala final maior
            child: Column(
              key: const ValueKey('logo'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SÓ O LOGO - SEM BOX, SEM TEXTO, MAIOR
                Image.asset(
                  'assets/splash/logo_outbox_screen.png', // ✅ CAMINHO CORRETO
                  width: 300, // Logo muito maior
                  height: 300, // Logo muito maior
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback caso a imagem não carregue
                    return const Icon(
                      Icons.video_camera_back_rounded,
                      size: 200, // Fallback também maior
                      color: Color(0xFFFBAF2A),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
