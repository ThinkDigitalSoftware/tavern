// ignore: one_member_abstracts

abstract class Repository<KeyType, ValueType> {
  static dynamic instance;

  Future<ValueType> get(KeyType query);

  Repository();
}
