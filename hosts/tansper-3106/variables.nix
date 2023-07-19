{ config, ... }:
{
  variables.username = "tansper";
  variables.fullName = "Taavi Ansper";
  variables.email = "taavi.ansper@cyber.ee";
  variables.userHashedPassword = config.age.secrets.tansper-3106-password.path;
}
