import 'package:flutter/material.dart';

class InteractivePhysics extends StatefulWidget {
  const InteractivePhysics({super.key});

  @override
  _InteractivePhysicsState createState() => _InteractivePhysicsState();
}

class _InteractivePhysicsState extends State<InteractivePhysics> {
  final List<BallData> balls = [
    BallData(id: 'red', color: Colors.red, matched: false),
    BallData(id: 'blue', color: Colors.blue, matched: false),
    BallData(id: 'green', color: Colors.green, matched: false),
    BallData(id: 'yellow', color: Colors.yellow, matched: false),
    BallData(id: 'purple', color: Colors.purple, matched: false),
  ];

  final List<ContainerData> containers = [
    ContainerData(id: 'red', color: Colors.red),
    ContainerData(id: 'blue', color: Colors.blue),
    ContainerData(id: 'green', color: Colors.green),
    ContainerData(id: 'yellow', color: Colors.yellow),
    ContainerData(id: 'purple', color: Colors.purple),
  ];

  int correctMatches = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: containers.length,
                itemBuilder: (context, index) {
                  return ContainerWidget(container: containers[index]);
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: balls.map((ball) {
                  return DraggableBall(ball: ball);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            for (var ball in balls) {
              ball.matched = false;
            }
            correctMatches = 0;
          });
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.refresh),
      ),
    );
  }

  // دالة للتحقق من المطابقة بدون SnackBar
  void checkMatch(String ballId, String containerId) {
    setState(() {
      if (ballId == containerId) {
        correctMatches++;
        balls.firstWhere((ball) => ball.id == ballId).matched = true;

        if (correctMatches == containers.length) {
          Future.delayed(Duration(milliseconds: 1500), () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('تهانينا!'),
                content: Text('لقد أكملت جميع المطابقات بنجاح!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('حسناً'),
                  ),
                ],
              ),
            );
          });
        }
      }
      // لا شيء عند الخطأ → فقط لا يحدث أي SnackBar
    });
  }
}

class BallData {
  final String id;
  final Color color;
  bool matched;

  BallData({required this.id, required this.color, required this.matched});
}

class ContainerData {
  final String id;
  final Color color;

  ContainerData({required this.id, required this.color});
}

class DraggableBall extends StatelessWidget {
  final BallData ball;

  const DraggableBall({super.key, required this.ball});

  @override
  Widget build(BuildContext context) {
    return Draggable<BallData>(
      data: ball,
      feedback: Material(
        elevation: 8,
        shape: CircleBorder(),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: ball.color.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.5, child: BallWidget(ball: ball)),
      child: ball.matched
          ? SizedBox(width: 70, height: 70)
          : BallWidget(ball: ball),
    );
  }
}

class BallWidget extends StatelessWidget {
  final BallData ball;

  const BallWidget({super.key, required this.ball});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(color: ball.color, shape: BoxShape.circle),
    );
  }
}

class ContainerWidget extends StatefulWidget {
  final ContainerData container;

  const ContainerWidget({super.key, required this.container});

  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  bool isHovered = false;
  bool isMatched = false;

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_InteractivePhysicsState>();
    return DragTarget<BallData>(
      builder: (context, candidateData, rejectedData) {
        isMatched =
            state?.balls
                .firstWhere(
                  (b) => b.id == widget.container.id,
                  orElse: () => BallData(
                    id: '',
                    color: Colors.transparent,
                    matched: false,
                  ),
                )
                .matched ??
            false;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.container.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.container.color, width: 2),
              ),
            ),
            if (isHovered && !isMatched)
              Positioned(
                bottom: 4,
                child: Icon(
                  Icons.arrow_downward,
                  color: widget.container.color,
                ),
              ),
            if (isMatched)
              Icon(Icons.check_circle, color: Colors.green, size: 36),
          ],
        );
      },
      onWillAcceptWithDetails: (details) {
        setState(() {
          isHovered = true;
        });
        return true;
      },
      onLeave: (data) {
        setState(() {
          isHovered = false;
        });
      },
      onAcceptWithDetails: (details) {
        setState(() {
          isHovered = false;
        });
        final ballId = details.data.id;
        state?.checkMatch(ballId, widget.container.id);
      },
    );
  }
}
