import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';
  bool _isPasswordVisible = false;

  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _logoAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _formAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();

      String? role;
      String? route;

      // Cek kredensial admin
      if (username == 'admin' && password == 'admin') {
        role = 'admin';
        route = '/adminHome';
      }
      // Cek kredensial user
      else if (username == 'user' && password == 'user') {
        role = 'user';
        route = '/home';
      }

      if (role != null && route != null) {
        // Simpan info login ke Firestore
        await FirebaseFirestore.instance.collection('login_logs').add({
          'username': username,
          'timestamp': DateTime.now(),
          'role': role,
        });

        if (mounted) {
          Navigator.pushReplacementNamed(context, route);
        }
      } else {
        setState(() {
          errorMessage = 'Username atau password salah';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildAnimatedLogo() {
    return ScaleTransition(
      scale: _logoAnimation,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gradStart.withOpacity(0.9),
                  AppColors.gradEnd,
                  AppColors.gradEnd.withOpacity(0.8),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradEnd.withOpacity(0.4),
                  blurRadius: 35,
                  spreadRadius: 8,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: AppColors.gradStart.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(28),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.school_rounded,
                size: 72,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [
                    AppColors.gradStart,
                    AppColors.gradEnd,
                    AppColors.gradSoftPurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
            child: Text(
              'EduBuild',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2.0,
                shadows: [
                  Shadow(
                    color: AppColors.gradEnd.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Membangun Masa Depan Pendidikan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary(context).withOpacity(0.8),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedForm() {
    return FadeTransition(
      opacity: _formAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(_formAnimation),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface(context).withOpacity(0.95),
                AppColors.surface(context).withOpacity(0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradEnd.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // Welcome Text
              Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk ke akun Anda untuk melanjutkan',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary(context).withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),

              // Username Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.background(context).withOpacity(0.8),
                      AppColors.background(context).withOpacity(0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradSoftPurple.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: AppColors.textPrimary(context).withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.gradStart, AppColors.gradEnd],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.gradSoftPurple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.gradEnd,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w500,
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.background(context).withOpacity(0.8),
                      AppColors.background(context).withOpacity(0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradSoftPurple.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: AppColors.textPrimary(context).withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.gradStart, AppColors.gradEnd],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.textPrimary(context).withOpacity(0.6),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.gradSoftPurple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.gradEnd,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w500,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (!isLoading) signIn();
                  },
                ),
              ),

              // Error Message
              if (errorMessage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Login Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gradStart,
                      AppColors.gradEnd,
                      AppColors.gradSoftPurple,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradEnd.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: isLoading ? null : signIn,
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : const Text(
                            'Masuk ke EduBuild',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return FadeTransition(
      opacity: _formAnimation,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface(context).withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(
                '© EduBuild 2025',
                style: TextStyle(
                  color: AppColors.textPrimary(context).withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _EnhancedBackgroundPainter(
            context,
            _backgroundAnimation.value,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Stack(
              children: [
                _buildEnhancedBackground(),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          _buildAnimatedLogo(),
                          const SizedBox(height: 40),
                          _buildAnimatedForm(),
                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EnhancedBackgroundPainter extends CustomPainter {
  final BuildContext context;
  final double animationValue;

  _EnhancedBackgroundPainter(this.context, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Gradient Background
    final backgroundGradient =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background(context),
              AppColors.background(context).withOpacity(0.95),
              AppColors.gradStart.withOpacity(0.05),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundGradient,
    );

    // Animated floating elements
    final paint1 =
        Paint()
          ..color = AppColors.gradStart.withOpacity(0.08)
          ..style = PaintingStyle.fill;
    final paint2 =
        Paint()
          ..color = AppColors.gradEnd.withOpacity(0.06)
          ..style = PaintingStyle.fill;
    final paint3 =
        Paint()
          ..color = AppColors.gradSoftPurple.withOpacity(0.05)
          ..style = PaintingStyle.fill;

    // Floating circles with animation
    canvas.drawCircle(
      Offset(
        size.width * 0.15 + (animationValue * 20),
        size.height * 0.18 + (animationValue * 15),
      ),
      110 + (animationValue * 10),
      paint1,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.85 - (animationValue * 15),
        size.height * 0.12 + (animationValue * 25),
      ),
      75 + (animationValue * 8),
      paint2,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.75 - (animationValue * 10),
        size.height * 0.88 - (animationValue * 20),
      ),
      95 + (animationValue * 12),
      paint3,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.08 + (animationValue * 25),
        size.height * 0.82 - (animationValue * 18),
      ),
      65 + (animationValue * 6),
      paint1,
    );

    // Floating shapes
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            size.width * 0.9 - (animationValue * 30),
            size.height * 0.7 + (animationValue * 20),
          ),
          width: 40,
          height: 40,
        ),
        const Radius.circular(12),
      ),
      paint2,
    );

    // Enhanced wave pattern
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.75);

    for (double i = 0; i <= size.width; i += size.width / 8) {
      wavePath.quadraticBezierTo(
        i + (size.width / 16),
        size.height * 0.73 + (animationValue * 10),
        i + (size.width / 8),
        size.height * 0.75,
      );
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    final waveGradient =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradEnd.withOpacity(0.08),
              AppColors.gradSoftPurple.withOpacity(0.04),
            ],
          ).createShader(wavePath.getBounds());

    canvas.drawPath(wavePath, waveGradient);

    // Subtle grid pattern
    final gridPaint =
        Paint()
          ..color = AppColors.gradEnd.withOpacity(0.02)
          ..strokeWidth = 0.5;

    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }

    for (double i = 0; i < size.height; i += 60) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
