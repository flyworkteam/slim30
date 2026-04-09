import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slim30/Core/Network/api_exception.dart';
import 'package:slim30/Core/Routes/app_routes.dart';
import 'package:slim30/Riverpod/Providers/backend_providers.dart';
import 'package:slim30/l10n/generated/app_localizations.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  static const _homeIconBase = 'assets/images/icons/homePage';
  static const _bodyTypes = ['slim', 'normal', 'overweight', 'obese'];

  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  final ImagePicker _imagePicker = ImagePicker();

  String _bodyType = 'normal';
  bool _initializedFromApi = false;
  bool _isUploadingAvatar = false;
  String? _avatarUrl;
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectBodyType() async {
    final l10n = AppLocalizations.of(context)!;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9C9C9),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              SizedBox(height: 10.h),
              ..._bodyTypes.map((type) {
                final active = type == _bodyType;
                return ListTile(
                  title: Text(
                    _bodyTypeLabel(l10n, type),
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18.sp,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  trailing: active
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF01A2F1),
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(type),
                );
              }),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );

    if (selected != null && selected != _bodyType) {
      setState(() => _bodyType = selected);
    }
  }

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;

    double? parseHeightCm(String input) {
      final raw = input.trim().replaceAll(',', '.');
      final value = double.tryParse(raw);
      if (value == null) {
        return null;
      }

      if (value <= 3) {
        return value * 100;
      }

      return value;
    }

    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()),
      'height_cm': parseHeightCm(_heightController.text),
      'weight_kg': double.tryParse(
        _weightController.text.trim().replaceAll(',', '.'),
      ),
    };

    payload.removeWhere((_, value) => value == null);

    try {
      await updateProfile(ref, payload);
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              l10n.editProfileSaveMessage,
              style: GoogleFonts.leagueSpartan(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Profil kaydedilemedi. Tekrar deneyin.'),
          ),
        );
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    if (_isUploadingAvatar) {
      return;
    }

    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 88,
    );

    if (!mounted || pickedFile == null) {
      return;
    }

    final contentType = _resolveImageContentType(
      filename: pickedFile.name,
      mimeType: pickedFile.mimeType,
    );
    if (contentType == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Sadece JPG, JPEG, PNG, WEBP, HEIC veya HEIF formatlari destekleniyor.',
            ),
          ),
        );
      return;
    }

    final bytes = await pickedFile.readAsBytes();

    if (!mounted) {
      return;
    }

    setState(() {
      _isUploadingAvatar = true;
    });

    try {
      final avatarUrl = await uploadProfileAvatar(
        ref,
        bytes: bytes,
        filename: pickedFile.name,
        contentType: contentType,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _avatarUrl = avatarUrl;
        _avatarBytes = bytes;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Profil fotografi guncellendi.')),
        );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Fotograf yuklenemedi. Tekrar deneyin.'),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }

  void _deleteAccount() {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.editProfileDeleteTitle,
            style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w600),
          ),
          content: Text(
            l10n.editProfileDeleteMessage,
            style: GoogleFonts.leagueSpartan(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.editProfileCancel,
                style: GoogleFonts.leagueSpartan(),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.editProfileDeletePendingMessage,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                l10n.editProfileConfirm,
                style: GoogleFonts.leagueSpartan(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider).valueOrNull;

    if (profile != null) {
      final shouldHydrate =
          !_initializedFromApi ||
          (_nameController.text.trim().isEmpty && profile.name.trim().isNotEmpty) ||
          (_ageController.text.trim().isEmpty && profile.age != null) ||
          (_heightController.text.trim().isEmpty && profile.heightCm != null) ||
          (_weightController.text.trim().isEmpty && profile.weightKg != null) ||
          ((_avatarUrl == null || _avatarUrl!.trim().isEmpty) &&
              profile.avatarUrl != null &&
              profile.avatarUrl!.trim().isNotEmpty);

      if (shouldHydrate) {
        _initializedFromApi = true;
        _nameController.text = profile.name;
        _ageController.text = profile.age?.toString() ?? '';
        _heightController.text = profile.heightCm != null
            ? (profile.heightCm! / 100).toStringAsFixed(2)
            : '';
        _weightController.text = profile.weightKg?.toStringAsFixed(0) ?? '';
        _avatarUrl = profile.avatarUrl;
        _avatarBytes = null;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 390.w,
          child: Stack(
            children: [
              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 90.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopHeader(title: l10n.editProfileTitle),
                        SizedBox(height: 33.h),
                        Center(
                          child: _ProfileIdentity(
                            nameController: _nameController,
                            avatarUrl: _avatarUrl,
                            avatarBytes: _avatarBytes,
                            isUploadingAvatar: _isUploadingAvatar,
                            onEditAvatar: _pickAndUploadAvatar,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        _EditFields(
                          nameController: _nameController,
                          ageController: _ageController,
                          heightController: _heightController,
                          weightController: _weightController,
                          bodyType: _bodyType,
                          onBodyTypeTap: _selectBodyType,
                        ),
                        SizedBox(height: 33.h),
                        _SaveActions(
                          label: l10n.editProfileSaveButton,
                          deleteLabel: l10n.editProfileDeleteAccount,
                          onSave: _saveChanges,
                          onDelete: _deleteAccount,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomBar(iconBase: _homeIconBase),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Semantics(
          label: l10n.questionBack,
          button: true,
          child: InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.leagueSpartan(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 1,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(width: 28.w),
      ],
    );
  }
}

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity({
    required this.nameController,
    required this.avatarUrl,
    required this.avatarBytes,
    required this.isUploadingAvatar,
    required this.onEditAvatar,
  });

  final TextEditingController nameController;
  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final bool isUploadingAvatar;
  final VoidCallback onEditAvatar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 114.w,
      child: Column(
        children: [
          SizedBox(
            width: 72.w,
            child: Column(
              children: [
                SizedBox(
                  width: 70.w,
                  height: 82.h,
                  child: InkWell(
                    onTap: isUploadingAvatar ? null : onEditAvatar,
                    borderRadius: BorderRadius.circular(35.r),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35.r),
                            child: _AvatarImage(
                              nameListenable: nameController,
                              avatarUrl: avatarUrl,
                              avatarBytes: avatarBytes,
                            ),
                          ),
                        ),
                        if (isUploadingAvatar)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(35.r),
                              ),
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          left: 23.w,
                          top: 58.h,
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              isUploadingAvatar
                                  ? Icons.hourglass_top
                                  : Icons.edit,
                              size: 14.w,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: nameController,
                  builder: (context, value, _) {
                    return Text(
                      value.text.trim().isEmpty ? 'User' : value.text.trim(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({
    required this.nameListenable,
    required this.avatarUrl,
    required this.avatarBytes,
  });

  final ValueListenable<TextEditingValue> nameListenable;
  final String? avatarUrl;
  final Uint8List? avatarBytes;

  @override
  Widget build(BuildContext context) {
    if (avatarBytes != null) {
      return Image.memory(
        avatarBytes!,
        width: 70.w,
        height: 70.w,
        fit: BoxFit.cover,
      );
    }

    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) {
      return Image.network(
        avatarUrl!,
        width: 70.w,
        height: 70.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _AvatarPlaceholderImage(nameListenable: nameListenable);
        },
      );
    }

    return _AvatarPlaceholderImage(nameListenable: nameListenable);
  }
}

class _AvatarPlaceholderImage extends StatelessWidget {
  const _AvatarPlaceholderImage({required this.nameListenable});

  final ValueListenable<TextEditingValue> nameListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: nameListenable,
      builder: (context, value, _) {
        final initials = _initials(value.text);
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF62DCF4), Color(0xFF66F393)],
            ),
          ),
          child: SizedBox(
            width: 70.w,
            height: 70.w,
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _initials(String raw) {
    final parts = raw
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _EditFields extends StatelessWidget {
  const _EditFields({
    required this.nameController,
    required this.ageController,
    required this.heightController,
    required this.weightController,
    required this.bodyType,
    required this.onBodyTypeTap,
  });

  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final String bodyType;
  final VoidCallback onBodyTypeTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: 342.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileInputField(
            label: l10n.editProfileNameLabel,
            controller: nameController,
            highlighted: true,
          ),
          SizedBox(height: 20.h),
          _ProfileInputField(
            label: l10n.editProfileBodyTypeLabel,
            value: _bodyTypeLabel(l10n, bodyType),
            readOnly: true,
            onTap: onBodyTypeTap,
            showTrailingArrow: true,
          ),
          SizedBox(height: 20.h),
          _ProfileInputField(
            label: l10n.editProfileAgeLabel,
            controller: ageController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20.h),
          _ProfileInputField(
            label: l10n.editProfileHeightLabel,
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: 20.h),
          _ProfileInputField(
            label: l10n.editProfileWeightLabel,
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }
}

class _ProfileInputField extends StatelessWidget {
  const _ProfileInputField({
    required this.label,
    this.controller,
    this.value,
    this.highlighted = false,
    this.readOnly = false,
    this.onTap,
    this.showTrailingArrow = false,
    this.keyboardType,
  }) : assert(controller != null || value != null);

  final String label;
  final TextEditingController? controller;
  final String? value;
  final bool highlighted;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool showTrailingArrow;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final displayTextColor = highlighted
        ? const Color(0xFF3D3D3D)
        : const Color(0xFF929292);

    return SizedBox(
      width: 342.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.leagueSpartan(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: -0.13,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: 342.w,
            height: 40.h,
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              keyboardType: keyboardType,
              style: GoogleFonts.leagueSpartan(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.13,
                color: displayTextColor,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: value,
                hintStyle: GoogleFonts.leagueSpartan(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: -0.13,
                  color: displayTextColor,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 11.h,
                ),
                filled: true,
                fillColor: const Color(0xFFF5FEFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: highlighted
                        ? const Color(0xFF2ED3EC)
                        : const Color(0xFFF5FEFF),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: highlighted
                        ? const Color(0xFF2ED3EC)
                        : const Color(0xFFF5FEFF),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFF2ED3EC)),
                ),
                suffixIcon: showTrailingArrow
                    ? Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.w,
                        color: const Color(0xFF929292),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveActions extends StatelessWidget {
  const _SaveActions({
    required this.label,
    required this.deleteLabel,
    required this.onSave,
    required this.onDelete,
  });

  final String label;
  final String deleteLabel;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342.w,
      child: Column(
        children: [
          InkWell(
            onTap: onSave,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 342.w,
              height: 44.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF62DCF4),
                    Color(0xFF64E6C4),
                    Color(0xFF66F393),
                  ],
                  stops: [0.0, 0.5843, 1.0],
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: GoogleFonts.leagueSpartan(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 15 / 16,
                  letterSpacing: -0.17,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: onDelete,
            child: Text(
              deleteLabel,
              style: GoogleFonts.leagueSpartan(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: -0.17,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _bodyTypeLabel(AppLocalizations l10n, String value) {
  switch (value) {
    case 'slim':
      return l10n.bodyTypeSlim;
    case 'normal':
      return l10n.bodyTypeNormal;
    case 'overweight':
      return l10n.bodyTypeOverweight;
    case 'obese':
      return l10n.bodyTypeObese;
    default:
      return l10n.bodyTypeNormal;
  }
}

String? _resolveImageContentType({required String filename, String? mimeType}) {
  final normalizedMimeType = mimeType?.trim().toLowerCase();
  const supportedMimeTypes = <String>{
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif',
  };

  if (normalizedMimeType != null &&
      supportedMimeTypes.contains(normalizedMimeType)) {
    return normalizedMimeType;
  }

  final lowerName = filename.trim().toLowerCase();
  if (lowerName.endsWith('.jpg') || lowerName.endsWith('.jpeg')) {
    return 'image/jpeg';
  }
  if (lowerName.endsWith('.png')) {
    return 'image/png';
  }
  if (lowerName.endsWith('.webp')) {
    return 'image/webp';
  }
  if (lowerName.endsWith('.heic')) {
    return 'image/heic';
  }
  if (lowerName.endsWith('.heif')) {
    return 'image/heif';
  }
  return null;
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.iconBase});

  final String iconBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 390.w,
      height: 68.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 1,
            offset: Offset(0, -0.6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _BottomItem(
            iconPath: '$iconBase/iconsax-home-2.svg',
            label: l10n.homeTabHome,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.home),
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-health.svg',
            label: l10n.homeTabWorkout,
            onTap: () {},
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-chart-square.svg',
            label: l10n.homeTabProgress,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.progress),
          ),
          SizedBox(width: 4.w),
          _BottomItem(
            iconPath: '$iconBase/iconsax-user.svg',
            label: l10n.homeTabProfile,
            active: true,
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.profile),
          ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.iconPath,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final String iconPath;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 94.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 28.w,
              height: 28.w,
              colorFilter: active
                  ? const ColorFilter.mode(Color(0xFF01A2F1), BlendMode.srcIn)
                  : null,
            ),
            SizedBox(height: 7.h),
            Text(
              label,
              style: GoogleFonts.leagueSpartan(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: -0.13,
                color: active ? const Color(0xFF01A2F1) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
