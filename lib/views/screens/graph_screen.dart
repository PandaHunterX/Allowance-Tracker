import 'package:flutter/cupertino.dart';
import 'package:productivity_app/views/widgets/pie_graph.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PieGraph(),
        ],
      ),
    );
  }
}
