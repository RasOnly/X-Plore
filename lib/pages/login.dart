import 'package:flutter/material.dart';
import 'package:ras/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _isLoading = false);
      _showDialog('Gagal', 'Email dan password tidak boleh kosong.');
      return;
    }

    try {
      final response = await ApiService().loginUser(email, password);

      print('✅ Response login: $response'); // Debug log

      // 🔑 Pastikan field sesuai dengan yang dikembalikan backend kamu
      final userId = response['id'];
      final username = response['username'];
      final userEmail = response['email'];
      final role = response['user_role'];

      // Simpan sesi login
      await SessionManager.saveUserSession(
        userId: userId,
        username: username,
        email: userEmail,
        role: role,
      );

      print('🧠 Login berhasil. user_id: $userId disimpan');

      Navigator.pushReplacementNamed(context, '/beranda');
    } catch (e) {
      _showDialog('Login Gagal', e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', width: 120),
                const SizedBox(height: 1),
                const Text(
                  'X-PLORE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),

                // Email
                _buildInputField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 20),

                // Password
                _buildInputField(
                  controller: _passwordController,
                  hintText: 'Kata Sandi',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Masuk dengan & Lupa sandi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Masuk dengan:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset('assets/images/google.png', width: 28),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lupa sandi?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Tombol Login
                _buildLoginButton(),

                const SizedBox(height: 20),

                // Link ke register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFA5E2FF), Color(0xFF4EA3FE)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: _isLoading ? null : _handleLogin,
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  'Masuk',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}
