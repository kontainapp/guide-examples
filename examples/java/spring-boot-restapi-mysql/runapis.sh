# add enteies
echo "Adding 2 tutorial entries"
echo
curl -s -XPOST -H "Content-type:application/json" http://localhost:6868/api/tutorials -d '{"title": "koder tutorial #1", "description": "Tutorial #1 description"}' | jq
echo
curl -s -XPOST -H "Content-type:application/json" http://localhost:6868/api/tutorials -d '{"title": "koder tutorial #2", "description": "Tutorial #2 description"}' | jq

echo
sleep 2
echo retrieving entries
curl http://localhost:6868/api/tutorials | jq
