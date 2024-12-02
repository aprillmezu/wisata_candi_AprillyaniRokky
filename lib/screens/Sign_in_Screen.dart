import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // TODO: 1. Deklarasikan variabel
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _isSignedIn = false;
  bool _obscurePassword = true;

  Future<Map<String, String>> retrieveAndDecryptDataFromPrefs(
      Future<SharedPreferences> prefs,
      ) async {
    final sharedPreferences = await prefs;
    final encryptedUsername = sharedPreferences.getSring('username') ?? '';
    final encryptedPassword = sharedPreferences.getSring('password') ?? '';
    final keyString = sharedPreferences.getSring('key') ?? '';
    final ivString = sharedPreferences.getSring('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

    // Mengembalikan data terdekripsi
    return {
      'username': decryptedUsername,
      'password': decryptedPassword,
    };
  }

  void _signIn() async {
    try {
      final Future<SharedPreferences> prefsFuture =
      SharedPreferences.getInstance();
      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();
      print('Sign in attempt');

      if (username.isNotEmpty && password.isNotEmpty) {
        final SharedPreferences prefs = await prefsFuture;
        final data = await retrieveAndDecryptDataFromPrefs(
            prefsFuture); //hanya prefs jika dimateri
        if (data.isNotEmpty) {
          final decryptedUsername = data['username'];
          final decryptedPassword = data['password'];

          if (username == decryptedUsername && password == decryptedPassword) {
            setState(() {
              _errorText = '';
              _isSignedIn = true;
              prefs.getBool('isSignedIn', true);
            });

            // Pemanggilan untuk menghapus halaman dalam tumpukan navigasi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });

            // Sign in berhasil, navigasikan ke Layar Utama
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/');
            });
            print('Sign in succeeded');
          } else {
            setState(() {
              _errorText = 'Nama pengguna atau kata sandi salah.';
            });
            print('Username or password is incorrect');
          }
        } else {
          setState(() {
            _errorText =
            'Pengguna belum terdaftar, Silahkan daftar terlebih dahulu.';
          });
          print('Username or password cannot be empty');
        }
      } else {
        setState(() {
          _errorText = 'Nama Pengguna dan kata sandi harus diisi.';
        });
        print('Username and password must be filled');
      }
    } catch (e) {
      setState(() {
        _errorText = 'An error occurred: $e';
      });
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 2. Pasang AppBar
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      // TODO: 3. Pasang Body
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                // TODO: 4. Atur mainAxisAlignment dan crossAxisAlignment
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TODO: 5. Pasang TextFormField Nama Pengguna
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Nama Pengguna",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // TODO: 6. Pasang TextFormField Kata Sandi
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Kata Sandi",
                      errorText: _errorText.isNotEmpty ? _errorText : null,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  // TODO: 7. Pasang ElevatedButton Sign In
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign In'),
                  ),
                  // TODO: 8. Pasang RichText Sign Up
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Daftar disini.',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/signup');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SharedPreferences {
  getSring(String s) {}

  static getInstance() {}

  getBool(String s, bool favoriteStatus) {}
}


// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SignInScreen extends StatefulWidget {
//   SignInScreen({super.key});
//
//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
//   // TODO 1:. Deklarasikan variabel
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordCintroller = TextEditingController();
//   late String _errorText ='';
//   late bool _isSignnedIn = false;
//   bool _obscurePassword = true;
//
//   void _signIn()async{
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String savedUsername = prefs.getString('username')?? '';
//     final String savedPassword = prefs.getString('password')?? '';
//     final String enteredUsername = _usernameController.text.trim();
//     final String enteredPassword = _passwordCintroller.text.trim();
//
//     if (enteredUsername == savedUsername && enteredPassword == savedPassword){
//       setState(() {
//         _errorText = "";
//         _isSignnedIn = true;
//         prefs.setBool('isSignnedIn', true);
//       });
//       //   pemanggilan untuk menghapus semua halaman dalam tumpulkan navigasi
//       WidgetsBinding.instance.addPostFrameCallback((_){
//         Navigator.of(context).popUntil((route)=>route.isFirst);
//       });
//       //   sign in berhasil, navigasi ke layar utama
//       WidgetsBinding.instance.addPostFrameCallback((_){
//         Navigator.pushReplacementNamed(context, '/');
//       });
//
//     }
//     if(savedUsername.isEmpty || savedPassword.isEmpty){
//       setState(() {
//         _errorText = 'Pengguna belum terdaftar. silakan daftar terlebih dahulu';
//       });
//     }
//
//     else {
//       setState(() {
//         _errorText = 'Nama pengguna atau kata sandi salah';
//       });
//     }
//     }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // TODO : 2. Pasang AppBar
//       appBar: AppBar(title: Text('Sign In'),),
//       // TODO : 3. Pasang body
//       body: Center(
//         child:SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 child: Column(
//                   // TODO : 4. Atur MainAxisAlignment dan crossAxisAlignment
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // TODO : 5. Pasang TextFromField Nama Pengguna
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(
//                         labelText: "Nama Pengguna",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     // TODO : 6. Pasang TextFromField Kata Sandi
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: _passwordCintroller,
//                       decoration: InputDecoration(
//                           labelText: "Kata Sandi",
//                           errorText: _errorText.isNotEmpty ? _errorText: null,
//                           border: OutlineInputBorder(),
//                           suffixIcon: IconButton(
//                             onPressed: (){
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                             icon: Icon(
//                               _obscurePassword ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),)
//                       ),
//                       obscureText: _obscurePassword,
//                     ),
//                     // TODO : 7. Pasang ElevatedButton Sign In
//                     SizedBox(height: 20),
//                     ElevatedButton(onPressed: (){}, child: Text('Sign In')),
//                     // TODO: 8. Pasang TextButton Sign up
//                     SizedBox(height: 10),
//                     //TextButton(onPressed: (){}, child: Text('Belum Punya Akun? Daftar di sini'))
//                     RichText(
//                         text: TextSpan(
//                             text: 'Belum punya akun?',
//                             style: TextStyle(fontSize: 16, color: Colors.deepPurple),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text: 'Daftar di sini',
//                                 style: TextStyle(
//                                     color: Colors.blue, //Warna untuk text yang bisa di tekan
//                                     decoration: TextDecoration.underline,
//                                     fontSize: 16
//                                 ),
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = (){
//                                   Navigator.pushNamed(context, '/signup');
//                                   },
//                               )
//                             ]
//                         ))
//                   ],
//                 ),
//               ),
//             )),
//       ),
//     );
//
//   }
// }