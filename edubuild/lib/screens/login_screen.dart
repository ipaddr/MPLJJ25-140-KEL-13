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

  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    );
    _formAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
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
              gradient: LinearGradient(
                colors: [AppColors.gradStart, AppColors.gradEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradEnd.withOpacity(0.18),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: const Icon(Icons.school, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 18),
          Text(
            'EduBuild',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
              letterSpacing: 1.2,
              shadows: const [
                Shadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
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
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_formAnimation),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context).withOpacity(0.97),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradEnd.withOpacity(0.13),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.textPrimary(context),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.gradSoftPurple,
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.gradSoftPurple,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.gradEnd,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.background(context),
                  ),
                  style: TextStyle(color: AppColors.textPrimary(context)),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.textPrimary(context),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.gradSoftPurple,
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.gradSoftPurple,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.gradEnd,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.background(context),
                  ),
                  style: TextStyle(color: AppColors.textPrimary(context)),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (!isLoading) signIn();
                  },
                ),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary(context),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                      shadowColor: AppColors.gradEnd.withOpacity(0.13),
                    ),
                    onPressed: isLoading ? null : signIn,
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Log In',
                              style: TextStyle(fontSize: 16),
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
        padding: const EdgeInsets.only(top: 32, bottom: 12),
        child: Text(
          '© EduBuild 2025\nMembangun Masa Depan Pendidikan',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSoftPatternBackground() {
    return CustomPaint(
      size: Size.infinite,
      painter: _BlueSoftPatternPainter(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          _buildSoftPatternBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    _buildAnimatedLogo(),
                    const SizedBox(height: 24),
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
  }
}

class _BlueSoftPatternPainter extends CustomPainter {
  final BuildContext context;
  _BlueSoftPatternPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 =
        Paint()
          ..color = AppColors.gradStart.withOpacity(0.11)
          ..style = PaintingStyle.fill;
    final paint2 =
        Paint()
          ..color = AppColors.gradEnd.withOpacity(0.09)
          ..style = PaintingStyle.fill;

    // Soft blue circles
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.16),
      90,
      paint1,
    );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.13),
      60,
      paint2,
    );
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.92), 80, paint1);
    canvas.drawCircle(Offset(size.width * 0.12, size.height * 0.8), 50, paint2);

    // Soft blue waves
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.68,
      size.width * 0.5,
      size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.82,
      size.width,
      size.height * 0.78,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
