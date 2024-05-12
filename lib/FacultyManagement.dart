import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyManagement extends StatefulWidget {
  @override
  _FacultyState createState() => _FacultyState();
}

class _FacultyState extends State<FacultyManagement> {
  List<dynamic> _faculties = [];
  TextEditingController facultyIdController = TextEditingController();
  TextEditingController facultyNameController = TextEditingController();
  TextEditingController deanController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numDepartmentsController = TextEditingController();
  List<String> departmentNames = [];
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
      _faculties = _prefs
              .getStringList('faculties')
              ?.map((faculty) => jsonDecode(faculty))
              .toList() ??
          [];
    });
  }

  Future<void> addFaculty() async {
    if (facultyIdController.text.isEmpty ||
        facultyNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Faculty ID and Faculty Name are required'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> facultyData = {
      'faculty_id': facultyIdController.text,
      'faculty_name': facultyNameController.text,
      'dean': deanController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'num_departments': numDepartmentsController.text,
      'department_names': departmentNames,
    };

    List<String> facultyList = _prefs.getStringList('faculties') ?? [];
    facultyList.add(jsonEncode(facultyData));
    _prefs.setStringList('faculties', facultyList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Faculty added successfully'),
        backgroundColor: Colors.blueAccent,
      ),
    );

    initPrefs(); // Refresh the list after adding a faculty

    facultyIdController.clear();
    facultyNameController.clear();
    deanController.clear();
    telephoneController.clear();
    emailController.clear();
    numDepartmentsController.clear();
    departmentNames.clear();
    setState(() {
      _selectedIndex = null;
    });
  }

  Future<void> updateFaculty() async {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a faculty to update'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> facultyData = {
      'faculty_id': facultyIdController.text,
      'faculty_name': facultyNameController.text,
      'dean': deanController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'num_departments': numDepartmentsController.text,
      'department_names': departmentNames,
    };

    List<String> facultyList = _prefs.getStringList('faculties') ?? [];
    facultyList[_selectedIndex!] = jsonEncode(facultyData);
    _prefs.setStringList('faculties', facultyList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Faculty updated successfully'),
        backgroundColor: Colors.blueAccent,
      ),
    );

    initPrefs(); // Refresh the list after updating a faculty

    facultyIdController.clear();
    facultyNameController.clear();
    deanController.clear();
    telephoneController.clear();
    emailController.clear();
    numDepartmentsController.clear();
    departmentNames.clear();
    setState(() {
      _selectedIndex = null;
    });
  }

  Future<void> deleteFaculty(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this faculty member?'),
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
        _faculties.removeAt(index);
        _prefs.setStringList('faculties',
            _faculties.map((faculty) => jsonEncode(faculty)).toList());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Faculty member deleted successfully'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  void editFaculty(int index, Map<String, dynamic> facultyData) {
    setState(() {
      _selectedIndex = index;
      facultyIdController.text = facultyData['faculty_id'];
      facultyNameController.text = facultyData['faculty_name'];
      deanController.text = facultyData['dean'];
      telephoneController.text = facultyData['telephone'];
      emailController.text = facultyData['email'];
      numDepartmentsController.text = facultyData['num_departments'];
      departmentNames = List<String>.from(facultyData['department_names']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Faculty ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: facultyIdController),
            SizedBox(height: 10.0),
            Text('Faculty Name:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: facultyNameController),
            SizedBox(height: 10.0),
            Text('Dean:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: deanController),
            SizedBox(height: 10.0),
            Text('Telephone Number:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: telephoneController),
            SizedBox(height: 10.0),
            Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: emailController),
            SizedBox(height: 10.0),
            Text('Number of Departments:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: numDepartmentsController),
            SizedBox(height: 10.0),
            Text('Department Names:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: departmentNames
                  .map((dept) => Chip(
                        label: Text(dept),
                        onDeleted: () {
                          setState(() {
                            departmentNames.remove(dept);
                          });
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newDepartmentName =
                        ''; // Store the new department name here
                    return AlertDialog(
                      title: Text('Add Department Name'),
                      content: TextField(
                        onChanged: (value) {
                          // Store the value in a variable but don't update the state yet
                          newDepartmentName = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter department name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              // Add the department name to the list only when the "Add" button is pressed
                              departmentNames.add(newDepartmentName);
                            });
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Department'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed:
                      _selectedIndex != null ? updateFaculty : addFaculty,
                  child: Text(_selectedIndex != null
                      ? 'Update Faculty'
                      : 'Add Faculty'),
                ),
                ElevatedButton(
                  onPressed: () {
                    facultyIdController.clear();
                    facultyNameController.clear();
                    deanController.clear();
                    telephoneController.clear();
                    emailController.clear();
                    numDepartmentsController.clear();
                    departmentNames.clear();
                    setState(() {
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
              itemCount: _faculties.length,
              itemBuilder: (context, index) {
                final facultyData = _faculties[index];
                return ListTile(
                  title:
                      Text('Faculty ID: ${facultyData['faculty_id'] ?? 'N/A'}'),
                  subtitle: Text(
                      'Faculty Name: ${facultyData['faculty_name'] ?? 'N/A'}'),
                  onTap: () {
                    _showFacultyInfoDialog(context, facultyData);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editFaculty(index, facultyData),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteFaculty(index),
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

  void _showFacultyInfoDialog(
      BuildContext context, Map<String, dynamic> facultyData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Faculty Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Faculty ID: ${facultyData['faculty_id'] ?? 'N/A'}'),
              Text('Faculty Name: ${facultyData['faculty_name'] ?? 'N/A'}'),
              Text('Dean: ${facultyData['dean'] ?? 'N/A'}'),
              Text('Telephone: ${facultyData['telephone'] ?? 'N/A'}'),
              Text('Email: ${facultyData['email'] ?? 'N/A'}'),
              Text(
                  'Number of Departments: ${facultyData['num_departments'] ?? 'N/A'}'),
              Text(
                  'Department Names: ${facultyData['department_names'] != null ? (facultyData['department_names'] as List).join(", ") : 'N/A'}'),
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
}
