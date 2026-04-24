import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kGreen = Color(0xFF4CAF50);
const _kAmber = Color(0xFFFFB300);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

// ─────────────────────────────────────────────
// Data model (unchanged)
// ─────────────────────────────────────────────
class MeasurementField {
  final String key, label, hint, icon;
  String value;
  MeasurementField({required this.key, required this.label, required this.hint, required this.icon, this.value = ''});
  MeasurementField copyWith({String? value}) => MeasurementField(key: key, label: label, hint: hint, icon: icon, value: value ?? this.value);
}

class MeasurementProfile {
  final String id;
  String name;
  final List<MeasurementField> fields;
  MeasurementProfile({required this.id, required this.name, required this.fields});
  bool get isComplete => fields.every((f) => f.value.isNotEmpty);
  int get filledCount => fields.where((f) => f.value.isNotEmpty).length;
  factory MeasurementProfile.empty(String name) => MeasurementProfile(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, fields: _defaultFields());
  factory MeasurementProfile.casual() => MeasurementProfile(id: 'casual', name: 'Casual Fit', fields: _defaultFields(values: {'chest': '40', 'waist': '34', 'hip': '38', 'shoulder': '18', 'sleeve': '25', 'neck': '15', 'shirt_length': '29', 'inseam': '31', 'thigh': '22', 'calf': '15'}));
  factory MeasurementProfile.formal() => MeasurementProfile(id: 'formal', name: 'Formal Fit', fields: _defaultFields(values: {'chest': '41', 'waist': '33', 'hip': '39', 'shoulder': '18.5', 'sleeve': '25.5', 'neck': '15.5', 'shirt_length': '30', 'inseam': '32', 'thigh': '21', 'calf': '14.5'}));
}

List<MeasurementField> _defaultFields({Map<String, String> values = const {}}) => [
  MeasurementField(key: 'chest', label: 'Chest', hint: 'e.g. 40', icon: '📏', value: values['chest'] ?? ''),
  MeasurementField(key: 'waist', label: 'Waist', hint: 'e.g. 34', icon: '📐', value: values['waist'] ?? ''),
  MeasurementField(key: 'hip', label: 'Hip', hint: 'e.g. 38', icon: '📏', value: values['hip'] ?? ''),
  MeasurementField(key: 'shoulder', label: 'Shoulder', hint: 'e.g. 18', icon: '📐', value: values['shoulder'] ?? ''),
  MeasurementField(key: 'sleeve', label: 'Sleeve Length', hint: 'e.g. 25', icon: '📏', value: values['sleeve'] ?? ''),
  MeasurementField(key: 'neck', label: 'Neck', hint: 'e.g. 15', icon: '📐', value: values['neck'] ?? ''),
  MeasurementField(key: 'shirt_length', label: 'Shirt Length', hint: 'e.g. 29', icon: '📏', value: values['shirt_length'] ?? ''),
  MeasurementField(key: 'inseam', label: 'Inseam', hint: 'e.g. 31', icon: '📐', value: values['inseam'] ?? ''),
  MeasurementField(key: 'thigh', label: 'Thigh', hint: 'e.g. 22', icon: '📏', value: values['thigh'] ?? ''),
  MeasurementField(key: 'calf', label: 'Calf', hint: 'e.g. 15', icon: '📐', value: values['calf'] ?? ''),
];

// ─────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────
class AddMeasurementsPage extends StatefulWidget {
  const AddMeasurementsPage({super.key});
  @override
  State<AddMeasurementsPage> createState() => _AddMeasurementsPageState();
}

