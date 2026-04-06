import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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

  String _bodyType = 'normal';
  bool _initializedFromApi = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Evrim Kurt');
    _ageController = TextEditingController(text: '26');
    _heightController = TextEditingController(text: '1.70');
    _weightController = TextEditingController(text: '70');
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
      'weight_kg': double.tryParse(_weightController.text.trim().replaceAll(',', '.')),
    };

    payload.removeWhere((_, value) => value == null);

    await updateProfile(ref, payload);

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

    if (!_initializedFromApi && profile != null) {
      _initializedFromApi = true;
      _nameController.text = profile.name;
      _ageController.text = profile.age?.toString() ?? _ageController.text;
      _heightController.text = profile.heightCm != null
          ? (profile.heightCm! / 100).toStringAsFixed(2)
          : _heightController.text;
      _weightController.text = profile.weightKg?.toStringAsFixed(0) ?? _weightController.text;
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
                          onSave: () {
                            _saveChanges();
                          },
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
  const _ProfileIdentity({required this.nameController});

  final TextEditingController nameController;

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
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.r),
                          child: Image.asset(
                            'assets/images/f62810c637b67734e57a8bfb4985baec89b2e79e.jpg',
                            width: 70.w,
                            height: 70.w,
                            fit: BoxFit.cover,
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
                            Icons.edit,
                            size: 14.w,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: nameController,
                  builder: (context, value, _) {
                    return Text(
                      value.text.trim().isEmpty ? 'Evrim Kurt' : value.text,
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
            value: ageController.text,
            readOnly: true,
          ),
          SizedBox(height: 20.h),
          _ProfileInputField(
            label: l10n.editProfileHeightLabel,
            value: heightController.text,
            readOnly: true,
          ),
          SizedBox(height: 20.h),
          _ProfileInputField(
            label: l10n.editProfileWeightLabel,
            value: weightController.text,
            readOnly: true,
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
  }) : assert(controller != null || value != null);

  final String label;
  final TextEditingController? controller;
  final String? value;
  final bool highlighted;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool showTrailingArrow;

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
                fontWeight: FontWeight.w400,
                color: active ? const Color(0xFF01A2F1) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
