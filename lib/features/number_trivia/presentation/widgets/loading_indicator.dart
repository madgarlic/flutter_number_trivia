import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const SizedBox(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
