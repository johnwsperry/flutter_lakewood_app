class MiscTools {
  ///Bounds the input on a interval [a,b)
  static int boundInt(int input, int lower, int upper) {
    //Bound the input.
    if (input >= upper) {
      input = upper - 1;
    } else if (input < lower) {
      input = lower;
    }
    return input;
  }

  ///Gets the objects in list 1(all) that are not present in list 2(some)
  static List<E> getNotPresent<E>(List<E> all, List<E> some){
    List<E> returnList = all;
    for(E item in some){
      returnList.remove(item);
    }
    return returnList;
  }
}
