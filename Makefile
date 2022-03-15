.PHONY: test check

build:
	dune build

utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

run:
	OCAMLRUNPARAM=b dune exec bin/main.exe

zip:
	rm -f gravity.zip
	zip -r gravity.zip . -x@exclude.lst

clean:
	dune clean
	rm -f gravity.zip

doc:
	dune build @doc
