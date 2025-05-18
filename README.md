This page builder uses `awk`, `jq`, `make`, `curl`, `sed`, and `sh` to build a static HTML page from a JSON file.

The JSON file has the following format:

```json
{
    "title": "My Page",
    "category": "My Category",
    "content": [
        "paragraph": "This is my page content.",
        "header": "This is my page content.",
        "image": "This is my page content.",
        "link": "This is my page content.",
        "embed": "This is my page content.",
        "code": "This is my page content."
    ]
}
```

Then it should turn the JSON file into a static HTML page in OUTIDIR, defined in the Makefile.