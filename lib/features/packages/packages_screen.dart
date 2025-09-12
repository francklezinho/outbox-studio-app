// lib/features/packages/packages_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import 'package_card.dart';
import '../booking/booking_screen.dart';

class PackagesScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const PackagesScreen({super.key, this.onBackToHome});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  String _sortBy = 'Default';

  final List<PackageData> _packages = [
    PackageData(
      title: 'The Mic Drop Table',
      badge: 'Most Popular',
      icon: Icons.table_restaurant,
      description: '1 hour 30 minutes @ \$99.00 - Professional podcast recording setup',
      price: '\$99.00',
      color: Colors.amber.shade400,
      features: [
        'Full Editing (audio + video) (90 minutes Session)',
        '3 Cameras',
        'Up to 4 Rode Microphones',
        'Studio Engineer',
      ],
    ),
    PackageData(
      title: 'The Sofa Session',
      badge: 'Comfortable',
      icon: Icons.weekend,
      description: '1 hour 30 minutes @ \$99.00 - Relaxed sofa recording experience',
      price: '\$99.00',
      color: Colors.orange.shade400,
      features: [
        'Full Editing (audio + video) (90 minutes Session)',
        '3 Cameras',
        'Up to 4 Rode Microphones',
        'Studio Engineer',
      ],
    ),
    PackageData(
      title: 'Content Creator',
      badge: 'Advanced',
      icon: Icons.video_camera_front,
      description: '4 hours @ \$300.00 - Complete content creation package',
      price: '\$300.00',
      color: Colors.purple.shade400,
      features: [
        'Clips / Reels / Shorts For Social Media (120 Minutes Session)',
        'Multi-Cam Recording + Professional Lighting & Audio',
        'Free Teleprompter Use',
        'On-camera coaching (presentation tips, pacing, energy)',
        'Audio cleanup and mastering',
      ],
    ),
    PackageData(
      title: 'Monthly Package',
      badge: 'Best Value',
      icon: Icons.calendar_month,
      description: '\$400.00 - Monthly recurring package with multiple sessions',
      price: '\$400.00',
      color: Colors.blueAccent.shade700,
      features: [
        '4 Podcast Recording Sessions / month (up to 90 Minutes Session)',
        'Full Editing (audio + video)',
        '4 Shorts/Reels per episode',
        '3 Cameras',
        '4 Rode Microphones',
        'Studio Engineer',
      ],
    ),
    PackageData(
      title: 'Membership OUTBOX',
      badge: 'Premium',
      icon: Icons.workspace_premium,
      description: '\$1,100.00 per month - Ultimate membership with premium features',
      price: '\$1,100.00',
      color: Colors.tealAccent.shade700,
      features: [
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
    ),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _goToBooking({
    required String name,
    required String badge,
    required String price,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => BookingScreen(
          packageName: name,
          packageBadge: badge,
          packagePrice: price,
        ),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _showDetails(PackageData p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PackageDetailsSheet(
        data: p,
        onBook: () => _goToBooking(
          name: p.title,
          badge: p.badge,
          price: p.price,
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.8),
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return SizedBox(
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF1A1A1A).withOpacity(0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filter & Sort',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.attach_money, color: AppTheme.accentPrimary, size: 20),
                      title: Text(
                          'Sort by Price',
                          style: TextStyle(color: Colors.white, fontFamily: 'Lato', fontSize: 14)
                      ),
                      trailing: _sortBy == 'Price' ? Icon(Icons.check, color: AppTheme.accentPrimary, size: 20) : null,
                      onTap: () {
                        setModalState(() => _sortBy = 'Price');
                        setState(() => _sortBy = 'Price');
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sorted by Price'),
                            backgroundColor: AppTheme.accentPrimary,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.star, color: AppTheme.accentPrimary, size: 20),
                      title: Text(
                          'Sort by Popularity',
                          style: TextStyle(color: Colors.white, fontFamily: 'Lato', fontSize: 14)
                      ),
                      trailing: _sortBy == 'Popularity' ? Icon(Icons.check, color: AppTheme.accentPrimary, size: 20) : null,
                      onTap: () {
                        setModalState(() => _sortBy = 'Popularity');
                        setState(() => _sortBy = 'Popularity');
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sorted by Popularity'),
                            backgroundColor: AppTheme.accentPrimary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildModernHeader(),
              Expanded(
                child: FadeTransition(
                  opacity: _fade,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                    itemCount: _packages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final package = _packages[index];
                      return GestureDetector(
                        onTap: () => _showDetails(package),
                        child: _buildModernPackageCard(package, index),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // ✅ CORREÇÃO: AGORA VOLTA PARA HOME SEMPRE
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundSecondary.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1), // ✅ MUDANÇA: BORDA BRANCA
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white, // ✅ MUDANÇA: SETA BRANCA
                      size: 24,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.5, end: 0),
              const Spacer(),
              Text(
                'PACKAGES',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
              const Spacer(),
              // ✅ MUDANÇA: BOTÃO FILTRO IGUAL À SETA
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _showFilterOptions,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundSecondary.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1), // ✅ MUDANÇA: BORDA BRANCA IGUAL À SETA
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: Colors.white, // ✅ MUDANÇA: ÍCONE BRANCO IGUAL À SETA
                      size: 24,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideX(begin: 0.5, end: 0),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Choose Your Perfect\nStudio Experience',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Professional packages tailored to your creative needs',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontFamily: 'Lato',
                    height: 1.4,
                  ),
                ),
              ),
              if (_sortBy != 'Default')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPrimary.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Sorted by $_sortBy',
                    style: TextStyle(
                      color: AppTheme.accentPrimary,
                      fontSize: 12,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildModernPackageCard(PackageData package, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundSecondary,
            AppTheme.backgroundTertiary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: package.color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: package.color.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      package.color.withOpacity(0.8),
                      package.color.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: package.color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  package.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      package.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      package.price,
                      style: TextStyle(
                        color: package.color,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: package.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: package.color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  package.badge,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            package.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'Lato',
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          ...package.features.take(2).map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: package.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontFamily: 'Lato',
                      fontSize: 13,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )).toList(),
          if (package.features.length > 2)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                '+ ${package.features.length - 2} more features...',
                style: TextStyle(
                  color: package.color.withOpacity(0.8),
                  fontFamily: 'Lato',
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showDetails(package),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: package.color,
                    side: BorderSide(color: package.color.withOpacity(0.5), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _goToBooking(
                    name: package.title,
                    badge: package.badge,
                    price: package.price,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: package.color,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: package.color.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Book Now',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (index * 150).ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
  }
}

class PackageData {
  final String title;
  final String badge;
  final IconData icon;
  final String description;
  final String price;
  final List<String> features;
  final Color color;

  const PackageData({
    required this.title,
    required this.badge,
    required this.icon,
    required this.description,
    required this.price,
    required this.features,
    required this.color,
  });
}

class _PackageDetailsSheet extends StatelessWidget {
  final PackageData data;
  final VoidCallback onBook;

  const _PackageDetailsSheet({
    required this.data,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundSecondary,
            AppTheme.backgroundTertiary.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: data.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              data.color.withOpacity(0.8),
                              data.color.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: data.color.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(data.icon, size: 32, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.price,
                              style: TextStyle(
                                color: data.color,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: data.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.badge,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    data.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                      fontFamily: 'Lato',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: data.color, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'What\'s Included:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...data.features.map((feature) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: data.color.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: data.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: 'Lato',
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onBook();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: data.color,
                        foregroundColor: Colors.white,
                        elevation: 12,
                        shadowColor: data.color.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'Book This Package',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
