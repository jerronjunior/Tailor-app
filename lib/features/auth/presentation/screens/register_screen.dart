import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String role;

  const RegisterScreen({super.key, required this.role});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    try {
      final auth = ref.read(authServiceProvider);
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      await auth.register(
        email: email,
        password: password,
        name: _nameController.text.trim(),
        role: widget.role,
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );
      final user = await auth.signIn(email, password, expectedRole: widget.role);
      if (mounted) await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        if (user.isCustomer) {
          context.go(AppRoutes.customerHome);
        } else {
          context.go(AppRoutes.tailorHome);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTailor = widget.role == AppConstants.roleTailor;
    final accentColor = isTailor ? const Color(0xFFD4AF37) : const Color(0xFF4A90E2);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Stack(
        children: [
          // Hero image top
          Positioned(
            top: 0, left: 0, right: 0,
            height: 220,
            child: Image.network(
              isTailor
                  ? 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=1200&h=500&fit=crop&q=80'
                  : 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=1200&h=500&fit=crop&q=80',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(height: 220, color: const Color(0xFF1B2A3B));
              },
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            height: 250,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x440D1B2A), Color(0xFF0D1B2A)],
                  stops: [0.2, 1.0],
                ),
              ),
            ),
          ),

          // Main scrollable content
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
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accentColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          isTailor ? '✂️  New Tailor' : '👗  New Customer',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 130, 20, 30),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Headline
                            Text(
                              isTailor
                                  ? 'Turn craft into\na polished studio.'
                                  : 'Start your next\noutfit journey.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isTailor
                                  ? 'Manage jobs, keep clients updated, and grow your bookings.'
                                  : 'Store your measurements, profile, and order history in one place.',
                              style: const TextStyle(color: Color(0xFF8FA3B1), fontSize: 13.5, height: 1.45),
                            ),
                            const SizedBox(height: 24),

                            // Form card
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
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Section label
                                    _sectionLabel('Personal Info', accentColor),
                                    const SizedBox(height: 14),
                                    _buildField(
                                      controller: _nameController,
                                      label: 'Full Name',
                                      icon: Icons.person_outline,
                                      accentColor: accentColor,
                                      textCapitalization: TextCapitalization.words,
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) return 'Enter your name';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildField(
                                      controller: _emailController,
                                      label: 'Email address',
                                      hint: 'you@example.com',
                                      icon: Icons.email_outlined,
                                      accentColor: accentColor,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) return 'Enter email';
                                        if (!v.contains('@')) return 'Enter a valid email';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildField(
                                      controller: _phoneController,
                                      label: 'Phone (optional)',
                                      icon: Icons.phone_outlined,
                                      accentColor: accentColor,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    const SizedBox(height: 20),
                                    _sectionLabel('Security', accentColor),
                                    const SizedBox(height: 14),
                                    _buildField(
                                      controller: _passwordController,
                                      label: 'Password',
                                      icon: Icons.lock_outline,
                                      accentColor: accentColor,
                                      obscureText: _obscurePassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          color: const Color(0xFF8FA3B1), size: 20,
                                        ),
                                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.length < 6) return 'Minimum 6 characters';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildField(
                                      controller: _confirmController,
                                      label: 'Confirm Password',
                                      icon: Icons.lock_outline,
                                      accentColor: accentColor,
                                      obscureText: _obscureConfirm,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          color: const Color(0xFF8FA3B1), size: 20,
                                        ),
                                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                      ),
                                      validator: (v) {
                                        if (v != _passwordController.text) return 'Passwords do not match';
                                        return null;
                                      },
                                    ),

                                    if (_errorMessage != null) ...[
                                      const SizedBox(height: 16),
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
                                              child: Text(_errorMessage!,
                                                  style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 22),

                                    // Register button
                                    SizedBox(
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentColor,
                                          foregroundColor: isTailor ? Colors.black : Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        child: _isLoading
                                            ? SizedBox(
                                                height: 22, width: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: isTailor ? Colors.black : Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'Create Account',
                                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.3),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(children: [
                                      Expanded(child: Divider(color: Colors.white.withOpacity(0.08))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text("Have an account?",
                                            style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 12)),
                                      ),
                                      Expanded(child: Divider(color: Colors.white.withOpacity(0.08))),
                                    ]),
                                    const SizedBox(height: 14),
                                    OutlinedButton(
                                      onPressed: () => context.push('${AppRoutes.login}?role=${widget.role}'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: accentColor,
                                        side: BorderSide(color: accentColor.withOpacity(0.4)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: const Text('Sign in instead',
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, Color accentColor) {
    return Row(
      children: [
        Container(width: 3, height: 14, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    required Color accentColor,
    TextInputType? keyboardType,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      style: const TextStyle(color: Colors.white, fontSize: 14.5),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13.5),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13.5),
        prefixIcon: Icon(icon, color: accentColor.withOpacity(0.7), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: accentColor, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }
}
