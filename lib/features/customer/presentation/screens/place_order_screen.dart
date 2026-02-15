import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/customer/providers/customer_providers.dart';
import 'package:uuid/uuid.dart';

class PlaceOrderScreen extends ConsumerStatefulWidget {
  final String tailorId;

  const PlaceOrderScreen({super.key, required this.tailorId});

  @override
  ConsumerState<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends ConsumerState<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _dressType = AppConstants.dressTypes.first;
  final _colorController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();
  final _shoulderController = TextEditingController();
  final _sleeveController = TextEditingController();
  final _lengthController = TextEditingController();
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 7));
  File? _referenceImage;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _colorController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    _shoulderController.dispose();
    _sleeveController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _referenceImage = File(x.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = ref.read(currentUserProvider)?.id;
    if (uid == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      String? imageUrl;
      if (_referenceImage != null) {
        final orderId = const Uuid().v4();
        imageUrl = await ref.read(storageServiceProvider).uploadOrderImage(
              _referenceImage!,
              uid,
              orderId,
            );
      }
      final order = OrderModel(
        id: '',
        customerId: uid,
        tailorId: widget.tailorId,
        dressType: _dressType,
        color: _colorController.text.trim(),
        measurements: {
          'chest': double.tryParse(_chestController.text),
          'waist': double.tryParse(_waistController.text),
          'hip': double.tryParse(_hipController.text),
          'shoulder': double.tryParse(_shoulderController.text),
          'sleeve': double.tryParse(_sleeveController.text),
          'length': double.tryParse(_lengthController.text),
        }.map((k, v) => MapEntry(k, v ?? 0.0)),
        referenceImage: imageUrl,
        deliveryDate: _deliveryDate,
        status: AppConstants.statusPending,
        createdAt: DateTime.now(),
      );
      await ref.read(firestoreServiceProvider).createOrder(order);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _dressType,
                decoration: const InputDecoration(labelText: 'Dress Type'),
                items: AppConstants.dressTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _dressType = v ?? _dressType),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter color' : null,
              ),
              const SizedBox(height: 16),
              const Text('Measurements (cm)', style: TextStyle(fontWeight: FontWeight.bold)),
              _measureField('Chest', _chestController),
              _measureField('Waist', _waistController),
              _measureField('Hip', _hipController),
              _measureField('Shoulder', _shoulderController),
              _measureField('Sleeve', _sleeveController),
              _measureField('Length', _lengthController),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Delivery: ${_deliveryDate.toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _deliveryDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _deliveryDate = date);
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text(_referenceImage == null ? 'Upload reference image' : 'Image selected'),
              ),
              if (_referenceImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.file(_referenceImage!, height: 120, fit: BoxFit.cover),
                ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _measureField(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
