import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF182232),
      body: Row(
        children: [
          // Lado izquierdo: Gradiente y textos
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF535E6D), Color(0xFF0D1E4C)],
                ),
              ),
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2D6DC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'systech',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102A43),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'SmartLists',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Verificación de identidades contra listas de\nriesgo, con evidencia trazable.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // Lado derecho: Formulario
          Expanded(
            child: Center(
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2E4A).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Título
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text('S', style: TextStyle(color: Color(0xFF102A43), fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bienvenido.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('Acredite sus credenciales para acceder', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Input Usuario
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDeco('Usuario', Icons.person_outline),
                    ),
                    const SizedBox(height: 16),

                    // Input Contraseña
                    TextField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDeco('Contraseña', Icons.lock_outline),
                    ),
                    const SizedBox(height: 12),

                    // Link olvidé
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('Olvidé mi contraseña', style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ),
                    const SizedBox(height: 24),

                    // Botón Log in
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        context.go('/client');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Log in', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Estilo simple para los inputs
  static InputDecoration _inputDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white30, fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.white30, size: 18),
      filled: true,
      fillColor: const Color(0xFF16253B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E3A60)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB)),
      ),
    );
  }
}
