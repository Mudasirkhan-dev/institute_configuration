import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DepartmentManagement extends StatefulWidget {
  @override
  _DepartmentManagementState createState() => _DepartmentManagementState();
}


class _DepartmentManagementState  extends State<DepartmentManagement> {

  List<dynamic> _departments = [];
  TextEditingController departmentIdController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController hodController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numCoursesController = TextEditingController();
  List<String> courseNames = [];
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
      _departments = _prefs
              .getStringList('departments')
              ?.map((department) => jsonDecode(department))
              .toList() ??
          [];
    });
  }

  Future<void> addDepartment() async {
    if (departmentIdController.text.isEmpty ||
        departmentNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Department ID and Department Name are required'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> departmentData = {
      'department_id': departmentIdController.text,
      'department_name': departmentNameController.text,
      'hod': hodController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'num_courses': numCoursesController.text,
      'course_names': courseNames,
    };

    List<String> departmentList = _prefs.getStringList('departments') ?? [];
    departmentList.add(jsonEncode(departmentData));
    _prefs.setStringList('departments', departmentList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Department added successfully'),
        backgroundColor: Colors.blueAccent,
      ),
    );

    initPrefs(); // Refresh the list after adding a department

    departmentIdController.clear();
    departmentNameController.clear();
    hodController.clear();
    telephoneController.clear();
    emailController.clear();
    numCoursesController.clear();
    courseNames.clear();
    setState(() {
      _selectedIndex = null;
    });
  }

  Future<void> updateDepartment() async {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a department to update'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> departmentData = {
      'department_id': departmentIdController.text,
      'department_name': departmentNameController.text,
      'hod': hodController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'num_courses': numCoursesController.text,
      'course_names': courseNames,
    };

    List<String> departmentList = _prefs.getStringList('departments') ?? [];
    departmentList[_selectedIndex!] = jsonEncode(departmentData);
    _prefs.setStringList('departments', departmentList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Department updated successfully'),
        backgroundColor: Colors.blueAccent,
      ),
    );

    initPrefs(); // Refresh the list after updating a department

    departmentIdController.clear();
    departmentNameController.clear();
    hodController.clear();
    telephoneController.clear();
    emailController.clear();
    numCoursesController.clear();
    courseNames.clear();
    setState(() {
      _selectedIndex = null;
    });
  }

  Future<void> deleteDepartment(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this department?'),
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
        _departments.removeAt(index);
        _prefs.setStringList('departments',
            _departments.map((department) => jsonEncode(department)).toList());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Department deleted successfully'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  void editDepartment(int index, Map<String, dynamic> departmentData) {
    setState(() {
      _selectedIndex = index;
      departmentIdController.text = departmentData['department_id'];
      departmentNameController.text = departmentData['department_name'];
      hodController.text = departmentData['hod'];
      telephoneController.text = departmentData['telephone'];
      emailController.text = departmentData['email'];
      numCoursesController.text = departmentData['num_courses'];
      courseNames = List<String>.from(departmentData['course_names']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Department Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Department ID:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: departmentIdController),
            SizedBox(height: 10.0),
            Text('Department Name:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: departmentNameController),
            SizedBox(height: 10.0),
            Text('Head of Department (HOD):',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: hodController),
            SizedBox(height: 10.0),
            Text('Telephone Number:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: telephoneController),
            SizedBox(height: 10.0),
            Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: emailController),
            SizedBox(height: 10.0),
            Text('Number of Courses:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: numCoursesController),
            SizedBox(height: 10.0),
            Text('Course Names:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: courseNames
                  .map((course) => Chip(
                        label: Text(course),
                        onDeleted: () {
                          setState(() {
                            courseNames.remove(course);
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
                    String newCourseName = ''; // Store the new course name here
                    return AlertDialog(
                      title: Text('Add Course Name'),
                      content: TextField(
                        onChanged: (value) {
                          // Store the value in a variable but don't update the state yet
                          newCourseName = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter course name',
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
                              // Add the course name to the list only when the "Add" button is pressed
                              courseNames.add(newCourseName);
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
              child: Text('Add Course'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed:
                      _selectedIndex != null ? updateDepartment : addDepartment,
                  child: Text(_selectedIndex != null
                      ? 'Update Department'
                      : 'Add Department'),
                ),
                ElevatedButton(
                  onPressed: () {
                    departmentIdController.clear();
                    departmentNameController.clear();
                    hodController.clear();
                    telephoneController.clear();
                    emailController.clear();
                    numCoursesController.clear();
                    courseNames.clear();
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
              itemCount: _departments.length,
              itemBuilder: (context, index) {
                final departmentData = _departments[index];
                return ListTile(
                  title: Text(
                      'Department ID: ${departmentData['department_id'] ?? 'N/A'}'),
                  subtitle: Text(
                      'Department Name: ${departmentData['department_name'] ?? 'N/A'}'),
                  onTap: () {
                    _showDepartmentInfoDialog(context, departmentData);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editDepartment(index, departmentData),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteDepartment(index),
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

  void _showDepartmentInfoDialog(
      BuildContext context, Map<String, dynamic> departmentData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Department Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Department ID: ${departmentData['department_id'] ?? 'N/A'}'),
              Text(
                  'Department Name: ${departmentData['department_name'] ?? 'N/A'}'),
              Text(
                  'Head of Department (HOD): ${departmentData['hod'] ?? 'N/A'}'),
              Text('Telephone: ${departmentData['telephone'] ?? 'N/A'}'),
              Text('Email: ${departmentData['email'] ?? 'N/A'}'),
              Text(
                  'Number of Courses: ${departmentData['num_courses'] ?? 'N/A'}'),
              Text(
                  'Course Names: ${departmentData['course_names'] != null ? (departmentData['course_names'] as List).join(", ") : 'N/A'}'),
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
