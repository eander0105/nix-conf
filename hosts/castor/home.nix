{ 
  inputs,
  outputs,
  lib,
  config,
  ...
} : {
  config = {
    home-manager = {
      extraSpecialArgs = { inherit inputs outputs; };
      backupFileExtension = "hm-backup";
      users = {
        emil = import ../../home-manager;
      };
    };
  };
}
