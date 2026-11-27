import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  static const String _defaultCategory = 'full-time';
  static const Map<String, String> _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  final _formKey = GlobalKey<FormState>();
  final _endedAtController = TextEditingController();

  String _title = '';
  String _description = '';
  String _category = _defaultCategory;
  String _thumbnailUrl = '';
  DateTime? _endedAt;
  bool _isOngoing = true;
  bool _dismissedIncomingSnackBar = false;
  bool _checkedAuthentication = false;
  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_dismissedIncomingSnackBar) return;
    _dismissedIncomingSnackBar = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    if (!_checkedAuthentication) {
      _checkedAuthentication = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final isLoggedIn = await ensureLoggedIn(context);
        if (!isLoggedIn && mounted) Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _endedAtController.dispose();
    super.dispose();
  }

  Future<void> _selectEndDate() async {
    final today = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? today,
      firstDate: DateTime(1900),
      lastDate: today,
      helpText: 'Pilih tanggal berakhir',
    );

    if (selectedDate == null || !mounted) return;

    setState(() {
      _endedAt = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      _endedAtController.text = MaterialLocalizations.of(context)
          .formatMediumDate(_endedAt!);
    });
  }

  Future<void> _saveExperience() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    if (!await ensureLoggedIn(context) || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    try {
      final experience = Experience(
        title: _title,
        description: _description,
        category: _category,
        thumbnail: _thumbnailUrl.isEmpty ? null : _thumbnailUrl,
        endedAt: _isOngoing ? null : _endedAt,
      );
      await context.read<ApiClient>().createExperience(
        experience,
        token: token,
      );
      if (!mounted) return;

      final openList = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Experience Saved'),
          content: Text('"$_title" berhasil ditambahkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Selesai'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Lihat daftar'),
            ),
          ],
        ),
      );
      if (openList == true && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => const ExperienceListScreen()),
        );
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        try {
          await context.read<AuthState>().logout();
        } catch (_) {
          // AuthState clears the local token even when the server is unreachable.
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
            content: Text(
              'Gagal menyimpan pengalaman (HTTP ${error.statusCode}).',
            ),
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
        title: const Text('Add Experience Form'),
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
            MaterialPageRoute<void>(
              builder: (context) => const ProjectFormPage(),
            ),
          );
        },
        onProjectsTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ProjectListScreen(),
            ),
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
        onAddExperienceTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ExperienceFormPage(),
            ),
          );
        },
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  maxLength: 255,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pengalaman',
                    hintText: 'Contoh: Asisten Laboratorium',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _title = value?.trim() ?? '',
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) {
                      return 'Nama pengalaman tidak boleh kosong!';
                    }
                    if (title.length > 255) {
                      return 'Nama pengalaman maksimal 255 karakter.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Pengalaman',
                    hintText: 'Ceritakan tanggung jawab atau pencapaianmu',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  onSaved: (value) => _description = value?.trim() ?? '',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi pengalaman tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButtonFormField<String>(
                  initialValue: _defaultCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori Pengalaman',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.entries
                      .map(
                        (entry) => DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Pilih kategori pengalaman.'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  maxLength: 200,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'URL Thumbnail (opsional)',
                    hintText: 'https://example.com/image.jpg',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _thumbnailUrl = value?.trim() ?? '',
                  validator: (value) {
                    final url = value?.trim() ?? '';
                    if (url.isEmpty) return null;
                    if (url.length > 200) {
                      return 'URL thumbnail maksimal 200 karakter.';
                    }

                    final uri = Uri.tryParse(url);
                    if (uri == null ||
                        !uri.hasScheme ||
                        !{'http', 'https'}.contains(uri.scheme) ||
                        uri.host.isEmpty) {
                      return 'Masukkan URL valid yang diawali http:// atau https://.';
                    }
                    return null;
                  },
                ),
              ),
              SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: const Text('Pengalaman masih berlangsung'),
                value: _isOngoing,
                onChanged: (isOngoing) {
                  setState(() {
                    _isOngoing = isOngoing;
                    if (isOngoing) {
                      _endedAt = null;
                      _endedAtController.clear();
                    }
                  });
                },
              ),
              if (!_isOngoing)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _endedAtController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Berakhir',
                      hintText: 'Pilih tanggal berakhir',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: 'Pilih tanggal',
                        onPressed: _selectEndDate,
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    onTap: _selectEndDate,
                    validator: (value) => _endedAt == null
                        ? 'Pilih tanggal berakhir atau tandai masih berlangsung.'
                        : null,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _saveExperience,
                    icon: _isSubmitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
