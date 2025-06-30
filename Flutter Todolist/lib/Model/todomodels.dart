class todolistmodel {
  int? id;
  String? name;
  String? description;
  String? status;

  todolistmodel({this.id, this.name, this.description, this.status});

  todolistmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    description = json['description'] as String?;
    status = (json['status'] as String?)?.toLowerCase();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    return data;
  }

  bool get isProcessed => status?.toLowerCase() == 'proccessed' || status?.toLowerCase() == 'processed';
}