mkdir -p build/cmx
ocamlopt -c src/types.ml -o build/cmx/types
ocamlopt -c src/card_parser.ml -I build/cmx -o build/cmx/card_parser
ocamlopt -c src/main.ml -I build/cmx -o build/cmx/main
ocamlopt -o build/main build/cmx/types.cmx build/cmx/card_parser.cmx build/cmx/main.cmx
