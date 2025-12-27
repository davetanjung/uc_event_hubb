// Make sure to add this file to your 'pages.dart' via 'part' or import it directly
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uc_event_hubb/viewmodel/auth_viewmodel.dart';
part of 'pages.dart';
// import your pages.dart or wherever necessary

class RegistrationPageView extends StatefulWidget {
  const RegistrationPageView({super.key});

  @override
  State<RegistrationPageView> createState() => _RegistrationPageViewState();
}

class _RegistrationPageViewState extends State<RegistrationPageView> {
  // Controllers for all required fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final nimController = TextEditingController();
  final orgTitleController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    nimController.dispose();
    orgTitleController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final authVM = context.read<AuthViewModel>();

    // 1. Basic Validation
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        nimController.text.isEmpty ||
        orgTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // 2. Call the ViewModel
    await authVM.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      fullName: fullNameController.text.trim(),
      nim: nimController.text.trim(),
      organizationTitle: orgTitleController.text.trim(),
    );

    if (!mounted) return;

    // 3. Handle Success or Failure
    if (authVM.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVM.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      // Close the registration page and return to login (or go to home)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch loading state to disable buttons/show spinner
    final isLoading = context.watch<AuthViewModel>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nimController,
              decoration: const InputDecoration(labelText: "NIM"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: orgTitleController,
              decoration: const InputDecoration(
                labelText: "Organization Title (e.g. Member)",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
