# INFO: Nushell's env.nu
{ config, ... }: let
    inherit (config.theme) colors;
in {
    programs.nushell.extraEnv = /* nu */ ''
        def create_left_prompt [] {
            let home =  $nu.home-path

            # Perform tilde substitution on dir
            # To determine if the prefix of the path matches the home dir, we split the current path into
            # segments, and compare those with the segments of the home dir. In cases where the current dir
            # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will 
            # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
            # Inside the condition, either:
            # 1. The home prefix will be replaced
            # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
            let dir = (
                if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
                    ($env.PWD | str replace $home "~")
                } else {
                    $env.PWD
                }
            )

            let path_color = (if (is-admin) { ansi red_bold } else { ansi magenta_bold })
            let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_magenta_bold })
            let path_segment = $"($path_color)($dir | path split | last 3 | path join)"

            $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
        }

        def create_right_prompt [] {
            # create a right prompt in magenta with green separators and am/pm underlined
            let time_segment = ([
                (ansi reset)
                (ansi blue)
                (date now | format date '%X %p') # try to respect user's locale
            ] | str join | str replace --regex --all "([/:])" $"(ansi cyan)''${1}(ansi blue)" |
                str replace --regex --all "([AP]M)" $"(ansi blue_underline)''${1}")

            let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
                (ansi rb)
                ($env.LAST_EXIT_CODE)
            ] | str join)
            } else { "" }

            ([$last_exit_code, (char space), $time_segment] | str join)
        }

        # Use nushell functions to define your right and left prompt
        $env.PROMPT_COMMAND = {|| create_left_prompt }
        # FIXME: This default is not implemented in rust code as of 2023-09-08.
        $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

        # The prompt indicators are environmental variables that represent
        # the state of the prompt
        $env.PROMPT_INDICATOR = {|| " ~> " }
        $env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
        $env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
        $env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

        # If you want previously entered commands to have a different prompt from the usual one,
        # you can uncomment one or more of the following lines.
        # This can be useful if you have a 2-line prompt and it's taking up a lot of space
        # because every command entered takes up 2 lines instead of 1. You can then uncomment
        # the line below so that previously entered commands show with a single `🚀`.
        # $env.TRANSIENT_PROMPT_COMMAND = {|| "~> " }
        # $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
        # $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
        # $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
        # $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
        # $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

        # Specifies how environment variables are:
        # - converted from a string to a value on Nushell startup (from_string)
        # - converted from a value back to a string when running external commands (to_string)
        # Note: The conversions happen *after* config.nu is loaded
        $env.ENV_CONVERSIONS = {
            "PATH": {
                from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
                to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
            }
            "Path": {
                from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
                to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
            }
        }

        # Directories to search for scripts when calling source or use
        $env.NU_LIB_DIRS = [
            # FIXME: This default is not implemented in rust code as of 2023-09-06.
            ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
        ]

        # Directories to search for plugin binaries when calling register
        $env.NU_PLUGIN_DIRS = [
            # FIXME: This default is not implemented in rust code as of 2023-09-06.
            ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
        ]

        # To add entries to PATH (on Windows you might use Path), you can use the following pattern:
        $env.PATH = ($env.PATH | split row (char esep) | prepend '~/.cargo/bin/')

        $env.RUSTC_WRAPPER = sccache
        $env.EDITOR = hx
        $env.LS_COLORS = "${builtins.replaceStrings [ "\n" ] [ ":" ] ''
            *~=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            bd=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.surface0}" ]}
            ca=0
            cd=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.pink}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.surface0}" ]}
            di=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.blue}" ]}
            do=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.crust}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.pink}" ]}
            ex=1;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            fi=0
            ln=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.pink}" ]}
            mh=0
            mi=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.crust}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            no=0
            or=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.crust}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            ow=0
            pi=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.crust}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.blue}" ]}
            rs=0
            sg=0
            so=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.crust}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.pink}" ]}
            st=0
            su=0
            tw=0
            *.a=1;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.c=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.d=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.h=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.m=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.o=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.p=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.r=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.t=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.z=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.7z=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.as=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.bc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.bz=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.cc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.cp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.cr=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.cs=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.di=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.el=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ex=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.fs=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.go=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.gv=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.gz=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.hh=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.hi=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.hs=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.jl=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.js=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ko=1;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.kt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.la=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.ll=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.lo=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.md=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.ml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.mn=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.nb=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.pl=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.pm=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.pp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ps=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.py=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.rb=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.rm=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.rs=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.sh=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.so=1;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.td=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ts=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ui=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.vb=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.wv=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.xz=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.aif=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.ape=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.apk=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.arj=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.asa=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.aux=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.avi=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.awk=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.bag=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.bak=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.bat=1;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.bbl=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.bcf=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.bib=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.bin=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.blg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.bmp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.bsh=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.bst=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.bz2=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.c++=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.cfg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.cgi=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.clj=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.com=1;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.cpp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.css=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.csv=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.csx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.cxx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.deb=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.def=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.dll=1;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.dmg=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.doc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.dot=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.dox=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.dpr=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.elc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.elm=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.epp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.eps=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.erl=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.exe=1;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.exs=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.fls=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.flv=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.fnt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.fon=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.fsi=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.fsx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.gif=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.git=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.gvy=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.h++=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.hpp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.htc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.htm=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.hxx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ico=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.ics=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.idx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.ilg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.img=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.inc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ind=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.ini=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.inl=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ipp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.iso=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.jar=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.jpg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.kex=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.key=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.kdbx=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.crt=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.kts=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.log=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.ltx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.lua=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.m3u=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.m4a=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.m4v=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.mid=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.mir=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.mkv=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.mli=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.mov=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.mp3=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.mp4=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.mpg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.nix=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.odp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.ods=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.odt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.ogg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.org=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.otf=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.out=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.pas=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.pbm=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.pdf=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.pgm=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.php=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.pid=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.pkg=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.png=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.pod=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ppm=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.pps=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.ppt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.pro=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.ps1=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.psd=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.pyc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.pyd=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.pyo=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.rar=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.rpm=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.rst=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.rtf=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.sbt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.sql=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.sty=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.svg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.swf=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.swp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.sxi=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.sxw=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.tar=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.tbz=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.tcl=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.tex=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.tgz=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.tif=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.tml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.tmp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.toc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.tsx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ttf=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.txt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.vcd=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.vim=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.vob=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.wav=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.wma=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.wmv=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.xcf=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.xlr=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.xls=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.xml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.xmp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.yml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.zip=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.zsh=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.zst=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *TODO=1
            *hgrc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.bash=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.conf=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.dart=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.diff=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.docx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.epub=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.fish=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.flac=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.h264=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.hgrc=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.html=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.java=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.jpeg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.json=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.less=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.lisp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.lock=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.make=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.mpeg=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.opus=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.orig=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.pptx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.psd1=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.psm1=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.purs=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.rlib=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.sass=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.scss=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.tbz2=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.tiff=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.toml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.webm=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.webp=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.woff=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.flamingo}" ]}
            *.xbps=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.xlsx=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.red}" ]}
            *.yaml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.cabal=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.cache=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.class=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.cmake=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.dyn_o=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.ipynb=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.mdown=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.patch=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.scala=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.shtml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.swift=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.toast=4;38;2;${builtins.exec [ "hex-to-decimal" "${colors.sapphire}" ]}
            *.xhtml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *README=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *passwd=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *shadow=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.config=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.dyn_hi=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.flake8=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.gradle=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.groovy=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.ignore=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.matlab=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *COPYING=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.overlay2}" ]}
            *INSTALL=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *LICENSE=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.overlay2}" ]}
            *TODO.md=1
            *.desktop=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.gemspec=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *Doxyfile=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *Makefile=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *TODO.txt=1
            *setup.py=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.DS_Store=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.cmake.in=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.fdignore=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.kdevelop=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.markdown=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.rgignore=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *COPYRIGHT=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.overlay2}" ]}
            *README.md=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *configure=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.gitconfig=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.gitignore=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.localized=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.scons_opt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *CODEOWNERS=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *Dockerfile=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *INSTALL.md=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *README.txt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *SConscript=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *SConstruct=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.gitmodules=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.synctex.gz=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.travis.yml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *INSTALL.txt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *LICENSE-MIT=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.overlay2}" ]}
            *MANIFEST.in=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *Makefile.am=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *Makefile.in=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.applescript=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *.fdb_latexmk=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *CONTRIBUTORS=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *appveyor.yml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *configure.ac=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.clang-format=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.gitattributes=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *.gitlab-ci.yml=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.green}" ]}
            *CMakeCache.txt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *CMakeLists.txt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *LICENSE-APACHE=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.overlay2}" ]}
            *CONTRIBUTORS.md=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *.sconsign.dblite=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *CONTRIBUTORS.txt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.base}" ]};48;2;${builtins.exec [ "hex-to-decimal" "${colors.yellow}" ]}
            *requirements.txt=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.teal}" ]}
            *package-lock.json=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
            *.CFUserTextEncoding=0;38;2;${builtins.exec [ "hex-to-decimal" "${colors.surface2}" ]}
        ''}"

        # Autostart an SSH agent and don't start more than one of it.
        let sshAgentEnvPath = $"/tmp/ssh-agent-($env.USER).nuon"
        if ($sshAgentEnvPath | path exists) and ($"/proc/(open $sshAgentEnvPath | get SSH_AGENT_PID)" | path exists) {
            load-env (open $sshAgentEnvPath)
        } else {
            ^ssh-agent -c
                | lines
                | first 2
                | parse "setenv {name} {value};"
                | transpose -r
                | into record
                | save --force $sshAgentEnvPath
            load-env (open $sshAgentEnvPath)
        }

        # If no keys are added, prompt to add one ASAP.
        let addedKeysCount = (ssh-add -l | lines | enumerate | where item =~ SHA | length)
        if ($addedKeysCount == 0) {
            ssh-add
        }
    '';
}

