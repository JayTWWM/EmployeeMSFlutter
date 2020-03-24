class User {
  String name;
  String designation;
  String contact;
  String email;
  String password;
  String picLink;
  bool isAdmin;

  User(this.name, this.designation, this.contact, this.email, this.password,
      this.picLink, this.isAdmin);

  Map toJson() => {
        "Name": name,
        "Designation": designation,
        "Contact": contact,
        "Email": email,
        "Password": password,
        "PicLick": picLink,
        "IsAdmin": isAdmin
      };

  void setName(String name) {
    this.name = name;
  }

  String getName() {
    return this.name;
  }

  void setDesignation(String designation) {
    this.designation = designation;
  }

  String getDesignation() {
    return this.designation;
  }

  void setContact(String contact) {
    this.contact = contact;
  }

  String getContact() {
    return this.contact;
  }

  void setEmail(String email) {
    this.email = email;
  }

  String getEmail() {
    return this.email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  String getPassword() {
    return this.password;
  }

  void setPicLink(String picLink) {
    this.picLink = picLink;
  }

  String getPicLink() {
    return this.picLink;
  }

  void setIsAdmin(bool isAdmin) {
    this.isAdmin = isAdmin;
  }

  bool getIsAdmin() {
    return this.isAdmin;
  }
}
