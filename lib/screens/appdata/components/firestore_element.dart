enum ElementType { document, collection, field, parentfield }

class FirestoreElement {
  FirestoreElement(this.name, this.type);

  final String name;
  final ElementType type;
  late dynamic data;
}