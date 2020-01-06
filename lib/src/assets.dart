import 'dart:io';

class Assets {
  final Directory _local;
  Directory get local => _local ?? Directory('assets');
  const Assets({
    Directory local,
  }) : _local = local;

  Assets copyWith({Directory local}) {
    return Assets(
      local: local ?? this.local,
    );
  }
}
