class SessionData {
  String? courseName;
  String? roomNumber;
  String? section;
  String? batch;
  String? department;
  String? time;
  List<String> studentIds = []; // Change to list
  String? courseID;
  String? roomID;
  String? instructorID;

  SessionData({
    this.courseName,
    this.roomNumber,
    this.section,
    this.batch,
    this.department,
    this.time,
    required this.studentIds, // Update constructor parameter
    this.courseID,
    this.roomID,
    this.instructorID,
  });
}

///////////////////////////////////////////////////////////////

class Menu_list {
  late String? course_name;
  late String? course_id;
  late String? Section;
  late String? Batch_No;

  Menu_list({
    this.course_name,
    this.course_id,
    this.Section,
    this.Batch_No,
  });
}

///////////////////////////////////////////////////////////
class InstInfo {
  final String? id_key;

  InstInfo({
    this.id_key,
  });
}

class ScnLists {
  final String section;

  ScnLists({
    required this.section,
  });
}

class DeptList {
  final String department_name;

  DeptList({
    required this.department_name,
  });
}

class BatchList {
  final String batch_number;

  BatchList({
    required this.batch_number,
  });
}

////////////////////////////////////////////////////////////////////////////
class Students_list {
  String batch;
  String department;
  String email;
  String first_name;
  String gender;
  String id;
  String last_name;
  String middle_name;
  String section;
  Students_list({
    required this.batch,
    required this.department,
    required this.email,
    required this.first_name,
    required this.gender,
    required this.id,
    required this.last_name,
    required this.middle_name,
    required this.section,
  });
  @override
  String toString() {
    return 'Students_list(batch: $batch, department: $department, email: $email, '
        'first_name: $first_name, gender: $gender, id: $id, last_name: $last_name, '
        'middle_name: $middle_name, section: $section)';
  }
}
///////////////////////////////////////////////////////////////////////////////

class Session_Check {
  String? course_name;
  String? room;
  String? start_time;
  String? batch;
  String? section;
  String? department;
  String? time;
  var student_id;
  String? courseID;
  bool msg;
  String? Instructor_ID;

  Session_Check({
    this.course_name,
    this.room,
    this.start_time,
    this.section,
    this.batch,
    this.department,
    this.time,
    this.student_id,
    this.courseID,
    required this.msg,
    this.Instructor_ID,
  });
}
