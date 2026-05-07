import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _reauthController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _reauthController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match.');
      return;
    }

    final validationError = _validatePassword(_passwordController.text);
    if (validationError != null) {
      _showError(validationError);
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Re-authentication might be needed if they haven't logged in recently
      await _showReauthDialog();
      await ref.read(authServiceProvider).updatePassword(_passwordController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully.')),
        );
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validatePassword(String password) {
    if (password.length < 8) return 'Password must be at least 8 characters.';
    if (!password.contains(RegExp(r'[A-Z]'))) return 'Password must contain at least one capital letter.';
    if (!password.contains(RegExp(r'[0-9]'))) return 'Password must contain at least one number.';
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action is PERMANENT. All your reading history, reviews, and lists will be deleted.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        final user = ref.read(authProvider).value;
        if (user != null) {
          // 1. Re-authenticate
          await _showReauthDialog();
          // 2. Delete Firestore data
          await ref.read(userServiceProvider).deleteUserData(user.uid);
          // 3. Delete Auth account
          await ref.read(authServiceProvider).deleteAuthAccount();
          
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      } catch (e) {
        _showError('Deletion failed. You may need to sign out and back in to verify your identity.');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showReauthDialog() async {
    final user = ref.read(authProvider).value;
    if (user == null || user.email == null) return;

    // Check if user is Google user - Google users don't need reauth with password
    final isGoogleUser = user.providerData.any((p) => p.providerId == 'google.com');
    if (isGoogleUser) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Verify Identity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your current password to continue.'),
            const SizedBox(height: 16),
            TextField(
              controller: _reauthController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _reauthController.clear();
              throw Exception('Verification cancelled.');
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).reauthenticate(
                  user.email!,
                  _reauthController.text,
                );
                _reauthController.clear();
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect password.')),
                  );
                }
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final isGoogleUser = user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (!isGoogleUser) ...[
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  child: const Text('Update Password'),
                ),
              ] else
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'You are signed in with Google. Password management is handled by your Google Account.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Danger Zone',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 16),
              const Text(
                'Once you delete your account, there is no going back. Please be certain.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _deleteAccount,
                icon: const Icon(Icons.delete_forever),
                label: const Text('Delete My Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
