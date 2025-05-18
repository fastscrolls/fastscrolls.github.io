BEGIN {
    FS = ":"  # Set field separator to colon
    # Read the template file
    while ((getline line < template) > 0) {
        template_content = template_content line "\n"
    }
    close(template)
}

function escape_html(str) {
    gsub(/&/, "\\&amp;", str)
    gsub(/</, "\\&lt;", str)
    gsub(/>/, "\\&gt;", str)
    gsub(/"/, "\\&quot;", str)
    gsub(/'/, "\\&#39;", str)
    return str
}

{
    file = $1
    title = $2
    category = $3
    image_url = $4
    
    if (image_url == "") {
        image_url = "default-placeholder.jpg"
    }
    
    # Get the category path and filename
    split(file, path_parts, "/")
    category_dir = path_parts[length(path_parts)-1]  # Get the category directory name
    filename = path_parts[length(path_parts)]
    gsub(/\.json$/, ".html", filename)
    
    # Build the link path with category
    link_path = category_dir "/" filename
    
    # Build gallery item HTML
    gallery_items = gallery_items \
        "<a href=\"" link_path "\" class=\"card\">\n" \
        "    <div style=\"position: relative;\">\n" \
        "        <img class=\"card-image\" src=\"" escape_html(image_url) "\" alt=\"" escape_html(title) "\">\n" \
        "        <p class=\"card-title\" style=\"position: absolute; bottom: 0; left: 0; right: 0; margin: 0; padding: 0px;\">" escape_html(title) "</p>\n" \
        "    </div>\n" \
        "</a>\n"
}

END {
    # Replace placeholder in template
    gsub(/{{GALLERY_ITEMS}}/, gallery_items, template_content)
    print template_content
} 