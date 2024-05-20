class Student_Courses {
  final String course_category;
  final String course_code;
  final String course_credit;
  final String course_department;
  final String course_name;
  final String id;

  Student_Courses({
    required this.course_category,
    required this.course_code,
    required this.course_credit,
    required this.course_department,
    required this.course_name,
    required this.id,
  });

  @override
  String toString() {
    return 'Student_Courses(course_category: $course_category, course_code: $course_code, course_credit: $course_credit, '
        'course_department: $course_department, course_name: $course_name, id: $id, )';
  }
}


class StuCrssDetails {
  final String? course_category;
  final String? course_code;
  final String? course_credit;
  final String? course_department;
  final String? course_name;
  final String? id;

  StuCrssDetails({
    required this.course_category,
    required this.course_code,
    required this.course_credit,
    required this.course_department,
    required this.course_name,
    required this.id,
  });
}