class _AddMeasurementsPageState extends State<AddMeasurementsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<MeasurementProfile> _profiles = [MeasurementProfile.casual(), MeasurementProfile.formal()];
  int _activeProfile = 0;
  String _unit = 'inches';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _profiles.length + 1, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index < _profiles.length) setState(() => _activeProfile = _tabController.index);
    });
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

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
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // Hero image
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Image.network(
              'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200&h=500&fit=crop&q=80',
              fit: BoxFit.cover,
              loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B)),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0, height: 240,
            child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0]))),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
                  child: Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('BODY PROFILE', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                      SizedBox(height: 4),
                      Text('Measurements', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    ]),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _unit = _unit == 'inches' ? 'cm' : 'inches'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _kGold.withOpacity(0.12), borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _kGold.withOpacity(0.4)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('in', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _unit == 'inches' ? _kGold : Colors.white.withOpacity(0.3))),
                          Text(' / ', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.2))),
                          Text('cm', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _unit == 'cm' ? _kGold : Colors.white.withOpacity(0.3))),
                        ]),
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                // Tab bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _kBorder)),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicator: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(12)),
                    labelColor: Colors.black,
                    unselectedLabelColor: _kMuted,
                    labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    dividerColor: Colors.transparent,
                    tabs: [
                      ..._profiles.map((p) => Tab(
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(p.name),
                          const SizedBox(width: 6),
                          _CompletionDot(filled: p.filledCount, total: p.fields.length),
                        ]),
                      )),
                      const Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.add, size: 14),
                        SizedBox(width: 4),
                        Text('New'),
                      ])),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ..._profiles.asMap().entries.map((e) => _ProfilePage(
                        profile: e.value, unit: _unit,
                        profileIndex: e.key, totalProfiles: _profiles.length,
                        onChanged: () => setState(() {}),
                        onDelete: () => _deleteProfile(e.key),
                      )),
                      _NewProfilePage(onAdd: _addProfile),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
  final int profileIndex, totalProfiles;
  final VoidCallback onChanged, onDelete;
  const _ProfilePage({required this.profile, required this.unit, required this.profileIndex, required this.totalProfiles, required this.onChanged, required this.onDelete});
  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  late final Map<String, TextEditingController> _ctrls;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _ctrls = {for (final f in widget.profile.fields) f.key: TextEditingController(text: f.value)};
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
  void dispose() { _ctrls.values.forEach((c) => c.dispose()); super.dispose(); }

  void _save() {
    FocusScope.of(context).unfocus();
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${widget.profile.name} saved!'),
      backgroundColor: _kGreen, behavior: SnackBarBehavior.floating, margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final filled = widget.profile.filledCount;
    final total = widget.profile.fields.length;
    final progress = filled / total;
    final isComplete = progress == 1.0;
    final progressColor = isComplete ? _kGreen : _kAmber;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Progress banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: progressColor.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: progressColor.withOpacity(0.25)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(isComplete ? Icons.check_circle_outline : Icons.info_outline, size: 16, color: progressColor),
              const SizedBox(width: 8),
              Text(isComplete ? 'Profile complete!' : '$filled of $total measurements filled',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: progressColor)),
              const Spacer(),
              Text('${(progress * 100).round()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: progressColor)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: progress, minHeight: 5, backgroundColor: Colors.white.withOpacity(0.08), valueColor: AlwaysStoppedAnimation<Color>(progressColor))),
          ]),
        ),
        const SizedBox(height: 16),

        // Body diagram + quick stats
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _kBorder)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _BodyDiagram(profile: widget.profile),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.profile.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
              Text('Unit: ${widget.unit}', style: const TextStyle(fontSize: 12, color: _kMuted)),
              const SizedBox(height: 12),
              ...['chest', 'waist', 'shoulder'].map((key) {
                final f = widget.profile.fields.firstWhere((f) => f.key == key);
                return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
                  Expanded(child: Text(f.label, style: const TextStyle(fontSize: 12, color: _kMuted))),
                  Text(f.value.isEmpty ? '—' : '${f.value} ${widget.unit == 'inches' ? 'in' : 'cm'}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: f.value.isEmpty ? _kMuted : _kGold)),
                ]));
              }),
            ])),
          ]),
        ),
        const SizedBox(height: 16),

        _SectionHeader(title: 'Upper Body', icon: Icons.person_outline),
        _MeasurementGrid(
          fields: widget.profile.fields.where((f) => ['chest', 'waist', 'shoulder', 'neck', 'sleeve', 'shirt_length'].contains(f.key)).toList(),
          controllers: _ctrls, unit: widget.unit,
        ),
        const SizedBox(height: 12),
        _SectionHeader(title: 'Lower Body', icon: Icons.accessibility_new),
        _MeasurementGrid(
          fields: widget.profile.fields.where((f) => ['hip', 'inseam', 'thigh', 'calf'].contains(f.key)).toList(),
          controllers: _ctrls, unit: widget.unit,
        ),
        const SizedBox(height: 20),

        SizedBox(width: double.infinity, child: ElevatedButton.icon(
          onPressed: _save,
          icon: Icon(_saved ? Icons.check : Icons.save_outlined, size: 16),
          label: Text(_saved ? 'Saved!' : 'Save Measurements', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: _saved ? _kGreen : _kGold, foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
        )),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined, size: 14, color: _kMuted), label: const Text('Upload Photo', style: TextStyle(color: _kMuted, fontSize: 12)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: _kBorder), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          const SizedBox(width: 10),
          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.person_pin_circle_outlined, size: 14, color: _kGold), label: const Text('Tailor Visit', style: TextStyle(color: _kGold, fontSize: 12)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: _kGold.withOpacity(0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
        ]),
        if (widget.totalProfiles > 1) ...[
          const SizedBox(height: 16),
          Divider(color: _kBorder),
          Center(child: TextButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline, size: 14, color: Colors.redAccent),
            label: const Text('Delete Profile', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
          )),
        ],
        const SizedBox(height: 20),
      ]),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: _kCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Delete Profile?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      content: Text('Delete "${widget.profile.name}"? This cannot be undone.', style: const TextStyle(fontSize: 13, color: _kMuted)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: _kMuted))),
        ElevatedButton(onPressed: () { Navigator.pop(context); widget.onDelete(); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Delete')),
      ],
    ));
  }
}

