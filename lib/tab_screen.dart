// Komponen Paket
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Setingan TabMenu
class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4 - Mobile Apps',
           style: TextStyle(
      color: Colors.white, // Ubah warna teks judul
      fontSize: 18,
    ),),
          backgroundColor: const Color.fromARGB(255, 72, 119, 158),
        
           // Mengubah warna AppBar
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color:  const Color.fromARGB(255, 72, 119, 158), // Mengubah warna latar belakang TabBar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
 
          ),
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Beranda'),
              Tab(icon: Icon(Icons.group), text: 'Siswa'), // Mengubah ikon
              Tab(icon: Icon(Icons.account_circle), text: 'Profile'), // Mengubah ikon
            ],
            labelColor: Colors.white, // Warna label ketika dipilih
            unselectedLabelColor: Colors.white70, // Warna label ketika tidak dipilih
           
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
// Layout untuk Tab Beranda
class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school_rounded, 'label': 'School'},
    {'icon': Icons.book, 'label': 'Courses'},
    {'icon': Icons.event, 'label': 'Events'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
    {'icon': Icons.assignment, 'label': 'Assignments'},
    {'icon': Icons.chat, 'label': 'Chat'},
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.help, 'label': 'Help'},
    {'icon': Icons.map, 'label': 'Map'},
    {'icon': Icons.calendar_today, 'label': 'Calendar'},
    {'icon': Icons.contact_phone, 'label': 'Contact'},
    {'icon': Icons.info, 'label': 'Info'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items per row
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              print('${item['label']} tapped');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], size: 40.0, color: Colors.blue.shade700),
                  SizedBox(height: 10.0),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// Layout untuk Tab User
class UsersTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: const Color.fromARGB(255, 72, 119, 158),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/person_image.jpg'),
                      radius: 30.0,
                    ),
                    title: Text(
                      '${user.firstName} ${user.email}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue.shade700),
                    onTap: () {
                      // Handle tap event, e.g., navigate to user detail page
                      print('${user.firstName} tapped');
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}


// Layout untuk Tab Profil
class ProfilTab extends StatefulWidget {
  @override
  _ProfilTabState createState() => _ProfilTabState();
}

class _ProfilTabState extends State<ProfilTab> {
  String fullName = 'John Doe'; // Initial name

  void _editName(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: fullName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Nama'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  fullName = nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/mika.jpg'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                fullName,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Email: email@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey[600],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Biodata',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.blueGrey[700]),
                title: Text('Nama Lengkap'),
                subtitle: Text(fullName),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.map, color: Colors.blueGrey[700]),
                title: Text('Tempat Lahir'),
                subtitle: Text('Bogor'),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.cake, color: Colors.blueGrey[700]),
                title: Text('Tanggal Lahir'),
                subtitle: Text('1990-01-01'),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.edit, color: Colors.blueGrey[700]),
                title: Text('Edit Nama'),
                onTap: () => _editName(context), // Add this line
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              label: Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {
                // Handle logout action
              },
            ),
            SizedBox(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: Colors.blueGrey[700]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.settings, color: Colors.blueGrey[700]),
              label: Text(
                'Profile Setting',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
              ),
              onPressed: () {
                // Handle profile settings action
              },
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  final String firstName;
  final String email;
  User({required this.firstName, required this.email});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}
