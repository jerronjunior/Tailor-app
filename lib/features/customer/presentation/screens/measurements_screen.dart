import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

// ─────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────
class MeasurementField {
  final String key;
  final String label;
  final String hint;
  final String icon;
  String value;

  MeasurementField({
    required this.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.value = '',
  });

  MeasurementField copyWith({String? value}) =>
      MeasurementField(key: key, label: label, hint: hint, icon: icon, value: value ?? this.value);
}

class MeasurementProfile {
  final String id;
  String name;
  final List<MeasurementField> fields;

  MeasurementProfile({required this.id, required this.name, required this.fields});

  bool get isComplete => fields.every((f) => f.value.isNotEmpty);
  int get filledCount => fields.where((f) => f.value.isNotEmpty).length;

  factory MeasurementProfile.empty(String name) => MeasurementProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        fields: _defaultFields(),
      );

  factory MeasurementProfile.casual() => MeasurementProfile(
        id: 'casual',
        name: 'Casual Fit',
        fields: _defaultFields(values: {
          'chest': '40', 'waist': '34', 'hip': '38',
          'shoulder': '18', 'sleeve': '25', 'neck': '15',
          'shirt_length': '29', 'inseam': '31', 'thigh': '22', 'calf': '15',
        }),
      );

  factory MeasurementProfile.formal() => MeasurementProfile(
        id: 'formal',
        name: 'Formal Fit',
        fields: _defaultFields(values: {
          'chest': '41', 'waist': '33', 'hip': '39',
          'shoulder': '18.5', 'sleeve': '25.5', 'neck': '15.5',
          'shirt_length': '30', 'inseam': '32', 'thigh': '21', 'calf': '14.5',
        }),
      );
}

List<MeasurementField> _defaultFields({Map<String, String> values = const {}}) => [
  MeasurementField(key: 'chest',       label: 'Chest',        hint: 'e.g. 40',   icon: '📏', value: values['chest'] ?? ''),
  MeasurementField(key: 'waist',       label: 'Waist',        hint: 'e.g. 34',   icon: '📐', value: values['waist'] ?? ''),
  MeasurementField(key: 'hip',         label: 'Hip',          hint: 'e.g. 38',   icon: '📏', value: values['hip'] ?? ''),
  MeasurementField(key: 'shoulder',    label: 'Shoulder',     hint: 'e.g. 18',   icon: '📐', value: values['shoulder'] ?? ''),
  MeasurementField(key: 'sleeve',      label: 'Sleeve Length',hint: 'e.g. 25',   icon: '📏', value: values['sleeve'] ?? ''),
  MeasurementField(key: 'neck',        label: 'Neck',         hint: 'e.g. 15',   icon: '📐', value: values['neck'] ?? ''),
  MeasurementField(key: 'shirt_length',label: 'Shirt Length', hint: 'e.g. 29',   icon: '📏', value: values['shirt_length'] ?? ''),
  MeasurementField(key: 'inseam',      label: 'Inseam',       hint: 'e.g. 31',   icon: '📐', value: values['inseam'] ?? ''),
  MeasurementField(key: 'thigh',       label: 'Thigh',        hint: 'e.g. 22',   icon: '📏', value: values['thigh'] ?? ''),
  MeasurementField(key: 'calf',        label: 'Calf',         hint: 'e.g. 15',   icon: '📐', value: values['calf'] ?? ''),
];

// ─────────────────────────────────────────────
// Entry point — used from Home quick action
// ─────────────────────────────────────────────
class AddMeasurementsPage extends StatefulWidget {
  const AddMeasurementsPage({super.key});
  @override
  State<AddMeasurementsPage> createState() => _AddMeasurementsPageState();
}

