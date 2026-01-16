{pkgs, ...}: {
  config = {
    systemSettings = {
      users = ["USER1"];
      adminUsers = ["USER1"];
    };
  };
}
