class ModuleMdl {
  final String id;
  final String moduleName;

  ModuleMdl({
    this.id = '',
    this.moduleName = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moduleName': moduleName,
    };
  }

  factory ModuleMdl.fromMap(Map<String, dynamic> data, String id) {
    return ModuleMdl(
      id: id,
      moduleName: data['moduleName'] as String,
    );
  }
}