class _AddMeasurementsPageState extends State<AddMeasurementsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<MeasurementProfile> _profiles = [
    MeasurementProfile.casual(),
    MeasurementProfile.formal(),
  ];

  int _activeProfile = 0;
  String _unit = 'inches'; // or 'cm'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _profiles.length + 1, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index < _profiles.length) {
        setState(() => _activeProfile = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addProfile(String name) {
    setState(() {
      _profiles.add(MeasurementProfile.empty(name));
      _tabController = TabController(length: _profiles.length + 1, vsync: this);
      _tabController.animateTo(_profiles.length - 1);
      _activeProfile = _profiles.length - 1;
    });
  }

  void _deleteProfile(int index) {
    if (_profiles.length <= 1) return;
    setState(() {
      _profiles.removeAt(index);
      _tabController = TabController(length: _profiles.length + 1, vsync: this);
      _activeProfile = 0;
      _tabController.animateTo(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.thread,
        title: const Text('Measurements'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Unit toggle
          GestureDetector(
            onTap: () => setState(() => _unit = _unit == 'inches' ? 'cm' : 'inches'),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 0.5),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('in', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _unit == 'inches' ? AppColors.gold : Colors.white38)),
                const Text(' / ', style: TextStyle(fontSize: 11, color: Colors.white30)),
                Text('cm', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _unit == 'cm' ? AppColors.gold : Colors.white38)),
              ]),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabAlignment: TabAlignment.start,
          tabs: [
            ..._profiles.map((p) => Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(p.name),
                const SizedBox(width: 6),
                _CompletionDot(filled: p.filledCount, total: p.fields.length),
              ]),
            )),
            const Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.add, size: 16),
              SizedBox(width: 4),
              Text('New Profile'),
            ])),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ..._profiles.asMap().entries.map((e) => _ProfilePage(
            profile: e.value,
            unit: _unit,
            profileIndex: e.key,
            totalProfiles: _profiles.length,
            onChanged: () => setState(() {}),
            onDelete: () => _deleteProfile(e.key),
          )),
          _NewProfilePage(onAdd: _addProfile),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Per-profile page
