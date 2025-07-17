import 'package:flutter/material.dart';

typedef TabOnClickFun = dynamic Function(String value);

class CustomTabWidget extends StatefulWidget {
  final List<String>? tabNames;
  final List<Widget>? tabPages;
  final TabOnClickFun? tabOnClickFun;
  final TabController tabController;
  final Color activeBoxColor;
  final Color activeTextColor;

  const CustomTabWidget({
    super.key,
    this.tabNames,
    this.tabPages,
    this.tabOnClickFun,
    required this.tabController,
    required this.activeBoxColor,
    required this.activeTextColor,
  });

  @override
  State<CustomTabWidget> createState() => _CustomTabWidgetState();
}

class _CustomTabWidgetState extends State<CustomTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  int _selectedIndex = 0;

  final List<GlobalKey> dataKey = [];

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController;
    _scrollController = ScrollController();
    _selectedIndex = 0;
    dataKey.clear();
    dataKey.addAll(
      List.generate(widget.tabNames?.length ?? 0, (_) => GlobalKey()),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedTab(int index) {
    final context = dataKey[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context);
    }
  }

  Future<void> _onTabPressed(int index) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (widget.tabOnClickFun != null) {
      await widget.tabOnClickFun!(widget.tabNames![index]);
    }

    if (!mounted) return;
    setState(() {
      _tabController.animateTo(index);
      _scrollToSelectedTab(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.tabNames?.length,
            itemBuilder: (context, index) {
              if (dataKey.length < widget.tabNames!.length) {
                dataKey.add(GlobalKey());
              }
              return Padding(
                key: dataKey[index],
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton(
                  onPressed: () => _onTabPressed(index),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: _selectedIndex == index
                        ? widget.activeBoxColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: _selectedIndex == index
                            ? Colors.transparent
                            : Theme.of(context).primaryColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.tabNames![index],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: _selectedIndex == index
                              ? widget.activeTextColor
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: TabBarView(
            //physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: widget.tabPages!,
          ),
        ),
      ],
    );
  }
}
