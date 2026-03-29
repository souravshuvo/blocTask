import 'package:flutter/material.dart';

import '../../../data/models/character_model.dart';
import '../../../data/repositories/character_repository.dart';

class EditCharacterScreen extends StatefulWidget {
  final CharacterModel character;
  final CharacterRepository repo;

  EditCharacterScreen({
    super.key,
    required this.character,
    CharacterRepository? repo,
  }) : repo = repo ?? CharacterRepository();

  @override
  State<EditCharacterScreen> createState() => _EditCharacterScreenState();
}

class _EditCharacterScreenState extends State<EditCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  CharacterRepository get _repo => widget.repo;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _speciesCtrl;
  late final TextEditingController _typeCtrl;
  late final TextEditingController _originCtrl;
  late final TextEditingController _locationCtrl;

  late String _selectedStatus;
  late String _selectedGender;

  bool _isSaving = false;

  static const _statusOptions = ['Alive', 'Dead', 'unknown'];
  static const _genderOptions = ['Male', 'Female', 'Genderless', 'unknown'];

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    _nameCtrl = TextEditingController(text: c.name);
    _speciesCtrl = TextEditingController(text: c.species);
    _typeCtrl = TextEditingController(text: c.type);
    _originCtrl = TextEditingController(text: c.origin.name);
    _locationCtrl = TextEditingController(text: c.location.name);
    _selectedStatus = _statusOptions.contains(c.status) ? c.status : 'unknown';
    _selectedGender = _genderOptions.contains(c.gender) ? c.gender : 'unknown';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _speciesCtrl.dispose();
    _typeCtrl.dispose();
    _originCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final edits = {
      'name': _nameCtrl.text.trim(),
      'status': _selectedStatus,
      'species': _speciesCtrl.text.trim(),
      'type': _typeCtrl.text.trim(),
      'gender': _selectedGender,
      'originName': _originCtrl.text.trim(),
      'locationName': _locationCtrl.text.trim(),
    };

    await _repo.saveLocalEdit(widget.character.id, edits);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved locally!'),
          backgroundColor: Color(0xFF97CE4C),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Character'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF97CE4C),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionTitle('Basic Info'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _nameCtrl,
              label: 'Name',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name cannot be empty' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _speciesCtrl,
              label: 'Species',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Species cannot be empty' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _typeCtrl,
              label: 'Type (optional)',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Status & Gender'),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Status',
              value: _selectedStatus,
              options: _statusOptions,
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Gender',
              value: _selectedGender,
              options: _genderOptions,
              onChanged: (v) => setState(() => _selectedGender = v!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Location Info'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _originCtrl,
              label: 'Origin Name',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _locationCtrl,
              label: 'Last Known Location',
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: _confirmReset,
              icon: const Icon(Icons.restore, color: Colors.redAccent),
              label: const Text(
                'Reset to API data',
                style: TextStyle(color: Colors.redAccent),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      dropdownColor: const Color(0xFF0F3460),
      style: const TextStyle(color: Colors.white),
      items: options
          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Reset edits?'),
        content: const Text(
          'All local changes will be discarded and the original API data will be shown.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _repo.resetLocalEdit(widget.character.id);
      if (mounted) Navigator.pop(context, true);
    }
  }
}
