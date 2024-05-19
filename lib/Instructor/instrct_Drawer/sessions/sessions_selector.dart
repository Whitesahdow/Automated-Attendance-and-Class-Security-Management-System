class SessionData {
  String? courseName;
  String? roomNumber;
  String? section;
  String? batch;
  String? department;

  SessionData({
    this.courseName,
    this.roomNumber,
    this.section,
    this.batch,
    this.department,
  });
}
///////////////////////////////////////////////////////////////

class Menu_list {
  late String? course_name;
  late String? Room_number;
  late String? Section;
  late String? Batch_No;

  Menu_list({
    this.course_name,
    this.Room_number,
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
