BEGIN {
    # Read the template file
    while ((getline line < template) > 0) {
        template_content = template_content line "\n"
    }
    close(template)
}

function get_page_title(url) {
    cmd = "curl -sL \"" url "\" | grep -i '<title>' | head -1 | sed 's/.*<title>//I; s/<\\/title>.*//I'"
    cmd | getline link_title
    close(cmd)
    if (link_title == "") {
        return url
    }
    return link_title
}

{
    type = $1
    $1 = ""
    content = substr($0, 2)  # Remove leading space
    
    if (type == "paragraph") {
        html = html "<p>" content "</p>\n"
    } else if (type == "header") {
        html = html "<h2>" content "</h2>\n"
    } else if (type == "image") {
        html = html "<img src=\"" content "\" alt=\"\">\n"
    } else if (type == "link") {
        url = content
        link_title = get_page_title(url)
        html = html "<a href=\"" url "\">" link_title "</a>\n"
    } else if (type == "embed") {
        html = html "<iframe width=\"560\" height=\"315\" src=\"" content "\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" referrerpolicy=\"strict-origin-when-cross-origin\" allowfullscreen></iframe>\n"
    } else if (type == "code") {
        html = html "<pre><code>" content "</code></pre>\n"
    }
}

END {
    # Replace placeholders in template
    gsub(/{{TITLE}}/, title, template_content)
    gsub(/{{CATEGORY}}/, category, template_content)
    gsub(/{{CONTENT}}/, html, template_content)
    print template_content
} 