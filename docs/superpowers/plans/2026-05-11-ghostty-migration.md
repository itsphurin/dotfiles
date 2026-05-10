# Ghostty Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Kitty with Ghostty as the primary terminal emulator, migrating all config to `config/ghostty/`, updating dotbot symlinks, and cleaning up all Kitty artifacts.

**Architecture:** Create `config/ghostty/config` translating Kitty settings to Ghostty format, update `install.conf.yaml` to symlink `~/.config/ghostty` and drop the Kitty entry, then delete `config/kitty/` after verifying Ghostty works. The kitty keyboard protocol key mappings are dropped since Ghostty supports them natively. Nerd font symbol maps are also dropped — Ghostty resolves glyphs automatically.

**Tech Stack:** Ghostty (already in Brewfile), Dotbot symlink manager, Catppuccin Mocha theme (built-in to Ghostty)

---

### Task 1: Create Ghostty config

**Files:**
- Create: `config/ghostty/config`

- [ ] **Step 1: Create the config directory and file**

```bash
mkdir -p /Users/phurin/dotfiles/config/ghostty
```

- [ ] **Step 2: Write `config/ghostty/config`**

```
font-family = "JetBrainsMono Nerd Font"
theme = 0x96f
font-size = 14
font-thicken = false
adjust-cell-height = 15%
macos-option-as-alt = true
```

> **Note:** The kitty keyboard protocol mappings (`ctrl+enter`, `shift+enter`, `ctrl+tab`, `ctrl+shift+tab`) are intentionally omitted — Ghostty enables the kitty keyboard protocol by default. Nerd font symbol maps are also omitted — Ghostty resolves them from the installed font automatically.

- [ ] **Step 3: Verify Ghostty accepts the config**

```bash
ghostty +show-config --config-file=/Users/phurin/dotfiles/config/ghostty/config 2>&1 | head -40
```

Expected: config echoed back with no `error` or `unknown key` lines.

- [ ] **Step 4: Commit**

```bash
git add config/ghostty/config
git commit -m "ghostty: add initial config translated from kitty"
```

---

### Task 2: Update dotbot symlinks

**Files:**
- Modify: `install.conf.yaml`

- [ ] **Step 1: Replace the kitty symlink entry with ghostty**

In `install.conf.yaml`, find:

```yaml
    ~/.config/kitty:
      create: true
      path: ./config/kitty
```

Replace with:

```yaml
    ~/.config/ghostty:
      create: true
      path: ./config/ghostty
```

- [ ] **Step 2: Remove the dangling kitty symlink before running dotbot**

```bash
rm ~/.config/kitty
```

- [ ] **Step 3: Run dotbot to create the new symlink**

```bash
cd /Users/phurin/dotfiles && ./install
```

Expected: dotbot output shows `~/.config/ghostty` linked, no errors.

- [ ] **Step 4: Verify symlink**

```bash
ls -la ~/.config/ghostty
```

Expected: `~/.config/ghostty -> /Users/phurin/dotfiles/config/ghostty`

- [ ] **Step 5: Commit**

```bash
git add install.conf.yaml
git commit -m "dotbot: replace kitty symlink with ghostty"
```

---

### Task 3: Remove Kitty from Brewfile

**Files:**
- Modify: `macos/Brewfile`

- [ ] **Step 1: Delete the kitty line**

In `macos/Brewfile`, remove:

```
cask "kitty"
```

- [ ] **Step 2: Commit**

```bash
git add macos/Brewfile
git commit -m "macos: remove kitty, ghostty is the primary terminal"
```

---

### Task 4: Verify Ghostty end-to-end

- [ ] **Step 1: Open Ghostty**

Launch Ghostty (it reads `~/.config/ghostty/config` via the symlink).

- [ ] **Step 2: Verify font rendering**

Confirm JetBrains Mono is active and nerd font icons render correctly (run `echo $''` — should print a Powerline arrow, not a box).

- [ ] **Step 3: Verify theme loads**

Run `ghostty +list-themes 2>/dev/null | grep 0x96f` — if it returns nothing, the theme name may need adjusting. Visually confirm the terminal colors look correct on launch.

- [ ] **Step 4: Verify Option-as-Alt**

In a program that reads Alt sequences (e.g. `cat` then press `Option+b`), confirm it sends `\eb` not a Unicode character.

- [ ] **Step 5: Verify kitty keyboard protocol**

In Neovim or another app that uses `<S-Enter>` / `<C-Enter>`, confirm these key combinations are received correctly.

---

### Task 5: Delete config/kitty/ and uninstall Kitty

Only do this after Task 4 verifications pass.

- [ ] **Step 1: Delete the kitty config directory**

```bash
rm -rf /Users/phurin/dotfiles/config/kitty
```

- [ ] **Step 2: Uninstall Kitty via Homebrew**

```bash
brew uninstall --cask kitty
```

Expected: Kitty removed from `/Applications`.

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "ghostty: remove kitty config and uninstall"
```

---

## Self-review

**Spec coverage:**
- [x] Ghostty config with translated kitty settings → Task 1
- [x] Drop kitty keyboard protocol mappings (native in Ghostty) → Task 1 note
- [x] Drop nerd font symbol maps (auto-resolved in Ghostty) → Task 1 note
- [x] Dotbot symlink updated → Task 2
- [x] Kitty removed from Brewfile → Task 3
- [x] config/kitty/ deleted → Task 5
- [x] macOS only (no platform branching) → throughout

**No placeholders present.**

**Type/key consistency:** All config keys in Task 1 verified via `ghostty +show-config` in the same task before committing.
