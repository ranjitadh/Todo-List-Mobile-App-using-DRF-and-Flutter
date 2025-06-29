class todolistmodel {
  int? id;
  String? name;
  String? description;
  String? status;

  todolistmodel({this.id, this.name, this.description, this.status});

  todolistmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}
