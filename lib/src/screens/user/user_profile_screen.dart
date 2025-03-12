import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  // final String phone;
  final String profileImage;

  const UserProfileScreen({
    Key? key,
    required this.name,
    required this.email,
    // required this.phone,
    this.profileImage =
        "https://www.google.com/imgres?q=userprofile%20withot&imgurl=https%3A%2F%2Fmedia.istockphoto.com%2Fid%2F1495088043%2Fvector%2Fuser-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg%3Fs%3D170667a%26w%3D0%26k%3D20%26c%3DLPUo_WZjbXXNnF6ok4uQr8I_Zj6WUVnH_FpREg21qaY%3D&imgrefurl=https%3A%2F%2Fwww.istockphoto.com%2Fvector%2Fuser-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-gm1495088043-518213332&docid=Ge5jDkH-lIKunM&tbnid=J-dC_FvdEV4umM&vet=12ahUKEwi0rYDeg4SMAxV_RaQEHXDcJocQM3oECBkQAA..i&w=416&h=416&hcb=2&ved=2ahUKEwi0rYDeg4SMAxV_RaQEHXDcJocQM3oECBkQAA",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(height: 16),

            // User Details
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildListTile(Icons.person, "Name", name),
                  _buildListTile(Icons.email, "Email", email),
                  // _buildListTile(Icons.phone, "Phone", phone),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Edit Profile Screen
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a ListTile
  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
