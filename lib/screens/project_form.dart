import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  static const String _defaultCategory = 'Web Development';

  final _formKey = GlobalKey<FormState>();
  String _projectName = "";
  String _description = "";
  String _category = _defaultCategory;
  String _technologies = "";
  String _projectLink = "";

  final List<String> _categories = const [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(
        onHomeTap: () {
          Navigator.pop(context);
        },
        onAddProjectTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ProjectFormPage(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Project Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Proyek",
                    labelText: "Nama Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onSaved: (String? value) {
                    _projectName = value?.trim() ?? "";
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama proyek tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Proyek",
                    labelText: "Deskripsi Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onSaved: (String? value) {
                    _description = value?.trim() ?? "";
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi proyek tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _defaultCategory,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue == null) return;
                    setState(() => _category = newValue);
                  },
                ),
              ),

              // === Technologies ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Flutter, Django, Figma",
                    labelText: "Teknologi yang Digunakan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onSaved: (String? value) {
                    _technologies = value?.trim() ?? "";
                  },
                ),
              ),

              // === Project Link ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Proyek (opsional)",
                    labelText: "Tautan Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (String? value) {
                    _projectLink = value?.trim() ?? "";
                  },
                  validator: (String? value) {
                    final link = value?.trim() ?? "";
                    if (link.isEmpty) return null;

                    final uri = Uri.tryParse(link);
                    if (uri == null ||
                        !uri.hasScheme ||
                        !{'http', 'https'}.contains(uri.scheme) ||
                        uri.host.isEmpty) {
                      return "Masukkan URL yang valid (http:// atau https://)!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Proyek berhasil ditambahkan!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Proyek: $_projectName'),
                                    Text('Deskripsi: $_description'),
                                    Text('Kategori: $_category'),
                                    Text(
                                      'Teknologi: ${_technologies.isEmpty ? "—" : _technologies}',
                                    ),
                                    Text(
                                      'Tautan: ${_projectLink.isEmpty ? "—" : _projectLink}',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _projectName = "";
                                      _description = "";
                                      _category = _defaultCategory;
                                      _technologies = "";
                                      _projectLink = "";
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
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
