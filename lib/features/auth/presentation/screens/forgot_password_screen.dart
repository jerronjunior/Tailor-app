import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;
  String? _errorMessage;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email address');
      return;
    }
    setState(() {
      _errorMessage = null;
      _isLoading = true;
      _sent = false;
    });
    try {
      await ref.read(authServiceProvider).sendPasswordResetEmail(email);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0, left: 0, right: 0,
            height: 260,
            child: Image.network(
              'https://images.unsplash.com/photo-1445205170230-053b83016050?w=1200&h=600&fit=crop&q=80',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(height: 260, color: const Color(0xFF1B2A3B));
              },
            ),
          ),
          // Gradient
          Positioned(
            top: 0, left: 0, right: 0,
            height: 300,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)],
                  stops: [0.2, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 140, 22, 30),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Icon circle
                            Center(
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: accentColor.withOpacity(0.35), width: 1.5),
                                ),
                                child: const Icon(Icons.lock_reset_rounded, color: accentColor, size: 32),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Reset your\npassword.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Enter the email associated with your account and we'll send you a reset link.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF8FA3B1), fontSize: 14, height: 1.5),
                            ),
                            const SizedBox(height: 32),

                            if (_sent) ...[
                              // Success state
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D2E1A),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.mark_email_read_outlined, color: Colors.greenAccent, size: 28),
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      'Email sent!',
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Check your inbox for the password reset link. It may take a few minutes to arrive.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Color(0xFF8FA3B1), fontSize: 13.5, height: 1.5),
                                    ),
                                    const SizedBox(height: 20),
                                    OutlinedButton(
                                      onPressed: () => context.pop(),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: accentColor,
                                        side: const BorderSide(color: accentColor),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                                      ),
                                      child: const Text('Back to login', style: TextStyle(fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              // Input card
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A2B3C),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: accentColor.withOpacity(0.18)),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 16)),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Email field
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(color: Colors.white, fontSize: 14.5),
                                      decoration: InputDecoration(
                                        labelText: 'Email address',
                                        hintText: 'you@example.com',
                                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13.5),
                                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13.5),
                                        prefixIcon: Icon(Icons.email_outlined, color: accentColor.withOpacity(0.7), size: 20),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.06),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: const BorderSide(color: accentColor, width: 1.5),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      ),
                                    ),

                                    if (_errorMessage != null) ...[
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _errorMessage!,
                                                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 20),

                                    // Submit button
                                    SizedBox(
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.black,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 22, width: 22,
                                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                                              )
                                            : const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.send_rounded, size: 18),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Send reset link',
                                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.3),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    TextButton(
                                      onPressed: () => context.pop(),
                                      child: Text(
                                        'Back to login',
                                        style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 40),
                            // Decorative tagline
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cut, color: accentColor.withOpacity(0.4), size: 12),
                                const SizedBox(width: 8),
                                Text(
                                  'Crafted with precision · Tailor App',
                                  style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 11, letterSpacing: 0.5),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.cut, color: accentColor.withOpacity(0.4), size: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
