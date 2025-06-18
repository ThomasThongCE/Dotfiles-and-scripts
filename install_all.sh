sudo apt update

for f in ./scripts/*.sh; do
   bash "$f" -H || break
done

