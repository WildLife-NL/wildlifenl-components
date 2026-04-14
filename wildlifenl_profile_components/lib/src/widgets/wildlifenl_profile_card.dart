import 'package:flutter/material.dart';

/// Reusable profile card component for the WildLifeNL ecosystem.
///
/// This widget focuses on UI only and exposes callbacks/state to the host app.
class WildLifeNLProfileCard extends StatelessWidget {
  const WildLifeNLProfileCard({
    super.key,
    required this.userName,
    required this.email,
    required this.isLoadingProfile,
    required this.isLocationTrackingEnabled,
    required this.notificationsEnabled,
    required this.version,
    required this.onEditProfile,
    required this.onLocationToggle,
    required this.onNotificationsToggle,
    required this.onLogout,
    required this.onDeleteAccount,
    this.primaryColor = const Color(0xFF2D5A39),
    this.destructiveBackgroundColor = const Color(0xFFFFE6E8),
    this.destructiveForegroundColor = const Color(0xFFB71C1C),
  });

  final String userName;
  final String email;
  final bool isLoadingProfile;
  final bool isLocationTrackingEnabled;
  final bool notificationsEnabled;
  final String version;
  final VoidCallback onEditProfile;
  final ValueChanged<bool> onLocationToggle;
  final ValueChanged<bool> onNotificationsToggle;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;
  final Color primaryColor;
  final Color destructiveBackgroundColor;
  final Color destructiveForegroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isLoadingProfile ? '...' : email,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: isLoadingProfile ? null : onEditProfile,
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text('Profiel Bewerken'),
            ),
            const SizedBox(height: 18),
            Text(
              'Voorkeuren',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    title: Text(
                      'Locatie delen',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    value: isLocationTrackingEnabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: primaryColor,
                    onChanged: onLocationToggle,
                  ),
                  Divider(height: 1, color: Colors.grey.shade300),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    title: Text(
                      'Meldingen',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    value: notificationsEnabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: primaryColor,
                    onChanged: onNotificationsToggle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              version.isEmpty ? '' : 'App Version: V$version',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: onLogout,
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text('Uitloggen'),
            ),
            const SizedBox(height: 12),
            Text(
              'Account verwijderen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Je gegevens gaan permanent verloren; dit kan niet ongedaan worden.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: onDeleteAccount,
              style: FilledButton.styleFrom(
                backgroundColor: destructiveBackgroundColor,
                foregroundColor: destructiveForegroundColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text(
                'Account verwijderen',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
