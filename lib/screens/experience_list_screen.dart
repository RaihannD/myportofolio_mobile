import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();
    _experiencesFuture = context.read<ApiClient>().getExperiences();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getExperiences();
    setState(() => _experiencesFuture = future);
    try {
      await future;
    } catch (_) {
      // FutureBuilder displays the error state once the refresh completes.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiences'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(
        onHomeTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (_) => const MyHomePage()),
          );
        },
        onAddProjectTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (_) => const ProjectFormPage()),
          );
        },
        onAddExperienceTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (_) => const ExperienceFormPage()),
          );
        },
        onProjectsTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (_) => const ProjectListScreen()),
          );
        },
        onExperiencesTap: () => Navigator.pop(context),
      ),
      body: FutureBuilder<List<Experience>>(
        future: _experiencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gagal memuat pengalaman: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final experiences = snapshot.data ?? const <Experience>[];
          if (experiences.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 300,
                    child: Center(child: Text('Belum ada pengalaman.')),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final experience = experiences[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.work_history_outlined),
                    ),
                    title: Text(experience.title),
                    subtitle: Text(
                      '${experience.categoryDisplay}\n${experience.description}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ExperienceDetailScreen(experience: experience),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
