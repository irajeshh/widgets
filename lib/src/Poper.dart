import 'package:flutter/material.dart';

class Poper extends StatefulWidget {
  final Widget child;
  final Future<bool> Function() onWillPop;

  const Poper({
    super.key,
    required this.child,
    required this.onWillPop,
  });

  @override
  State<Poper> createState() => _PoperState();
}

class _PoperState extends State<Poper> {
  // We default to false to block the system back initially.
  // This allows us to intercept the gesture and run onWillPop logic.
  bool _canPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        // If didPop is true, the pop already happened (because we set _canPop = true).
        if (didPop) return;

        // Run the custom logic
        final bool shouldPop = await widget.onWillPop();

        if (shouldPop) {
          // If allowed, we update state to enable pop and manually trigger it.
          if (mounted) {
            setState(() => _canPop = true);

            // Wait for the build to finish so PopScope sees canPop: true, then pop.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context).pop(result);
              }
            });
          }
        }
      },
      child: widget.child,
    );
  }
}
