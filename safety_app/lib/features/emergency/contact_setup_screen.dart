import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactSetupScreen extends StatefulWidget {
  const ContactSetupScreen({super.key});

  @override
  State<ContactSetupScreen> createState() => _ContactSetupScreenState();
}

class _ContactSetupScreenState extends State<ContactSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;
  bool _isVerified = false;

  final List<Map<String, String>> _savedContacts = [];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      // Simulate OTP sending
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _otpSent = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('OTP sent successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length == 6) {
      setState(() => _isLoading = true);
      
      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isVerified = true;
        });
        
        _savedContacts.add({
          'name': _nameController.text,
          'phone': _phoneController.text,
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Contact verified and saved successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        
        // Reset form
        _nameController.clear();
        _phoneController.clear();
        _otpController.clear();
        setState(() {
          _otpSent = false;
          _isVerified = false;
        });
      }
    }
  }

  Future<void> _removeContact(int index) async {
    setState(() {
      _savedContacts.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact removed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.contact_phone_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Add Emergency Contacts',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add trusted contacts who will be notified in case of emergency. They will receive your location and alert message.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Saved Contacts
            if (_savedContacts.isNotEmpty) ...[
              Text(
                'Saved Contacts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _savedContacts.length,
                itemBuilder: (context, index) {
                  final contact = _savedContacts[index];
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.person_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(contact['name'] ?? ''),
                      subtitle: Text(contact['phone'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeContact(index),
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
            
            // Add New Contact Form
            Text(
              'Add New Contact',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Contact Name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter contact name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter phone number';
                      }
                      if ((value?.length ?? 0) < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  if (_otpSent) ...[
                    const SizedBox(height: 16),
                    // OTP Field
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 6) {
                          _verifyOTP();
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  // Action Button
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : (_otpSent ? _verifyOTP : _sendOTP),
                    icon: Icon(_otpSent ? Icons.check : Icons.send),
                    label: Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
