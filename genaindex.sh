#!/bin/bash

# TSV output: mdfile htmlfile title "Month DD, YYYY" Unixtime
listarticles () {
  IFS=" "
  stat -c "%Z %n" articles/*.md | sort -n | while read -r DATE NAME; do
  printf "%s\t%s\t%s\t%s\t%s\n" "$NAME" "${NAME/.md/.html}" \
    "$(awk '{if (/^Title:/) { $1=""; print }}' "$NAME")"\
    "$(date -d "@$DATE" "+%B %d, %Y")" $DATE
  done
}

makehtmllist() {
  echo "<ul>"
  listarticles | awk -F\\t '{printf "<li><a href=\"%s\">%s</a> (%s)</li>\n", $2, $3, $4}'
  echo "</ul>"
}

makerss () {
  echo "<rss version=\"2.0\"><channel>"
  echo "<title>Oliver Webb's Webspace Thingy</title>"
  echo "<link>https://oliverkwebb.github.io</link>"
  echo "<language>en</language>"
  IFS=$'\t'
  listarticles | while read OLDFILE NEWFILE TITLE DATE UNIXDATE; do
    echo "<item>"
    printf "<title>%s</title>\n" "$TITLE"
    printf "<link>%s</link>\n" "https://oliverkwebb.github.io/$NEWFILE"
    printf "<pubDate>%s</pubDate>\n" "$(date -Rd @$UNIXDATE)"
    echo "<description>"
    $MD $OLDFILE
    echo "</description>"
    echo "</item>"
  done
  echo "</channel></rss>"
}

case "$1" in
  list) makehtmllist;;
  rss) makerss;;
  *) echo "invalid fmt $1"; exit ;;
esac
