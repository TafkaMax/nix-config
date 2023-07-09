{ config, ... }:
{
  variables.username = "tafka";
  variables.fullName = "Taavi Ansper";
  variables.userHashedPassword = config.age.secrets.tafka-e495-password.path;
}