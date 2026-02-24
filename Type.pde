class Type {
  color c;
  float typeRadius;
  float[] attraction;
  float[] middle;
  float[] repelDist;
  int index;

  Type(color c, float typeRadius, float[] attraction, float[] middle, float[] repelDist, ArrayList<Type> typeList) {
    this.c = c;
    this.typeRadius = typeRadius;
    this.attraction = attraction;
    this.middle = middle;
    this.repelDist = repelDist;
    this.index = typeList.size();
  }
}
