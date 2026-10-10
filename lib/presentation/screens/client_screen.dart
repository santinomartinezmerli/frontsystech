import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ClientScreen> {
  int _selectedIndex = 1; // 1 corresponde a "Clientes"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B245A),
      body: Row(
        children: [
          // ==================== SIDEBAR ====================
          Container(
            width: 230,
            decoration: const BoxDecoration(
              color: Color(0xFF0F3277),
              border: Border(
                right: BorderSide(color: Color(0xFF1E428F), width: 1.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Systech
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'systech',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Ítems de navegación
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  label: 'Dashboard',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.people_outline,
                  label: 'Clientes',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.settings_outlined,
                  label: 'Configuracion',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.vpn_key_outlined,
                  label: 'Tokens',
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.lock_outline,
                  label: 'Secrets',
                ),
                _buildNavItem(
                  index: 5,
                  icon: Icons.format_list_bulleted,
                  label: 'Listas',
                ),

                const Spacer(),

                // Cerrar sesión
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  leading: const Icon(Icons.logout, color: Colors.white70, size: 20),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  onTap: () {
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),

          // ==================== CONTENIDO PRINCIPAL ====================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header superior derecho (Avatar del Administrador)
                Padding(
                  padding: const EdgeInsets.only(top: 24, right: 36, bottom: 12),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Text(
                            'S',
                            style: TextStyle(
                              color: Color(0xFF0F3277),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Systech',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Administrador',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Contenedor central (vacío por ahora para montar la vista correspondiente)
                const Expanded(
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF163E8C) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white60,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}