// ─────────────────────────────────────────────
class _ProfilePage extends StatefulWidget {
  final MeasurementProfile profile;
  final String unit;
  final int profileIndex;
  final int totalProfiles;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const _ProfilePage({
    required this.profile,
    required this.unit,
    required this.profileIndex,
    required this.totalProfiles,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  late final Map<String, TextEditingController> _ctrls;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _ctrls = {
      for (final f in widget.profile.fields)
        f.key: TextEditingController(text: f.value)
    };
    for (final entry in _ctrls.entries) {
      entry.value.addListener(() {
        final field = widget.profile.fields.firstWhere((f) => f.key == entry.key);
        field.value = entry.value.text;
        widget.onChanged();
        if (_saved) setState(() => _saved = false);
      });
    }
  }

  @override
  void dispose() {
    _ctrls.values.forEach((c) => c.dispose());
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${widget.profile.name} saved!'),
      backgroundColor: AppColors.badgeGreenText,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ));
  }

  void _requestVisit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 30),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Request Tailor Visit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.thread)),
          const SizedBox(height: 6),
          const Text('A tailor will come to your address and take your measurements in person.', style: TextStyle(fontSize: 13, color: AppColors.taupe, height: 1.5)),
          const SizedBox(height: 16),
          const Text('Preferred Date', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          const TextField(decoration: InputDecoration(hintText: 'Select a date…', prefixIcon: Icon(Icons.calendar_today_outlined, size: 16))),
          const SizedBox(height: 10),
          const Text('Time Preference', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          const TextField(decoration: InputDecoration(hintText: 'e.g. Morning, Afternoon…')),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Confirm Visit'))),
            const SizedBox(width: 10),
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ]),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filled = widget.profile.filledCount;
    final total = widget.profile.fields.length;
    final progress = filled / total;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Completion banner ───────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: progress == 1.0 ? AppColors.badgeGreenBg : AppColors.badgeAmberBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (progress == 1.0 ? AppColors.badgeGreenText : AppColors.badgeAmberText).withOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(
                progress == 1.0 ? Icons.check_circle_outline : Icons.info_outline,
                size: 18,
                color: progress == 1.0 ? AppColors.badgeGreenText : AppColors.badgeAmberText,
              ),
              const SizedBox(width: 8),
              Text(
                progress == 1.0 ? 'Profile complete!' : '$filled of $total measurements filled',
                style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: progress == 1.0 ? AppColors.badgeGreenText : AppColors.badgeAmberText,
                ),
              ),
              const Spacer(),
              Text('${(progress * 100).round()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: progress == 1.0 ? AppColors.badgeGreenText : AppColors.badgeAmberText)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0 ? AppColors.badgeGreenText : AppColors.badgeAmberText,
                ),
              ),
            ),
          ]),
        ),

        // ── Body diagram card ───────────────────────────────
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Simple body silhouette SVG-like widget
            _BodyDiagram(profile: widget.profile),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.profile.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.thread)),
              const SizedBox(height: 2),
              Text('Unit: ${widget.unit}', style: const TextStyle(fontSize: 12, color: AppColors.taupe)),
              const SizedBox(height: 12),
              ..._quickStats(widget.profile),
            ])),
          ]),
        ),

        // ── Upper body section ──────────────────────────────
        const SizedBox(height: 4),
        _SectionHeader(title: 'Upper Body', icon: Icons.person_outline),
        _MeasurementGrid(
          fields: widget.profile.fields.where((f) => ['chest', 'waist', 'shoulder', 'neck', 'sleeve', 'shirt_length'].contains(f.key)).toList(),
          controllers: _ctrls,
          unit: widget.unit,
        ),

        // ── Lower body section ──────────────────────────────
        const SizedBox(height: 8),
        _SectionHeader(title: 'Lower Body', icon: Icons.accessibility_new),
        _MeasurementGrid(
          fields: widget.profile.fields.where((f) => ['hip', 'inseam', 'thigh', 'calf'].contains(f.key)).toList(),
          controllers: _ctrls,
          unit: widget.unit,
        ),

        const SizedBox(height: 20),

        // ── Action buttons ──────────────────────────────────
        Row(children: [
          Expanded(child: ElevatedButton.icon(
            onPressed: _save,
            icon: Icon(_saved ? Icons.check : Icons.save_outlined, size: 16),
            label: Text(_saved ? 'Saved!' : 'Save Measurements'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _saved ? AppColors.badgeGreenText : AppColors.thread,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          )),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, size: 16),
            label: const Text('Upload Photo'),
          )),
          const SizedBox(width: 10),
          Expanded(child: OutlinedButton.icon(
            onPressed: _requestVisit,
            icon: const Icon(Icons.person_pin_circle_outlined, size: 16),
            label: const Text('Tailor Visit'),
          )),
        ]),

        // ── Danger zone ─────────────────────────────────────
        if (widget.totalProfiles > 1) ...[
          const SizedBox(height: 20),
          const AppDivider(),
          Center(child: TextButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.badgeRedText),
            label: const Text('Delete Profile', style: TextStyle(color: AppColors.badgeRedText, fontSize: 13)),
          )),
        ],
        const SizedBox(height: 20),
      ]),
    );
  }

  List<Widget> _quickStats(MeasurementProfile profile) {
    final highlights = ['chest', 'waist', 'shoulder'];
    return highlights.map((key) {
      final f = profile.fields.firstWhere((f) => f.key == key, orElse: () => MeasurementField(key: key, label: key, hint: '', icon: ''));
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(children: [
          Expanded(child: Text(f.label, style: const TextStyle(fontSize: 12, color: AppColors.taupe))),
          Text(
            f.value.isEmpty ? '—' : '${f.value} ${widget.unit == 'inches' ? 'in' : 'cm'}',
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: f.value.isEmpty ? AppColors.taupe : AppColors.silk,
            ),
          ),
        ]),
      );
    }).toList();
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Profile?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.thread)),
        content: Text('Are you sure you want to delete "${widget.profile.name}"? This cannot be undone.', style: const TextStyle(fontSize: 13, color: AppColors.taupe)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); widget.onDelete(); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.badgeRedText),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Measurement input grid
// ─────────────────────────────────────────────
class _MeasurementGrid extends StatelessWidget {
  final List<MeasurementField> fields;
  final Map<String, TextEditingController> controllers;
  final String unit;

  const _MeasurementGrid({required this.fields, required this.controllers, required this.unit});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemCount: fields.length,
      itemBuilder: (_, i) => _MeasurementInputTile(
        field: fields[i],
        controller: controllers[fields[i].key]!,
        unit: unit,
      ),
    );
  }
}

class _MeasurementInputTile extends StatefulWidget {
  final MeasurementField field;
  final TextEditingController controller;
  final String unit;

