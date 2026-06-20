import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moparthi Prem | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5C35),
          secondary: Color(0xFFB2FF33),
          surface: Color(0xFF171717),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const PortfolioScreen(),
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Keys for section navigation
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  int _activeSectionIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Determine active section based on scroll offset to highlight nav buttons
    final double offset = _scrollController.offset;
    // Basic approximate thresholds
    if (offset < 600) {
      if (_activeSectionIndex != 0) setState(() => _activeSectionIndex = 0);
    } else if (offset >= 600 && offset < 1400) {
      if (_activeSectionIndex != 1) setState(() => _activeSectionIndex = 1);
    } else if (offset >= 1400 && offset < 2100) {
      if (_activeSectionIndex != 2) setState(() => _activeSectionIndex = 2);
    } else if (offset >= 2100 && offset < 2800) {
      if (_activeSectionIndex != 3) setState(() => _activeSectionIndex = 3);
    } else {
      if (_activeSectionIndex != 4) setState(() => _activeSectionIndex = 4);
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 950;
          
          if (isDesktop) {
            // Desktop Layout: Two columns (Left Sticky Profile Card, Right Scrollable Panel)
            return SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Sticky Panel
                  Container(
                    width: 380,
                    height: constraints.maxHeight,
                    padding: const EdgeInsets.all(24),
                    child: const LeftProfileCard(),
                  ),
                  
                  // Right Scrollable Panel
                  Expanded(
                    child: Stack(
                      children: [
                        // Main Scrollable Area
                        SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(left: 24, right: 64, top: 100, bottom: 64),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sections with keys for smooth scrolling
                              Container(key: _homeKey, child: _buildHeroSection(isDesktop)),
                              const SizedBox(height: 80),
                              Container(key: _projectsKey, child: _buildProjectsSection()),
                              const SizedBox(height: 80),
                              Container(key: _experienceKey, child: _buildExperienceSection()),
                              const SizedBox(height: 80),
                              Container(key: _skillsKey, child: _buildSkillsSection()),
                              const SizedBox(height: 80),
                              Container(key: _contactKey, child: _buildContactSection()),
                            ],
                          ),
                        ),
                        
                        // Floating Navbar at the top of the right panel
                        Positioned(
                          top: 24,
                          left: 24,
                          right: 64,
                          child: Align(
                            alignment: Alignment.center,
                            child: FloatingNavbar(
                              activeIndex: _activeSectionIndex,
                              onTap: (index) {
                                switch (index) {
                                  case 0: _scrollToSection(_homeKey); break;
                                  case 1: _scrollToSection(_projectsKey); break;
                                  case 2: _scrollToSection(_experienceKey); break;
                                  case 3: _scrollToSection(_skillsKey); break;
                                  case 4: _scrollToSection(_contactKey); break;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Mobile/Tablet Layout: Single Column vertical flow
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 90, bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Profile Card acts as top header card on mobile
                        const LeftProfileCard(),
                        const SizedBox(height: 48),
                        
                        // Main Content sections
                        Container(key: _homeKey, child: _buildHeroSection(isDesktop)),
                        const SizedBox(height: 64),
                        Container(key: _projectsKey, child: _buildProjectsSection()),
                        const SizedBox(height: 64),
                        Container(key: _experienceKey, child: _buildExperienceSection()),
                        const SizedBox(height: 64),
                        Container(key: _skillsKey, child: _buildSkillsSection()),
                        const SizedBox(height: 64),
                        Container(key: _contactKey, child: _buildContactSection()),
                      ],
                    ),
                  ),
                  
                  // Floating Navbar centered at the top for mobile
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Align(
                      alignment: Alignment.center,
                      child: FloatingNavbar(
                        activeIndex: _activeSectionIndex,
                        onTap: (index) {
                          switch (index) {
                            case 0: _scrollToSection(_homeKey); break;
                            case 1: _scrollToSection(_projectsKey); break;
                            case 2: _scrollToSection(_experienceKey); break;
                            case 3: _scrollToSection(_skillsKey); break;
                            case 4: _scrollToSection(_contactKey); break;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // --- Right Panel Section Builders ---

  Widget _buildHeroSection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Giant Heading Block
        Wrap(
          direction: Axis.vertical,
          spacing: 0,
          children: [
            Text(
              "FULL STACK",
              style: GoogleFonts.outfit(
                fontSize: isDesktop ? 76 : 48,
                fontWeight: FontWeight.w900,
                height: 1.0,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
            Text(
              "FLUTTER DEV",
              style: GoogleFonts.outfit(
                fontSize: isDesktop ? 76 : 48,
                fontWeight: FontWeight.w900,
                height: 1.1,
                letterSpacing: -1,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Colors.white.withOpacity(0.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          "Passionate about creating intuitive, high-performance, and gorgeous user experiences. Specializing in transforming ideas into beautifully crafted, clean mobile and backend ecosystems.",
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            color: const Color(0xFF9F9F9F),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        
        // Stats Counter Row
        const Wrap(
          spacing: 48,
          runSpacing: 24,
          children: [
            StatItem(value: "+2", label: "YEARS OF\nEXPERIENCE"),
            StatItem(value: "+12", label: "COMPLETED\nPROJECTS"),
            StatItem(value: "+5", label: "APPS ON STORES\n(PLAY & APP STORE)"),
          ],
        ),
        const SizedBox(height: 48),
        
        // Large Action block cards (Orange & Lime Green)
        LayoutBuilder(
          builder: (context, cardConstraints) {
            final double cardWidth = isDesktop 
              ? (cardConstraints.maxWidth - 24) / 2
              : cardConstraints.maxWidth;
            
            final cards = [
              GridAccentCard(
                width: cardWidth,
                bgColor: const Color(0xFFFF5C35),
                textColor: Colors.white,
                icon: Icons.layers_outlined,
                title: "CLEAN ARCHITECTURE\n& SECURE DESIGN",
                description: "Clean architecture, MVC, state management, and strict separation of concerns.",
              ),
              GridAccentCard(
                width: cardWidth,
                bgColor: const Color(0xFFB2FF33),
                textColor: const Color(0xFF0F0F0F),
                icon: Icons.code,
                title: "FLUTTER, FIREBASE\n& MOBILE ECOSYSTEMS",
                description: "Cross-platform mobile apps, dynamic systems, secure payment gates, and notifications.",
              ),
            ];

            return isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: cards,
                )
              : Column(
                  children: [
                    cards[0],
                    const SizedBox(height: 16),
                    cards[1],
                  ],
                );
          },
        ),
      ],
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "RECENT ",
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              "WORKS",
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.5
                  ..color = Colors.white.withOpacity(0.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Project items
        ProjectCard(
          year: "2025-2026",
          title: "Seven Pay Services",
          subtitle: "Fintech Flutter Application & Admin Dashboard",
          description: "Built and deployed a production-ready Flutter application integrated with Firebase Authentication, Firestore, and Cloud Functions. Designed real-time service management, secure payment workflows (Razorpay integration), and comprehensive admin controls with optimized data operations.",
          techTags: const ["Flutter", "Dart", "Firebase Auth", "Firestore", "Cloud Functions", "Razorpay"],
          icon: Icons.payment,
        ),
        const SizedBox(height: 24),
        ProjectCard(
          year: "2025-2026",
          title: "Ride 4 you",
          subtitle: "Real-time Location-Based Ride Booking Platform",
          description: "Built a location-based ride booking platform with real-time GPS tracking, dynamic pricing models, and instant driver allocation algorithms. Integrated Firebase Authentication, Firestore, and Cloud Functions for secure ride lifecycle management and seamless payment checkouts.",
          techTags: const ["Flutter & Dart", "Google Maps API", "GPS Tracking", "Firestore", "Cloud Functions"],
          icon: Icons.local_taxi,
        ),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "WORK ",
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              "EXPERIENCE",
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.5
                  ..color = Colors.white.withOpacity(0.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Experience items
        TimelineExperienceCard(
          duration: "2026-Present",
          company: "All Hands Global Pvt. Ltd.",
          location: "HYDERABAD · India",
          role: "Flutter Developer",
          description: "Working as a Flutter Developer, responsible for designing and developing cross-platform mobile applications (Android & iOS) and Web Admin Panels. Implementing scalable app architectures, secure authentication protocols, dynamic content synchronization, and seamless integration with third-party modules and APIs.",
        ),
        const SizedBox(height: 24),
        TimelineExperienceCard(
          duration: "2024-2025",
          company: "Space Age Infotech",
          location: "BENGALURU · India",
          role: "Web Developer",
          description: "Worked as a Web Developer, developing responsive websites and interactive web applications. Successfully implemented REST API integrations, optimized client-side performance, and ensured highly secure, robust, and scalable solutions for dynamic service websites.",
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "SKILLS & ",
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              "SPECIALIZATION",
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.5
                  ..color = Colors.white.withOpacity(0.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Education and Skills Content blocks
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 700;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1: Technical Skill chips
                Expanded(
                  flex: isDesktop ? 6 : 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TECHNICAL EXPERTISE",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB2FF33),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          SkillChip(label: "Flutter (Android / iOS / Web)"),
                          SkillChip(label: "Firebase (Auth, Firestore, Cloud Functions)"),
                          SkillChip(label: "Clean Architecture & MVC"),
                          SkillChip(label: "State Management (Bloc, Riverpod, Provider)"),
                          SkillChip(label: "REST APIs & Razorpay"),
                          SkillChip(label: "Swift & Kotlin"),
                          SkillChip(label: "Play Store & App Store Deployments"),
                          SkillChip(label: "Git / GitHub"),
                          SkillChip(label: "Secure System Design"),
                          SkillChip(label: "Xcode & Android Studio"),
                          SkillChip(label: "Figma UI/UX design"),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      Text(
                        "PROGRAMMING LANGUAGES",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFF5C35),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          LangChip(name: "Dart", rating: 5),
                          LangChip(name: "Kotlin", rating: 4),
                          LangChip(name: "Python", rating: 4),
                          LangChip(name: "Java", rating: 3),
                          LangChip(name: "React.js", rating: 3),
                        ],
                      ),
                    ],
                  ),
                ),
                
                if (isDesktop) const SizedBox(width: 32),
                
                // Column 2: Education Info
                if (isDesktop)
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EDUCATION",
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const EducationTimelineItem(
                          year: "2019-2023",
                          degree: "B.Tech - Computer Science",
                          school: "National Institute of Technology Sikkim, India",
                        ),
                        const SizedBox(height: 16),
                        const EducationTimelineItem(
                          year: "2017-2019",
                          degree: "Intermediate (12th)",
                          school: "Narayana Junior College, Andhra Pradesh",
                        ),
                        const SizedBox(height: 16),
                        const EducationTimelineItem(
                          year: "2016-2017",
                          degree: "Secondary Education (10th)",
                          school: "Kennedy School, Andhra Pradesh",
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        
        // Display Education below on Mobile
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth <= 700;
            if (!isMobile) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  "EDUCATION",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const EducationTimelineItem(
                  year: "2019-2023",
                  degree: "B.Tech - Computer Science",
                  school: "National Institute of Technology Sikkim, India",
                ),
                const SizedBox(height: 16),
                const EducationTimelineItem(
                  year: "2017-2019",
                  degree: "Intermediate (12th)",
                  school: "Narayana Junior College, Andhra Pradesh",
                ),
                const SizedBox(height: 16),
                const EducationTimelineItem(
                  year: "2016-2017",
                  degree: "Secondary Education (10th)",
                  school: "Kennedy School, Andhra Pradesh",
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "GET IN ",
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              "TOUCH",
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.5
                  ..color = Colors.white.withOpacity(0.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        Text(
          "I am open to new professional opportunities, full-time Flutter roles, app architecture consultations, or just standard tech chats. Drop me a line directly!",
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6), height: 1.6),
        ),
        const SizedBox(height: 32),
        
        // Contact block links
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ContactTileCard(
              icon: Icons.email_outlined,
              title: "Email me",
              value: "premmoparthi0829@gmail.com",
              url: "mailto:premmoparthi0829@gmail.com",
            ),
            ContactTileCard(
              icon: Icons.phone_android_outlined,
              title: "Call/WhatsApp",
              value: "+91 7780324745",
              url: "tel:+917780324745",
            ),
            ContactTileCard(
              icon: Icons.location_on_outlined,
              title: "Based in",
              value: "Hyderabad, India",
              url: "https://maps.google.com/?q=Hyderabad,India",
            ),
          ],
        ),
        const SizedBox(height: 48),
        
        // Footer credits
        const Divider(color: Colors.white10),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "© 2026 Moparthi Prem. All rights reserved.",
              style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
            ),
            Text(
              "Premium Flutter Web Portfolio",
              style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}

// --- Custom Reusable Interactive Widgets ---

class HoverWidget extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Function()? onTap;

  const HoverWidget({
    super.key,
    required this.child,
    this.scale = 1.025,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
  });

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

// --- Floating Navigation Bar ---

class FloatingNavbar extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTap;

  const FloatingNavbar({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withOpacity(0.85),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavItem(0, Icons.home_outlined),
          _buildNavItem(1, Icons.folder_open_outlined),
          _buildNavItem(2, Icons.work_outline),
          _buildNavItem(3, Icons.psychology_outlined),
          _buildNavItem(4, Icons.mail_outline),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isActive = activeIndex == index;
    return HoverWidget(
      onTap: () => onTap(index),
      scale: 1.15,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? const Color(0xFF0F0F0F) : Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}

// --- Left Sticky Profile Card ---

class LeftProfileCard extends StatelessWidget {
  const LeftProfileCard({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Photo with concentric dashed circles background
          AspectRatio(
            aspectRatio: 1.1,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Concentric circles painted behind the picture
                Positioned.fill(
                  child: CustomPaint(
                    painter: DashedCirclesPainter(),
                  ),
                ),
                
                // Orange image frame
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 175,
                    height: 185,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5C35),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white, width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/profile.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Safe fallback if image is not loaded
                        return Container(
                          color: const Color(0xFFFF5C35),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Name and Details
          Text(
            "Moparthi Prem",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: const Color(0xFF0F0F0F),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Full Stack Flutter Developer &\nMobile Application Architect",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF555555),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          
          // Orange circular flame element
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5C35).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF5C35).withOpacity(0.2), width: 1.5),
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Color(0xFFFF5C35),
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Short bio
          const Text(
            "Computer Science graduate from NIT Sikkim. Building highly secure, robust systems with expertise in Clean Architecture, state structures, dynamic payments, and cloud APIs.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 12.5,
              height: 1.55,
            ),
          ),
          const Spacer(),
          
          // Interactive Social icons row (Orange theme)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialIconBtn(
                icon: Icons.language,
                onTap: () => _launchUrl("https://github.com/premmoparthi0829"),
                tooltip: "GitHub",
              ),
              SocialIconBtn(
                icon: Icons.work_history_outlined,
                onTap: () => _launchUrl("https://linkedin.com/in/moparthi-prem"),
                tooltip: "LinkedIn",
              ),
              SocialIconBtn(
                icon: Icons.chat_bubble_outline_outlined,
                onTap: () => _launchUrl("tel:+917780324745"),
                tooltip: "Contact",
              ),
              SocialIconBtn(
                icon: Icons.alternate_email_outlined,
                onTap: () => _launchUrl("mailto:premmoparthi0829@gmail.com"),
                tooltip: "Email",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Social Icon Button ---

class SocialIconBtn extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final String tooltip;

  const SocialIconBtn({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: HoverWidget(
        onTap: onTap,
        scale: 1.25,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFF5C35).withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF5C35).withOpacity(0.15), width: 1),
          ),
          child: Icon(
            icon,
            size: 18,
            color: const Color(0xFFFF5C35),
          ),
        ),
      ),
    );
  }
}

// --- Dashed concentric background circles for Avatar ---

class DashedCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFFFF5C35).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    _drawDashedCircle(canvas, center, 105, paint, 6, 6);
    _drawDashedCircle(canvas, center, 125, paint, 8, 8);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint, double dashWidth, double dashSpace) {
    final double circumference = 2 * 3.1415926535 * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();
    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * (dashWidth + dashSpace) / circumference) * 2 * 3.1415926535;
      final double sweepAngle = (dashWidth / circumference) * 2 * 3.1415926535;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- Stat Card Helper ---

class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 54,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF8F8F8F),
            letterSpacing: 1.2,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// --- Grid Action Accent Card ---

class GridAccentCard extends StatelessWidget {
  final double width;
  final Color bgColor;
  final Color textColor;
  final IconData icon;
  final String title;
  final String description;

  const GridAccentCard({
    super.key,
    required this.width,
    required this.bgColor,
    required this.textColor,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      scale: 1.03,
      child: Container(
        width: width,
        height: 200,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 32,
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Recent Project Card ---

class ProjectCard extends StatelessWidget {
  final String year;
  final String title;
  final String subtitle;
  final String description;
  final List<String> techTags;
  final IconData icon;

  const ProjectCard({
    super.key,
    required this.year,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.techTags,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      scale: 1.015,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    year,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_outward,
                  color: Colors.white.withOpacity(0.4),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5C35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFFF5C35),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: techTags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Timeline Experience Card ---

class TimelineExperienceCard extends StatelessWidget {
  final String duration;
  final String company;
  final String location;
  final String role;
  final String description;

  const TimelineExperienceCard({
    super.key,
    required this.duration,
    required this.company,
    required this.location,
    required this.role,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      scale: 1.015,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  duration,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFB2FF33),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              company,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              role,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Education Timeline Item ---

class EducationTimelineItem extends StatelessWidget {
  final String year;
  final String degree;
  final String school;

  const EducationTimelineItem({
    super.key,
    required this.year,
    required this.degree,
    required this.school,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFB2FF33),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                year,
                style: GoogleFonts.outfit(
                  color: const Color(0xFFB2FF33),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                degree,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                school,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Skill Chip Helper ---

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// --- Language Chip with Star Rating Helper ---

class LangChip extends StatelessWidget {
  final String name;
  final int rating;

  const LangChip({
    super.key,
    required this.name,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 12,
                color: index < rating ? const Color(0xFFFF5C35) : Colors.white.withOpacity(0.1),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// --- Contact Tile Card ---

class ContactTileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String url;

  const ContactTileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.url,
  });

  Future<void> _launchUrl() async {
    final Uri parsedUrl = Uri.parse(url);
    if (!await launchUrl(parsedUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $parsedUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onTap: _launchUrl,
      scale: 1.025,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
