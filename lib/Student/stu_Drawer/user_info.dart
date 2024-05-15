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

  Student_info(
      {required this.first_name,
      required this.last_name,
      required this.email,
      required this.id,
      required this.middle_name,
      required this.department,
      required this.gender,
      required this.batch,
      required this.section});
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

  Instructor_info({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.teacher_id,
    required this.middle_name,
    required this.department,
    required this.gender,
    required this.qualification,
  });
}
