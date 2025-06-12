sudo apt update

for f in ./script/*.sh; do
   bash "$f" -H || break
done