// ─────────────────────────────────────────────
// Measurement grid
// ─────────────────────────────────────────────
class _MeasurementGrid extends StatelessWidget {
  final List<MeasurementField> fields;
  final Map<String, TextEditingController> controllers;
  final String unit;
  const _MeasurementGrid({required this.fields, required this.controllers, required this.unit});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.4),
      itemCount: fields.length,
      itemBuilder: (_, i) => _MeasurementTile(field: fields[i], controller: controllers[fields[i].key]!, unit: unit),
    );
  }
}

class _MeasurementTile extends StatefulWidget {
  final MeasurementField field;
  final TextEditingController controller;
  final String unit;
  const _MeasurementTile({required this.field, required this.controller, required this.unit});
  @override
  State<_MeasurementTile> createState() => _MeasurementTileState();
}

class _MeasurementTileState extends State<_MeasurementTile> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.controller.text.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _kCard, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _focused ? _kGold : hasValue ? _kGold.withOpacity(0.25) : _kBorder, width: _focused ? 1.5 : 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(widget.field.label, style: const TextStyle(fontSize: 10.5, color: _kMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Row(children: [
          Expanded(child: Focus(
            onFocusChange: (v) => setState(() => _focused = v),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.field.hint,
                hintStyle: const TextStyle(color: _kMuted, fontSize: 13, fontWeight: FontWeight.w400),
                border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
              ),
            ),
          )),
          Text(widget.unit == 'inches' ? 'in' : 'cm', style: const TextStyle(fontSize: 10, color: _kMuted)),
        ]),
      ]),
    );
  }
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
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: _kGold.withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: _kGold.withOpacity(0.3))),
          child: Icon(icon, size: 14, color: _kGold)),
        const SizedBox(width: 10),
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.2)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Body diagram (dark-themed)
// ─────────────────────────────────────────────
class _BodyDiagram extends StatelessWidget {
  final MeasurementProfile profile;
  const _BodyDiagram({required this.profile});
  @override
  Widget build(BuildContext context) => SizedBox(width: 90, height: 160, child: CustomPaint(painter: _BodyPainter(profile: profile)));
}

class _BodyPainter extends CustomPainter {
  final MeasurementProfile profile;
  _BodyPainter({required this.profile});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final body = Paint()..color = const Color(0xFF243447)..style = PaintingStyle.fill;
    final outline = Paint()..color = const Color(0xFF4A90E2).withOpacity(0.4)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    final highlight = Paint()..color = _kGold.withOpacity(0.3)..style = PaintingStyle.fill;

    void drawHighlight(Path path, String key) {
      if (profile.fields.firstWhere((f) => f.key == key, orElse: () => MeasurementField(key: '', label: '', hint: '', icon: '')).value.isNotEmpty) {
        canvas.drawPath(path, highlight);
      }
    }

    // Head
    canvas.drawCircle(Offset(w / 2, h * 0.07), w * 0.14, body);
    canvas.drawCircle(Offset(w / 2, h * 0.07), w * 0.14, outline);

    // Shoulders
    final shoulder = Path()..moveTo(w * 0.12, h * 0.2)..lineTo(w * 0.88, h * 0.2)..lineTo(w * 0.78, h * 0.28)..lineTo(w * 0.22, h * 0.28)..close();
    canvas.drawPath(shoulder, body); canvas.drawPath(shoulder, outline);

    // Torso
    final torso = Path()..moveTo(w * 0.22, h * 0.28)..lineTo(w * 0.78, h * 0.28)..lineTo(w * 0.74, h * 0.52)..lineTo(w * 0.26, h * 0.52)..close();
    canvas.drawPath(torso, body); canvas.drawPath(torso, outline);