  const _MeasurementInputTile({required this.field, required this.controller, required this.unit});

  @override
  State<_MeasurementInputTile> createState() => _MeasurementInputTileState();
}

class _MeasurementInputTileState extends State<_MeasurementInputTile> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.controller.text.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _focused
              ? AppColors.gold
              : hasValue
                  ? AppColors.silk.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
          width: _focused ? 1.5 : 0.5,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(widget.field.label, style: const TextStyle(fontSize: 11, color: AppColors.taupe, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Row(children: [
          Expanded(
            child: Focus(
              onFocusChange: (v) => setState(() => _focused = v),
              child: TextFormField(
                controller: widget.controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.thread),
                decoration: InputDecoration(
                  hintText: widget.field.hint,
                  hintStyle: const TextStyle(color: AppColors.taupe, fontSize: 13, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          Text(widget.unit == 'inches' ? 'in' : 'cm', style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Body diagram widget (canvas-drawn silhouette)
// ─────────────────────────────────────────────
class _BodyDiagram extends StatelessWidget {
  final MeasurementProfile profile;
  const _BodyDiagram({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 160,
      child: CustomPaint(
        painter: _BodyPainter(profile: profile),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  final MeasurementProfile profile;
  _BodyPainter({required this.profile});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..color = AppColors.sand
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = AppColors.taupe.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final highlightPaint = Paint()
      ..color = AppColors.gold.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    // Head
    final headCenter = Offset(w / 2, h * 0.07);
    canvas.drawCircle(headCenter, w * 0.14, bodyPaint);
    canvas.drawCircle(headCenter, w * 0.14, outlinePaint);

    // Neck
    final neckRect = Rect.fromCenter(center: Offset(w / 2, h * 0.15), width: w * 0.16, height: h * 0.05);
    canvas.drawRect(neckRect, bodyPaint);

    // Shoulders (trapezoid)
    final shoulderPath = Path()
      ..moveTo(w * 0.12, h * 0.2)
      ..lineTo(w * 0.88, h * 0.2)
      ..lineTo(w * 0.78, h * 0.28)
      ..lineTo(w * 0.22, h * 0.28)
      ..close();
    canvas.drawPath(shoulderPath, bodyPaint);
    canvas.drawPath(shoulderPath, outlinePaint);

    // Torso
    final torsoPath = Path()
      ..moveTo(w * 0.22, h * 0.28)
      ..lineTo(w * 0.78, h * 0.28)
      ..lineTo(w * 0.74, h * 0.52)
      ..lineTo(w * 0.26, h * 0.52)
      ..close();
    canvas.drawPath(torsoPath, bodyPaint);
    canvas.drawPath(torsoPath, outlinePaint);

    // Chest highlight if filled
    if (profile.fields.firstWhere((f) => f.key == 'chest').value.isNotEmpty) {
      final chestPath = Path()
        ..moveTo(w * 0.24, h * 0.29)
        ..lineTo(w * 0.76, h * 0.29)
        ..lineTo(w * 0.72, h * 0.37)
        ..lineTo(w * 0.28, h * 0.37)
        ..close();
      canvas.drawPath(chestPath, highlightPaint);
    }

    // Waist highlight
    if (profile.fields.firstWhere((f) => f.key == 'waist').value.isNotEmpty) {
      final waistPath = Path()
        ..moveTo(w * 0.26, h * 0.44)
        ..lineTo(w * 0.74, h * 0.44)
        ..lineTo(w * 0.74, h * 0.52)
        ..lineTo(w * 0.26, h * 0.52)
        ..close();
      canvas.drawPath(waistPath, highlightPaint);
    }

    // Hip/pelvis
    final hipPath = Path()
      ..moveTo(w * 0.26, h * 0.52)
      ..lineTo(w * 0.74, h * 0.52)
      ..lineTo(w * 0.78, h * 0.62)
      ..lineTo(w * 0.22, h * 0.62)
      ..close();
    canvas.drawPath(hipPath, bodyPaint);
    canvas.drawPath(hipPath, outlinePaint);

    if (profile.fields.firstWhere((f) => f.key == 'hip').value.isNotEmpty) {
      canvas.drawPath(hipPath, highlightPaint);
    }

    // Left leg
    final leftLeg = Path()
      ..moveTo(w * 0.22, h * 0.62)
      ..lineTo(w * 0.48, h * 0.62)
      ..lineTo(w * 0.44, h * 1.0)
      ..lineTo(w * 0.18, h * 1.0)
      ..close();
    canvas.drawPath(leftLeg, bodyPaint);
    canvas.drawPath(leftLeg, outlinePaint);

    // Right leg
    final rightLeg = Path()
      ..moveTo(w * 0.52, h * 0.62)
      ..lineTo(w * 0.78, h * 0.62)
      ..lineTo(w * 0.82, h * 1.0)
      ..lineTo(w * 0.56, h * 1.0)
      ..close();
    canvas.drawPath(rightLeg, bodyPaint);
    canvas.drawPath(rightLeg, outlinePaint);

    // Arms
    final leftArm = Path()
      ..moveTo(w * 0.12, h * 0.2)
      ..lineTo(w * 0.22, h * 0.28)
      ..lineTo(w * 0.14, h * 0.52)
      ..lineTo(w * 0.04, h * 0.44)
      ..close();
    canvas.drawPath(leftArm, bodyPaint);
    canvas.drawPath(leftArm, outlinePaint);

    final rightArm = Path()
      ..moveTo(w * 0.88, h * 0.2)
      ..lineTo(w * 0.78, h * 0.28)
      ..lineTo(w * 0.86, h * 0.52)
      ..lineTo(w * 0.96, h * 0.44)
      ..close();
    canvas.drawPath(rightArm, bodyPaint);
    canvas.drawPath(rightArm, outlinePaint);
  }

  @override
  bool shouldRepaint(_BodyPainter old) => old.profile != profile;
}

// ─────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.thread, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 14, color: AppColors.gold),
        ),
        const SizedBox(width: 10),
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.thread, letterSpacing: 1.2)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// New profile creation page
// ─────────────────────────────────────────────
class _NewProfilePage extends StatefulWidget {
  final ValueChanged<String> onAdd;
  const _NewProfilePage({required this.onAdd});
  @override
  State<_NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<_NewProfilePage> {
  final _nameCtrl = TextEditingController();
  final _templates = ['Wedding Fit', 'Athletic Cut', 'Office Slim', 'Ethnic Fit', 'Plus Fit', 'Summer Casual'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Illustration
        Center(
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.person_add_outlined, size: 40, color: AppColors.silk),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text('Create New Profile', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.thread)),
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text('Save different fits for different occasions', style: TextStyle(fontSize: 13, color: AppColors.taupe), textAlign: TextAlign.center),
        ),
        const SizedBox(height: 24),
        const Text('Profile Name', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: _nameCtrl,
          style: const TextStyle(fontSize: 14, color: AppColors.thread),
          decoration: const InputDecoration(hintText: 'e.g. Wedding Fit, Athletic Cut…'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        const Text('Or pick a template:', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _templates.map((t) => GestureDetector(
            onTap: () { setState(() => _nameCtrl.text = t); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _nameCtrl.text == t ? AppColors.thread : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _nameCtrl.text == t ? AppColors.thread : Colors.black.withOpacity(0.15), width: 0.5),
              ),
              child: Text(t, style: TextStyle(fontSize: 13, color: _nameCtrl.text == t ? AppColors.cream : AppColors.taupe)),
            ),
          )).toList(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _nameCtrl.text.trim().isEmpty ? null : () => widget.onAdd(_nameCtrl.text.trim()),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create Profile'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Completion dot badge in tab
// ─────────────────────────────────────────────
class _CompletionDot extends StatelessWidget {
  final int filled;
  final int total;
  const _CompletionDot({required this.filled, required this.total});

  @override
  Widget build(BuildContext context) {
    final complete = filled == total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: complete ? AppColors.badgeGreenText.withOpacity(0.2) : AppColors.badgeAmberText.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        complete ? '✓' : '$filled/$total',
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: complete ? AppColors.badgeGreenText : AppColors.badgeAmberText),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Also export the old MeasurementsScreen name
// so existing nav references don't break
// ─────────────────────────────────────────────
class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});
  @override
  Widget build(BuildContext context) => const AddMeasurementsPage();
}
