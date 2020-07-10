class Experience {
  int exp;

  Experience(this.exp);

  level() {
    if (exp < 200) {
      return 1;
    }
    if (exp < 450) {
      return 2;
    }
    if (exp < 800) {
      return 3;
    }
    if (exp < 1200) {
      return 4;
    } else {
      return 5;
    }
  }
}
