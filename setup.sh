#!/usr/bin/env bash -eu

work_dir=$(mktemp -d)

tail -n +$[ $(grep -n "^DOTFILES" $0|cut -d ":" -f 1) + 1 ] $0 | base64 -d | tar -C ${work_dir} -xz

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

  while true; do
    read -p "Overwrite '$HOME/${file:2}'? ( [Y]es / [n]o / show [d]iffrence ): " input
    case "$input" in
      [Y])
        mkdir -p "$HOME/$(dirname "${file}")" && cp -a "${file}" "$HOME/${file}"
        ;;
      [d])
        diff "${file}" "$HOME/${file}" || :
        continue
        ;;
      *)
        ;;
    esac
    break
  done
done

if ! git config user.name 1>/dev/null; then
  read -p "Input git user.name: " git_user_name
  git config --global user.name "${git_user_name}"
fi

if ! git config user.email 1>/dev/null; then
  read -p "Input git user.email: " git_user_email
  git config --global user.email "${git_user_email}"
fi

echo "done"
exit

DOTFILES
