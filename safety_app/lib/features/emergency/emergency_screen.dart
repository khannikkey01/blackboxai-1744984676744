import 'package:flutter/material.dart';
import 'gesture_setup_screen.dart';
import 'contact_setup_screen.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _isGestureSet = false;
  bool _isContactSet = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // TODO: Load settings from SharedPreferences
    setState(() {
      _isGestureSet = false;
      _isContactSet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar.large(
            title: const Text('Emergency Setup'),
            centerTitle: true,
            floating: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Status Card
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Setup Status',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatusItem(
                          context,
                          'Emergency Contact',
                          _isContactSet,
                          'Set up your emergency contacts',
                          Icons.contact_phone_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildStatusItem(
                          context,
                          'Emergency Gesture',
                          _isGestureSet,
                          'Configure your emergency gesture',
                          Icons.gesture,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Quick Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Contact Setup Button
                _buildActionButton(
                  context,
                  'Set Up Emergency Contacts',
                  'Add trusted contacts who will be notified in case of emergency',
                  Icons.person_add_outlined,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ContactSetupScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                // Gesture Setup Button
                _buildActionButton(
                  context,
                  'Configure Emergency Gesture',
                  'Set up a custom gesture pattern for quick emergency alerts',
                  Icons.gesture,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GestureSetupScreen(),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                // Help Text
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Complete both setups to enable emergency features',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (_isContactSet && _isGestureSet)
            ? () {
                // TODO: Test emergency feature
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Testing emergency features...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            : null,
        icon: const Icon(Icons.warning_amber_rounded),
        label: const Text('Test Emergency'),
        backgroundColor: (_isContactSet && _isGestureSet)
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String title,
    bool isSet,
    String description,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSet
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSet
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Icon(
          isSet ? Icons.check_circle : Icons.warning,
          color: isSet
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
