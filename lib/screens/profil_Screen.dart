import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //TODO: 1. Deklarasikan variabel yang di tentukan
  bool isSigneIn = true;
  String fullName ='';
  String userName = '';
  int favoriteCandiCount= 0;
  late Color iconColor;

  void signIn(){
    // setState(() {
    // isSigneIn = true;
    // fullName ='Budi Santoso';
    // userName = 'budi';
    // favoriteCandiCount= 3;
    // });
    Navigator.pushNamed(context, '/signin');

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple.shade200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // TODO: 2. buat bagian Profile yang berisi gambar profil
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200 - 50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepPurple, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/placeholder_image.png'),
                          ),
                        ),
                        if(isSigneIn)
                          IconButton(onPressed: (){},
                              icon: Icon(Icons.camera_alt, color: Colors.deepPurple[50],))
                      ],
                    ),
                  ),
                )
                // TODO: 3. Buat bagian profilnya yang berisi info profil
                // TODO : 4. Buat bagian ProfileAction yang berisi TextButton sign in/out
              ],
            ),
          )
        ],
      ),
    );
  }
}