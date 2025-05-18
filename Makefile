OUTDIR := dist
TEMPLATES := templates
SCRIPTS := scripts
PUBLIC := public

.PHONY: all clean

all: $(OUTDIR) $(OUTDIR)/index.html copy-public
	@echo "Building pages..."
	@find pages -name "*.json" | while read json; do \
		filename=$$(basename $$json .json); \
		category=$$(dirname $$json | sed 's|^pages/||'); \
		mkdir -p $(OUTDIR)/$$category; \
		jq -r '.content[] | to_entries[] | "\(.key) \(.value)"' $$json | \
		awk -f $(SCRIPTS)/process_content.awk -v title="$$(jq -r '.title' $$json)" \
			-v category="$$(jq -r '.category' $$json)" \
			-v template="$(TEMPLATES)/template.html" > $(OUTDIR)/$$category/$$filename.html; \
	done

$(OUTDIR)/index.html: $(TEMPLATES)/gallery.html $(SCRIPTS)/generate_gallery.awk $(shell find pages -name "*.json")
	@echo "Generating gallery..."
	@find pages -name "*.json" | while read json; do \
		echo "$$json:$$(jq -r '.title' "$$json"):$$(jq -r '.category' "$$json"):$$(jq -r '.content[] | select(.image != null) | .image' "$$json" | head -1)"; \
	done | awk -f $(SCRIPTS)/generate_gallery.awk -v template="$(TEMPLATES)/gallery.html" > $(OUTDIR)/index.html

$(OUTDIR):
	mkdir -p $(OUTDIR)

copy-public: $(OUTDIR)
	@echo "Copying public assets..."
	@if [ -d "$(PUBLIC)" ]; then \
		cp -r $(PUBLIC)/* $(OUTDIR)/; \
	else \
		mkdir -p $(PUBLIC); \
		echo "Created public directory. Place your images and other assets here."; \
	fi

clean:
	rm -rf $(OUTDIR)/* 