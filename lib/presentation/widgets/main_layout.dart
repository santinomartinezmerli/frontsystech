import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'custom_sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: const Color(0xFF0B245A),
      body: Row(
        children: [
          // Sidebar fija
          CustomSidebar(currentRoute: currentRoute),

          // Contenedor principal con Header y el contenido dinámico
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header superior derecho (Admin avatar)
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

                // Contenido dinámico inyectado por GoRouter
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}