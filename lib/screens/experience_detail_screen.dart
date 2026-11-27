import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  String _displayDate(DateTime? date) => date?.toLocal().toString() ?? '—';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience Details'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(
        onHomeTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(builder: (_) => const MyHomePage()),
            (_) => false,
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
        onExperiencesTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const ExperienceListScreen(),
            ),
          );
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (experience.thumbnail?.isNotEmpty ?? false) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                experience.thumbnail!,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          Text(
            experience.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _ExperienceDetailField(label: 'ID', value: experience.id ?? '—'),
          _ExperienceDetailField(
            label: 'Description',
            value: experience.description,
          ),
          _ExperienceDetailField(label: 'Category', value: experience.category),
          _ExperienceDetailField(
            label: 'Category display',
            value: experience.categoryDisplay,
          ),
          _ExperienceDetailField(
            label: 'Thumbnail URL',
            value: experience.thumbnail ?? '—',
          ),
          _ExperienceDetailField(
            label: 'Started at',
            value: _displayDate(experience.startedAt),
          ),
          _ExperienceDetailField(
            label: 'Ended at',
            value: _displayDate(experience.endedAt),
          ),
          _ExperienceDetailField(
            label: 'Ongoing',
            value: experience.isOngoing ? 'Yes' : 'No',
          ),
          _ExperienceDetailField(
            label: 'Star count',
            value: experience.starCount.toString(),
          ),
          _ExperienceDetailField(
            label: 'Starred by you',
            value: experience.isStarred ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }
}

class _ExperienceDetailField extends StatelessWidget {
  const _ExperienceDetailField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          SelectableText(value),
        ],
      ),
    );
  }
}
