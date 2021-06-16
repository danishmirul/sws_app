class Staff {
  String uid;
  String password;
  String fullname;
  String email;
  String phone;
  bool hotline;

  bool active;

  Staff({
    this.uid,
    this.fullname,
    this.password,
    this.email,
    this.phone,
    this.hotline = false,
    this.active = true,
  });

  Staff.copy(Staff from)
      : this(
          uid: from.uid,
          fullname: from.fullname,
          password: from.password,
          email: from.email,
          phone: from.phone,
          hotline: from.hotline,
          active: from.active,
        );

  @override
  String toString() =>
      "{ uid:${this.uid}, fullname:${this.fullname}, email:${this.email}, phone:${this.phone}, hotline:${this.hotline} }";
}
