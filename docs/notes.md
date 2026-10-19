# Learning notes

Short lessons I've picked up while using this setup. Newest sections at the bottom.

---

## Launching the workspace

- Open a **new** Terminal window (⌘N), `cd` into a project, run `dev`.
- Layout: nvim on the left, Claude Code top right, a shell bottom right (for running code).
- Each project folder gets its own tmux session, named after the folder.
- Running `dev` again in the same folder **reattaches**. It doesn't start a second copy.
- If nvim or Claude quits, the pane drops to a shell. Run `nvim .` or `claude` to restart it.
- If the layout looks squashed, maximise the window first.

## The tmux prefix only covers ONE key

- `Ctrl-a` = "the next key is for tmux". After that single key, keys go back to the active pane.
- To move twice: `Ctrl-a` `l`, then `Ctrl-a` `h`. Not `Ctrl-a` `l` `h`.
- Why it can seem to work in nvim: stray `h`/`j`/`k`/`l` just move the cursor there. In Claude they get typed into the chat.
- Easier ways to switch panes:
  - **Click** the pane (mouse support is on).
  - **`Option` + arrow keys**, with no prefix. Needs Terminal → Settings → Profiles → Basic → Keyboard → **Use Option as Meta key**.

## Detach and reattach

- `Ctrl-a` `d` = detach. Everything keeps running in the background, even after closing Terminal.
- `dev` in the same folder (or `tmux attach`) = come back.
- `tmux ls` lists sessions. `Ctrl-a` `s` switches between them.
- `tmux kill-session -t <name>` ends one for good.

## Handy tmux keys

| Action | Keys |
|---|---|
| Zoom pane full-screen / back | `Ctrl-a` `z` |
| Resize | drag the border, or `Ctrl-a` `H`/`J`/`K`/`L` |
| Scroll back | mouse wheel, or `Ctrl-a` `[` (`q` to exit) |
| Copy | in scroll mode: `v` to select, `y` to copy |
| Reload config | `Ctrl-a` `r` |

## Dotfiles and git

- `~/.config/nvim`, `~/.config/tmux/tmux.conf`, `~/.local/bin/dev` and `~/.claude/CLAUDE.md` are **symlinks** into `~/dotfiles`. Editing them edits the repo.
- Save and share a change:
  ```sh
  cd ~/dotfiles
  git status            # what changed?
  git diff              # see the exact changes
  git add -A            # stage everything
  git commit -m "Describe the change"
  git push              # send to GitHub
  ```
- New machine: install Homebrew, then `git clone https://github.com/abe1144/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh`.
- The repo is **public**, so never put API keys or tokens in it.

## Claude Code context

- `~/.claude/CLAUDE.md` (in the repo as `claude/CLAUDE.md`) is read at the start of **every** Claude session. Keep it short.
- It tells Claude to act as a Socratic tutor for coding questions. Say "just give me the answer" to skip that.
- Longer lessons go here in `notes.md`. Claude reads this file when needed.

## Python in Neovim

- Open a `.py` file and two language servers start: **pyright** (types, go-to-definition, hover docs) and **ruff** (lint warnings and quick fixes). Each checks different things, so both stay on.
- **Completion:** suggestions pop up as you type. `Tab` accepts, `Ctrl-n`/`Ctrl-p` move through the list, `Ctrl-e` closes the menu (do that first if you want a real tab while it's open), `Ctrl-Space` opens it by hand.
- **Formatting:** saving (`:w`) sorts imports and formats the file with ruff. `Space` `f` formats without saving.
- **LSP keys:** `grd` go to definition, `grr` find references, `grn` rename, `gra` code actions (e.g. "remove unused import"), `K` hover docs.
- **Virtual envs:** pyright finds a `.venv/` in the project root, so run `uv venv` / `uv sync` there and it sees your packages.
- `:Mason` shows installed tools. `:checkhealth vim.lsp` and `:ConformInfo` help when something isn't working.
