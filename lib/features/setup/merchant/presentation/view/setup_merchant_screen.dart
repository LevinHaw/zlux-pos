import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import 'package:zlux_pos/features/setup/merchant/presentation/viewmodel/setup_merchant_viewmodel.dart';

import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_strings.dart';

class SetupMerchantScreen extends ConsumerStatefulWidget {
  const SetupMerchantScreen({super.key});

  @override
  ConsumerState<SetupMerchantScreen> createState() =>
      _SetupMerchantScreenState();
}

class _SetupMerchantScreenState extends ConsumerState<SetupMerchantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      ref
          .read(setupMerchantViewModelProvider.notifier)
          .setImage(File(picked.path));
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(setupMerchantViewModelProvider.notifier).save(
          name: _nameController.text,
          address: _addressController.text,
        );

    if (!mounted) return;
    final state = ref.read(setupMerchantViewModelProvider);

    if (state.isSaved) {
      Navigator.of(context).pop();
    } else if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(setupMerchantViewModelProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: const Text(AppStrings.setupMerchant),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
            children: [
              SizedBox(height: AppSizes.lg),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: AppSizes.lg,
                    backgroundColor: context.appColors.surface,
                    backgroundImage: state.imageFile != null
                        ? FileImage(state.imageFile!)
                        : null,
                    child: state.imageFile == null
                        ? const Icon(Icons.camera_alt_outlined)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.lg),
              Text(
                AppStrings.nameMerchant,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              SizedBox(height: AppSizes.lg),
              TextFormField(
                controller: _nameController,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? AppStrings.Username
                    : null,
              ),
              SizedBox(height: AppSizes.lg),
              Text(
                AppStrings.address,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              SizedBox(height: AppSizes.lg),
              TextFormField(
                controller: _addressController,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? AppStrings.address
                    : null,
              ),
              SizedBox(height: AppSizes.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _onSave,
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AppStrings.save),
                ),
              ),
              SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }
}
