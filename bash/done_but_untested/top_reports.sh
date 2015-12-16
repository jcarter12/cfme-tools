#/bin/bash
find . -type d -maxdepth 1 -mindepth 1 -exec {}/rename_top_pdf.sh {} \;
