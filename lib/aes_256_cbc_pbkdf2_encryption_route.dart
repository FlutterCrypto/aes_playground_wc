import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webcrypto/webcrypto.dart';

class Aes256CbcPbkdf2EncryptionRoute extends StatefulWidget {
  const Aes256CbcPbkdf2EncryptionRoute({Key? key}) : super(key: key);

  final String title = 'CBC Verschlüsselung';
  final String subtitle = 'AES-256 CBC PBKDF2';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<Aes256CbcPbkdf2EncryptionRoute> {
  @override
  void initState() {
    super.initState();
    descriptionController.text = txtDescription;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  // the following controller have a default value
  TextEditingController plaintextController = TextEditingController(
      text: 'The quick brown fox jumps over the lazy dog');
  TextEditingController iterationenController =
      TextEditingController(text: '15000');

  TextEditingController passwordController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  String txtDescription = 'AES-256 CBC Verschlüsselung, der Schlüssel'
      ' wird mit PBKDF2 (wählbare Iterationen) von einem Passwort abgeleitet.';

  String _returnJson(String data) {
    var parts = data.split(':');
    var algorithm = parts[0];
    var iterations = parts[1];
    var salt = parts[2];
    var iv = parts[3];
    var ciphertext = parts[4];
    var gcmTag = parts[5];

    JsonEncryption jsonEncryption = JsonEncryption(
        algorithm: algorithm,
        iterations: iterations,
        salt: salt,
        iv: iv,
        ciphertext: ciphertext,
        gcmTag: gcmTag);

    String encryptionResult = jsonEncode(jsonEncryption);
    // make it pretty
    var object = json.decode(encryptionResult);
    var prettyEncryptionResult2 = JsonEncoder.withIndent('  ').convert(object);

    return prettyEncryptionResult2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //SizedBox(height: 20),
                // form description
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enabled: false,
                  // false = disabled, true = enabled
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),
                // plaintext
                TextFormField(
                  controller: plaintextController,
                  maxLines: 3,
                  maxLength: 500,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Klartext',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte Daten eingeben';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          plaintextController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          plaintextController.text = data!.text!;
                        },
                        child: Text('aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                // password
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  enabled: true,
                  // false = disabled, true = enabled
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Passwort',
                    hintText: 'geben Sie das Passwort zur Verschlüsselung ein',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte Daten eingeben';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          passwordController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          passwordController.text = data!.text!;
                        },
                        child: Text('aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                // iterationen
                SizedBox(height: 20),
                TextFormField(
                  controller: iterationenController,
                  enabled: true,
                  // false = disabled, true = enabled
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Iterationen',
                    hintText: 'geben Sie die Anzahl der Iterationen ein',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value)! < 10000) {
                      return 'Bitte Daten eingeben (Minimum 10000)';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // reset() setzt alle Felder wieder auf den Initalwert zurück.
                          _formKey.currentState!.reset();
                        },
                        child: Text('Formulardaten löschen'),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          // Wenn alle Validatoren der Felder des Formulars gültig sind.
                          if (_formKey.currentState!.validate()) {
                            String plaintext = plaintextController.text;
                            String password = passwordController.text;
                            String iterations = iterationenController.text;
                            String output = await aesCbcIterPbkdf2EncryptToBase64Wc(
                                password, iterations, plaintext);
                            String _formdata = 'AES-256 CBC PBKDF2' +
                                ':' +
                                iterations +
                                ':' +
                                output +
                                ':nicht benutzt'; // empty gcm tag

                            String jsonOutput = _returnJson(_formdata);
                            outputController.text = jsonOutput;
                          } else {
                            print("Formular ist nicht gültig");
                          }
                        },
                        child: Text('verschlüsseln'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: outputController,
                  maxLines: 15,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Ausgabe',
                    hintText: 'Ausgabe',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          outputController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              ClipboardData(text: outputController.text);
                          await Clipboard.setData(data);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Daten in die Zwischenablage kopiert'),
                            ),
                          );
                        },
                        child: Text('in Zwischenablage kopieren'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> aesCbcIterPbkdf2EncryptToBase64Wc(
      String password, String iterations, String plaintext) async {
    try {
      var plaintextUint8 = createUint8ListFromString(plaintext);
      var passphrase = createUint8ListFromString(password);
      final PBKDF2_ITERATIONS = int.tryParse(iterations);
      final key = await Pbkdf2SecretKey.importRawKey(passphrase);
      final salt = generateSalt32ByteWc();
      final derivedBits =
      await key.deriveBits(256, Hash.sha256, salt, PBKDF2_ITERATIONS!);
      final iv = generateIv16ByteWc();
      AesCbcSecretKey aesCbcSecretKey =
      await AesCbcSecretKey.importRawKey(derivedBits);
      Uint8List ciphertext =
      await aesCbcSecretKey.encryptBytes(plaintextUint8, iv);
      String ciphertextBase64 = base64Encoding(ciphertext);
      String ivBase64 = base64Encoding(iv);
      String saltBase64 = base64Encoding(salt);
      return saltBase64 + ':' + ivBase64 + ':' + ciphertextBase64;
    } catch (error) {
      return 'Fehler bei der Verschlüsselung';
    }
  }

  Uint8List generateSalt32ByteWc() {
    final salt = Uint8List(32);
    fillRandomBytes(salt);
    return salt;
  }

  Uint8List generateIv16ByteWc() {
    final nonce = Uint8List(16);
    fillRandomBytes(nonce);
    return nonce;
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  String base64Encoding(Uint8List input) {
    return base64.encode(input);
  }

  Uint8List base64Decoding(String input) {
    return base64.decode(input);
  }
}

class JsonEncryption {
  JsonEncryption({
    required this.algorithm,
    this.iterations,
    this.salt,
    this.iv,
    required this.ciphertext,
    this.gcmTag,
  });

  final String algorithm;
  final String? iterations;
  final String? salt;
  final String? iv;
  final String ciphertext;
  final String? gcmTag;

  Map toJson() => {
        'algorithm': algorithm,
        'iterations': iterations,
        'salt': salt,
        'iv': iv,
        'ciphertext': ciphertext,
        'gcmTag': gcmTag,
      };
}
