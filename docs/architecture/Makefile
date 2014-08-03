

DOTFILES=$(wildcard *.dot)
GENERATED_FILES=$(addsuffix .jpg, $(basename $(DOTFILES)))

all: $(GENERATED_FILES)

%.jpg:%.dot
	dot -Tjpg $< -o $@

clean:
	$(RM) $(GENERATED_FILES)

