import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/services/models/calender_modal.dart';
import 'package:intl/intl.dart';

class PriorityScreen extends StatelessWidget {
  const PriorityScreen({super.key});

  Future<List<Task>> _fetchTasksByPriority(
      HiveService hiveService, String priority) async {
    List<Task> allTasks = await hiveService.getAllTasks();
    return allTasks.where((task) => task.priority == priority).toList();
  }

  @override
  Widget build(BuildContext context) {
    final HiveService hiveService = Provider.of<HiveService>(context);

    final List<Map<String, dynamic>> priorityItems = [
      {
        "title": "Top Priority",
        "color": 0xFFB3E5FC,
        "priority": 'Top Priority'
      },
      {"title": "Necessary", "color": 0xFFFFF59D, "priority": 'Necessary'},
      {"title": "Regular", "color": 0xFFB0BEC5, "priority": 'Regular'},
      {"title": "Delete", "color": 0xFFFF8A80, "priority": 'Delete'},
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'Eisenhower Matrix'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: Future.wait(priorityItems
              .map((item) =>
                  _fetchTasksByPriority(hiveService, item['priority']))
              .toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<List<Task>> tasksByPriority =
                snapshot.data as List<List<Task>>;

            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                int crossAxisCount =
                    (constraints.maxWidth ~/ 200).toInt().clamp(2, 4);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: priorityItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PriorityContainer(
                      title: priorityItems[index]["title"],
                      color: Color(priorityItems[index]["color"]),
                      tasks: tasksByPriority[index],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PriorityContainer extends StatelessWidget {
  final String title;
  final Color color;
  final List<Task> tasks;

  const PriorityContainer({
    required this.title,
    required this.color,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 41, 35, 35).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 63, 63, 63),
              ),
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks',
                      style: TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final formattedDate =
                          DateFormat('dd MMM yyyy').format(task.date);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                task.likeToDo,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
