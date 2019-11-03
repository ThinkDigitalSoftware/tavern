part of 'widgets.dart';

class PackageListView extends StatefulWidget {
  final PageQuery pageQuery;
  final Orientation orientation;

  const PackageListView({
    Key key,
    @required this.pageQuery,
    @required this.orientation,
  })  : assert(pageQuery != null),
        super(key: key);

  @override
  _PackageListViewState createState() => _PackageListViewState();
}

class _PackageListViewState extends State<PackageListView> {
  // used to reset the list when we change filter or sort types.
  Key pageWiseSliverKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.orientation == Orientation.portrait) {
      return PagewiseSliverList<Package>(
        key: pageWiseSliverKey,
        pageSize: 10,
        pageFuture: _pageFuture,
        itemBuilder: (BuildContext context, entry, int index) {
          return PackageTile(
            package: entry,
          );
        },
      );
    } else {
      final size = MediaQuery.of(context).size;
      return PagewiseSliverGrid.count(
        key: pageWiseSliverKey,
        crossAxisCount: 2,
        pageSize: 10,
        childAspectRatio: 5,
        pageFuture: _pageFuture,
        itemBuilder: (BuildContext context, entry, int index) {
          return PackageTile(
            package: entry,
          );
        },
      );
    }
  }

  @override
  void didUpdateWidget(PackageListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageQuery.filterType != widget.pageQuery.filterType ||
        oldWidget.pageQuery.sortType != widget.pageQuery.sortType) {
      pageWiseSliverKey = GlobalKey();
    }
  }

  Future<List<Package>> _pageFuture(index) async {
    const int offset = 1;
    // page numbering starts at 1, so we need to add 1.
    final completer = Completer<Page>();
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(
      GetPageOfPackagesEvent(
        pageNumber: index + offset,
        completer: completer,
        filterBy: homeBloc.state.filterType,
        sortBy: homeBloc.state.sortType,
      ),
    );
    return completer.future;
  }
}
