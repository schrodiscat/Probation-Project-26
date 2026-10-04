import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool isPhoneLogin = false;
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.visibility_outlined, size: 60, color: Color(0xFF8A2BE2)),
                const SizedBox(height: 20),
                const Text(
                  'WELCOME TO THE VIGIL',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF8A2BE2)),
                ),
                const SizedBox(height: 40),

                if (!isPhoneLogin) ...[
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A2BE2),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: authProvider.isLoading ? null : () async {
                     bool success = await authProvider.signInWithEmail(_emailController.text, _passwordController.text);
                     if (!context.mounted) return;
                     if (success) {
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                     }
                     },
                   
                      child: authProvider.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign In with Email', style: TextStyle(color: Colors.white)),
                  ),
                ] else ...[
                  if (!otpSent) ...[
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Phone Number (+91...)',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A2BE2),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        await authProvider.verifyPhoneNumber(_phoneController.text, (id) {
                          setState(() { otpSent = true; });
                        });
                      },
                      child: const Text('Send OTP', style: TextStyle(color: Colors.white)),
                    ),
                  ] else ...[
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter OTP Code',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A2BE2),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        bool success = await authProvider.verifyOTP(_otpController.text);
                        if (!context.mounted) return;
                        if (success && mounted) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                        }
                      },
                      child: const Text('Verify & Sign In', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ],

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () { setState(() { isPhoneLogin = !isPhoneLogin; }); },
                  child: Text(
                    isPhoneLogin ? 'Or login with Email' : 'Or login with Phone Number',
                    style: const TextStyle(color: Color(0xFF8A2BE2)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}