import 'package:digita_mobile/presentation/features/mahasiswa/kanban/widgets/kanban_card.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/kanban/widgets/tambah_kanban_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  final List<Map<String, String>> kanban = [
    {
      'title': 'BAB IV: Implementasi dan pembahasan',
      'date': '04 Maret 2025, 14:00',
    },
    {
      'title': 'BAB IV: Implementasi dan pembahasan',
      'date': '04 Maret 2025, 14:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showTambahKanbanForm(context);
          },
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Papan Kanban',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TabBar(
                    splashFactory: NoSplash.splashFactory,
                    indicatorPadding: EdgeInsets.symmetric(vertical: 10.0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 1.0,
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    labelColor: Colors.white,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    dividerHeight: 4,
                    dividerColor: Theme.of(context).colorScheme.primary,
                    tabs: [
                      Tab(text: 'To Do'),
                      Tab(text: 'In Progress'),
                      Tab(text: 'Done'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: kanban.length,
                            itemBuilder: (context, index) {
                              return KanbanCard(
                                title: kanban[index]['title']!,
                                date: kanban[index]['date']!,
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: kanban.length,
                            itemBuilder: (context, index) {
                              return KanbanCard(
                                title: kanban[index]['title']!,
                                date: kanban[index]['date']!,
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: kanban.length,
                            itemBuilder: (context, index) {
                              return KanbanCard(
                                title: kanban[index]['title']!,
                                date: kanban[index]['date']!,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTambahKanbanForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return TambahKanbanBottomSheet();
      },
    );
  }
}
