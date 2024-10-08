import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/event_screen.dart';
import 'package:todo/widgets/tab_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalCount = 0;
  int completedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchTodoCounts();
  }

  Future<void> _fetchTodoCounts() async {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final todos = await todoProvider.fetchTodos();

    setState(() {
      totalCount = todos.length;
      completedCount = todos.where((todo) => todo.isCompleted == true).length;
    });
  }

  Future<void> _deleteTodo(Todo todo) async{
    Provider.of<TodoProvider>(context,listen: false).deletedTodo(todo);
    _fetchTodoCounts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Công việc',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.green.shade100,
                  ),
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        TabItem(title: 'Tất cả', count: totalCount),
                        TabItem(title: 'Hoàn thành', count: completedCount),
                      ]),
                ),
              )),
        ),
        body: TabBarView(children: [
          _TotalTodo(),
          _CompletedTodo(),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, EventScreen.routeName,
                arguments: null);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _TotalTodo() {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<List<Todo>>(
        future: todoProvider.fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final todos = snapshot.data!;
            if (todos.isEmpty) {
              return const Center(child: Text('Không có công việc nào.'));
            }

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      todo.title.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Hiển thị tiêu đề công việc
                    subtitle: Text(todo.content.toString() ?? 'Không có mô tả'),
                    trailing: SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              todoProvider.updateCompletedTodo(todo);
                            },
                            icon: todo.isCompleted == true
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.circle_outlined),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, EventScreen.routeName,
                                    arguments: todo);
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                            onPressed :()=> _deleteTodo(todo),
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Không có dữ liệu.'));
        },
      ),
    );
  }

  Widget _CompletedTodo() {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<List<Todo>>(
        future: todoProvider.fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final todos = snapshot.data!;

            final completedTodo =
                todos.where((todo) => todo.isCompleted == true).toList();

            if (todos.isEmpty) {
              return const Center(child: Text('Không có công việc nào.'));
            }
            return ListView.builder(
              itemCount: completedTodo.length,
              itemBuilder: (context, index) {
                final todo = completedTodo[index];
                return Card(
                  child: ListTile(
                    title: Text(todo.title.toString()),
                    subtitle: Text(todo.content.toString() ?? 'Không có mô tả'),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Không có dữ liệu.'));
        },
      ),
    );
  }
}
