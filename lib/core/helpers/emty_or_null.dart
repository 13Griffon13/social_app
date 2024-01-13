extension EmptyOrNull on String?{

  bool get emptyOrNull{
    return this == null || this!.isEmpty;
  }
}