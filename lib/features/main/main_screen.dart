// lib/features/main/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/animated_drawer.dart';
import '../../widgets/animated_bottom_nav.dart';
import '../../widgets/parallax_carousel.dart';
import '../packages/packages_screen.dart';
import '../booking/booking_list_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_screen.dart';

// ✅ CORREÇÃO: IMPORTS DOS 3 ARQUIVOS CLONADOS QUE FUNCIONAM 100%
import '../packages/nav_packages_screen.dart';
import '../booking/nav_booking_list_screen.dart'; // ✅ CORREÇÃO: NOME CORRETO DO ARQUIVO
import '../profile/nav_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ✅ REMOVIDO: PageController (não precisa mais)
  int _currentIndex = 0;
  DateTime? _lastBackPressed;

  // ✅ CORREÇÃO PRINCIPAL: USAR OS ARQUIVOS CLONADOS QUE FUNCIONAM 100%
  late final List<Widget> _screens = [
    const HomeTab(),
    NavPackagesScreen(onTabChanged: (index) {
      setState(() {
        _currentIndex = index;
      });
    }),
    NavBookingListScreen(onTabChanged: (index) {
      setState(() {
        _currentIndex = index;
      });
    }),
    NavProfileScreen(onTabChanged: (index) {
      setState(() {
        _currentIndex = index;
      });
    }),
  ];

  @override
  void dispose() {
    // ✅ REMOVIDO: _pageController.dispose() (não precisa mais)
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // ✅ REMOVIDO: _pageController.jumpToPage(index) (não precisa mais)
  }

  Future<bool> _handleBackPress() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }

    final now = DateTime.now();
    const exitWarning = Duration(seconds: 2);

    if (_lastBackPressed == null || now.difference(_lastBackPressed!) > exitWarning) {
      _lastBackPressed = now;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }

    if (Platform.isAndroid) {
      SystemNavigator.pop();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppTheme.backgroundPrimary,
        drawerScrimColor: Colors.black.withAlpha(179),
        drawer: const AnimatedDrawer(),
        // ✅ CORREÇÃO PRINCIPAL: IndexedStack mantém todos os widgets vivos
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: AnimatedBottomNav(
          currentIndex: _currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}

// ✅ MANTENHA SUA HomeTab ORIGINAL COMPLETA - NÃO ALTERO NADA
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> _carouselImages = List.generate(
    14,
        (index) => 'assets/slides-home/Slide-${index + 1}.jpg',
  );

  void _navigateToBooking(Map packageData) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to make a booking'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          packageName: packageData['title'] as String,
          packageBadge: packageData['duration'] as String,
          packagePrice: packageData['price'] as String,
        ),
      ),
    );
  }

  void _navigateToPackages() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackagesScreen(
          onBackToHome: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com padding
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: _buildHeader(context),
              ),
              const SizedBox(height: 40),
              // ✅ CAROUSEL FULL WIDTH (sem padding do pai)
              _buildCarouselSlider(),
              // Resto do conteúdo com padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildBookRecordReceiveSection(),
                    const SizedBox(height: 40),
                    _buildTitles(),
                    const SizedBox(height: 40),
                    _buildServicesSection(),
                    const SizedBox(height: 40),
                    _buildBookingPackagesSection(),
                    const SizedBox(height: 40),
                    _buildProductsAndPackagesSection(),
                    const SizedBox(height: 40),
                    _buildCallToAction(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Títulos com padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'VIDEO PODCAST AND LIVE STREAMING',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3, end: 0),
              const SizedBox(height: 8),
              Text(
                'Broadcast-Quality Podcast Studio in Downtown Las Vegas',
                style: TextStyle(
                  color: Colors.white.withAlpha(204),
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: -0.2, end: 0),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // ✅ CAROUSEL FULL WIDTH (sem padding)
        ParallaxCarousel(
          images: _carouselImages,
          height: 280.0,
          autoPlayInterval: const Duration(seconds: 5),
          enableAutoPlay: true,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary.withAlpha(204),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withAlpha(100),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.menu,
              color: Colors.white,
              size: 24,
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.5, end: 0),
        ),
        const Spacer(),
        Text(
          'OUTBOX STUDIO',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary.withAlpha(204),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 24,
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideX(begin: 0.5, end: 0),
        ),
      ],
    );
  }

  // ✅ MANTENHA TODOS OS SEUS OUTROS MÉTODOS _build ORIGINAIS AQUI
  // (Copiando exatamente do seu arquivo original - todos os métodos como _buildBookRecordReceiveSection, _buildTitles, etc.)

  Widget _buildBookRecordReceiveSection() {
    final actions = [
      {
        'number': 1,
        'title': 'BOOK',
        'subtitle': 'Schedule Session',
        'description': 'Lock in your desired session on a day and time that works best for you',
        'color': AppTheme.accentPrimary,
      },
      {
        'number': 2,
        'title': 'RECORD',
        'subtitle': 'Start Creating',
        'description': 'Professional recording with state-of-the-art equipment and technology',
        'color': Colors.red.shade400,
      },
      {
        'number': 3,
        'title': 'RECEIVE',
        'subtitle': 'Get Your Content',
        'description': 'Download your professionally edited and produced content ready to publish',
        'color': Colors.green.shade400,
      },
    ];

    return Column(
      children: [
        Text(
          'HOW IT WORKS',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w700,
            fontSize: 36,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 50),
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 35,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accentPrimary.withOpacity(0.5),
                      Colors.red.shade400.withOpacity(0.5),
                      Colors.green.shade400.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ).animate().fadeIn(duration: 1200.ms, delay: 600.ms).scaleX(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions.map((action) {
                int index = actions.indexOf(action);
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1a1a1a),
                          border: Border.all(
                            color: (action['color'] as Color),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (action['color'] as Color).withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            action['number'].toString(),
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: (action['color'] as Color).withOpacity(0.8),
                                  blurRadius: 6,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        action['title'] as String,
                        style: TextStyle(
                          color: action['color'] as Color,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        action['subtitle'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          action['description'] as String,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Lato',
                            fontSize: 11,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: (index * 250).ms)
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.3, end: 0)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'THE STUDIO',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.w700,
              fontSize: 36,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Professional Media Production',
            style: TextStyle(
              color: Colors.white.withAlpha(179),
              fontFamily: 'Lato',
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.3, end: 0),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {
        'title': 'VIDEO PODCASTING',
        'description': 'Full production video podcasting with professional cameras, audio, microphones, lighting.',
        'svgPath': 'assets/images/icons/podcast-icon.svg',
        'fallbackIcon': Icons.videocam,
        'placeholder': 'podcast-icon.svg',
      },
      {
        'title': 'LIVE STREAMING',
        'description': 'Stream LIVE with professional audio and video including graphics, live call ins.',
        'svgPath': 'assets/images/icons/live-icon.svg',
        'fallbackIcon': Icons.live_tv,
        'placeholder': 'live-icon.svg',
      },
      {
        'title': 'SOCIAL MEDIA',
        'description': 'Create single person content for Instagram Reels, TikTok, Youtube.',
        'svgPath': 'assets/images/icons/media-icon.svg',
        'fallbackIcon': Icons.video_library,
        'placeholder': 'media-icon.svg',
      },
    ];

    return Column(
      children: services.map((service) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.backgroundSecondary,
                AppTheme.backgroundTertiary.withAlpha(153),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withAlpha(25),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0D0D0D),
                      AppTheme.backgroundSecondary,
                      const Color(0xFF111111),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withAlpha(38),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(76),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildServiceIcon(
                      svgPath: service['svgPath'] as String,
                      fallbackIcon: service['fallbackIcon'] as IconData,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['placeholder'] as String,
                      style: TextStyle(
                        color: Colors.white.withAlpha(128),
                        fontSize: 8,
                        fontFamily: 'Lato',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'] as String,
                      style: TextStyle(
                        color: AppTheme.accentPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Oswald',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['description'] as String,
                      style: TextStyle(
                        color: Colors.white.withAlpha(204),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.3, end: 0);
      }).toList(),
    );
  }

  Widget _buildServiceIcon({
    required String svgPath,
    required IconData fallbackIcon,
  }) {
    return SvgPicture.asset(
      svgPath,
      width: 32,
      height: 32,
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (context) => Icon(
        fallbackIcon,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  // ✅ ADICIONE AQUI TODOS OS OUTROS MÉTODOS DO SEU ARQUIVO ORIGINAL
  // _buildBookingPackagesSection(), _buildProductsAndPackagesSection(), _buildCallToAction(), etc.
  // (Mantenha exatamente como estava no seu código original)

  Widget _buildBookingPackagesSection() {
    final packages = [
      {
        'title': 'The Mic Drop Table',
        'duration': '1 hour 30 minutes',
        'price': r'$99.00',
        'features': [
          'Full Editing (audio + video) (90 minutes Session)',
          '3 Cameras',
          'Up to 4 Rode Microphones',
          'Studio Engineer',
        ],
        'icon': Icons.table_restaurant,
        'color': AppTheme.accentPrimary,
      },
      {
        'title': 'The Sofa Session',
        'duration': '1 hour 30 minutes',
        'price': r'$99.00',
        'features': [
          'Full Editing (audio + video) (90 minutes Session)',
          '3 Cameras',
          'Up to 4 Rode Microphones',
          'Studio Engineer',
        ],
        'icon': Icons.weekend,
        'color': Colors.orange.shade400,
      },
      {
        'title': 'Content Creator',
        'duration': '4 hours',
        'price': r'$300.00',
        'features': [
          'Clips / Reels / Shorts For Social Media (120 Minutes Session)',
          'Multi-Cam Recording + Professional Lighting & Audio',
          'Free Teleprompter Use',
          'On-camera coaching (presentation tips, pacing, energy)',
          'Audio cleanup and mastering',
        ],
        'icon': Icons.video_camera_front,
        'color': Colors.purple.shade400,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'BOOK YOUR SESSION NOW',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w700,
            fontSize: 36,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        Text(
          'We\'ll reach out within 24 hours to confirm details and make sure your session runs smoothly. Please plan to arrive 15 minutes before your scheduled time for setup.',
          style: TextStyle(
            color: Colors.white.withAlpha(179),
            fontFamily: 'Lato',
            fontSize: 16,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 40),
        ...packages.asMap().entries.map((entry) {
          int index = entry.key;
          Map package = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.backgroundSecondary,
                    AppTheme.backgroundTertiary.withAlpha(153),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: (package['color'] as Color).withAlpha(76),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(76),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: (package['color'] as Color).withAlpha(25),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (package['color'] as Color).withAlpha(204),
                              (package['color'] as Color).withAlpha(153),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (package['color'] as Color).withAlpha(76),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          package['icon'] as IconData,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package['title'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  package['duration'] as String,
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(204),
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  ' @ ',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(153),
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  package['price'] as String,
                                  style: TextStyle(
                                    color: package['color'] as Color,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...((package['features'] as List).map((feature) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: package['color'] as Color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (package['color'] as Color).withAlpha(76),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: Colors.white.withAlpha(217),
                                fontFamily: 'Lato',
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => _navigateToBooking(package),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: package['color'] as Color,
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: (package['color'] as Color).withAlpha(76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 0),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white.withAlpha(25);
                            }
                            return null;
                          },
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Book Now',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(51),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.arrow_forward, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: (index * 200).ms)
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.5, end: 0)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
        }).toList(),
      ],
    );
  }

  Widget _buildProductsAndPackagesSection() {
    final packages = [
      {
        'title': 'Monthly Package',
        'price': r'$400.00',
        'duration': '4 sessions/month',
        'features': [
          '4 Podcast Recording Sessions / month (up to 90 Minutes Session)',
          'Full Editing (audio + video )',
          '4 Shorts/Reels per episode',
          '3 Cameras',
          '4 Rode Microphones',
          'Studio Engineer',
        ],
        'icon': Icons.calendar_month,
        'color': Colors.blueAccent.shade700,
      },
      {
        'title': 'Membership OUTBOX',
        'price': r'$1,100.00 per month',
        'duration': '6 sessions/month',
        'features': [
          '6 Podcast Recording Sessions / month (120 Minutes Session)',
          'Full Editing (audio + video with branding overlays)',
          'Custom Graphics Pack (banners, intros, branding kit)',
          'Highlight intro hook for every episode to draw in your audience from the start.',
          'Thumbnail Design for YouTube',
          'Unlimited YouTube Upload Support',
          '6 Shorts/Reels per episode',
          '3 Clips up 7 minutes per Episode',
          'Priority Scheduling & Support',
          '3 Cameras',
          '4 Rode Microphones',
          'Studio Engineer',
        ],
        'icon': Icons.workspace_premium,
        'color': Colors.tealAccent.shade700,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'PRODUCTS & PACKAGES',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w700,
            fontSize: 36,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 30),
        ...packages.asMap().entries.map((entry) {
          int index = entry.key;
          Map pack = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 28),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.backgroundSecondary,
                    AppTheme.backgroundTertiary.withAlpha(153),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: (pack['color'] as Color).withAlpha(102),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(76),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: (pack['color'] as Color).withAlpha(25),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (pack['color'] as Color).withAlpha(204),
                              (pack['color'] as Color).withAlpha(179),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (pack['color'] as Color).withAlpha(51),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          pack['icon'] as IconData,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pack['title'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pack['price'] as String,
                              style: TextStyle(
                                color: pack['color'] as Color,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ...((pack['features'] as List).map((feature) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: pack['color'] as Color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (pack['color'] as Color).withAlpha(76),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: Colors.white.withAlpha(217),
                                fontFamily: 'Lato',
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => _navigateToBooking(pack),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pack['color'] as Color,
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: (pack['color'] as Color).withAlpha(76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 0),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white.withAlpha(25);
                            }
                            return null;
                          },
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Book Now',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(51),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.arrow_forward, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: (index * 200).ms)
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.3, end: 0)
              .scale(begin: const Offset(0.96, 0.96), end: const Offset(1.0, 1.0));
        }).toList(),
      ],
    );
  }

  Widget _buildCallToAction() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentPrimary.withAlpha(76),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Ready to Create?',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Oswald',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your session today and bring your vision to life',
            style: TextStyle(
              color: Colors.black.withAlpha(204),
              fontFamily: 'Lato',
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToPackages,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ).animate()
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
  }
}
