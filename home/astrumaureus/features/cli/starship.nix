# INFO: `starship.rs`, rust-powered, cross-platform shell propmt
{ lib, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      scan_timeout = 10;
      add_newline = false;

      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$battery"
        # "$package"
        "$line_break"
        "$hostname"
        "$cmd_duration"
        "$character"
      ];

      directory = {
        style = "fg:bold blue";
        format = lib.concatStrings [
          "[$read_only]($read_only_style)"
          "[󰉋 $path ]($style)"
        ];
        repo_root_style = "bold purple";
        repo_root_format = lib.concatStrings [
          "[󰉋 $repo_root]($repo_root_style)"
          "[$path ]($style)"
        ];
        read_only = "RO ";
        read_only_style = "bold yellow";
        truncation_length = 5;
      };

      git_branch = {
        style = "bold red";
        format = lib.concatStrings [
          "[$symbol $branch(:$remote_branch) ]($style)"
        ];
        symbol = "󰊢";
      };

      battery = {
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        display = [
          {
            threshold = 10;
            style = "bold red";
          }
          {
            threshold = 30;
            style = "bold yellow";
          }
          {
            threshold = 100;
            style = "bold white";
          }
        ];
      };

      hostname = {
        style = "bold white";
        format = lib.concatStrings [
          "[$ssh_symbol]($style)"
          "[$hostname ]($style)"
        ];
        ssh_only = false;
        ssh_symbol = "SSH: ";
      };

      cmd_duration = {
        min_time = 1000;
        style = "cyan";
        format = lib.concatStrings [
          "[\\(]($style)"
          "took [$duration]($style)"
          "[\\) ]($style)"
        ];
      };

      character = {
          success_symbol = "[󰄾](bold green)";
          error_symbol = "[x](bold red)";
      };
    };
  };
}
