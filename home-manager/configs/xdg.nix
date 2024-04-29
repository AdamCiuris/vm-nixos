{
  config,
  pkgs,
  ...
}: let
  browser = ["brave"];
  imageViewer = ["gimp"];
  videoPlayer = ["vlc"];
  audioPlayer = ["vlc"];
  textViewer = ["libreoffice"];

  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  image = xdgAssociations "image" imageViewer ["png" "svg" "jpeg" "gif" "webp" "bmp" "tiff" "svg+xml"];
  video = xdgAssociations "video" videoPlayer ["mpeg" "avi" "mkv" "quicktime" "webm"];  
  text = xdgAssociations "text" textViewer ["toml" "txt" "docx" "odt" "pdf" "rtf"  ];
  audio = xdgAssociations "audio" audioPlayer ["mpeg" "flac" "wav" "aac"];
  browserTypes =
    (xdgAssociations "application" browser [
      "json"
      "x-extension-htm"
      "x-extension-html"
      "x-extension-shtml"
      "x-extension-xht"
      "x-extension-xhtml"
    ])
    // (xdgAssociations "x-scheme-handler" browser [
      "about"
      "ftp"
      "http"
      "https"
      "unknown"
    ]);

  # XDG MIME types
  associations = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) ({
      "application/pdf" = ["libreoffice.desktop"];
      "text/html" = browser;
      "text/plain" = ["libreoffice.desktop"];
      "x-scheme-handler/chrome" = ["brave.desktop"];
    #   "inode/directory" = ["yazi"];
    }
    // image
    // video
    // audio
    // text
    // browserTypes);
in {
  xdg = {
    enable = true;
    # cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    # userDirs = {
    #   enable = true;
    #   createDirectories = true;
    #   extraConfig = {
    #     XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
    #   };
    # };
  };

}