#!/bin/bash
echo "<ul>"
for article in $(stat -c "%Z---%n" articles/*.md | sort -nr); do
  NAME="${article#*---}"
  TIME="${article%%---*}"
  printf "<li><a href=\"%s\">%s</a> (%s)</li>\n" "${NAME/.md/.html}" \
    "$(awk -F'>' '/^<title>/ {gsub("</title", "", $2); print $2}' $NAME)"\
    "$(date -d @$TIME "+%B %m, %Y")"
done
  
echo "</ul>"
