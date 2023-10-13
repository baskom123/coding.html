import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);

  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  String? _image;
  double _score = 0;
  final ImagePicker _picker = ImagePicker();
  final String _keyScore = 'score';
  final String _keyImage = 'image';
  late SharedPreferences prefs;
  final String _keyDate = 'date';

  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = (prefs.getDouble(_keyScore) ?? 0);
      _image = prefs.getString(_keyImage);
      final savedDate = prefs.getString(_keyDate);
      if (savedDate != null) {
        Provider.of<BioData>(context, listen: false).setDate(savedDate);
      }
    });
  }

  // SharedPreferences

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> _setScore(double value) async {
    print('Set Score: $value'); // Tambahkan ini
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble(_keyScore, value);
      _score = (prefs.getDouble(_keyScore) ?? 0);
    });
  }

  Future<void> _setImage(String? value) async {
    final bioData = Provider.of<BioData>(context, listen: false);
    if (value != null) {
      setState(() {
        _image = value;
      });
     
      bioData.setImage(value);
    }
  }

  Future<void> _setDate(DateTime date) async {
    final bioData = Provider.of<BioData>(context, listen: false);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    bioData.setDate(formattedDate);
    prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyDate, formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Bio')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                        File(_image!),
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 198, 198, 198),
                        ),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    _setImage(image?.path);
                  },
                  child: const Text('Take Image'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinBox(
                    max: 10.0,
                    min: 0.0,
                    value: _score,
                    step: 0.1,
                    decimals: 1,
                    decoration: InputDecoration(labelText: 'Decimal'),
                    onChanged: _setScore,
                  )),
              Text(
                'Tanggal Yang disimpan: ${Provider.of<BioData>(context).date ?? "Belum Disimpan"}',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (selectedDate != null) {
                      _setDate(selectedDate);
                    }
                  },
                  child: Text('Pilih Tanggal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