    final chestPath = Path()..moveTo(w * 0.24, h * 0.29)..lineTo(w * 0.76, h * 0.29)..lineTo(w * 0.72, h * 0.37)..lineTo(w * 0.28, h * 0.37)..close();
    drawHighlight(chestPath, 'chest');
    final waistPath = Path()..moveTo(w * 0.26, h * 0.44)..lineTo(w * 0.74, h * 0.44)..lineTo(w * 0.74, h * 0.52)..lineTo(w * 0.26, h * 0.52)..close();
    drawHighlight(waistPath, 'waist');

    // Hip
    final hip = Path()..moveTo(w * 0.26, h * 0.52)..lineTo(w * 0.74, h * 0.52)..lineTo(w * 0.78, h * 0.62)..lineTo(w * 0.22, h * 0.62)..close();
    canvas.drawPath(hip, body); canvas.drawPath(hip, outline); drawHighlight(hip, 'hip');

    // Legs
    final leftLeg = Path()..moveTo(w * 0.22, h * 0.62)..lineTo(w * 0.48, h * 0.62)..lineTo(w * 0.44, h * 1.0)..lineTo(w * 0.18, h * 1.0)..close();
    canvas.drawPath(leftLeg, body); canvas.drawPath(leftLeg, outline);
    final rightLeg = Path()..moveTo(w * 0.52, h * 0.62)..lineTo(w * 0.78, h * 0.62)..lineTo(w * 0.82, h * 1.0)..lineTo(w * 0.56, h * 1.0)..close();
    canvas.drawPath(rightLeg, body); canvas.drawPath(rightLeg, outline);

    // Arms
    final leftArm = Path()..moveTo(w * 0.12, h * 0.2)..lineTo(w * 0.22, h * 0.28)..lineTo(w * 0.14, h * 0.52)..lineTo(w * 0.04, h * 0.44)..close();
    canvas.drawPath(leftArm, body); canvas.drawPath(leftArm, outline);
    final rightArm = Path()..moveTo(w * 0.88, h * 0.2)..lineTo(w * 0.78, h * 0.28)..lineTo(w * 0.86, h * 0.52)..lineTo(w * 0.96, h * 0.44)..close();
    canvas.drawPath(rightArm, body); canvas.drawPath(rightArm, outline);
  }

  @override
  bool shouldRepaint(_BodyPainter old) => old.profile != profile;
}

// ─────────────────────────────────────────────
// New profile page
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: _kGold.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: _kGold.withOpacity(0.3))),
          child: const Icon(Icons.person_add_outlined, size: 36, color: _kGold),
        )),
        const SizedBox(height: 16),
        const Center(child: Text('Create New Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white))),
        const SizedBox(height: 4),
        const Center(child: Text('Save different fits for different occasions', style: TextStyle(fontSize: 13, color: _kMuted), textAlign: TextAlign.center)),
        const SizedBox(height: 24),
        const Text('Profile Name', style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: _nameCtrl,
          style: const TextStyle(fontSize: 14, color: Colors.white),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'e.g. Wedding Fit, Athletic Cut…', hintStyle: const TextStyle(color: _kMuted),
            filled: true, fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kGold)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
        ),
        const SizedBox(height: 16),
        const Text('Or pick a template:', style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _templates.map((t) => GestureDetector(
          onTap: () => setState(() => _nameCtrl.text = t),
          child: AnimatedContainer(duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _nameCtrl.text == t ? _kGold.withOpacity(0.15) : _kCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _nameCtrl.text == t ? _kGold.withOpacity(0.5) : _kBorder),
            ),
            child: Text(t, style: TextStyle(fontSize: 12, color: _nameCtrl.text == t ? _kGold : _kMuted, fontWeight: _nameCtrl.text == t ? FontWeight.w700 : FontWeight.w400)),
          ),
        )).toList()),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _nameCtrl.text.trim().isEmpty ? null : () => widget.onAdd(_nameCtrl.text.trim()),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Create Profile', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          style: ElevatedButton.styleFrom(backgroundColor: _kGold, foregroundColor: Colors.black, disabledBackgroundColor: _kBorder,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Completion dot
// ─────────────────────────────────────────────
class _CompletionDot extends StatelessWidget {
  final int filled, total;
  const _CompletionDot({required this.filled, required this.total});
  @override
  Widget build(BuildContext context) {
    final complete = filled == total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(color: complete ? _kGreen.withOpacity(0.2) : _kAmber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
      child: Text(complete ? '✓' : '$filled/$total', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: complete ? _kGreen : _kAmber)),
    );
  }
}

// ─────────────────────────────────────────────
// Alias
// ─────────────────────────────────────────────
class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});
  @override
  Widget build(BuildContext context) => const AddMeasurementsPage();
}
