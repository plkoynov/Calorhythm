import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/constants/app_strings.dart';
import 'package:calorhythm/domain/entities/user_profile.dart';
import 'package:calorhythm/presentation/features/profile/providers/profile_provider.dart';
import 'package:calorhythm/presentation/features/profile/widgets/numeric_field.dart';

class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({super.key, this.initialProfile});

  final UserProfile? initialProfile;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _heightCtrl;
  late bool _useRepMultiplier;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialProfile?.name ?? '');
    _weightCtrl = TextEditingController(
        text: widget.initialProfile?.weightKg.toString() ?? '');
    _heightCtrl = TextEditingController(
        text: widget.initialProfile?.heightCm.toString() ?? '');
    _useRepMultiplier =
        widget.initialProfile?.useRepMultiplierForCalories ?? false;
    _nameCtrl.addListener(_onChanged);
    _weightCtrl.addListener(_onChanged);
    _heightCtrl.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _isDirty {
    final p = widget.initialProfile;
    final currentName =
        _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim();
    if (currentName != p?.name) return true;
    if (_weightCtrl.text != (p?.weightKg.toString() ?? '')) return true;
    if (_heightCtrl.text != (p?.heightCm.toString() ?? '')) return true;
    if (_useRepMultiplier != (p?.useRepMultiplierForCalories ?? false)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(profileSaverProvider);
    final canSave = _isDirty && !saveState.isLoading;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            NumericField(controller: _weightCtrl, label: AppStrings.weightKg),
            const SizedBox(height: 16),
            NumericField(controller: _heightCtrl, label: AppStrings.heightCm),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Count reps toward calories'),
                      const SizedBox(height: 2),
                      Text(
                        _useRepMultiplier
                            ? 'Calories scale with reps × time'
                            : 'Calories based on duration only',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _useRepMultiplier,
                  onChanged: (v) => setState(() => _useRepMultiplier = v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: canSave ? _save : null,
              child: saveState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text(AppStrings.saveProfile),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final profile = UserProfile(
      name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
      weightKg: double.parse(_weightCtrl.text),
      heightCm: double.parse(_heightCtrl.text),
      useRepMultiplierForCalories: _useRepMultiplier,
    );
    ref.read(profileSaverProvider.notifier).save(profile);
  }
}
