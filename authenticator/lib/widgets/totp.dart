import 'dart:async';

import 'package:flutter/material.dart';
import 'package:totp/totp.dart';

const TOTP_PERIOD_SECONDS = 30; // TOTP period in seconds

class TOTP extends StatefulWidget {
  final String secret;

  const TOTP({super.key, required this.secret});

  @override
  State<TOTP> createState() => _TOTPState();
}

class _TOTPState extends State<TOTP> {
  late Totp _totp;
  String _currentTotp = 'Loading...';
  Timer? _timer;
  int _remainingSeconds = 0; // To show countdown to next refresh

  @override
  void initState() {
    super.initState();
    // Initialize your TOTP object with your secret
    _totp = Totp.fromBase32(
      secret: widget.secret,
      digits: 6,
      algorithm: Algorithm.sha1,
    ); // Replace with your actual secret

    _generateTotpAndStartTimer();
  }

  void _generateTotpAndStartTimer() {
    // Generate the initial TOTP
    _updateTotp();

    // Calculate how many seconds are left in the current TOTP period
    // TOTP periods are usually 30 seconds.
    // The `remaining` method can help predict the next interval.
    _remainingSeconds = TOTP_PERIOD_SECONDS - _totp.remaining;

    // Set up a timer to update the TOTP.
    // It's often good to update slightly before the 0-second mark
    // or precisely when the new period starts.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // _remainingSeconds--;
        _remainingSeconds =
            TOTP_PERIOD_SECONDS -
            _totp.remaining; // Recalculate for the new period
        if (_remainingSeconds <= 0) {
          _updateTotp();
        }
      });
    });
  }

  void _updateTotp() {
    setState(() {
      _currentTotp = _totp.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          value:
              1 - (_remainingSeconds / 30), // Assuming a 30-second TOTP period
          strokeWidth: 6,
        ),
        SizedBox(height: 10),
        Text("remainingSeconds totp : ${_totp.remaining}"),
        Text((30 - _remainingSeconds).toString()),
        SizedBox(height: 20),
        Text(
          _currentTotp,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
