DIR="$1/clash"
RULE="$DIR/rules"

rm -f "$RULE"
pat='s/payload://g; s/^  - //g; /^[[:space:]]*$/d;'
for yml in unbreak block proxy direct; do
  case $yml in
    proxy)
      pattern="${pat} s/$/,PROXY/g"
      ;;
    unbreak | direct)
      pattern="${pat} s/$/,DIRECT/g"
      ;;
    block | block-lite) 
      pattern="${pat} s/$/,REJECT/g"
      ;;
  esac
  echo >> "$RULE"
  sed "$pattern" "$DIR/${yml}.yaml" >> "$RULE"
done
