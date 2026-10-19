import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSidebar extends StatelessWidget {
  final String currentRoute;

  const CustomSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            context: context,
            route: '/dashboard',
            icon: Icons.bar_chart_outlined,
            label: 'Dashboard',
          ),
          _buildNavItem(
            context: context,
            route: '/client',
            icon: Icons.people_outline,
            label: 'Clientes',
          ),
          _buildNavItem(
            context: context,
            route: '/configuration',
            icon: Icons.settings_outlined,
            label: 'Configuracion',
          ),
          _buildNavItem(
            context: context,
            route: '/tokens',
            icon: Icons.vpn_key_outlined,
            label: 'Tokens',
          ),
          _buildNavItem(
            context: context,
            route: '/secrets',
            icon: Icons.lock_outline,
            label: 'Secrets',
          ),
          _buildNavItem(
            context: context,
            route: '/list',
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
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String route,
    required IconData icon,
    required String label,
  }) {
    final isSelected = currentRoute.startsWith(route);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (!isSelected) {
            context.go(route);
          }
        },
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