// ignore_for_file: library_private_types_in_public_api, avoid_renaming_method_parameters, use_build_context_synchronously

import 'package:carrier_hive/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:math';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;

  String selectedRole = 'Student';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Advanced animation controllers
  late AnimationController _backgroundAnimationController;
  late AnimationController _loginButtonController;

  // Focus nodes for input fields
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Password visibility toggle
  bool _isPasswordVisible = false;

  // Particle system for background
  List<ParticleModel> particles = [];

  @override
  void initState() {
    super.initState();
    controller1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // Background pulsating animation
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Login button animation controller
    _loginButtonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    );

    // Initialize particle system
    _initParticles();
  }

  void _initParticles() {
    final random = Random();
    particles = List.generate(50, (index) {
      return ParticleModel(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3,
        speed: random.nextDouble() * 0.5,
        color: Colors.white.withOpacity(random.nextDouble() * 0.3),
      );
    });
  }

  void onLogin() async {
    final FirestoreAuthService authService = FirestoreAuthService();

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    try {
      final result = await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (result['success'] == true) {
        final String role = result['role'];

        // Navigate based on the role
        if (role == 'admin') {
          Navigator.pushNamed(context, '/admin/dashboard');
        } else if (role == 'recruiter') {
          Navigator.pushNamed(context, '/recruiter/dashboard');
        } else if (role == 'student') {
          Navigator.pushNamed(context, '/user/dashboard');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    _backgroundAnimationController.dispose();
    _loginButtonController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Particle Background
          ...particles.map((particle) => AnimatedParticle(particle: particle)),

          // Gradient Background with Animation
          AnimatedBuilder(
            animation: _backgroundAnimationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(Colors.deepPurple.shade900, Colors.black,
                          _backgroundAnimationController.value)!,
                      Color.lerp(Colors.black, Colors.deepPurple.shade900,
                          _backgroundAnimationController.value)!,
                    ],
                  ),
                ),
              );
            },
          ),

          // Glassmorphic Login Container
          Center(
            child: GlassmorphicContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                borderRadius: 20,
                blur: 20,
                alignment: Alignment.bottomCenter,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Logo
                          const SizedBox(
                            height: 50,
                            child: rive.RiveAnimation.asset(
                              'lib/assets/placement_image.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Animated Title
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Welcome to Carrier Hive',
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            totalRepeatCount: 1,
                          ),

                          const SizedBox(height: 20),

                          // Role Dropdown with Fancy Styling
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonFormField<String>(
                              dropdownColor: Colors.deepPurple.shade800,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              value: selectedRole,
                              items: ['Student', 'Recruiter', 'Admin']
                                  .map((role) => DropdownMenuItem(
                                        value: role,
                                        child: Text(
                                          role,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Email TextField with Animated Focus
                          AnimatedBuilder(
                            animation: _emailFocusNode,
                            builder: (context, child) {
                              return TextField(
                                controller: emailController,
                                focusNode: _emailFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: _emailFocusNode.hasFocus
                                        ? Colors.tealAccent
                                        : Colors.white.withOpacity(0.7),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: _emailFocusNode.hasFocus
                                          ? Colors.tealAccent
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: _emailFocusNode.hasFocus
                                        ? Colors.tealAccent
                                        : Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Password TextField with Visibility Toggle
                          TextField(
                            controller: passwordController,
                            focusNode: _passwordFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: _passwordFocusNode.hasFocus
                                    ? Colors.tealAccent
                                    : Colors.white.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: _passwordFocusNode.hasFocus
                                    ? Colors.tealAccent
                                    : Colors.white.withOpacity(0.7),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            obscureText: !_isPasswordVisible,
                          ),

                          const SizedBox(height: 30),

                          // Animated Login Button
                          ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 1.2)
                                .animate(_loginButtonController),
                            child: ElevatedButton(
                              onPressed: onLogin,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 50),
                                backgroundColor: Colors.tealAccent.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class ParticleModel {
  double x;
  double y;
  double size;
  double speed;
  Color color;

  ParticleModel({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}

// Animated Particle Widget
class AnimatedParticle extends StatefulWidget {
  final ParticleModel particle;

  const AnimatedParticle({super.key, required this.particle});

  @override
  _AnimatedParticleState createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: Random().nextInt(10) + 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset(widget.particle.x, widget.particle.y),
      end: Offset(widget.particle.x + (Random().nextBool() ? 0.1 : -0.1),
          widget.particle.y + (Random().nextBool() ? 0.1 : -0.1)),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: CustomPaint(
        painter: ParticlePainter(
          size: widget.particle.size,
          color: widget.particle.color,
        ),
      ),
    );
  }
}

// Custom Particle Painter
class ParticlePainter extends CustomPainter {
  final double size;
  final Color color;

  ParticlePainter({required this.size, required this.color});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(canvasSize.width * size, canvasSize.height * size),
      size,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
