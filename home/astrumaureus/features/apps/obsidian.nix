{
  config,
  pkgs,
  ...
}: let
  inherit (config.theme) colors;
in {
  home.packages = with pkgs; [
    obsidian
  ];

  home.file."Obsidian/Vault/.obsidian/themes/Nix/manifest.json".text = ''
    {
        "name": "Nix",
        "version": "0.1.0",
        "minAppVersion": "0.16.0",
        "author": "astrumaureus"
    }
  '';

  home.file."Obsidian/Vault/.obsidian/themes/Nix/theme.css".text = ''
    /***** TABLE OF CONTENTS *****/
    /* TODO: Reformat entire CSS file as below.
    /* 1. Font
    /* 2. Colours
    /*     2.1. Dark theme color variables
    /*     2.2. Light theme color variables
    /*     2.3. Dark theme implementation
    /*     2.4. Light theme implementation
    /* 3. General UI
    /*     3.1. Title Bar
    /* 4. Markdown (editor / preview)
    /*     4.1. Headings
    /*         4.1.1. Fix font weights
    /*     4.2. Links
    /*         4.2.1. Nifty arrow before internal links (also applies to embeds)
    /*     4.3. Embeds
    /*     4.4. Tables
    /*     4.5. Popovers
    /*     4.6. Task Lists
    /*     4.7. Blockquotes
    /*     4.8. Code
    /*     4.9. Bulleted lists
    /*     4.10. Misc Fixes
    /* 5. Graph view colours
    /* 6. Notion Colour Blocks
    /* 7. In-document header (scrolls with the document) [remove for compatibility with Andy's mode]
    /*     7.1. Adjustments for non-in-document headers (graphs, etc)\
    /*     7.2. Active pane border 
    /*     7.3. Misc fixes
    /* 8. Tags
    /*     8.1. Tag custom colours
    /***** *****/

    /* 1. Font */
    body {
        /* font stacks taken directly from Notion */
        --font-monospace: "Hack Nerd Font", "Source Code Pro", monospace;
        -webkit-font-smoothing: auto;
        --h1-color: var(--text-title-h1);
        --h2-color: var(--text-title-h2);
        --h3-color: var(--text-title-h3);
        --h4-color: var(--text-title-h4);
        --h5-color: var(--text-title-h5);
        --h6-color: var(--text-title-h6);
    }

    /* 2. Colours */
    :root
    {
        /* 2.1 Dark theme color variables */
        --bg0-dark:       #${colors.base};
        --bg1-dark:       #${colors.base};
        --bg-dark:        #${colors.base};
        --bg2-dark:       #${colors.surface0};
        --bg3-dark:       #${colors.surface0};
        --bg4-dark:       #${colors.surface1};
        --bg5-dark:       #${colors.surface1};
        --bg_visual:      #${colors.surface1};
        --bg_red:         #${colors.surface0};
        --bg_green:       #${colors.surface0};
        --bg_blue:        #${colors.surface0};
        --bg_yellow:      #${colors.surface0};
        --shadow:         #${colors.base}70;

        --fg-dark:        #${colors.text};
        --grey0-dark:     #${colors.surface1};
        --grey1-dark:     #${colors.surface2};
        --grey2-dark:     #${colors.surface2};

        --faded-red:     #${colors.red};
        --faded-orange:  #${colors.peach};
        --faded-yellow:  #${colors.pink};
        --faded-green:   #${colors.green};
        --faded-aqua:    #${colors.teal};
        --faded-blue:    #${colors.blue};
        --faded-purple:  #${colors.mauve};

        --dim-red:       #${colors.red};
        --dim-orange:    #${colors.peach};
        --dim-yellow:    #${colors.pink};
        --dim-green:     #${colors.green};
        --dim-aqua:      #${colors.teal};
        --dim-blue:      #${colors.blue};
        --dim-purple:    #${colors.mauve};


        /* 2.2 Light theme color variables */
        --bg0-light:     #f0edd8;
        --bg1-light:     #f6f1dd;
        --bg-light:      #fdf6e3;
        --bg2-light:     #f3efda;
        --bg3-light:     #edead5;
        --bg4-light:     #e4e1cd;
        --bg5-light:     #dfdbc8;
        --grey0-light:   #a4ad9e;
        --grey1-light:   #939f91;
        --grey2-light:   #879686;
        --shadow-light:  #3c474d20;


        --bg_visual_light:      #eaedc8;
        --bg_red_light:         #fbe3da;
        --bg_green_light:       #f0f1d2;
        --bg_blue_light:        #e9f0e9;
        --bg_yellow_light:      #faedcd;

        --fg-light:       #5c6a72;
    
        --light-red:     #f85552;
        --light-orange:  #f57d26;
        --light-yellow:  #bf983d;
        --light-green:   #899c40;
        --light-aqua:    #569d79;
        --light-blue:    #5a93a2;
        --light-purple:  #b87b9d;

        --light-dim-red:    #f1706f;
        --light-dim-orange: #f39459;
        --light-dim-yellow: #e4b649;
        --light-dim-green:  #a4bb4a;
        --light-dim-aqua:   #6ec398;
        --light-dim-blue:   #6cb3c6;
        --light-dim-purple: #e092be;


    }

    /* 2.3 Dark theme implementation */
    .theme-dark
    {
        --background-primary:         var(--bg-dark);
        --background-primary-alt:     var(--bg-dark);
        --background-secondary:       var(--bg-dark);
        --background-secondary-alt:   var(--bg-dark);
        --text-normal:                var(--fg-dark);
        --text-faint:                 var(--grey1-dark);
        --text-title-h1:              var(--dim-red);
        --text-title-h2:              var(--dim-orange);
        --text-title-h3:              var(--dim-yellow);
        --text-title-h4:              var(--dim-green);
        --text-title-h5:              var(--dim-aqua);
        --text-title-h6:              var(--dim-purple);
        --text-link:                  var(--faded-blue);
        --text-a:                     var(--dim-aqua);
        --text-a-hover:               var(--faded-aqua);
        --text-mark:                  rgba(215, 153, 33, 0.4); /* light-yellow */
        --pre-code:                   var(--bg1-dark);
        --text-highlight-bg:          var(--bg_green);
        --interactive-accent:         var(--dim-aqua);
        --interactive-before:         var(--bg5-dark);
        --background-modifier-border: var(--bg5-dark);
        --text-accent:                var(--dim-blue);
        --interactive-accent-rgb:     var(--dim-blue);
        --inline-code:                var(--dim-blue);
        --code-block:                 var(--fg-dark);
        --vim-cursor:                 var(--faded-blue);
        --text-selection:             var(--bg5-dark);
    }

    /* 2.4 Light theme implementation */
    .theme-light
    {
        --background-primary:         var(--bg-light);
        --background-primary-alt:     var(--bg-light);
        --background-secondary:       var(--bg-light);
        --background-secondary-alt:   var(--bg-light);
        --text-normal:                var(--fg-light);
        --text-faint:                 var(--grey1-light);
        --text-title-h1:              var(--light-red);
        --text-title-h2:              var(--light-orange);
        --text-title-h3:              var(--light-yellow);
        --text-title-h4:              var(--light-green);
        --text-title-h5:              var(--light-aqua);
        --text-title-h6:              var(--light-purple);
        --text-link:                  var(--light-blue);
        --text-a:                     var(--light-dim-blue);
        --text-a-hover:               var(--light-blue);
        --text-mark:                  rgba(215, 153, 33, 0.4); /* light-yellow */
        --pre-code:                   var(--bg1-light);
        --text-highlight-bg:          var(--light-dim-green);
        --interactive-accent:         var(--bg5-light);
        --interactive-before:         var(--bg5-light);
        --background-modifier-border: var(--bg5-light);
        --text-accent:                var(--light-dim-green);
        --interactive-accent-rgb:     var(--light-dim-green);
        --inline-code:                var(--light-blue);
        --code-block:                 var(--fg-light);
        --vim-cursor:                 var(--light-blue);
        --text-selection:             rgba(189, 174, 147, 0.5); /* light3 */
    }

    .theme-dark code[class*="language-"],
    .theme-dark pre[class*="language-"],
    .theme-light code[class*="language-"],
    .theme-light pre[class*="language-"]
    {
        text-shadow: none ;
        background-color: var(--pre-code) ;
    }

    /* 3. General UI */
    .view-header-title {
        font-weight: 700;
      }
  
      /* 3.1. Title bar */
      .titlebar {
        background-color: var(--background-secondary-alt);
      }
  
      .titlebar-inner {
        color: var(--text-normal);
      }

    .graph-view.color-circle,
    .graph-view.color-fill-highlight,
    .graph-view.color-line-highlight
    {
        color: var(--interactive-accent-rgb) ;
    }
    .graph-view.color-text
    {
        color: var(--text-a-hover) ;
    }
    /*
    .graph-view.color-fill
    {
        color: var(--background-secondary);
    }
    .graph-view.color-line
    {
      color: var(--background-modifier-border);
    }
    */

    html,
    body
    {
        font-size: 16px ;
    }

    strong
    {
        font-weight: 600 ;
    }

    a,
    .cm-hmd-internal-link
    {
        color: var(--text-a) ;
        text-decoration: none ;
    }

    a:hover,
    .cm-hmd-internal-link:hover,
    .cm-url
    {
        color: var(--text-a-hover) ;
        text-decoration: none ;
    }


    /*----------------------------------------------------------------
    TAGS
    ----------------------------------------------------------------*/

    .token.tag {
        padding: 0px 0px;
        background-color: transparent;
        border: none;
      }
  
      .token.tag:hover {
        background: transparent;
        color: var(--text-a-hover) !important;
      }
  
      /*----------------------------------------------------------------
      TAG PILLS
      ----------------------------------------------------------------*/
      .markdown-preview-section h1 a.tag,
      .markdown-preview-section h2 a.tag,
      .markdown-preview-section h3 a.tag,
      .markdown-preview-section h4 a.tag,
      .markdown-preview-section h5 a.tag,
      .markdown-preview-section h4 a.tag {
        font-weight: inherit;
      }
  
      .tag {
        background-color: var(--tag-base);
        border: 1px solid var(--interactive-accent);
        color: var(--text-a);
        font-weight: 500;
        padding: 1.5px 6px;
        padding-left: 6px;
        padding-right: 6px;
        text-align: center;
        text-decoration: none !important;
        display: inline-block;
        cursor: pointer;
        border-radius: 8px;
        transition: 0.2s ease-in-out;
      }
  
      .tag:hover {
        color: var(--interactive-accent);
      }
  
      /*----------------------------------------------------------------
      TAG REF STYLING
      ----------------------------------------------------------------*/
  
      .tag[href^="#❗️"],
      .tag[href^="#important❗️"] {
        background-color: var(--tag-base);
        border: 1px solid var(--boldred);
      }
  
      .tag[href^="#📓"],
      .tag[href^="#journal📓"] {
        background-color: var(--tag-base);
        border: 1px solid var(--purple);
      }
  
      .tag[href^="#🌱"],
      .tag[href^="#seedling🌱"],
      .tag[href^="#🌿"],
      .tag[href^="#budding🌿"],
      .tag[href^="#🌳"],
      .tag[href^="#evergreen🌳"] {
        background-color: var(--tag-base);
        border: 1px solid var(--boldgreen);
      }

    mark
    {
        background-color: var(--text-mark) ;
    }

    .view-actions a
    {
        color: var(--text-normal) ;
    }

    .view-actions a:hover
    {
        color: var(--text-a) ;
    }

    .HyperMD-codeblock-bg
    {
        background-color: var(--pre-code) ;
    }

    .HyperMD-codeblock
    {
        line-height: 1.4em ;
        color: var(--code-block) ;
    }

    .HyperMD-codeblock-begin
    {
        border-top-left-radius: 4px ;
        border-top-right-radius: 4px ;
    }

    .HyperMD-codeblock-end
    {
        border-bottom-left-radius: 4px ;
        border-bottom-right-radius: 4px ;
    }

    th
    {
        font-weight: 600 ;
    }

    thead
    {
        border-bottom: 2px solid var(--background-modifier-border) ;
    }

    .HyperMD-table-row
    {
        line-height: normal ;
        padding-left: 4px ;
        padding-right: 4px ;
        /* background-color: var(--pre-code) ; */
    }

    .HyperMD-table-row-0
    {
        padding-top: 4px ;
    }

    .CodeMirror-foldgutter-folded,
    .is-collapsed .nav-folder-collapse-indicator
    {
        color: var(--text-a) ;
    }

    .nav-file-tag
    {
        color: var(--text-a) ;
    }

    .is-active .nav-file-title
    {
        color: var(--text-a) ;
        background-color: var(--background-primary-alt) ;
    }

    .nav-file-title
    {
        border-bottom-left-radius: 0 ;
        border-bottom-right-radius: 0 ;
        border-top-left-radius: 0 ;
        border-top-right-radius: 0 ;
    }

    img
    {
        display: block ;
        margin-left: auto ;
        margin-right: auto ;
    }

    .HyperMD-list-line
    {
        padding-top: 0 ;
    }

    .CodeMirror-code,
    .CodeMirror-linenumber,
    .cm-formatting
    {
        font-family: var(--font-monospace) ;
        font-size: 0.9em;
    }

    .markdown-preview-section pre code,
    .markdown-preview-section code
    {
        font-size: 0.9em ;
        background-color: var(--pre-code) ;
    }

    .markdown-preview-section pre code
    {
        padding: 4px ;
        line-height: 1.4em ;
        display: block ;
        color: var(--code-block) ;
    }

    .markdown-preview-section code
    {
        color: var(--inline-code) ;
    }

    .cm-s-obsidian,
    .cm-inline-code
    {
        -webkit-font-smoothing: auto ;
    }

    .cm-inline-code
    {
        color: var(--inline-code) ;
        background-color: var(--pre-code) ;
        padding: 1px ;
    }

    .workspace-leaf-header-title
    {
        font-weight: 600 ;
    }

    .side-dock-title
    {
        padding-top: 15px ;
        font-size: 20px ;
    }

    .side-dock-ribbon-tab:hover,
    .side-dock-ribbon-action:hover,
    .side-dock-ribbon-action.is-active:hover,
    .nav-action-button:hover,
    .side-dock-collapse-btn:hover
    {
        color: var(--text-a);
    }

    .side-dock
    {
        border-right: 0 ;
    }

    .cm-s-obsidian,
    .markdown-preview-view
    {
        /* padding-left: 10px ; */
        padding-right: 10px ;
    }

    /* vertical resize-handle */
    .workspace-split.mod-vertical > * > .workspace-leaf-resize-handle,
    .workspace-split.mod-left-split > .workspace-leaf-resize-handle,
    .workspace-split.mod-right-split > .workspace-leaf-resize-handle
    {
        width: 1px ;
        background-color: var(--dim-aqua);
    }

    /* horizontal resize-handle */
    .workspace-split.mod-horizontal > * > .workspace-leaf-resize-handle
    {
        height: 1px ;
        background-color: var(--dim-aqua);
    }

    /* Remove vertical split padding */
    .workspace-split.mod-root .workspace-split.mod-vertical .workspace-leaf-content,
    .workspace-split.mod-vertical > .workspace-split,
    .workspace-split.mod-vertical > .workspace-leaf,
    .workspace-tabs
    {
        padding-right: 0px;
    }

    .markdown-embed-title
    {
        font-weight: 600 ;
    }

    .markdown-embed
    {
        padding-left: 10px ;
        padding-right: 10px ;
        margin-left: 10px ;
        margin-right: 10px ;
    }

    .cm-header-1,
    .markdown-preview-section h1
    {
        font-weight: 500 ;
        font-size: 34px ;
        color: var(--text-title-h1) ;
    }

    .cm-header-2,
    .markdown-preview-section h2
    {
        font-weight: 500 ;
        font-size: 26px ;
        color: var(--text-title-h2) ;
    }

    .cm-header-3,
    .markdown-preview-section h3
    {
        font-weight: 500 ;
        font-size: 22px ;
        color: var(--text-title-h3) ;
    }

    .cm-header-4,
    .markdown-preview-section h4
    {
        font-weight: 500 ;
        font-size: 20px ;
        color: var(--text-title-h4) ;
    }

    .cm-header-5,
    .markdown-preview-section h5
    {
        font-weight: 500 ;
        font-size: 18px ;
        color: var(--text-title-h5) ;
    }

    .cm-header-6,
    .markdown-preview-section h6
    {
        font-weight: 500 ;
        font-size: 18px ;
        color: var(--text-title-h6) ;
    }

    .suggestion-item.is-selected
    {
        background-color: var(--text-selection);
    }

    .empty-state-container:hover
    {
        background-color: var(--background-secondary-alt);
        border: 5px solid var(--interactive-accent) ;
    }

    .checkbox-container
    {
        background-color: var(--interactive-before);
    }

    .checkbox-container:after
    {
        background-color: var(--interactive-accent);
    }

    .checkbox-container.is-enabled:after 
    {
        background-color: var(--bg5-dark);
    }

    .mod-cta
    {
        color: var(--background-secondary-alt) ;
        font-weight: 600 ;
    }

    .mod-cta a
    {
        color: var(--background-secondary-alt) ;
        font-weight: 600 ;
    }

    .mod-cta:hover
    {
        background-color: var(--interactive-before) ;
        font-weight: 600 ;
    }

    .CodeMirror-cursor
    {
        background-color: var(--vim-cursor) ;
        opacity: 60% ;
    }

    input.task-list-item-checkbox {
        border: 1px solid var(--faded-blue);
        appearance: none;
        -webkit-appearance: none;
    }

    input.task-list-item-checkbox:checked
    {
        background-color: var(--faded-blue);
        box-shadow: inset 0 0 0 2px var(--background-primary);
    }

    ::selection
    {
        background-color: var(--text-selection) ;
    }

    .mermaid .note
    {
        fill: var(--dark3) ;
    }

    .frontmatter-container {
        display: none;
    }

    /* Bullet point relationship lines */
    .markdown-source-view.mod-cm6 .cm-indent::before,
    .markdown-rendered.show-indentation-guide li > ul::before,
    .markdown-rendered.show-indentation-guide li > ol::before {
      position: absolute;
      border-right: 1px solid var(--dim-blue);
    }
  '';
}
