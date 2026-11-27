import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _imageUrl = '';
  bool _isSubmitting = false;

  String? _validateUrl(String? value, {bool optional = false}) {
    final url = value?.trim() ?? '';
    if (url.isEmpty && optional) return null;
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.hasScheme ||
        !{'http', 'https'}.contains(uri.scheme.toLowerCase()) ||
        uri.host.isEmpty) {
      return 'Masukkan URL valid yang diawali http:// atau https://.';
    }
    return null;
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();

    setState(() => _isSubmitting = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;

      final authState = context.read<AuthState>();
      final token = authState.token;
      if (token == null) return;

      final project = Project(
        title: _title,
        description: _description,
        techStack: _techStack,
        projectUrl: _projectUrl,
        projectImageUrl: _imageUrl,
      );
      await context.read<ApiClient>().createProject(project, token: token);
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Project created'),
          content: Text('"$_title" berhasil ditambahkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        try {
          await context.read<AuthState>().logout();
        } catch (_) {
          // AuthState clears the local token even if the server is unavailable.
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi berakhir. Silakan login kembali.'),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan proyek (HTTP ${error.statusCode}).'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal menghubungi server. Periksa koneksi dan coba lagi.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              maxLength: 255,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _title = value?.trim() ?? '',
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) return 'Title cannot be empty.';
                if (title.length > 255) {
                  return 'Title must be 255 characters or fewer.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _description = value?.trim() ?? '',
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Description cannot be empty.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              maxLength: 255,
              decoration: const InputDecoration(
                labelText: 'Tech Stack',
                hintText: 'Flutter, Django, PostgreSQL',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _techStack = value?.trim() ?? '',
              validator: (value) {
                final techStack = value?.trim() ?? '';
                if (techStack.isEmpty) return 'Tech stack cannot be empty.';
                if (techStack.length > 255) {
                  return 'Tech stack must be 255 characters or fewer.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Project URL (optional)',
                hintText: 'https://example.com/project',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _projectUrl = value?.trim() ?? '',
              validator: (value) => _validateUrl(value, optional: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              maxLength: 500,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Project Image URL (optional)',
                hintText: 'https://example.com/image.jpg',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _imageUrl = value?.trim() ?? '',
              validator: (value) {
                final error = _validateUrl(value, optional: true);
                if (error != null) return error;
                if ((value?.trim().length ?? 0) > 500) {
                  return 'Image URL must be 500 characters or fewer.';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSubmitting ? 'Saving...' : 'Save Project'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
