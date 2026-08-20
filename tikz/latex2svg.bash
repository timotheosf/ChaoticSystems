#> Inksplt macro
inksplit() {
    if [ -z "$1" ]; then
        echo "Erro: Forneça o nome do arquivo. Exemplo: inksplit documento.pdf"
        return 1
    fi

    local FILE="$1"

    # Descobre o número total de páginas automaticamente
    local PAGES
    PAGES=$(pdfinfo "$FILE" 2>/dev/null | grep "Pages:" | awk '{print $2}')

    local FILENAME
    FILENAME=$(basename "$FILE" .pdf) # Remove a extensão .pdf do nome
    
    if [ "$PAGES" -eq 1 ]; then 
        inkscape "$FILE" --export-filename="$OUTPUT_DIR/${FILENAME}.svg"
    else 
        for i in $(seq 1 "$PAGES"); do 
            inkscape --pages="$i" "$FILE" --export-filename="$OUTPUT_DIR/${FILENAME}_$i.svg"
        done
    fi 
}

#> Clean workspace
cleanWorkspace() {
    rm -rf "$INPUT_DIR/*pdf."
}

FILE="$1"
INPUT_DIR="tikz/"
OUTPUT_DIR="tikz/"
LATEXMK_DIR="build"

readarray -t files2compile < <(ls $INPUT_DIR/*.tex)

for file in "${files2compile[@]}"; do
    latexmk -silent -r "$INPUT_DIR/.latexmkrc" -outdir="$INPUT_DIR" "$file"
done

readarray -t files2transform < <(ls "$INPUT_DIR"/*.pdf)

for file in "${files2transform[@]}"; do
    inksplit "$file"
done

rm -rf build
rm -rf "$LATEXMK_DIR"
rm -rf "$INPUT_DIR"/*pdf