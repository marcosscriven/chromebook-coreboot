#! /bin/bash

# This a record/script for upstreaming Wolf

# Clone coreboot
git clone http://review.coreboot.org/p/coreboot
cd coreboot

# Add and fetch Google's remote
git remote add google https://chromium.googlesource.com/chromiumos/third_party/coreboot
git fetch google

# A mirror of my own to work from, and be able to backup branches to
git remote add marcos git@github.com:marcosscriven/coreboot.git
git fetch marcos

# Make working branch
git checkout -b add-wolf-to-upstream

# Google removed the vboot and blob submodules:
# https://chromium.googlesource.com/chromiumos/third_party/coreboot/+/f5ff8221e9894aa9ec7aff71e25cad5090088dc4
# This makes cherry picking subsequent commits *always* have a conflict. See:
# http://git.661346.n2.nabble.com/problem-with-cherry-picking-a-commit-which-comes-before-introducing-a-new-submodule-td5900085.html
# If I rebase the Wolf branch to fix this, cherry picks will have meaningless hashes local to my machine
# Therefore remove these and commit, with the intention of rebasing onto it (to remove it) before pushing with
# git rebase --onto commit-to-remove~ commit-to-remove add-wolf-to-upstream
git rm 3rdparty/blobs 3rdparty/vboot
git commit -am "--- DO NOT MERGE - This is a temporary local commit. ---"
export TEMP_COMMIT=$(git rev-parse HEAD)

# Cherry pick the first commit for the 'src/mainboard/google/wolf' path
# Don't autocommit because there's a couple of files we don't want in it.
git rev-list --skip 2 --reverse google/firmware-wolf-4389.24.B -- src/mainboard/google/wolf | head -1 | git cherry-pick -n -x --stdin -X ours

# We don't want these two files, as only Google uses these
git reset HEAD configs/config.wolf payloads/libpayload/configs/config.wolf
rm -rf configs/ payloads/libpayload/configs/config.wolf

# Commit accepting the default commit message for a cherry pick
git commit --no-edit

# Do the remainder (tail -n +2 is an arcane way of getting all but the first)
git rev-list --skip 2 --reverse google/firmware-wolf-4389.24.B -- src/mainboard/google/wolf | tail -n +2 | git cherry-pick -x --stdin

# Done cherry picking, undo my earlier fix
git rebase --onto $TEMP_COMMIT~ $TEMP_COMMIT add-wolf-to-upstream

# Now there a whole bunch of further commits, but manual inspects show all but two of them are cherry picked, from already upstreamed commits
# There's only two commits remaining that are only in wolf, but not picked up by our cherry picks:
# 4ee486d202423353a07c54000f977f7ac5689455 Delay the setup of pc-beep verbs
# 2b5c5c5795c0c752ae0fdb65e4395217b95972ad Enable 2x Refresh mode
# Both of these refer to 'partner' bug IDs, which I can't see
