OUTDIR := dist
TEMPLATES := templates
SCRIPTS := scripts

.PHONY: all clean

all: $(OUTDIR)
	@echo "Building pages..."
	@for json in pages/*.json; do \
		filename=$$(basename $$json .json); \
		jq -r '.content[] | to_entries[] | "\(.key) \(.value)"' $$json | \
		awk -f $(SCRIPTS)/process_content.awk -v title="$$(jq -r '.title' $$json)" \
			-v category="$$(jq -r '.category' $$json)" \
			-v template="$(TEMPLATES)/template.html" > $(OUTDIR)/$$filename.html; \
	done

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)/* 