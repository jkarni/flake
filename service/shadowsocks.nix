{
  config,
  lib,
  pkgs,
  ...
}: {



services.shadowsocks={
   enable =true;
   port = 6666;
   password = "12345";
   extraConfig ={
     nameserver = "1.1.1.1";
   };
};  


}
