import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

class _Profile {
  final String name;
  final Map<String, String> measurements;
  _Profile({required this.name, required this.measurements});
}

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});
  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _editMode = false;

  final List<_Profile> _profiles = [
    _Profile(name: 'Casual Fit', measurements: {
      'Chest': '40 in',
      'Waist': '34 in',
      'Shoulder': '18 in',
      'Shirt Length': '29 in',
      'Inseam': '31 in',
      'Hip': '38 in',
    }),
    _Profile(name: 'Formal Fit', measurements: {
      'Chest': '41 in',
      'Waist': '33 in',
      'Shoulder': '18.5 in',
      'Shirt Length': '30 in',
      'Inseam': '32 in',
      'Hip': '39 in',
    }),
  ];

  final _controllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _profiles.length + 1, vsync: this);
    for (final key in _profiles.first.measurements.keys) {
      _controllers[key] = TextEditingController(text: _profiles.first.measurements[key]);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Measurements'),
        backgroundColor: AppColors.thread,
        actions: [
          TextButton(
            onPressed: () => setState(() => _editMode = !_editMode),
            child: Text(_editMode ? 'Done' : 'Edit', style: const TextStyle(color: AppColors.gold, fontSize: 14)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: [
            ..._profiles.map((p) => Tab(text: p.name)),
            const Tab(icon: Icon(Icons.add, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ..._profiles.map((p) => _ProfileTab(profile: p, editMode: _editMode)),
          _NewProfileTab(onAdd: (name) {
            setState(() {
              _profiles.add(_Profile(name: name, measurements: {'Chest': '', 'Waist': '', 'Shoulder': '', 'Shirt Length': '', 'Inseam': '', 'Hip': ''}));
              _tabController = TabController(length: _profiles.length + 1, vsync: this);
            });
          }),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final _Profile profile;
  final bool editMode;
  const _ProfileTab({required this.profile, required this.editMode});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppCard(
          child: Column(
            children: profile.measurements.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: Text(e.key, style: const TextStyle(fontSize: 13, color: AppColors.thread))),
                    if (editMode)
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          initialValue: e.value,
                          style: const TextStyle(fontSize: 13, color: AppColors.silk),
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                        ),
                      )
                    else
                      Text(e.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.silk)),
                    const Divider(),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, size: 16),
            label: const Text('Upload Image'),
          ),
          OutlinedButton.icon(
            onPressed: () => _requestVisit(context),
            icon: const Icon(Icons.person_pin_circle_outlined, size: 16),
            label: const Text('Request Tailor Visit'),
          ),
        ]),
      ]),
    );
  }

  void _requestVisit(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Request Tailor Visit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.thread)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('A tailor will visit your address to take measurements.', style: TextStyle(fontSize: 13, color: AppColors.taupe)),
          SizedBox(height: 12),
          Text('Preferred Date', style: TextStyle(fontSize: 12, color: AppColors.taupe)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Confirm')),
        ],
      ),
    );
  }
}

class _NewProfileTab extends StatefulWidget {
  final ValueChanged<String> onAdd;
  const _NewProfileTab({required this.onAdd});
  @override
  State<_NewProfileTab> createState() => _NewProfileTabState();
}

class _NewProfileTabState extends State<_NewProfileTab> {
  final _nameCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionLabel('New Measurement Profile'),
        const SizedBox(height: 4),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'e.g. Wedding Fit, Athletic Cut…', labelText: 'Profile Name')),
        const SizedBox(height: 20),
        const Text('Measurements will be empty — you can fill them after creating.', style: TextStyle(fontSize: 13, color: AppColors.taupe)),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () { if (_nameCtrl.text.isNotEmpty) widget.onAdd(_nameCtrl.text.trim()); },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Create Profile'),
        ),
      ]),
    );
  }
}
