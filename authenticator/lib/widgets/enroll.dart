import 'package:flutter/material.dart';

class Enroll extends StatefulWidget {
  final Future<void> Function(String email) handleEnroll;
  const Enroll({super.key, required this.handleEnroll});

  @override
  State<Enroll> createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  bool _isLoading = false;
  String _email = '';

  void _handleChange(String email) {
    setState(() {
      _email = email;
    });
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });
    await widget.handleEnroll(_email);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Enter Email',
            border: OutlineInputBorder(),
          ),
          onChanged: _handleChange,
          enabled: !_isLoading,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: Text('Enroll Now'),
        ),
      ],
    );
  }
}
