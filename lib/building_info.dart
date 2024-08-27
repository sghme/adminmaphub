import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuildingInfo extends StatefulWidget {
  @override
  _BuildingInfoState createState() => _BuildingInfoState();
}

class _BuildingInfoState extends State<BuildingInfo> {
  Future<List<Map<String, dynamic>>>? _classroomsFuture;

  @override
  void initState() {
    super.initState();
    _classroomsFuture = Supabase.instance.client
        .from('classrooms') // Fetch data from the Classrooms table
        .select();
       
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classrooms Info'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _classroomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final classrooms = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 16.0,
                  headingRowColor: MaterialStateProperty.all<Color>(Colors.blueGrey.shade50),
                  dataRowHeight: 56.0,
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  dataTextStyle: TextStyle(
                    color: Colors.black54,
                  ),
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                    verticalInside: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                    left: BorderSide(
                      color: const Color.fromARGB(255, 218, 218, 218),
                      width: 1.0,
                    ),
                    top: BorderSide(
                      color: const Color.fromARGB(255, 218, 218, 218),
                      width: 1.0,
                    ),
                    right: BorderSide(
                      color: const Color.fromARGB(255, 218, 218, 218),
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: const Color.fromARGB(255, 218, 218, 218),
                      width: 1.0,
                    ),
                  ),
                  columns: const [
                    DataColumn(label: Text('Room Name')),
                    DataColumn(label: Text('Teacher Name')),
                    DataColumn(label: Text('Section')),
                    DataColumn(label: Text('Grade Level')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: classrooms.map<DataRow>((classroom) {
                    return DataRow(
                      cells: [
                        DataCell(Text(classroom['name'] ?? 'No name')),
                        DataCell(Text(classroom['teacher_name'] ?? 'No teacher name')),
                        DataCell(Text(classroom['section'] ?? 'No section')),
                        DataCell(Text(classroom['grade_level']?.toString() ?? 'No grade level')),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Implement edit functionality here
                                print("Edit classroom: ${classroom['name']}");
                              },
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.delete, color: Colors.red),
                            //   onPressed: () {
                            //     // Implement delete functionality here
                            //     print("Delete classroom: ${classroom['name']}");
                            //   },
                            // ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
