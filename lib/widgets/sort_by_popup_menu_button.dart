part of 'widgets.dart';

class SortByPopupMenuButton extends StatelessWidget {
  final SortType sortType;
  final void Function(SortType) onSelected;

  const SortByPopupMenuButton({
    Key key,
    @required this.sortType,
    @required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortType>(
      initialValue: sortType,
      offset: Offset(-20, -20),
      icon: Icon(
        GroovinMaterialIcons.filter_outline,
        color: DynamicTheme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Overall Score'),
          value: SortType.overAllScore,
        ),
        PopupMenuItem(
          child: Text('Recently Updated'),
          value: SortType.recentlyUpdated,
        ),
        PopupMenuItem(
          child: Text('Newest Package'),
          value: SortType.newestPackage,
        ),
        PopupMenuItem(
          child: Text('Popularity'),
          value: SortType.popularity,
        ),
      ],
      onSelected: onSelected,
    );
  }
}
