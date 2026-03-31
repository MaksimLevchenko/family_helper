import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/media/providers/media_provider.dart';

class FamilyMemberAvatar extends StatefulWidget {
  const FamilyMemberAvatar({
    super.key,
    required this.displayName,
    required this.avatarMediaId,
    this.size = 40,
    this.loadSignedUrl,
  });

  final String displayName;
  final int? avatarMediaId;
  final double size;
  final Future<String> Function(int mediaId)? loadSignedUrl;

  @override
  State<FamilyMemberAvatar> createState() => _FamilyMemberAvatarState();
}

class _FamilyMemberAvatarState extends State<FamilyMemberAvatar> {
  Future<String>? _avatarUrlFuture;
  bool _hasRetriedAfterImageError = false;

  @override
  void initState() {
    super.initState();
    _avatarUrlFuture = _createAvatarUrlFuture();
  }

  @override
  void didUpdateWidget(covariant FamilyMemberAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.avatarMediaId != widget.avatarMediaId) {
      _hasRetriedAfterImageError = false;
      _avatarUrlFuture = _createAvatarUrlFuture();
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.size / 2;
    final fallbackLabel = _initials(widget.displayName);
    final fallback = CircleAvatar(
      radius: radius,
      child: fallbackLabel == null
          ? Icon(Icons.person_outline, size: widget.size * 0.45)
          : Text(
              fallbackLabel,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: widget.size * 0.32,
              ),
            ),
    );

    if (_avatarUrlFuture == null) {
      return fallback;
    }

    return FutureBuilder<String>(
      future: _avatarUrlFuture,
      builder: (context, snapshot) {
        final imageUrl = snapshot.data;
        if (imageUrl == null || snapshot.hasError) {
          return fallback;
        }

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                _retrySignedUrlOnceAfterImageError();
                return fallback;
              },
            ),
          ),
        );
      },
    );
  }

  void _retrySignedUrlOnceAfterImageError() {
    if (_hasRetriedAfterImageError || widget.avatarMediaId == null) {
      return;
    }
    _hasRetriedAfterImageError = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _avatarUrlFuture = _createAvatarUrlFuture();
      });
    });
  }

  Future<String>? _createAvatarUrlFuture() {
    final avatarMediaId = widget.avatarMediaId;
    if (avatarMediaId == null) {
      return null;
    }
    final explicitLoader = widget.loadSignedUrl;
    if (explicitLoader != null) {
      return explicitLoader(avatarMediaId);
    }

    final mediaCubit = context.read<MediaCubit?>();
    if (mediaCubit == null) {
      return null;
    }
    return mediaCubit.loadSignedUrl(avatarMediaId);
  }

  String? _initials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return null;
    }
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
