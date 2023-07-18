{ config, ... }:
{
  variables.username = "tafka";
  variables.fullName = "Taavi Ansper";
  variables.email = "taaviansperr@gmail.com";
  variables.userHashedPassword = config.age.secrets.tafka-e495-password.path;
}