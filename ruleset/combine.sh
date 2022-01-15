DIR="$1/clash"
RULE="$DIR/rules"

rm -f "$RULE"
pattern='s/payload://g; s/^  - //g; /^[[:space:]]*$/d'
for yml in unbreak block proxy direct; do
  sed "$pattern" "$DIR/${yml}.yaml" >> "$RULE"
  echo >> "$RULE"
done
