// lib/features/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final AudioPlayer _audioPlayer;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imagePath: 'assets/second-screen/book-tela.png',
      title: 'Book',
      description: 'Lock in your desired session on a day and time that works best for you.',
    ),
    OnboardingPageData(
      imagePath: 'assets/second-screen/record-tela.png',
      title: 'Record',
      description: "Walk in and start recording. We'll handle all the tech stuff.",
    ),
    OnboardingPageData(
      imagePath: 'assets/second-screen/receive-tela.png',
      title: 'Receive',
      description: 'Receive your final long‑form video within 24 hours.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSwipeSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/page_swipe.mp3'));
    } catch (e) {
      print('Sound not found: $e');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  // ✅ NOVA FUNÇÃO: Completa onboarding e vai para login
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C2C2C),
              Color(0xFF020202),
            ],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: availableHeight,
            child: Column(
              children: [
                // ✅ IMAGEM - Altura Fixa Responsiva
                Expanded(
                  flex: 6,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      _playSwipeSound();
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Image.asset(
                            _pages[index].imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 60,
                                    color: Color(0xFFFBAF2A),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ).animate()
                          .fadeIn(duration: 600.ms)
                          .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
                    },
                  ),
                ),

                // ✅ CONTEÚDO - Altura Flexível
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Título e Descrição
                        Column(
                          children: [
                            Text(
                              _pages[_currentPage].title,
                              style: const TextStyle(
                                color: Color(0xFFFBAF2A),
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Oswald',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _pages[_currentPage].description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Lato',
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        // Controles na parte inferior
                        Column(
                          children: [
                            // ✅ BOTÃO NEXT/GET STARTED CORRIGIDO
                            SizedBox(
                              width: double.infinity,
                              height: 65, // ✅ AUMENTADO DE 48 PARA 70
                              child: ElevatedButton(
                                onPressed: _nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFBAF2A),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentPage == _pages.length - 1
                                          ? 'Get Started'
                                          : 'Next',
                                      style: const TextStyle(
                                        fontSize: 20, // ✅ AUMENTADO DE 16 PARA 20
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Oswald',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      _currentPage == _pages.length - 1
                                          ? Icons.check_rounded
                                          : Icons.arrow_forward_rounded,
                                      size: 20, // ✅ AUMENTADO DE 18 PARA 20
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_pages.length, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentPage == index ? 20 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 12),

                            // ✅ SKIP BUTTON COM PADDING MAIOR
                            TextButton(
                              onPressed: _skip,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // ✅ PADDING MAIOR
                              ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16, // ✅ AUMENTADO DE 14 PARA 16
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingPageData {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
