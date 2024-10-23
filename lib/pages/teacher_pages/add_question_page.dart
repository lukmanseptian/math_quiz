import 'package:flutter/material.dart';
import 'package:math_quiz/helpers/index.dart';
import 'package:math_quiz/models/index.dart';
import 'package:math_quiz/pages/widgets/index.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _options = ['', '', '', ''];

  List<ModuleMdl> _modules = [];
  List<PartMdl> _parts = [];

  String? _selectedModuleName;
  String? _selectedPartName;
  String? _questionText;
  String? _correctAnswer;

  bool _isLoading = true;

  Future<void> _submitQuestion() async {
    //? Validasi Semua Harus Diisi
    if (_selectedModuleName == null ||
        _selectedPartName == null ||
        _questionText == null ||
        _questionText!.isEmpty ||
        _correctAnswer == null ||
        !_options.every((option) => option.isNotEmpty)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(MySnackbar.failed(message: 'Semua form harus diisi.'));

      return;
    }

    try {
      //? Mengirim Data Ke Firebase
      setState(() => _isLoading = true);
      final question = QuestionMdl(
        imageUrl: 'test', // TODO(Aliryo): Implement image for question
        questionText: _questionText ?? '',
        correctAnswer: _correctAnswer ?? '',
        partName: _selectedPartName ?? '',
        moduleName: _selectedModuleName ?? '',
        options: _options,
      );

      await FirebaseHelper.addQuestion(question);

      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              MySnackbar.success(message: 'Pertanyaan berhasil ditambahkan.'));
      }
      setState(() {
        _correctAnswer = null;
        _isLoading = false;
      });
    } catch (e) {
      //? Jika Terdapat Kegagalan
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(MySnackbar.failed(message: e.toString()));
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchModules() async {
    final modules = await FirebaseHelper.fetchModules();

    setState(() {
      _modules = modules;
      _isLoading = false;
    });
  }

  Future<void> _fetchParts(String moduleName) async {
    final parts = await FirebaseHelper.fetchParts(moduleName);

    setState(() {
      _parts = parts;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchModules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const answerLabels = ['A', 'B', 'C', 'D'];

    if (_isLoading) {
      return const MyLoading();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pertanyaan Baru'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyDropdown<String>(
              label: 'Pilih Modul',
              value: _selectedModuleName,
              items: _modules.map((ModuleMdl module) {
                return DropdownMenuItem<String>(
                  value: module.moduleName,
                  child: Text(module.moduleName),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedModuleName = newValue;
                  _parts = [];
                  _selectedPartName = null;
                  _isLoading = true;
                });

                _fetchParts(newValue ?? '');
              },
            ),
            if (_parts.isNotEmpty) ...[
              const SizedBox(height: 20),
              MyDropdown<String>(
                label: 'Pilih Materi',
                value: _selectedPartName,
                items: _parts.map((PartMdl parts) {
                  return DropdownMenuItem<String>(
                    value: parts.partName,
                    child: Text(parts.partName),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() => _selectedPartName = newValue);
                },
              ),
            ],
            const SizedBox(height: 20),
            MyInputField(
              label: 'Teks Pertanyaan',
              onChanged: (text) {
                setState(() => _questionText = text);
              },
            ),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MyInputField(
                  label: 'Opsi ${answerLabels[i]}',
                  onChanged: (text) {
                    setState(() => _options[i] = text);
                  },
                ),
              ),
            const SizedBox(height: 20),
            MyDropdown<String>(
              label: 'Jawaban Benar',
              value: _correctAnswer,
              items: answerLabels.map((String answer) {
                return DropdownMenuItem<String>(
                  value: answer,
                  child: Text(answer),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _correctAnswer = newValue);
              },
            ),
            const SizedBox(height: 20),
            MySelectionButton(
              onTap: _submitQuestion,
              title: 'Tambah Pertanyaan',
            ),
          ],
        ),
      ),
    );
  }
}
