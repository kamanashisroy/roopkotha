
all: architecture.dot
	dot -Tsvg $< -o architecture_generated_upload_in_wiki.svg
	dot -Tjpg $< -o architecture_generated_upload_in_wiki.jpg
