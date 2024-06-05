import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampusManagement extends StatefulWidget {
  @override
  _CampusManagementState createState() => _CampusManagementState();
}

class _CampusManagementState extends State<CampusManagement> {
  List<dynamic> _campuses = [];
  TextEditingController campusIdController = TextEditingController();
  TextEditingController campusNameController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? selectedDepartment;
  late SharedPreferences _prefs;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _campuses = _prefs.getStringList('campuses')?.map((campus) => jsonDecode(campus)).toList() ?? [];
    });
  }

  Future<void> addCampus() async {
    if (campusIdController.text.isEmpty || campusNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Campus ID and Campus Name are required')),
      );
      return;
    }

    Map<String, dynamic> campusData = {
      'campus_id': campusIdController.text,
      'campus_name': campusNameController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'address': addressController.text,
      'departments': selectedDepartment ?? '',
    };

    List<String> campusList = _prefs.getStringList('campuses') ?? [];
    campusList.add(jsonEncode(campusData));
    _prefs.setStringList('campuses', campusList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Campus added successfully')),
    );

    initPrefs(); // Refresh the list after adding a campus

    campusIdController.clear();
    campusNameController.clear();
    telephoneController.clear();
    emailController.clear();
    addressController.clear();
    setState(() {
      selectedDepartment = null;
    });
  }

  Future<void> updateCampus() async {
    if (_selectedIndex == null) return;

    Map<String, dynamic> campusData = {
      'campus_id': campusIdController.text,
      'campus_name': campusNameController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'address': addressController.text,
      'departments': selectedDepartment ?? '',
    };

    List<String> campusList = _prefs.getStringList('campuses') ?? [];
    campusList[_selectedIndex!] = jsonEncode(campusData);
    _prefs.setStringList('campuses', campusList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Campus updated successfully')),
    );

    initPrefs(); // Refresh the list after updating a campus

    campusIdController.clear();
    campusNameController.clear();
    telephoneController.clear();
    emailController.clear();
    addressController.clear();
    setState(() {
      selectedDepartment = null;
    });
  }

  Future<void> deleteCampus(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this campus?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                                  Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _campuses.removeAt(index);
        _prefs.setStringList('campuses', _campuses.map((campus) => jsonEncode(campus)).toList());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Campus deleted successfully')),
      );
    }
  }

  void _showCampusInfoDialog(BuildContext context, Map<String, dynamic> campusData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Campus Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Campus ID: ${campusData['campus_id'] ?? 'N/A'}'),
              Text('Campus Name: ${campusData['campus_name'] ?? 'N/A'}'),
              Text('Telephone: ${campusData['telephone'] ?? 'N/A'}'),
              Text('Email: ${campusData['email'] ?? 'N/A'}'),
              Text('Address: ${campusData['address'] ?? 'N/A'}'),
              Text('Departments: ${campusData['departments'] ?? 'N/A'}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

void editCampus(int index, Map<String, dynamic> campusData) {
  setState(() {
    _selectedIndex = index;
    campusIdController.text = campusData['campus_id'];
    campusNameController.text = campusData['campus_name'];
    telephoneController.text = campusData['telephone'];
    emailController.text = campusData['email'];
    addressController.text = campusData['address'];
    selectedDepartment = campusData['departments'];
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Campus ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: campusIdController),
            SizedBox(height: 10.0),
            Text('Campus Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: campusNameController),
            SizedBox(height: 10.0),
            Text('Telephone Number:'),
            TextField(controller: telephoneController),
            SizedBox(height: 10.0),
            Text('Email:'),
            TextField(controller: emailController),
            SizedBox(height: 10.0),
            Text('Address:'),
            TextField(controller: addressController),
            SizedBox(height: 10.0),
            Text('Department:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedDepartment,
              onChanged: (newValue) {
                setState(() {
                  selectedDepartment = newValue;
                });
              },
              items: <String>[
                'BS Software Engineering',
                'BS Computer Science',
                'BS Information Technologies',
                'BS Artificial Engineering',
                'BS Information Security',
                'BS Cyber Security',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectedIndex != null ? updateCampus : addCampus,
                  child: Text(_selectedIndex != null ? 'Update Campus' : 'Add Campus'),
                ),
                ElevatedButton(
                  onPressed: () {
                    campusIdController.clear();
                    campusNameController.clear();
                    telephoneController.clear();
                    emailController.clear();
                    addressController.clear();
                    setState(() {
                      selectedDepartment = null;
                      _selectedIndex = null;
                    });
                  },
                  child: Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _campuses.length,
              itemBuilder: (context, index) {
                final campusData = _campuses[index];
                return ListTile(
                  title: Text('Campus ID: ${campusData['campus_id'] ?? 'N/A'}'),
                  subtitle: Text('Campus Name: ${campusData['campus_name'] ?? 'N/A'}'),
                  onTap: () {
                    _showCampusInfoDialog(context, campusData);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editCampus(index, campusData),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteCampus(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

