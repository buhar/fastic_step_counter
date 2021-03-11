import 'package:flutter/cupertino.dart';

class DailyGoalSpinner extends StatefulWidget {
  final int initialGoal;
  final Function(int) dailyGoalCallback;

  const DailyGoalSpinner({Key key, this.initialGoal, this.dailyGoalCallback})
      : super(key: key);

  @override
  _DailyGoalSpinnerState createState() => _DailyGoalSpinnerState();
}

class _DailyGoalSpinnerState extends State<DailyGoalSpinner> {
  static const int _lowestDailyGoal = 3000;
  static const int _highestDailyGoal = 30000;
  static const int _incrementDailyGoal = 500;
  static const double _itemExtent = 35.0;

  FixedExtentScrollController _controller;
  List<int> _dailyGoals;
  int initialItem;

  @override
  void initState() {
    super.initState();
    int initialItem =
        ((widget.initialGoal - _lowestDailyGoal) / _incrementDailyGoal).round();

    _dailyGoals = [
      for (int dailyGoal = _lowestDailyGoal;
          dailyGoal <= _highestDailyGoal;
          dailyGoal += _incrementDailyGoal)
        dailyGoal
    ];

    _controller = FixedExtentScrollController(initialItem: initialItem);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectedDailyGoal(int index) {
    int selectedDailyGoal = index * _incrementDailyGoal + _lowestDailyGoal;
    widget.dailyGoalCallback(selectedDailyGoal);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      itemExtent: _itemExtent,
      scrollController: _controller,
      onSelectedItemChanged: (int index) => _selectedDailyGoal(index),
      children: _dailyGoals
          .map((dailyGoal) => Center(
                child: Text(
                  dailyGoal.toString(),
                  // We have to explicitly specify the font family because we are
                  // using a cupertino widget which cannot inherit global theme
                  // from material app
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              ))
          .toList(),
    );
  }
}
