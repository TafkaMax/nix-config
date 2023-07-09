{ nixosConfig, config, pkgs, lib, ...}:

lib.mkIf nixosConfig.setup.gui.enable {
  programs.ncmpcpp = {
    enable = true;
    package = (pkgs.ncmpcpp.override {
      visualizerSupport = true;
      taglibSupport = false;
      clockSupport = true;
    });
    mpdMusicDir = null; # does not work (not of type `null or path')
    settings = {
      # Connection
      mpd_host = config.services.mpd.network.listenAddress;

      # Visualizer
      visualizer_autoscale = true;
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_in_stereo = "yes";
      visualizer_look = "●█";
      visualizer_output_name = "my_fifo";
      visualizer_spectrum_dft_size = 1;

      # Display lists in column mode by default
      browser_display_mode = "columns";
      search_engine_display_mode = "columns";

      # Faster seeking
      seek_time = 5;

      # More modern UI
      user_interface = "alternative";

      # Misc
      external_editor = "nvim";
    };
  };

  home.packages = with pkgs; [
    mpc_cli
  ];
}
