# 1 disk
# - boot ESP vfat
# - root ext4
{
  disk0 ? "/dev/sda",
  ...
}:
{
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = "${disk0}";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            primary = {
              size = "100%";
              type = "filesystem";
              content = {
                type = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
