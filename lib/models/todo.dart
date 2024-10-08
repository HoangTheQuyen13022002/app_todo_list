  class Todo {
    String? id;
    String? title;
    String? content;
    bool? isCompleted;

    Todo({this.id,this.title, this.content, this.isCompleted});

    Todo.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      title = json['title'];
      content = json['content'];
      isCompleted = json['isCompleted'];
    }


    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['title'] = this.title;
      data['content'] = this.content;
      data['isCompleted'] = this.isCompleted;
      return data;
    }

    Todo copyTodo({
      String? title,
      String? content,
      bool? isCompleted,
  }) => Todo(
      id : this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
