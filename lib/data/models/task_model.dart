class TaskModel {
  String id;
  String title; 
  String? notes;
  int? priority;
  bool isDone;
  bool isStarred;
  bool isImportance;
  DateTime? startDate;
  DateTime? dueDate;

  int? statusDel;
  String? nguoiCapNhat;
  DateTime? ngayCapNhat;

  TaskModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.dueDate,
    this.notes,
    this.priority,
    this.isDone = false,
    this.isStarred = false,
    this.isImportance = false,
  
    this.statusDel,
    this.nguoiCapNhat,
    this.ngayCapNhat
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'priority': priority ?? 1,
      'is_done': isDone,
      'is_starred': isStarred,
      'is_important': isImportance,
      'start_date': startDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'status_del': statusDel,
      'nguoi_cap_nhat': nguoiCapNhat,
      'ngay_cap_nhat': ngayCapNhat?.toIso8601String()
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    try {
      return TaskModel(
      id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      notes: json['notes'] ?? '',
      priority: json['priority'] ?? 0,
      isDone: json['is_done'] ?? false,
      isStarred: json['is_starred'] ?? false,
      isImportance: json['is_important'] ?? false,
      startDate: DateTime.parse(json['start_date']),
      dueDate: DateTime.parse(json['due_date']),
      statusDel: json['status_del'] ?? 1,
      nguoiCapNhat: json['nguoi_cap_nhat'] ?? 'admin',
      ngayCapNhat: (json['ngay_cap_nhat'] is String) ? DateTime.parse(json['ngay_cap_nhat']) : DateTime.now()
    );
    } catch (e) {
      return TaskModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: '',
        notes: '',
        priority: 0,
        isDone: false,
        isStarred: false,
        isImportance: false,
        startDate: DateTime.now(),
        dueDate: DateTime.now(),
        statusDel: 1,
        nguoiCapNhat: 'admin',
        ngayCapNhat: DateTime.now()
      );
    }
  }

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, notes: $notes, '
        'priority: $priority, isDone: $isDone, isStarred: $isStarred, '
        'isImportance: $isImportance, startDate: $startDate, dueDate: $dueDate, '
        'statusDel: $statusDel, nguoiCapNhat: $nguoiCapNhat, ngayCapNhat: $ngayCapNhat}';
  }
}

