#!/bin/bash
set -euo pipefail

rm -rf build
mkdir -p build/posts
cp -r static build/static

post_list_file=$(mktemp)
echo "---
title: int
---
" >"$post_list_file"

find posts/*.md | while IFS= read -r md_file_path; do
    build_path=$(echo "$md_file_path" | sed -e "s/posts/build\/posts/" -e "s/md/html/")

    post_title=$(grep '^title:' "$md_file_path" | sed 's/^title: *//')
    post_link=$(basename "$build_path")

    echo "- [$post_title](posts/$post_link)" >>"$post_list_file"

    pandoc "$md_file_path" \
        --from gfm \
        --output "$build_path" \
        --template templates/post.html
done

pandoc "$post_list_file" \
    --from gfm \
    --template templates/index.html \
    --output build/index.html

rm "$post_list_file"
