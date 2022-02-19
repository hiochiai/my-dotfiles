#!/usr/bin/env bash -eu

OVERWRITE=${OVERWRITE:-false}
DOTFILES=$(cat << EOF
REPLACE_ME_TO_BASE64_TAR_GZ
EOF
)

work_dir=$(mktemp -d)

echo ${DOTFILES} | base64 -d | tar -C ${work_dir} -xz

cd ${work_dir}

IFS='
'
for file in $(find . -type f); do
  if [ ! -f "$HOME/${file}" ]; then
    mkdir -p "$HOME/$(dirname "${file}")" && cp -a "${file}" "$HOME/${file}"
    continue
  fi
  if diff "${file}" "$HOME/${file}" >/dev/null; then
    mkdir -p "$HOME/$(dirname "${file}")" && cp -a "${file}" "$HOME/${file}"
    continue
  fi

  case "${OVERWRITE}" in
    true)
      mkdir -p "$HOME/$(dirname "${file}")" && cp -a "${file}" "$HOME/${file}"
      ;;
    *)
      echo "Skip to overwrite $HOME/${file}."
      echo "Difference:"
      diff "${file}" "$HOME/${file}" || :
      ;;
  esac
done

post_script=
if ! git config user.name 1>/dev/null; then
  if [ -n "${GIT_USER_NAME}" ]; then
    git config --global user.name ${GIT_USER_NAME}
  else
    post_script+="\n  git config --global user.name \${GIT_USER_NAME}"
  fi
fi
if ! git config user.email 1>/dev/null; then
  if [ -n "${GIT_USER_EMAIL}" ]; then
    git config --global user.email ${GIT_USER_EMAIL}
  else
    post_script+="\n  git config --global user.email \${GIT_USER_EMAIL}"
  fi
fi

echo "Done"

if [ -n "${post_script}" ]; then
  echo    ""
  echo -n "You might want to run following scripts:"
  echo -e "${post_script}"
fi