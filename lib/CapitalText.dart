String makeFirstLetterCapital(String temp) {
  if (temp != null) {
    if (temp.isNotEmpty) {
      String temp1;
      int ignoreIndex = 0;
      temp1 = '${temp[0].toUpperCase()}';
      for (int i = 0; i < temp.length; i++) {
        if (temp[i] != ' ') {
          if (i != ignoreIndex) {
            temp1 += temp[i];
          }
        } else {
          if (i + 1 < temp.length) {
            temp1 += ' ${temp[i + 1].toUpperCase()}';
            ignoreIndex = i + 1;
          } else {
            temp1 += ' ';
          }
        }
      }
      return temp1;
    }
  }
}
