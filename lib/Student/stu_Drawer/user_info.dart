class Student_info {
  final String first_name;
  final String last_name;
  final String email;
  final String middle_name;
  final String gender;
  final String batch;
  final String department;
  final String section;
  final String id;
  final String id_key;

  Student_info({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.id,
    required this.middle_name,
    required this.department,
    required this.gender,
    required this.batch,
    required this.section,
    required this.id_key,
  });
}

class Instructor_info {
  final String first_name;
  final String last_name;
  final String email;
  final String middle_name;
  final String gender;
  final String qualification;
  final String department;
  final String teacher_id;
  final String id_key;

  Instructor_info({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.teacher_id,
    required this.middle_name,
    required this.department,
    required this.gender,
    required this.qualification,
    required this.id_key,
  });
}
