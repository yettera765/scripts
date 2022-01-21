DIR="$1/clash"
RULE="$DIR/rules"

rm -f "$RULE"
pat='s/payload://g; /^[[:space:]]*$/d;'
for yml in unbreak block-lite proxy direct; do
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
printf "\n  - GEOIP,CN,DIRECT,no-resolve" >> "$RULE"
printf "\n  - GEOIP,LAN,DIRECT" >> "$RULE"
printf "\n  - MATCH,PROXY" >> "$RULE"
sed -i '/^[[:space:]]*$/d' "$RULE"
