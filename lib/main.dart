import 'dart:ui' show ImageFilter;
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_icons/simple_icons.dart';
import 'services/resume_service.dart';
import 'utils/download_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prem Moparthi | Portfolio',
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
                    child: const SingleChildScrollView(
                      child: LeftProfileCard(),
                    ),
                  ),

                  // Right Scrollable Panel
                  Expanded(
                    child: Stack(
                      children: [
                        // Main Scrollable Area
                        SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 64,
                            top: 100,
                            bottom: 64,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sections with keys for smooth scrolling
                              Container(
                                key: _homeKey,
                                child: _buildHeroSection(isDesktop),
                              ),
                              const SizedBox(height: 80),
                              Container(
                                key: _projectsKey,
                                child: _buildProjectsSection(),
                              ),
                              const SizedBox(height: 80),
                              Container(
                                key: _experienceKey,
                                child: _buildExperienceSection(),
                              ),
                              const SizedBox(height: 80),
                              Container(
                                key: _skillsKey,
                                child: _buildSkillsSection(),
                              ),
                              const SizedBox(height: 80),
                              Container(
                                key: _contactKey,
                                child: _buildContactSection(),
                              ),
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
                                  case 0:
                                    _scrollToSection(_homeKey);
                                    break;
                                  case 1:
                                    _scrollToSection(_projectsKey);
                                    break;
                                  case 2:
                                    _scrollToSection(_experienceKey);
                                    break;
                                  case 3:
                                    _scrollToSection(_skillsKey);
                                    break;
                                  case 4:
                                    _scrollToSection(_contactKey);
                                    break;
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
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 80,
                      bottom: 60,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Profile Card acts as top header card on mobile
                        const LeftProfileCard(),
                        const SizedBox(height: 48),

                        // Main Content sections
                        Container(
                          key: _homeKey,
                          child: _buildHeroSection(isDesktop),
                        ),
                        const SizedBox(height: 64),
                        Container(
                          key: _projectsKey,
                          child: _buildProjectsSection(),
                        ),
                        const SizedBox(height: 64),
                        Container(
                          key: _experienceKey,
                          child: _buildExperienceSection(),
                        ),
                        const SizedBox(height: 64),
                        Container(
                          key: _skillsKey,
                          child: _buildSkillsSection(),
                        ),
                        const SizedBox(height: 64),
                        Container(
                          key: _contactKey,
                          child: _buildContactSection(),
                        ),
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
                            case 0:
                              _scrollToSection(_homeKey);
                              break;
                            case 1:
                              _scrollToSection(_projectsKey);
                              break;
                            case 2:
                              _scrollToSection(_experienceKey);
                              break;
                            case 3:
                              _scrollToSection(_skillsKey);
                              break;
                            case 4:
                              _scrollToSection(_contactKey);
                              break;
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
    return LayoutBuilder(
      builder: (context, heroConstraints) {
        final double availableWidth = heroConstraints.maxWidth;
        // Scale heading font size from available width
        // Desktop: 76, Tablet (600-950): proportional, Mobile: clamp 28..40
        final double headingSize = isDesktop
            ? 76.0
            : (availableWidth * 0.105).clamp(28.0, 40.0);
        final double bodyFontSize = isDesktop ? 18.0 : 15.0;
        final double sectionSpacing = isDesktop ? 48.0 : 28.0;
        final double statsSpacing = isDesktop ? 48.0 : 24.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Giant Heading Block — always 3 lines on mobile, 2 on desktop
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  "FULL STACK",
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5C35), Color(0xFFB2FF33)],
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -0.5,
                  ),
                ),
                if (isDesktop)
                  GradientText(
                    "FLUTTER DEVELOPER",
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.4)],
                    ),
                    style: GoogleFonts.outfit(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  )
                else ...[
                  GradientText(
                    "FLUTTER",
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.4)],
                    ),
                    style: GoogleFonts.outfit(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  GradientText(
                    "DEVELOPER",
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.4)],
                    ),
                    style: GoogleFonts.outfit(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: isDesktop ? 24 : 16),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: bodyFontSize,
                  color: const Color(0xFF9F9F9F),
                  height: 1.6,
                ),
                children: isDesktop
                    ? [
                        const TextSpan(
                          text: "As a Mobile Application Architect & Lead Flutter Developer (CS graduate from NIT Sikkim), I engineer premium cross-platform ecosystems. Over the last 2+ years, I have successfully delivered 12+ premium projects and launched 5+ apps to production. Combining clean architecture with pixel-perfect design, I build secure, scalable, and polished mobile solutions. ",
                        ),
                        const TextSpan(
                          text: "Let's build together extraordinary mobile apps for Android & iOS!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]
                    : [
                        const TextSpan(
                          text: "CS graduate from NIT Sikkim and Mobile Architect specializing in engineering high-performance cross-platform applications. With 2+ years of experience, I have delivered 12+ projects and launched 5+ apps to production, leveraging clean architecture, reactive state, and pixel-perfect design. ",
                        ),
                        const TextSpan(
                          text: "Let's build together extraordinary mobile apps for Android & iOS!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
              ),
            ),
            SizedBox(height: sectionSpacing),

            // Stats Counter Row
            Wrap(
              spacing: statsSpacing,
              runSpacing: 20,
              children: [
                StatItem(
                  value: "+2",
                  label: "YEARS OF\nEXPERIENCE",
                  compact: !isDesktop,
                ),
                StatItem(
                  value: "+12",
                  label: "COMPLETED\nPROJECTS",
                  compact: !isDesktop,
                ),
                StatItem(
                  value: "+5",
                  label: "APPS ON STORES\n(PLAY & APP STORE)",
                  compact: !isDesktop,
                ),
              ],
            ),
            SizedBox(height: sectionSpacing),

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
                    description:
                        "Clean architecture, MVC, state management, and strict separation of concerns.",
                  ),
                  GridAccentCard(
                    width: cardWidth,
                    bgColor: const Color(0xFFB2FF33),
                    textColor: const Color(0xFF0F0F0F),
                    icon: Icons.code,
                    title: "FLUTTER, FIREBASE\n& MOBILE ECOSYSTEMS",
                    description:
                        "Cross-platform mobile apps, dynamic systems, secure payment gates, and notifications.",
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
      },
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        LayoutBuilder(
          builder: (context, c) {
            final double fs = c.maxWidth > 600 ? 36 : 28;
            return Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "RECENT ",
                  style: GoogleFonts.outfit(
                    fontSize: fs,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                GradientText(
                  "WORKS",
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.4)],
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: fs,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 32),

        // Dynamically generated project items mapping from static dataset
        ...ProjectDetail.projects.map((project) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: ProjectCard(
              year: project.year,
              title: project.title,
              subtitle: project.subtitle,
              description: project.description,
              techTags: project.techTags,
              icon: project.icon,
              onTap: () {
                Navigator.of(
                  context,
                ).push(ProjectDetailRoute(project: project));
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        LayoutBuilder(
          builder: (context, c) {
            final double fs = c.maxWidth > 600 ? 36 : 28;
            return Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "WORK ",
                  style: GoogleFonts.outfit(
                    fontSize: fs,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                GradientText(
                  "EXPERIENCE",
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.4)],
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: fs,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 32),

        // Experience items
        TimelineExperienceCard(
          duration: "2026-Present",
          company: "All Hands Global Pvt. Ltd.",
          location: "HYDERABAD · India",
          role: "Mobile Application Architect & Flutter Developer",
          description:
              "Lead the architecture and delivery of premium cross-platform mobile apps for iOS and Android. Spearheaded migrations to clean architecture, reducing codebase complexity and boosting feature delivery velocity. Integrated secure biometric auth, local caching (Hive/Isar), and optimized push notification delivery paths.",
        ),
        const SizedBox(height: 24),
        TimelineExperienceCard(
          duration: "2024-2025",
          company: "Space Age Infotech",
          location: "BENGALURU · India",
          role: "Software Development Engineer (Web & APIs)",
          description:
              "Developed performant, responsive web apps and robust REST APIs. Optimized API response times by implementing Redis caching and database indexing. Constructed smooth, interactive frontend dashboards using React, establishing solid fundamentals in UI state management and client-server synchronization.",
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        LayoutBuilder(
          builder: (context, c) {
            final double fs = c.maxWidth > 600 ? 36 : 26;
            return Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "SKILLS & ",
                  style: GoogleFonts.outfit(
                    fontSize: fs,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                GradientText(
                  "SPECIALIZATION",
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.4)],
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: fs,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            );
          },
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
                          SkillChip(
                            label:
                                "Firebase (Auth, Firestore, Cloud Functions)",
                          ),
                          SkillChip(label: "Clean Architecture & MVC"),
                          SkillChip(
                            label:
                                "State Management (Bloc, Riverpod, Provider)",
                          ),
                          SkillChip(label: "REST APIs & Razorpay"),
                          SkillChip(label: "Swift & Kotlin"),
                          SkillChip(
                            label: "Play Store & App Store Deployments",
                          ),
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
                          school:
                              "National Institute of Technology Sikkim, India",
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
    final isDesktop = MediaQuery.of(context).size.width > 950;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        LayoutBuilder(
          builder: (context, c) {
            final double fs = c.maxWidth > 600 ? 36 : 28;
            return Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "GET IN ",
                  style: GoogleFonts.outfit(
                    fontSize: fs,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                GradientText(
                  "TOUCH",
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.4)],
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: fs,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        Text(
          isDesktop
              ? "Let's get in touch! I'm always open to discussing new opportunities, codebase architecture, or consulting on scalable Flutter projects. Whether you want to collaborate, hire a dedicated Mobile Architect, or simply brainstorm high-performance systems, drop me a line directly!"
              : "Let's get in touch! I am deeply passionate about engineering high-performance mobile applications and always open to discussing full-time roles, codebase architecture, or collaborations. Drop me a line directly!",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.85),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),

        // Resume View & Download Row
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = constraints.maxWidth > 600
                ? 180.0
                : double.infinity;
            return Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                HoverWidget(
                  scale: 1.02,
                  onTap: () async {
                    try {
                      final resume = await ResumeService.getActiveResume();
                      if (resume.sourceType == ResumeSourceType.customUrl) {
                        final Uri url = Uri.parse(resume.url!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open resume link'),
                            ),
                          );
                        }
                      } else if (resume.bytes != null) {
                        viewFile(resume.bytes!, resume.fileName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No resume content available'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error viewing resume: $e')),
                      );
                    }
                  },
                  child: Container(
                    width: buttonWidth,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5C35).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFF5C35).withOpacity(0.35),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          color: Color(0xFFFF5C35),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "VIEW RESUME",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFFF5C35),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                HoverWidget(
                  scale: 1.02,
                  onTap: () async {
                    try {
                      final resume = await ResumeService.getActiveResume();
                      if (resume.sourceType == ResumeSourceType.customUrl) {
                        final Uri url = Uri.parse(resume.url!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open resume link'),
                            ),
                          );
                        }
                      } else if (resume.bytes != null) {
                        downloadFile(resume.bytes!, resume.fileName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No resume content available'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error downloading resume: $e')),
                      );
                    }
                  },
                  child: Container(
                    width: buttonWidth,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB2FF33).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFB2FF33).withOpacity(0.35),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.file_download_outlined,
                          color: Color(0xFFB2FF33),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "DOWNLOAD RESUME",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFB2FF33),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 32),

        // Contact block links
        LayoutBuilder(
          builder: (context, cc) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ContactTileCard(
                  icon: SimpleIcons.gmail,
                  title: "Email me",
                  value: "premmoparthi8@gmail.com",
                  url: "mailto:premmoparthi8@gmail.com",
                  accentColor: const Color(0xFFEA4335),
                ),
                ContactTileCard(
                  icon: SimpleIcons.whatsapp,
                  title: "Call/WhatsApp",
                  value: "",
                  url: "",
                  accentColor: const Color(0xFF25D366),
                  subItems: const [
                    {
                      "label": "Primary",
                      "value": "+91 7780324745",
                      "url": "tel:+917780324745",
                    },
                    {
                      "label": "Alternate",
                      "value": "+91 7287928766",
                      "url": "tel:+917287928766",
                    },
                  ],
                ),
                ContactTileCard(
                  icon: SimpleIcons.googlemaps,
                  title: "Based in",
                  value: "Hyderabad, India",
                  url: "https://maps.google.com/?q=Hyderabad,India",
                  accentColor: const Color(0xFF4285F4),
                ),
                ContactTileCard(
                  customIcon: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0077B5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ),
                  title: "LinkedIn",
                  value: "moparthi-prem",
                  url: "https://linkedin.com/in/moparthi-prem",
                  accentColor: const Color(0xFF0077B5),
                ),
                ContactTileCard(
                  icon: SimpleIcons.github,
                  title: "GitHub",
                  value: "premmoparthi0829",
                  url: "https://github.com/premmoparthi0829",
                  accentColor: const Color(0xFFB0BEC5),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 48),

        // Footer credits
        const Divider(color: Colors.white10),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = MediaQuery.of(context).size.width > 700;
            if (isWide) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "© 2026 Prem Moparthi. All rights reserved.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "Prem Moparthi Portfolio",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 13,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "© 2026 Prem Moparthi. All rights reserved.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Prem Moparthi Portfolio",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 13,
                    ),
                  ),
                ],
              );
            }
          },
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
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
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
    final isWide = MediaQuery.of(context).size.width > 600;
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
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 16 : 8,
        vertical: isWide ? 10 : 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavItem(context, 0, Icons.home_outlined),
          _buildNavItem(context, 1, Icons.folder_open_outlined),
          _buildNavItem(context, 2, Icons.work_outline),
          _buildNavItem(context, 3, Icons.psychology_outlined),
          _buildNavItem(context, 4, Icons.mail_outline),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final isActive = activeIndex == index;
    return HoverWidget(
      onTap: () => onTap(index),
      scale: 1.15,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isWide ? 6 : 3),
        padding: EdgeInsets.all(isWide ? 10 : 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: isWide ? 20 : 18,
          color: isActive
              ? const Color(0xFF0F0F0F)
              : Colors.white.withOpacity(0.6),
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
    final isNativeProtocol =
        url.scheme == 'mailto' || url.scheme == 'tel' || url.scheme == 'sms';
    if (!await launchUrl(
      url,
      mode: isNativeProtocol
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    )) {
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
                  child: CustomPaint(painter: DashedCirclesPainter()),
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
            "Prem Moparthi",
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
            "Mobile Application Architect &\nLead Flutter Developer",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF555555),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Android & iOS icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3DDC84).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF3DDC84).withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.android,
                  color: Color(0xFF3DDC84),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF555555).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF555555).withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.apple,
                  color: Color(0xFF555555),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            "Hi, I'm Prem! A passionate Mobile Architect focused on building fluid, high-performance user experiences. Specializing in secure clean architecture, state dynamics, and custom interactive animations that bring apps to life. Let's build together extraordinary mobile apps for Android & iOS!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 12.5,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 32),

          // Interactive Social icons row (Orange theme)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 0,
            runSpacing: 8,
            children: [
              SocialIconBtn(
                icon: Icons.language,
                onTap: () => _launchUrl("https://github.com/premmoparthi0829"),
                tooltip: "GitHub",
              ),
              SocialIconBtn(
                icon: Icons.work_history_outlined,
                onTap: () =>
                    _launchUrl("https://linkedin.com/in/moparthi-prem"),
                tooltip: "LinkedIn",
              ),
              SocialIconBtn(
                icon: Icons.chat_bubble_outline_outlined,
                onTap: () => _launchUrl("tel:+917780324745"),
                tooltip: "Contact",
              ),
              SocialIconBtn(
                icon: Icons.alternate_email_outlined,
                onTap: () => _launchUrl("mailto:premmoparthi8@gmail.com"),
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
            border: Border.all(
              color: const Color(0xFFFF5C35).withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFFFF5C35)),
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

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final double circumference = 2 * 3.1415926535 * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();
    for (int i = 0; i < dashCount; i++) {
      final double startAngle =
          (i * (dashWidth + dashSpace) / circumference) * 2 * 3.1415926535;
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
  final bool compact;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: compact ? 40 : 54,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: compact ? 10 : 11,
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
    final isWide = MediaQuery.of(context).size.width > 600;
    return HoverWidget(
      scale: 1.03,
      child: Container(
        width: width,
        height: isWide ? 220 : 230,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(isWide ? 28 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: textColor, size: 32),
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
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.year,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.techTags,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onTap: onTap,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                  child: Icon(icon, color: const Color(0xFFFF5C35), size: 24),
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
              children: techTags.map((tag) {
                final icon = TechIconHelper.getIcon(tag);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: TechIconHelper.getIconColor(icon),
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        tag,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 4,
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

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final icons = TechIconHelper.getIconsForLabel(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 4,
        children: [
          if (icons.isNotEmpty) ...[
            for (var icon in icons) ...[
              Icon(icon, color: TechIconHelper.getIconColor(icon), size: 14),
            ],
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Language Chip with Star Rating Helper ---

class LangChip extends StatelessWidget {
  final String name;
  final int rating;

  const LangChip({super.key, required this.name, required this.rating});

  @override
  Widget build(BuildContext context) {
    final icon = TechIconHelper.getIcon(name);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          if (icon != null) ...[
            Icon(icon, color: TechIconHelper.getIconColor(icon), size: 16),
          ],
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            spacing: 2,
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 12,
                color: index < rating
                    ? const Color(0xFFFF5C35)
                    : Colors.white.withOpacity(0.1),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// --- Contact Tile Card ---

class ContactTileCard extends StatefulWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String title;
  final String value;
  final String url;
  final List<Map<String, String>>? subItems;
  final Color? accentColor;

  const ContactTileCard({
    super.key,
    this.icon,
    this.customIcon,
    required this.title,
    required this.value,
    required this.url,
    this.subItems,
    this.accentColor,
  });

  @override
  State<ContactTileCard> createState() => _ContactTileCardState();
}

class _ContactTileCardState extends State<ContactTileCard> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final Uri parsedUrl = Uri.parse(widget.url);
    final isNativeProtocol =
        parsedUrl.scheme == 'mailto' ||
        parsedUrl.scheme == 'tel' ||
        parsedUrl.scheme == 'sms';
    if (!await launchUrl(
      parsedUrl,
      mode: isNativeProtocol
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $parsedUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final hasSubItems = widget.subItems != null && widget.subItems!.isNotEmpty;

    final accent = widget.accentColor ?? Colors.white;

    final bgCol = _isHovered
        ? accent.withOpacity(0.06)
        : const Color(0xFF171717);
    final borderCol = _isHovered
        ? accent.withOpacity(0.3)
        : Colors.white.withOpacity(0.06);
    final iconCol = widget.accentColor ?? Colors.white.withOpacity(0.8);
    final titleCol = widget.accentColor != null
        ? widget.accentColor!.withOpacity(0.6)
        : Colors.white.withOpacity(0.4);

    Widget cardContent = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconCol.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: widget.customIcon ?? (widget.icon != null ? Icon(widget.icon, color: iconCol, size: 20) : const SizedBox.shrink()),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: titleCol,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              if (hasSubItems)
                ...widget.subItems!.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: HoverPhoneItem(
                      value: item['value'] ?? '',
                      label: item['label'] ?? '',
                      url: item['url'] ?? '',
                      hoverColor: iconCol,
                    ),
                  );
                })
              else
                Text(
                  widget.value,
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
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: hasSubItems ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: hasSubItems ? null : _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          width: isWide ? 270 : double.infinity,
          decoration: BoxDecoration(
            color: bgCol,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderCol, width: 1),
          ),
          padding: const EdgeInsets.all(20),
          child: cardContent,
        ),
      ),
    );
  }
}

// --- Hoverable Phone Item for Combined Card ---

class HoverPhoneItem extends StatefulWidget {
  final String value;
  final String label;
  final String url;
  final Color hoverColor;

  const HoverPhoneItem({
    super.key,
    required this.value,
    required this.label,
    required this.url,
    this.hoverColor = const Color(0xFFFF5C35),
  });

  @override
  State<HoverPhoneItem> createState() => _HoverPhoneItemState();
}

class _HoverPhoneItemState extends State<HoverPhoneItem> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final Uri parsedUrl = Uri.parse(widget.url);
    if (await canLaunchUrl(parsedUrl)) {
      await launchUrl(parsedUrl, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchUrl,
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.outfit(
              color: _isHovered ? widget.hoverColor : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: widget.value),
              if (widget.label.isNotEmpty)
                TextSpan(
                  text: ' (${widget.label})',
                  style: TextStyle(
                    color: _isHovered
                        ? widget.hoverColor.withOpacity(0.7)
                        : Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Tech Icon & Color Mapper Helper Class ---

class TechIconHelper {
  static IconData? getIcon(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('flutter')) return SimpleIcons.flutter;
    if (lower.contains('firebase') || lower.contains('firestore'))
      return SimpleIcons.firebase;
    if (lower.contains('dart')) return SimpleIcons.dart;
    if (lower.contains('kotlin')) return SimpleIcons.kotlin;
    if (lower.contains('python')) return SimpleIcons.python;
    if (lower.contains('java') && !lower.contains('script'))
      return SimpleIcons.openjdk;
    if (lower.contains('react')) return SimpleIcons.react;
    if (lower.contains('git') || lower.contains('github'))
      return SimpleIcons.git;
    if (lower.contains('figma')) return SimpleIcons.figma;
    if (lower.contains('xcode')) return SimpleIcons.xcode;
    if (lower.contains('android studio')) return SimpleIcons.androidstudio;
    if (lower.contains('swift')) return SimpleIcons.swift;
    return null;
  }

  static Color getIconColor(IconData icon) {
    Color color = Colors.white;
    if (icon == SimpleIcons.flutter)
      color = SimpleIconColors.flutter;
    else if (icon == SimpleIcons.firebase)
      color = SimpleIconColors.firebase;
    else if (icon == SimpleIcons.git)
      color = SimpleIconColors.git;
    else if (icon == SimpleIcons.figma)
      color = SimpleIconColors.figma;
    else if (icon == SimpleIcons.swift)
      color = SimpleIconColors.swift;
    else if (icon == SimpleIcons.kotlin)
      color = SimpleIconColors.kotlin;
    else if (icon == SimpleIcons.xcode)
      color = SimpleIconColors.xcode;
    else if (icon == SimpleIcons.androidstudio)
      color = SimpleIconColors.androidstudio;
    else if (icon == SimpleIcons.dart)
      color = SimpleIconColors.dart;
    else if (icon == SimpleIcons.openjdk)
      color = SimpleIconColors.openjdk;
    else if (icon == SimpleIcons.python)
      color = SimpleIconColors.python;
    else if (icon == SimpleIcons.react)
      color = SimpleIconColors.react;

    // Fallback to white for pure black/very dark colors to look good in dark mode
    if (color.computeLuminance() < 0.15) {
      return Colors.white;
    }
    return color;
  }

  static List<IconData> getIconsForLabel(String label) {
    final lower = label.toLowerCase();
    final icons = <IconData>[];
    if (lower.contains('flutter')) icons.add(SimpleIcons.flutter);
    if (lower.contains('firebase') || lower.contains('firestore'))
      icons.add(SimpleIcons.firebase);
    if (lower.contains('git')) icons.add(SimpleIcons.git);
    if (lower.contains('figma')) icons.add(SimpleIcons.figma);
    if (lower.contains('swift')) icons.add(SimpleIcons.swift);
    if (lower.contains('kotlin')) icons.add(SimpleIcons.kotlin);
    if (lower.contains('xcode')) icons.add(SimpleIcons.xcode);
    if (lower.contains('android studio')) icons.add(SimpleIcons.androidstudio);
    if (lower.contains('dart')) icons.add(SimpleIcons.dart);
    if (lower.contains('python')) icons.add(SimpleIcons.python);
    if (lower.contains('java') && !lower.contains('script'))
      icons.add(SimpleIcons.openjdk);
    if (lower.contains('react')) icons.add(SimpleIcons.react);
    return icons;
  }
}

// --- Gradient Text Widget ---

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

// --- Project Details Data Model ---

class ProjectDetail {
  final String year;
  final String title;
  final String subtitle;
  final String description;
  final List<String> techTags;
  final IconData icon;
  final List<String> userImages;
  final List<String> adminImages;
  final List<String> highlights;
  final String githubUrl;

  const ProjectDetail({
    required this.year,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.techTags,
    required this.icon,
    required this.userImages,
    required this.adminImages,
    required this.highlights,
    this.githubUrl = "https://github.com/premmoparthi0829",
  });

  static const List<ProjectDetail> projects = [
    ProjectDetail(
      year: "2025-2026",
      title: "Seven Pay Services",
      subtitle: "Enterprise Fintech Mobile App & Dashboard",
      description:
          "Engineered and shipped a production-ready fintech ecosystem. Architected secure transactional layers, integrated multi-channel payment gateways, and built real-time synchronizations with Firebase. Implemented strict state management patterns (Bloc) and clean security boundaries.",
      techTags: [
        "Flutter",
        "Dart",
        "Firebase Auth",
        "Firestore",
        "Cloud Functions",
        "Razorpay",
      ],
      icon: Icons.payment,
      userImages: [
        "assets/project_seven_pay_services_user1.png",
        "assets/project_seven_pay_services_user2.png",
        "assets/project_seven_pay_services_user3.png",
      ],
      adminImages: [
        "assets/project_seven_pay_services_admin1.png",
        "assets/project_seven_pay_services_admin2.png",
      ],
      highlights: [
        "Developed secure transactional API channels with strict payload validations.",
        "Integrated Razorpay Payment Gateway for seamless deposits and automated settlement routing.",
        "Built live ledger updates and transaction statement exports using PDF generator libraries.",
        "Implemented Firebase Authentication with secure storage for sessions and biometric lock toggle.",
        "Architected client state using Bloc/Cubit pattern to separate presentation from transaction logic.",
      ],
    ),
    ProjectDetail(
      year: "2025-2026",
      title: "Ride 4 you",
      subtitle: "Real-time Ride-Hailing Mobile Platform",
      description:
          "Developed a location-aware, reactive mobile booking app with background GPS tracking, dynamic pricing calculators, and efficient driver routing algorithms. Optimized location fetch intervals to conserve battery while maintaining high tracking accuracy.",
      techTags: [
        "Flutter & Dart",
        "Google Maps API",
        "GPS Tracking",
        "Firestore",
        "Cloud Functions",
      ],
      icon: Icons.local_taxi,
      userImages: [
        "assets/project_ride_4_you_user1.png",
        "assets/project_ride_4_you_user2.png",
        "assets/project_ride_4_you_user3.png",
      ],
      adminImages: [
        "assets/project_ride_4_you_admin1.png",
        "assets/project_ride_4_you_admin2.png",
      ],
      highlights: [
        "Configured persistent background location tracking optimized for low battery usage.",
        "Integrated Google Maps API with route drawing, custom markers, and camera transitions.",
        "Calculated fare estimations dynamically using geographic distance matrices and surge factors.",
        "Designed double-token validation handshake between rider and driver to verify trip starts.",
      ],
    ),
    ProjectDetail(
      year: "2025-2026",
      title: "Alham Mutton",
      subtitle: "Premium Meat & Fresh E-Commerce App (Licious-style)",
      description:
          "Engineered a premium, fast delivery mobile app for fresh meat ordering. Implemented smart item categorization, localized search algorithms, real-time order tracking, and dynamic checkout layers. Integrated reactive local caching to ensure zero latency during high-traffic order peaks.",
      techTags: [
        "Flutter",
        "Dart",
        "Firebase Auth",
        "Firestore",
        "Push Notifications",
        "Razorpay",
      ],
      icon: Icons.shopping_bag_outlined,
      userImages: [
        "assets/project_alham_mutton_user1.png",
        "assets/project_alham_mutton_user2.png",
        "assets/project_alham_mutton_user3.png",
      ],
      adminImages: [
        "assets/project_alham_mutton_admin1.png",
        "assets/project_alham_mutton_admin2.png",
      ],
      highlights: [
        "Engineered an interface for meat category filtering with animated transitions.",
        "Implemented local cart caching using SQLite/Hive for instant offline editing and retrieval.",
        "Configured cloud push notifications for real-time delivery status updates.",
        "Integrated Razorpay secure payment processing with auto-refund trigger loops on fail.",
      ],
    ),
    ProjectDetail(
      year: "2025-2026",
      title: "Rythu Rice",
      subtitle: "Multi-App Rice Booking & Supply Chain Ecosystem",
      description:
          "Architected and engineered a comprehensive 4-app rice distribution platform containing dedicated apps for Users (ordering), Vendors (inventory & store management), Riders (delivery routing), and an Admin Dashboard (metrics & control). Designed robust real-time order matching and secure transaction layers.",
      techTags: [
        "Flutter",
        "Dart",
        "Firebase Auth",
        "Firestore",
        "Google Maps API",
        "Push Notifications",
      ],
      icon: Icons.agriculture_outlined,
      userImages: [
        "assets/project_rythu_rice_user1.png",
        "assets/project_rythu_rice_user2.png",
        "assets/project_rythu_rice_user3.png",
      ],
      adminImages: [
        "assets/project_rythu_rice_admin1.png",
        "assets/project_rythu_rice_admin2.png",
      ],
      highlights: [
        "Constructed a 4-app ecosystem separating User, Vendor, Rider, and Admin dashboards.",
        "Built real-time order matching queue matching riders to close-proximity store vendors.",
        "Designed vendors stock management portal with real-time push synchronization.",
        "Integrated route optimization maps for riders delivering heavy volume orders.",
      ],
    ),
    ProjectDetail(
      year: "2025-2026",
      title: "Meatoon",
      subtitle: "Live Online Meat & Poultry Delivery App",
      description:
          "Designed and shipped a production-ready, live online meat delivery app. Engineered instant order processing, dynamic weight/price calculations, cold-chain delivery monitoring, and automated SMS alert pipelines.",
      techTags: [
        "Flutter",
        "Dart",
        "Firebase Auth",
        "Firestore",
        "Razorpay",
        "Push Notifications",
      ],
      icon: Icons.restaurant_menu_outlined,
      userImages: [
        "assets/project_meatoon_user1.png",
        "assets/project_meatoon_user2.png",
        "assets/project_meatoon_user3.png",
      ],
      adminImages: [
        "assets/project_meatoon_admin1.png",
        "assets/project_meatoon_admin2.png",
      ],
      highlights: [
        "Engineered instant order placement flow with custom weighing-scale integrations.",
        "Developed localized search algorithm with partial match capabilities.",
        "Implemented automated SMS alert pipelines using Twilio functions trigger on Firebase DB updates.",
        "Created custom animations for items added to cart for high-end feel.",
      ],
    ),
    ProjectDetail(
      year: "2025-2026",
      title: "Fresh & Fresh",
      subtitle: "Vibrant Local Grocery Delivery Platform",
      description:
          "Developed a comprehensive grocery e-commerce app featuring smart product cataloging, localized search filters, dynamic discount managers, and integration with local logistics systems for rapid order fulfilment.",
      techTags: [
        "Flutter",
        "Dart",
        "Firebase Auth",
        "Firestore",
        "Google Maps API",
      ],
      icon: Icons.local_grocery_store_outlined,
      userImages: [
        "assets/project_fresh_fresh_user1.png",
        "assets/project_fresh_fresh_user2.png",
        "assets/project_fresh_fresh_user3.png",
      ],
      adminImages: [
        "assets/project_fresh_fresh_admin1.png",
        "assets/project_fresh_fresh_admin2.png",
      ],
      highlights: [
        "Created dynamic catalog filtering with deep-nested category support.",
        "Designed interactive discount and coupon applying logic in checkout stage.",
        "Built Google Maps store locator with distance calculation.",
        "Configured dashboard statistics for local merchants to monitor active orders.",
      ],
    ),
    ProjectDetail(
      year: "2025-2026",
      title: "Church App",
      subtitle: "Community Engagement & Livestream Mobile App",
      description:
          "Created a dedicated mobile platform for community interaction, event registrations, secure donations, and audio/video livestream integration. Boosted community participation by introducing instant notifications for live updates.",
      techTags: [
        "Flutter",
        "Dart",
        "Firebase Auth",
        "Firestore",
        "Push Notifications",
        "Razorpay",
      ],
      icon: Icons.church_outlined,
      userImages: [
        "assets/project_church_app_user1.png",
        "assets/project_church_app_user2.png",
        "assets/project_church_app_user3.png",
      ],
      adminImages: [
        "assets/project_church_app_admin1.png",
        "assets/project_church_app_admin2.png",
      ],
      highlights: [
        "Integrated YouTube / HLS video player supporting picture-in-picture background execution.",
        "Built secure donation module using Razorpay, generating instant receipts sent to email.",
        "Developed events registration and digital entry ticket passes using QR codes.",
        "Designed daily verses notifications delivered via FCM scheduled CRON triggers.",
      ],
    ),
  ];
}

// --- Project Details Page Route Builder ---

class ProjectDetailRoute extends PageRouteBuilder {
  final ProjectDetail project;

  ProjectDetailRoute({required this.project})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProjectDetailScreen(project: project),
        transitionDuration: const Duration(milliseconds: 550),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
      );
}

// --- Custom Smartphone Device Chassis Frame Wrapper ---

class MobileDeviceFrame extends StatelessWidget {
  final Widget child;
  const MobileDeviceFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 420,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          // Notch / Speaker slit
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              width: 80,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Web Browser Device Chassis Frame Wrapper ---

class BrowserDeviceFrame extends StatelessWidget {
  final Widget child;
  final String projectTitle;
  const BrowserDeviceFrame({
    super.key,
    required this.child,
    required this.projectTitle,
  });

  @override
  Widget build(BuildContext context) {
    final cleanSubdomain = projectTitle.toLowerCase().replaceAll(' ', '');
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Browser top bar
          Container(
            height: 36,
            color: const Color(0xFF222222),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Three window controls dots
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5F57),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFBD2E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF27C13F),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                // Address bar
                Expanded(
                  child: Container(
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFF171717),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "https://admin.$cleanSubdomain.com",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Window content
          Expanded(child: child),
        ],
      ),
    );
  }
}

// --- Project Details Interactive Screen ---

class ProjectDetailScreen extends StatefulWidget {
  final ProjectDetail project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with TickerProviderStateMixin {
  int _selectedTab = 0; // 0 = Mobile User, 1 = Web Admin
  int _currentImageIndex = 0;
  bool _showImages = false;

  late AnimationController _animationController;
  late AnimationController _sweepController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _slideAnimationMobile;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.12, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _slideAnimationMobile = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final currentImages = _selectedTab == 0
        ? widget.project.userImages
        : widget.project.adminImages;

    // Boundary sanity check
    if (_currentImageIndex >= currentImages.length) {
      _currentImageIndex = 0;
    }

    // Retrieve ModalRoute animation
    final ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
    final Animation<double> routeAnim = modalRoute?.animation ?? const AlwaysStoppedAnimation(1.0);

    // Derived card scale animation using easeOutBack curve (bounce pop)
    final Animation<double> cardScaleAnim = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: routeAnim,
        curve: Curves.easeOutBack,
      ),
    );

    // Derived card slide animation
    final Animation<Offset> cardSlideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: routeAnim,
      curve: Curves.easeOutCubic,
    ));
    // Staggered cinematic transitions driven by routeAnim

    final Animation<double> closeFadeAnim = CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
    );
    final Animation<double> closeRotateAnim = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: routeAnim,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutBack),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Blurred background overlay tapping it dismisses the dialog
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: AnimatedBuilder(
                animation: routeAnim,
                builder: (context, child) {
                  final blurVal = routeAnim.value * 12.0;
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blurVal, sigmaY: blurVal),
                    child: Container(
                      color: Colors.black.withOpacity(0.65 * routeAnim.value),
                    ),
                  );
                },
              ),
            ),
          ),

          // Glowing Ambient Aura behind the dialog card
          Center(
            child: AnimatedBuilder(
              animation: routeAnim,
              builder: (context, child) {
                final animValue = routeAnim.value;
                final currentWidth = isDesktop
                    ? (580.0 + (_animationController.value * 400.0)).clamp(0.0, screenWidth * 0.95)
                    : screenWidth * 0.92;
                final currentHeight = isDesktop ? screenHeight * 0.85 : screenHeight * 0.90;

                return ScaleTransition(
                  scale: cardScaleAnim,
                  child: SlideTransition(
                    position: cardSlideAnim,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Orange Glow at top-left
                        Transform.translate(
                          offset: Offset(-currentWidth * 0.25, -currentHeight * 0.25),
                          child: Container(
                            width: currentWidth * 0.6,
                            height: currentHeight * 0.6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFF5C35).withOpacity(0.15 * animValue),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5C35).withOpacity(0.22 * animValue),
                                  blurRadius: 70,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Lime Glow at bottom-right
                        Transform.translate(
                          offset: Offset(currentWidth * 0.25, currentHeight * 0.25),
                          child: Container(
                            width: currentWidth * 0.6,
                            height: currentHeight * 0.6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFB2FF33).withOpacity(0.10 * animValue),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFB2FF33).withOpacity(0.18 * animValue),
                                  blurRadius: 70,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Center Card
          Center(
            child: SlideTransition(
              position: cardSlideAnim,
              child: ScaleTransition(
                scale: cardScaleAnim,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final animValue = _animationController.value;
                    final currentWidth = isDesktop
                        ? (580.0 + (animValue * 400.0)).clamp(0.0, screenWidth * 0.95)
                        : screenWidth * 0.92;
                    final currentHeight = isDesktop ? screenHeight * 0.85 : screenHeight * 0.90;

                    return Container(
                      width: currentWidth,
                      height: currentHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.65),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _sweepController,
                        builder: (context, childWidget) {
                          final double angle = _sweepController.value * 2 * 3.141592653589793;
                          return Container(
                            padding: const EdgeInsets.all(1.5), // border thickness
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF5C35).withOpacity(routeAnim.value * 0.8),
                                  const Color(0xFFB2FF33).withOpacity(routeAnim.value * 0.8),
                                  const Color(0xFFFF5C35).withOpacity(routeAnim.value * 0.8),
                                ],
                                begin: Alignment(math.cos(angle), math.sin(angle)),
                                end: Alignment(math.cos(angle + 3.141592653589793), math.sin(angle + 3.141592653589793)),
                              ),
                            ),
                            child: childWidget,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF121212),
                            borderRadius: BorderRadius.circular(31),
                          ),
                          child: Stack(
                            children: [
                              // Scrollable Content
                              Positioned.fill(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    left: isDesktop ? 40 : 20,
                                    right: isDesktop ? 40 : 20,
                                    top: isDesktop
                                        ? 40
                                        : 64, // extra space on mobile for close button
                                    bottom: 40,
                                  ),
                                  child: isDesktop
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Left Column: Detailed info, highlights, tags
                                            Expanded(
                                              flex: 6,
                                              child: _buildDetailsContent(context, routeAnim),
                                            ),
                                            if (animValue > 0) ...[
                                              SizedBox(width: animValue * 40),
                                              // Right Column: Mockup Image switcher and Project Meta
                                              Expanded(
                                                flex: 5,
                                                child: FadeTransition(
                                                  opacity: _fadeAnimation,
                                                  child: SlideTransition(
                                                    position: _slideAnimation,
                                                    child: ScaleTransition(
                                                      scale: _scaleAnimation,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          _buildImageCard(context, currentImages),
                                                          const SizedBox(height: 24),
                                                          _buildProjectMeta(context),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (animValue > 0) ...[
                                              FadeTransition(
                                                opacity: _fadeAnimation,
                                                child: SlideTransition(
                                                  position: _slideAnimationMobile,
                                                  child: ScaleTransition(
                                                    scale: _scaleAnimation,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        _buildImageCard(context, currentImages),
                                                        const SizedBox(height: 24),
                                                        _buildProjectMeta(context),
                                                        const SizedBox(height: 24),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            _buildDetailsContent(context, routeAnim),
                                          ],
                                        ),
                                ),
                              ),

                              // Pinned close button at top-right
                              Positioned(
                                top: 20,
                                right: 20,
                                child: FadeTransition(
                                  opacity: closeFadeAnim,
                                  child: RotationTransition(
                                    turns: closeRotateAnim,
                                    child: HoverWidget(
                                      scale: 1.15,
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1E1E1E),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, List<String> currentImages) {
    final activeImage = currentImages[_currentImageIndex];
    return Column(
      children: [
        // Tab buttons (Mobile User vs Admin Web)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedTab = 0;
                    _currentImageIndex = 0;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedTab == 0
                          ? const Color(0xFFFF5C35)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "USER APP (3)",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: _selectedTab == 0
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedTab = 1;
                    _currentImageIndex = 0;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedTab == 1
                          ? const Color(0xFFB2FF33)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "ADMIN PANEL (2)",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: _selectedTab == 1
                            ? const Color(0xFF0F0F0F)
                            : Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Active Device Frame Mockup Display
        Center(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.95),
                  barrierDismissible: true,
                  barrierLabel: "Gallery",
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, anim, secAnim) => ImageGalleryDialog(
                    images: currentImages,
                    initialIndex: _currentImageIndex,
                    title: widget.project.title,
                  ),
                  transitionBuilder: (context, anim, secAnim, child) {
                    final scale = Tween<double>(begin: 0.88, end: 1.0).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                    );
                    final opacity = CurvedAnimation(parent: anim, curve: Curves.easeOut);
                    return FadeTransition(
                      opacity: opacity,
                      child: ScaleTransition(
                        scale: scale,
                        child: child,
                      ),
                    );
                  },
                );
              },
              child: Tooltip(
                message: "Click to view fullscreen",
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: _selectedTab == 0
                      ? MobileDeviceFrame(
                          key: ValueKey("mobile_$activeImage"),
                          child: Image.asset(activeImage, fit: BoxFit.cover),
                        )
                      : Container(
                          height: 260,
                          width: 390,
                          alignment: Alignment.center,
                          child: BrowserDeviceFrame(
                            key: ValueKey("browser_$activeImage"),
                            projectTitle: widget.project.title,
                            child: Image.asset(
                              activeImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Thumbnails selector row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(currentImages.length, (idx) {
            final isSelected = _currentImageIndex == idx;
            return GestureDetector(
              onTap: () => setState(() => _currentImageIndex = idx),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 45,
                height: _selectedTab == 0 ? 60 : 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? (_selectedTab == 0
                              ? const Color(0xFFFF5C35)
                              : const Color(0xFFB2FF33))
                        : Colors.white.withOpacity(0.1),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(currentImages[idx], fit: BoxFit.cover),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProjectMeta(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF5C35).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFF5C35).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            widget.project.year,
            style: GoogleFonts.outfit(
              color: const Color(0xFFFF5C35),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.devices_other,
                size: 14,
                color: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Text(
                "Multi-Platform App",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsContent(BuildContext context, Animation<double> routeAnim) {
    // Staggered cinematic transitions driven by routeAnim
    final Animation<double> titleFadeAnim = CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    final Animation<Offset> titleSlideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
    ));

    final Animation<double> descFadeAnim = CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );
    final Animation<Offset> descSlideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
    ));

    final Animation<double> specsTitleFadeAnim = CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    );
    final Animation<Offset> specsTitleSlideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
    ));

    final Animation<double> techFadeAnim = CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
    );
    final Animation<double> techScaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: routeAnim,
        curve: const Interval(0.6, 0.95, curve: Curves.easeOutBack),
      ),
    );

    final Animation<double> actionsFadeAnim = CurvedAnimation(
      parent: routeAnim,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );
    final Animation<double> actionsScaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: routeAnim,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOutBack),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        FadeTransition(
          opacity: titleFadeAnim,
          child: SlideTransition(
            position: titleSlideAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  widget.project.title,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5C35), Color(0xFFB2FF33)],
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.project.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Description
        FadeTransition(
          opacity: descFadeAnim,
          child: SlideTransition(
            position: descSlideAnim,
            child: Text(
              widget.project.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Key Contributions Title
        FadeTransition(
          opacity: specsTitleFadeAnim,
          child: SlideTransition(
            position: specsTitleSlideAnim,
            child: Text(
              "KEY CONTRIBUTIONS & FEATURES",
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFB2FF33),
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Key Contributions Highlights Staggered Cascade
        ...widget.project.highlights.asMap().entries.map(
          (entry) {
            final int idx = entry.key;
            final String highlight = entry.value;

            final start = (0.45 + (idx * 0.05)).clamp(0.0, 0.95);
            final end = (0.75 + (idx * 0.05)).clamp(0.0, 1.0);
            final itemAnim = CurvedAnimation(
              parent: routeAnim,
              curve: Interval(start, end, curve: Curves.easeOutCubic),
            );

            final itemSlideAnim = Tween<Offset>(
              begin: const Offset(0.0, 0.35),
              end: Offset.zero,
            ).animate(itemAnim);

            return FadeTransition(
              opacity: itemAnim,
              child: SlideTransition(
                position: itemSlideAnim,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFFB2FF33),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          highlight,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 28),

        // Tech Stack
        FadeTransition(
          opacity: techFadeAnim,
          child: ScaleTransition(
            scale: techScaleAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TECH STACK",
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.project.techTags.map((tag) {
                    final icon = TechIconHelper.getIcon(tag);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              color: TechIconHelper.getIconColor(icon),
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            tag,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 36),

        // Actions
        FadeTransition(
          opacity: actionsFadeAnim,
          child: ScaleTransition(
            scale: actionsScaleAnim,
            child: Row(
              children: [
                Expanded(
                  child: HoverWidget(
                    scale: 1.03,
                    onTap: () {
                      setState(() {
                        _showImages = !_showImages;
                      });
                      if (_showImages) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFF5C35),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _showImages
                                ? Icons.visibility_off_outlined
                                : Icons.collections_rounded,
                            color: const Color(0xFFFF5C35),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _showImages ? "Hide Images" : "View Images",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFFF5C35),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- Fullscreen Interactive Image Gallery Lightbox ---
class ImageGalleryDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String title;

  const ImageGalleryDialog({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.title,
  });

  @override
  State<ImageGalleryDialog> createState() => _ImageGalleryDialogState();
}

class _ImageGalleryDialogState extends State<ImageGalleryDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: Stack(
        children: [
          // Dismiss on tap background (outside the InteractiveViewer bounds)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),

          // Swipeable PageView with Interactive Zooming
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (idx) => setState(() => _currentIndex = idx),
              itemBuilder: (context, index) {
                return Center(
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        widget.images[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top Header Info & Close Button
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Image ${_currentIndex + 1} of ${widget.images.length}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                HoverWidget(
                  scale: 1.15,
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Left Arrow (only show when there is a previous page)
          if (_currentIndex > 0)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: HoverWidget(
                  scale: 1.15,
                  onTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

          // Right Arrow (only show when there is a next page)
          if (_currentIndex < widget.images.length - 1)
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: HoverWidget(
                  scale: 1.15,
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

          // Indicator Dots at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                final isSelected = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isSelected ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFF5C35)
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
