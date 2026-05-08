#! /bin/bash

# Only run this script if we are the real maintainer of this project (the owner of the git repository that contains the autogen.sh file).
if test "$(echo "$GIT_COMMITTER_EMAIL $GIT_COMMITTER_NAME" | md5sum | cut -d \  -f 1)" = "$1"; then
  # Colors.
  esc=""
  reset="$esc""[0m"
  prefix="$esc""[36m***""$reset"
  red="$esc[31m"
  green="$esc[32m"
  orange="$esc[33m"

  # Greetings.
  echo "Hi $GIT_COMMITTER_NAME, how are you today?"

  # Sanity check.
  CMAKE_AICXX_BRANCH=$(git config -f .gitmodules submodule.cmake/aicxx.branch)
  if test -z "$CMAKE_AICXX_BRANCH"; then
    echo "$prefix $red""Setting submodule.cmake/aicxx.branch to master!"
    git config -f .gitmodules submodule.cmake/aicxx.branch master
    CMAKE_AICXX_BRANCH="master"
  fi

  # Is cmake-aicxx on CMAKE_AICXX_BRANCH already?
  pushd cmake/aicxx >/dev/null || exit 1
  if test x"$(git rev-parse --abbrev-ref HEAD)" != x"$CMAKE_AICXX_BRANCH"; then
    echo "$prefix $red""cmake-aicxx is not up-to-date$reset; checking out branch $CMAKE_AICXX_BRANCH."
    git checkout $CMAKE_AICXX_BRANCH && git pull --ff-only || exit 1
  fi
  popd >/dev/null

  if [[ -z "$AICXX_AUTOGEN_BRANCH" ]]; then
    if git show-ref --quiet refs/heads/master; then
      AICXX_AUTOGEN_BRANCH=master
    elif git show-ref --quiet refs/heads/main; then
      AICXX_AUTOGEN_BRANCH=main
    else
      echo "Fatal error: branch master does not exist. Set AICXX_AUTOGEN_BRANCH to point to the developers branch containing autogen.sh."
      exit 1
    fi
  fi

  # Get the trailing 'AccountName/projectname.git' of the upstream fetch url of branch $AICXX_AUTOGEN_BRANCH:
  AICXX_AUTOGEN_BRANCH_REMOTE=$(git config branch.$AICXX_AUTOGEN_BRANCH.remote)
  if test -z "$AICXX_AUTOGEN_BRANCH_REMOTE"; then
    REPO_NAME=$(basename $(pwd))
    echo "Fatal error: branch $AICXX_AUTOGEN_BRANCH does not have a remote set."
    echo "Make sure you created the repository $REPO_NAME on github and issued the commands"
    echo "under '...or push an existing repository from the command line'"
    echo "That is: create the remote REMOTE (ie, origin) and then issue the command:"
    echo "git push -u REMOTE $AICXX_AUTOGEN_BRANCH"
    exit 1
  fi
  PROJECT_URL="$(git config remote.$AICXX_AUTOGEN_BRANCH_REMOTE.url | sed -e 's%.*[^A-Za-z]\([^/ ]*/[^/ ]*$\)%\1%')"
  NEW_MD5=$(sed -e "s%@PROJECT_URL@%$PROJECT_URL%" cmake/aicxx/templates/autogen.sh | cat - cmake/aicxx/scripts/real_maintainer.sh | md5sum)
  OLD_MD5=$(cat autogen.sh cmake/aicxx/scripts/real_maintainer.sh | md5sum)
  if test "$OLD_MD5" = "$NEW_MD5"; then
    echo "  $prefix $green""Already up-to-date.""$reset"
  else
    sed -e "s%@PROJECT_URL@%$PROJECT_URL%" cmake/aicxx/templates/autogen.sh > autogen.sh
    echo "  $prefix $red""autogen.sh and/or real_maintainer.sh changed!""$reset"" Running the new script..."
    exec ./autogen.sh
    exit $?
  fi
  pushd cmake/aicxx >/dev/null || exit 1
  if ! git diff-index --quiet HEAD --; then
    echo -e "\n$prefix $red""Committing all changes in cmake/aicxx!$reset"
    git --no-pager diff
    git commit -a -m 'Automatic commit of changes by autogen.sh.'
  fi
  CMAKE_AICXXCOMMIT=$(git rev-parse HEAD)
  popd >/dev/null
  CMAKE_AICXXHASH=$(git ls-tree HEAD | grep '[[:space:]]cmake/aicxx$' | awk '{ print $3 }')
  if test "$CMAKE_AICXXHASH" != "$CMAKE_AICXXCOMMIT"; then
    if git diff-index --quiet --cached HEAD; then
      echo -e "\n$prefix $red""Updating gitlink cmake/aicxx to current $CMAKE_AICXX_BRANCH branch!$reset"
      git commit -m "Updating gitlink cmake/aicxx to point to current HEAD of $CMAKE_AICXX_BRANCH branch." -o -- "cmake/aicxx"
    elif test x"$(git rev-parse --abbrev-ref HEAD)" != x"$CMAKE_AICXX_BRANCH"; then
      echo -e "\n$prefix $red""Please checkout $CMAKE_AICXX_BRANCH in cmake/aicxx and add it to the current project!$reset"
    fi
  fi

  # Do we have a .gitignore?
  if ! test -f .gitignore; then
    echo -e "\n$prefix Adding .gitignore..."
    cp cmake/aicxx/templates/dot_gitignore .gitignore
    git add .gitignore
  fi

  echo -e "\n$prefix Updating all submodules (recursively)..."

  # Check if 'branch' is set for all submodules owned by CarloWood and fix the url of remotes when needed.
  git submodule foreach --recursive -q '
      echo "name = \"$name\""
      URL=$(git config -f $toplevel/.gitmodules submodule.$name.url)
      regex="^(github-carlo:|https://github\.com/)CarloWood"
      if [[ $URL =~ $regex ]]; then
        if ! git config -f $toplevel/.gitmodules submodule.$name.branch >/dev/null; then
          if [[ -z "$AICXX_AUTOGEN_BRANCH" ]]; then
            if git show-ref --quiet refs/heads/master; then
              AICXX_AUTOGEN_BRANCH=master
            elif git show-ref --quiet refs/heads/main; then
              AICXX_AUTOGEN_BRANCH=main
            else
              echo "Fatal error: branch master does not exist."
              exit 1
            fi
          fi
          echo "  $name: '"$red"'Setting submodule.$name.branch to $AICXX_AUTOGEN_BRANCH!'"$reset"'"
          git config -f $toplevel/.gitmodules "submodule.$name.branch" $AICXX_AUTOGEN_BRANCH
        fi
        NEWURL=$(echo "$URL" | sed -e '"'"'s%^github-carlo:%https://github.com/%'"'"')
        if test "$URL" != "$NEWURL"; then
          echo "  $name: '"$red"'Changing url of .gitmodules to $NEWURL!'"$reset"'"
          git config -f $toplevel/.gitmodules "submodule.$name.url" "$NEWURL"
        fi
        BRANCH=$(git config -f $toplevel/.gitmodules submodule.$name.branch)
        REMOTE=$(git config branch.$BRANCH.remote)
        if test -n "$GITHUB_REMOTE_NAME" -a x"$REMOTE" != x"$GITHUB_REMOTE_NAME"; then
          echo "  $name: '"$red"'Renaming remote from $REMOTE to $GITHUB_REMOTE_NAME!'"$reset"'"
          git remote rename $REMOTE $GITHUB_REMOTE_NAME
          REMOTE=$GITHUB_REMOTE_NAME
        fi
        if test -n "$GITHUB_URL_PREFIX"; then
          URL=$(git config remote.$REMOTE.url)
          PART=$(echo "$URL" | grep -o '"'"'[^/:]*$'"'"')
          NEWURL="$GITHUB_URL_PREFIX$PART"
          if test "$URL" != "$NEWURL"; then
            echo "  $name: '"$red"'Changing url of remote to $NEWURL!'"$reset"'"
            git remote set-url $REMOTE "$NEWURL"
          fi
        fi
      fi'

  # Update all submodules. update_submodule.sh doesn't access the remote, so we need to fetch first.
  echo "*** Fetching new commits..."
  git fetch --jobs=8 --recurse-submodules-default=yes
  echo "*** Doing fast-forward on branched submodules..."
  if ! git submodule --quiet foreach "$(realpath cmake/aicxx/scripts/update_submodule.sh)"' $name "$path" $sha1 "$toplevel"'; then
    echo "autogen.sh: Failed to update one or more submodules. Does it have uncommitted changes?"
    exit 1
  fi
  echo "*** Updating submodule gitlinks..."
  if ! git submodule --quiet foreach "$(realpath cmake/aicxx/scripts/update_submodule.sh)"' --quiet --commit $name "$path" $sha1 "$toplevel"'; then
    echo "autogen.sh: Failed to update one or more submodules. Does it have uncommitted changes?"
    exit 1
  fi
fi

# Continue to run update_submodule.sh in each submodule.
exit 2
