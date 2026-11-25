import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

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

  String _categoryLabel(String value) => _categories[value] ?? value;

  void _saveExperience() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Experience Saved'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Experience: $_title'),
              const SizedBox(height: 8),
              Text('Description: $_description'),
              const SizedBox(height: 8),
              Text('Category: ${_categoryLabel(_category)}'),
              const SizedBox(height: 8),
              Text('Thumbnail: ${_thumbnailUrl.isEmpty ? '—' : _thumbnailUrl}'),
              const SizedBox(height: 8),
              Text(
                _isOngoing
                    ? 'Status: Ongoing'
                    : 'Ended: ${_endedAtController.text}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
        onHomeTap: () => Navigator.pop(context),
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
                    onPressed: _saveExperience,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
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
