import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    super.key,
    required this.onHomeTap,
    required this.onAddProjectTap,
    required this.onAddExperienceTap,
    required this.onProjectsTap,
  });

  final VoidCallback onHomeTap;
  final VoidCallback onAddProjectTap;
  final VoidCallback onAddExperienceTap;
  final VoidCallback onProjectsTap;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Navigasi ke halaman utama portofolio
            onTap: () {
              Navigator.pop(context);
              onHomeTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Projects'),
            onTap: () {
              Navigator.pop(context);
              onProjectsTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            // Navigasi ke halaman tambah proyek
            onTap: () async {
              final allowed = await ensureLoggedIn(context);
              if (!context.mounted) return;
              Navigator.pop(context);
              if (allowed) onAddProjectTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_history_outlined),
            title: const Text('Add Experience'),
            onTap: () {
              Navigator.pop(context);
              onAddExperienceTap();
            },
          ),
          if (!isLoggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () async {
                await ensureLoggedIn(context);
                if (!context.mounted) return;
                Navigator.pop(context);
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final authState = context.read<AuthState>();
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                try {
                  await authState.logout();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Kamu berhasil logout.')),
                  );
                } catch (_) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Sesi lokal dihapus, tetapi server tidak dapat dijangkau.',
                      ),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
