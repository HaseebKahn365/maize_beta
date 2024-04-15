//here is what each of the timeline tile looks like. it is just an indicator for each level whether or not the level is finished

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimelineTile extends StatefulWidget {
  final isFirst;
  final isLast;
  var isPast;
  final Widget child;

  MyTimelineTile({super.key, required this.isFirst, required this.isLast, this.isPast = false, required this.child});

  @override
  State<MyTimelineTile> createState() => _MyTimelineTileState();
}

class _MyTimelineTileState extends State<MyTimelineTile> {
  @override
  Widget build(BuildContext context) {
    var color = widget.isPast ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.onPrimaryContainer;
    return TimelineTile(
      isFirst: widget.isFirst,
      isLast: widget.isLast,
      beforeLineStyle: LineStyle(color: color),
      indicatorStyle: IndicatorStyle(
        color: color,
        width: 30,
        iconStyle: IconStyle(
          color: widget.isPast ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.primaryContainer,
          //use a lock iicon iif not past
          iconData: widget.isPast ? Icons.check : Icons.lock,
        ),
      ),
      endChild: EventCard(
        child: widget.child,
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  EventCard({super.key, required this.child});
  final Widget child;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.child);
  }
}
